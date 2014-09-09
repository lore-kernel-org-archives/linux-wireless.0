Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52130 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbaIITpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 15:45:09 -0400
Date: Tue, 9 Sep 2014 15:32:38 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jade Bilkey <herself@thefumon.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH v2] ath5k: added debugfs file for dumping eeprom
Message-ID: <20140909193237.GN29412@tuxdriver.com> (sfid-20140909_214538_348857_D84A0C8F)
References: <20140906170048.GA32300@apiculture.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140906170048.GA32300@apiculture.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original patch was already merged.  To make a change, you need
to post a new patch based on the new head of the tree.  This one just
conflicts with what is already there now.

Also, I think all you really need is a "#include <linux/vmalloc.h>".

Post a v3 that just adds the #include?

John

On Sat, Sep 06, 2014 at 01:00:48PM -0400, Jade Bilkey wrote:
> Signed-off-by: Jade Bilkey <herself@thefumon.com>
> ---
> 
> v2: vmalloc not included in some configs
>    Switched to using kmalloc
> 
>  drivers/net/wireless/ath/ath5k/debug.c | 96 ++++++++++++++++++++++++++++++++++
>  1 file changed, 96 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
> index b8d031a..ca3cd06 100644
> --- a/drivers/net/wireless/ath/ath5k/debug.c
> +++ b/drivers/net/wireless/ath/ath5k/debug.c
> @@ -894,6 +894,100 @@ static const struct file_operations fops_queue = {
>  	.llseek = default_llseek,
>  };
>  
> +/* debugfs: eeprom */
> +
> +struct eeprom_private {
> +	u16 *buf;
> +	int len;
> +};
> +
> +static int open_file_eeprom(struct inode *inode, struct file *file)
> +{
> +	struct eeprom_private *ep;
> +	struct ath5k_hw *ah = inode->i_private;
> +	bool res;
> +	int i, ret;
> +	u32 eesize;
> +	u16 val, *buf;
> +
> +	/* Get eeprom size */
> +
> +	res = ath5k_hw_nvram_read(ah, AR5K_EEPROM_SIZE_UPPER, &val);
> +	if (!res)
> +		return -EACCES;
> +
> +	if (val == 0) {
> +		eesize = AR5K_EEPROM_INFO_MAX + AR5K_EEPROM_INFO_BASE;
> +	} else {
> +		eesize = (val & AR5K_EEPROM_SIZE_UPPER_MASK) <<
> +			AR5K_EEPROM_SIZE_ENDLOC_SHIFT;
> +		ath5k_hw_nvram_read(ah, AR5K_EEPROM_SIZE_LOWER, &val);
> +		eesize = eesize | val;
> +	}
> +
> +	if (eesize > 4096)
> +		return -EINVAL;
> +
> +	/* Create buffer and read in eeprom */
> +
> +	buf = kmalloc(eesize, GFP_KERNEL);
> +	if (!buf) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	for (i = 0; i < eesize; ++i) {
> +		AR5K_EEPROM_READ(i, val);
> +		buf[i] = val;
> +	}
> +
> +	/* Create private struct and assign to file */
> +
> +	ep = kmalloc(sizeof(*ep), GFP_KERNEL);
> +	if (!ep) {
> +		ret = -ENOMEM;
> +		goto freebuf;
> +	}
> +
> +	ep->buf = buf;
> +	ep->len = i;
> +
> +	file->private_data = (void *)ep;
> +
> +	return 0;
> +
> +freebuf:
> +	kfree(buf);
> +err:
> +	return ret;
> +
> +}
> +
> +static ssize_t read_file_eeprom(struct file *file, char __user *user_buf,
> +				   size_t count, loff_t *ppos)
> +{
> +	struct eeprom_private *ep = file->private_data;
> +
> +	return simple_read_from_buffer(user_buf, count, ppos, ep->buf, ep->len);
> +}
> +
> +static int release_file_eeprom(struct inode *inode, struct file *file)
> +{
> +	struct eeprom_private *ep = file->private_data;
> +
> +	kfree(ep->buf);
> +	kfree(ep);
> +
> +	return 0;
> +}
> +
> +static const struct file_operations fops_eeprom = {
> +	.open = open_file_eeprom,
> +	.read = read_file_eeprom,
> +	.release = release_file_eeprom,
> +	.owner = THIS_MODULE,
> +};
> +
>  
>  void
>  ath5k_debug_init_device(struct ath5k_hw *ah)
> @@ -921,6 +1015,8 @@ ath5k_debug_init_device(struct ath5k_hw *ah)
>  
>  	debugfs_create_file("misc", S_IRUSR, phydir, ah, &fops_misc);
>  
> +	debugfs_create_file("eeprom", S_IRUSR, phydir, ah, &fops_eeprom);
> +
>  	debugfs_create_file("frameerrors", S_IWUSR | S_IRUSR, phydir, ah,
>  			    &fops_frameerrors);
>  
> -- 
> 2.1.0
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
