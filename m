Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24923 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab1HaIYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 04:24:11 -0400
Message-ID: <4E5DEFA5.7050001@qca.qualcomm.com> (sfid-20110831_102418_584454_86D3C603)
Date: Wed, 31 Aug 2011 11:24:05 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Add debugfs interface to dump diagnostic registers
References: <1314717419-16512-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1314717419-16512-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/2011 06:16 PM, Vasanthakumar Thiagarajan wrote:
> To dump a particular register, echo reg_addr > <debugfs_root>/ieee80211/phyX/ath6kl/reg_addr,
> to dump the entire register set, echo 0 > <debugfs_root>/ieee80211/phyX/ath6kl/reg_addr, and
> register values will be available at <debugfs_root>/ieee80211/phyX/ath6kl/reg_dump.

I like this :) The full dump just takes quite long, 22 seconds on my x86
box, and cat dumps everything only in the end. It would be nice to
improve that somehow by sending results in smaller pieces, but no need
to worry about that now.

I just saw your message about sending v2, but I had already started
reviewing this and didn't want to stop.

First, I saw few sparse warnings:

drivers/net/wireless/ath/ath6kl/debug.c:666:33: warning: incorrect type
in argument 2 (different base types)
drivers/net/wireless/ath/ath6kl/debug.c:666:33:    expected unsigned int
[unsigned] [usertype] address
drivers/net/wireless/ath/ath6kl/debug.c:666:33:    got restricted __le32
[usertype] <noident>
drivers/net/wireless/ath/ath6kl/debug.c:667:34: warning: incorrect type
in argument 3 (different base types)
drivers/net/wireless/ath/ath6kl/debug.c:667:34:    expected unsigned int
[usertype] *value
drivers/net/wireless/ath/ath6kl/debug.c:667:34:    got restricted __le32
*<noident>
drivers/net/wireless/ath/ath6kl/debug.c:680:41: warning: incorrect type
in argument 2 (different base types)
drivers/net/wireless/ath/ath6kl/debug.c:680:41:    expected unsigned int
[unsigned] [usertype] address
drivers/net/wireless/ath/ath6kl/debug.c:680:41:    got restricted __le32
[usertype] <noident>
drivers/net/wireless/ath/ath6kl/debug.c:681:50: warning: incorrect type
in argument 3 (different base types)
drivers/net/wireless/ath/ath6kl/debug.c:681:50:    expected unsigned int
[usertype] *value
drivers/net/wireless/ath/ath6kl/debug.c:681:50:    got restricted __le32
*<noident>

> --- a/drivers/net/wireless/ath/ath6kl/core.h
> +++ b/drivers/net/wireless/ath/ath6kl/core.h
> @@ -480,6 +480,7 @@ struct ath6kl {
>  	} debug;
>  #endif /* CONFIG_ATH6KL_DEBUG */
>  
> +	unsigned int dbgfs_diag_reg;
>  };

Please move this inside the debug struct above. I'm trying to categorise
struct ath6kl a bit to make it easier to understand.

>  static inline void *ath6kl_priv(struct net_device *dev)
> diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
> index 9608692..6ecfc70 100644
> --- a/drivers/net/wireless/ath/ath6kl/debug.c
> +++ b/drivers/net/wireless/ath/ath6kl/debug.c
> @@ -54,6 +54,28 @@ int ath6kl_printk(const char *level, const char *fmt, ...)
>  }
>  
>  #ifdef CONFIG_ATH6KL_DEBUG
> +
> +#define REG_OUTPUT_LEN_PER_LINE	25
> +#define ATH6KL_REG_TYPE_MAX 8
> +#define REGTYPE_STR_LEN 100

please indent values 8 and 100 similarly like you did with 25.

Also ATH6KL_REG_TYPE_MAX could be replaced with ARRAY_SIZE(), right?

