Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:19809 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaFEQST (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 12:18:19 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath10k:  provide firmware crash info via debugfs.
References: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
Date: Thu, 5 Jun 2014 19:18:12 +0300
In-Reply-To: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Wed, 4 Jun 2014 11:01:39
	-0700")
Message-ID: <87egz3nxdn.fsf@kamboji.qca.qualcomm.com> (sfid-20140605_181830_020263_D4EF03AE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> Store the firmware crash registers and last 128 or so
> firmware debug-log ids and present them to user-space
> via debugfs.
>
> Should help with figuring out why the firmware crashed.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

My first comments, more later. But my first impression is that I like
this, we just need to sort out some implementation issues.

kbuild found some warnings:

drivers/net/wireless/ath/ath10k/debug.c:725:2: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
drivers/net/wireless/ath/ath10k/debug.c:624:2: error: implicit declaration of function 'vmalloc' [-Werror=implicit-function-declaration]
drivers/net/wireless/ath/ath10k/debug.c:624:6: warning: assignment makes pointer from integer without a cast [enabled by default]

The naming of structures and functions are a bit too long, but I'll
comment on that later. That's easy to change as the last thing.

> +/**
> + * enum ath10k_fw_error_dump_type - types of data in the dump file
> + * @ATH10K_FW_ERROR_DUMP_DBGLOG:  Recent firmware debug log entries
> + * @ATH10K_FW_ERROR_DUMP_CRASH:   Crash dump in binary format
> + */
> +enum ath10k_fw_error_dump_type {
> +	ATH10K_FW_ERROR_DUMP_DBGLOG = 0,
> +	ATH10K_FW_ERROR_DUMP_REGDUMP = 1,
> +
> +	ATH10K_FW_ERROR_DUMP_MAX,
> +};
> +
> +

Extra newline.

> +struct ath10k_tlv_dump_data {
> +	u32 type; /* see ath10k_fw_error_dump_type above */
> +	u32 tlv_len; /* in bytes */
> +	u8 tlv_data[]; /* Pad to 32-bit boundaries as needed. */
> +} __packed;
> +
> +struct ath10k_dump_file_data {
> +	/* Dump file information */
> +	u32 len;
> +	u32 magic; /* 0x01020304, tells us byte-order of host if we care */
> +	u32 version; /* File dump version, 1 for now. */

Actually I would prefer to have magic first and have ASCII string as
string, for example "ATH10K-FW-DUMP".

> +	/* Some info we can get from ath10k struct that might help. */
> +	u32 chip_id;
> +	u32 target_version;

bus_type or something like that would be good to add already now.

> +	u8 fw_version_major;
> +	u8 unused8; /* pad fw_version_major */
> +	u16 unused16; /* pad fw_version_major */

I don't see any point of using u8 or u16. Would it be simpler just to
use u32 for everything?

> +	u32 fw_version_minor;
> +	u16 fw_version_release;
> +	u16 fw_version_build;
> +	u32 phy_capability;
> +	u32 hw_min_tx_power;
> +	u32 hw_max_tx_power;
> +	u32 ht_cap_info;
> +	u32 vht_cap_info;
> +	u32 num_rf_chains;
> +	char fw_ver[64]; /* Firmware version string */

Can we reuse ETHTOOL_FWVERS_LEN? cfg80211 already uses that.

#define ETHTOOL_FWVERS_LEN	32

> +	/* Kernel related information */
> +	u32 kernel_ver_code; /* LINUX_VERSION_CODE */
> +	char kernel_ver[64]; /* VERMAGIC_STRING */
> +
> +	u8 unused[64]; /* Room for growth w/out changing binary format */

Maybe 128 bytes, just so that we don't need to change it for some time?

> +	struct ath10k_tlv_dump_data data; /* more may follow */

I would prefer:

u8 data[0];

So that this struct is only about the header.

> +} __packed;
> +
> +/* This will store at least the last 128 entries.  Each dbglog message
> + * is a max of 7 32-bit integers in length, but the length can be less
> + * than that as well.
> + */
> +#define ATH10K_DBGLOG_DATA_LEN (128 * 7 * 4)

Empty line after the define.

> @@ -488,6 +555,12 @@ struct ath10k {
>  
>  	struct dfs_pattern_detector *dfs_detector;
>  
> +	/* Used for crash-dump storage */
> +	/* Don't over-write dump info until someone reads the data. */
> +	bool crashed_since_read;
> +	struct ath10k_dbglog_entry_storage dbglog_entry_data;
> +	u32 reg_dump_values[REG_DUMP_COUNT_QCA988X];

I think these should be in struct ath10k_debug.

> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index 1b7ff4b..a7d7877 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -17,6 +17,8 @@
>  
>  #include <linux/module.h>
>  #include <linux/debugfs.h>
> +#include <linux/version.h>
> +#include <linux/vermagic.h>
>  
>  #include "core.h"
>  #include "debug.h"
> @@ -577,6 +579,145 @@ static const struct file_operations fops_chip_id = {
>  	.llseek = default_llseek,
>  };
>  
> +void ath10k_dbg_save_fw_dbg_buffer(struct ath10k *ar, u8 *buffer, int len)
> +{
> +	int i;
> +	int z = ar->dbglog_entry_data.next_idx;
> +
> +	/* Don't save any new logs until user-space reads this. */
> +	if (ar->crashed_since_read)
> +		return;

Locking? If this functions depends on something, please document that
with lockdep_assert_held().

> +	for (i = 0; i < len; i++) {
> +		ar->dbglog_entry_data.data[z] = buffer[i];
> +		z++;
> +		if (z >= ATH10K_DBGLOG_DATA_LEN)
> +			z = 0;
> +	}

Empty line here.

> +	ar->dbglog_entry_data.next_idx = z;
> +}
> +EXPORT_SYMBOL(ath10k_dbg_save_fw_dbg_buffer);
> +
> +static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
> +{
> +	unsigned int len = (sizeof(ar->dbglog_entry_data)

Unneeded parenthesis.

> +			    + sizeof(ar->reg_dump_values));
> +	unsigned int sofar = 0;
> +	char *buf;
> +	struct ath10k_tlv_dump_data *dump_tlv;
> +	struct ath10k_dump_file_data *dump_data;
> +	int hdr_len = sizeof(*dump_data) - sizeof(dump_data->data);

I prefer separating variable declarations and definitions.

> +
> +	lockdep_assert_held(&ar->conf_mutex);
> +
> +	len += hdr_len;
> +	sofar += hdr_len;
> +
> +	/* So we can add headers to the data dump */
> +	len += 2 * sizeof(*dump_tlv);

This is a bit awkward way of defining the length. Something like this
would be easier to read:

len = sizeof (*dump_tlv) + sizeof(ar->dbglog_entry_data);
len +=	sizeof (*dump_tlv) + sizeof(ar->reg_dump_values));

> +
> +	/* This is going to get big when we start dumping FW RAM and such,
> +	 * so go ahead and use vmalloc.
> +	 */
> +	buf = vmalloc(len);
> +	if (!buf)
> +		return NULL;
> +
> +	memset(buf, 0, len);
> +	dump_data = (struct ath10k_dump_file_data *)(buf);
> +	dump_data->len = len;
> +	dump_data->magic = 0x01020304;
> +	dump_data->version = 1;
> +	dump_data->chip_id = ar->chip_id;
> +	dump_data->target_version = ar->target_version;
> +	dump_data->fw_version_major = ar->fw_version_major;
> +	dump_data->fw_version_minor = ar->fw_version_minor;
> +	dump_data->fw_version_release = ar->fw_version_release;
> +	dump_data->fw_version_build = ar->fw_version_build;
> +	dump_data->phy_capability = ar->phy_capability;
> +	dump_data->hw_min_tx_power = ar->hw_min_tx_power;
> +	dump_data->hw_max_tx_power = ar->hw_max_tx_power;
> +	dump_data->ht_cap_info = ar->ht_cap_info;
> +	dump_data->vht_cap_info = ar->vht_cap_info;
> +	dump_data->num_rf_chains = ar->num_rf_chains;
> +
> +	strncpy(dump_data->fw_ver, ar->hw->wiphy->fw_version,
> +		sizeof(dump_data->fw_ver) - 1);

BUILD_BUG_ON(sizeof(dump_data->fw_ver) != sizeof(ar->hw->wiphy->fw_version))?

And wouldn't strlcpy() be safer?

> +	dump_data->kernel_ver_code = LINUX_VERSION_CODE;

checkpatch actually complains about this:

drivers/net/wireless/ath/ath10k/debug.c:649: WARNING: LINUX_VERSION_CODE should be avoided, code should be for the version to which it is merged

But I guess there's nothing we can do for that.

> +	strncpy(dump_data->kernel_ver, VERMAGIC_STRING,
> +		sizeof(dump_data->kernel_ver) - 1);

strlcpy()?

> +	/* Gather dbg-log */
> +	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
> +	dump_tlv->type = ATH10K_FW_ERROR_DUMP_DBGLOG;
> +	dump_tlv->tlv_len = sizeof(ar->dbglog_entry_data);
> +	memcpy(dump_tlv->tlv_data, &ar->dbglog_entry_data, dump_tlv->tlv_len);
> +	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
> +
> +	/* Gather crash-dump */
> +	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
> +	dump_tlv->type = ATH10K_FW_ERROR_DUMP_REGDUMP;
> +	dump_tlv->tlv_len = sizeof(ar->reg_dump_values);
> +	memcpy(dump_tlv->tlv_data, &ar->reg_dump_values, dump_tlv->tlv_len);
> +	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
> +
> +	return dump_data;
> +}
> +
> +static int ath10k_fw_error_dump_open(struct inode *inode, struct file *file)
> +{
> +	struct ath10k *ar = inode->i_private;
> +	int ret;
> +	struct ath10k_dump_file_data *dump;
> +
> +	if (!ar)
> +		return -EINVAL;

Is this cheak necessary? In what cases is i_private NULL?

> --- a/drivers/net/wireless/ath/ath10k/debug.h
> +++ b/drivers/net/wireless/ath/ath10k/debug.h
> @@ -19,6 +19,7 @@
>  #define _DEBUG_H_
>  
>  #include <linux/types.h>
> +#include "pci.h"

debug.h shouldn't access pci.h directly. All access should happen
through hif.

>  
>  enum ath10k_debug_mask {
> @@ -110,4 +111,28 @@ static inline void ath10k_dbg_dump(enum ath10k_debug_mask mask,
>  {
>  }
>  #endif /* CONFIG_ATH10K_DEBUG */
> +
> +
> +/* Target debug log related defines and structs */
> +
> +/* Target is 32-bit CPU, so we just use u32 for
> + * the pointers.  The memory space is relative to the
> + * target, not the host.
> + */
> +struct ath10k_fw_dbglog_buf {
> +	u32 next; /* pointer to dblog_buf_s. */
> +	u32 buffer; /* pointer to u8 buffer */
> +	u32 bufsize;
> +	u32 length;
> +	u32 count;
> +	u32 free;
> +} __packed;
> +
> +struct ath10k_fw_dbglog_hdr {
> +	u32 dbuf; /* pointer to dbglog_buf_s */
> +	u32 dropped;
> +} __packed;

Should these be in hw.h?

> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -19,7 +19,7 @@
>  #include <linux/module.h>
>  #include <linux/interrupt.h>
>  #include <linux/spinlock.h>
> -#include <linux/bitops.h>

Why remove bitops.h?

Have to stop here, more later.

-- 
Kalle Valo