> +
> +struct ath6kl_diag_reg_info {
> +	u32 reg_start;
> +	u32 reg_end;
> +	char *reg_info;

const char *?

> +};
> +
> +static const struct ath6kl_diag_reg_info diag_reg[ATH6KL_REG_TYPE_MAX] = {
> +	{ 0x20000, 0x200fc, "General DMA and Rx registers" },
> +	{ 0x28000, 0x28900, "MAC PCU register & keycache" },
> +	{ 0x20800, 0x20a40, "QCU" },
> +	{ 0x21000, 0x212f0, "DCU" },
> +	{ 0x4000,  0x42e4, "RTC" },
> +	{ 0x540000, 0x540000 + (256 * 1024), "RAM" },
> +	{ 0x29800, 0x2B210, "Base Band" },
> +	{ 0x1C000, 0x1C748, "Analog" },
> +};
> +
>  void ath6kl_dump_registers(struct ath6kl_device *dev,
>  			   struct ath6kl_irq_proc_registers *irq_proc_reg,
>  			   struct ath6kl_irq_enable_reg *irq_enable_reg)
> @@ -533,6 +555,171 @@ static const struct file_operations fops_credit_dist_stats = {
>  	.llseek = default_llseek,
>  };
>  
> +static unsigned long ath6kl_get_num_reg(void)
> +{
> +	int i;
> +	unsigned long n_reg = 0;
> +
> +	for (i = 0; i < ATH6KL_REG_TYPE_MAX; i++)
> +		n_reg = n_reg +
> +		     (diag_reg[i].reg_end - diag_reg[i].reg_start) / 4 + 1;
> +
> +	return n_reg;
> +}
> +
> +static bool ath6kl_dbg_is_diag_reg_valid(u32 reg_addr)
> +{
> +	int i;
> +
> +	for (i = 0; i < ATH6KL_REG_TYPE_MAX; i++) {
> +		if (reg_addr >= diag_reg[i].reg_start &&
> +		    reg_addr <= diag_reg[i].reg_end)
> +			return true;
> +	}
> +
> +	ath6kl_info("Invalid addr\n");

ath6kl_warn() and a better warning message, please.

> +	if (n_reg == 1) {
> +		addr = ar->dbgfs_diag_reg;
> +
> +		status = ath6kl_diag_read32(ar,
> +				cpu_to_le32(TARG_VTOP(ar->target_type, addr)),
> +				&reg_val);
> +		if (status)
> +			goto fail_reg_read;
> +
> +		len += scnprintf(buf + len, reg_len - len,
> +				 "0x%06x 0x%08x\n", addr, le32_to_cpu(reg_val));
> +	} else {

You could add 'goto out;' at the end of the if block and then you don't
wouldn't need to use else block at all. That would make indentation more
readable.

> +static ssize_t read_file_reg_dump(struct file *file, char __user *user_buf,
> +				  size_t count, loff_t *ppos)
> +{
> +	u8 *buf = file->private_data;
> +	return simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));

Does simple_read_from_buffer() handle the case when buf doesn't fit to
user_buf in one go? I guess it does but too busy to check that right now.

> +static const struct file_operations fops_reg_dump = {
> +	.open = open_file_reg_dump,
> +	.read = read_file_reg_dump,
> +	.release = release_file_reg_dump,

The naming could follow more the style I'm trying to push, for example
something like this:

ath6kl_reg_dump_open()
ath6kl_reg_dump_read()
ath6kl_reg_dump_release()

> +	.owner = THIS_MODULE,
> +	.llseek = default_llseek,
> +};
> +
>  int ath6kl_debug_init(struct ath6kl *ar)
>  {
>  	ar->debug.fwlog_buf.buf = vmalloc(ATH6KL_FWLOG_SIZE);
> @@ -566,6 +753,10 @@ int ath6kl_debug_init(struct ath6kl *ar)
>  
>  	debugfs_create_file("credit_dist_stats", S_IRUSR, ar->debugfs_phy, ar,
>  			    &fops_credit_dist_stats);
> +	debugfs_create_file("reg_addr", S_IRUSR, ar->debugfs_phy, ar,
> +			    &fops_diag_reg_read);

You need write mode for reg_addr. I had missed the same in my fwlog
patches :)

Kalle
