Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbbHOCGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 22:06:14 -0400
Date: Fri, 14 Aug 2015 19:06:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chandra S Gorentla <csgorentla@gmail.com>
Cc: rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, linux-kernel@vger.kernel.org,
	dan.carpenter@oracle.com
Subject: Re: [PATCH v2] staging: wilc1000: Process WARN, INFO options of
 debug levels from user
Message-ID: <20150815020613.GA25718@kroah.com> (sfid-20150815_040618_625958_6E06C127)
References: <1439572807-27772-1-git-send-email-csgorentla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439572807-27772-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 14, 2015 at 10:50:07PM +0530, Chandra S Gorentla wrote:
> This patch enables setting the module's debug options WARN and INFO in the
> debugfs file 'wilc_debug_level'.  This enables the user to enable logging
> of warning and other information.  Before this change writes to this
> debugfs file sets only one option DGB.  This is additional to the default
> option ERR. 
> 
> As a side effect, this patch removes the 'sparse' warning -
> 'warning: incorrect type in argument 2 (different address spaces)'.
> 
> Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_debugfs.c | 28 +++++++++-------------------
>  1 file changed, 9 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
> index be2e901..23419d9 100644
> --- a/drivers/staging/wilc1000/wilc_debugfs.c
> +++ b/drivers/staging/wilc1000/wilc_debugfs.c
> @@ -48,29 +48,18 @@ static ssize_t wilc_debug_level_read(struct file *file, char __user *userbuf, si
>  	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
>  }
>  
> -static ssize_t wilc_debug_level_write(struct file *filp, const char *buf, size_t count, loff_t *ppos)
> +static ssize_t wilc_debug_level_write(struct file *filp, const char __user *buf,
> +					size_t count, loff_t *ppos)
>  {
> -	char buffer[128] = {};
>  	int flag = 0;
> +	int ret;
>  
> -	if (count > sizeof(buffer))
> -		return -EINVAL;
> -
> -	if (copy_from_user(buffer, buf, count)) {
> -		return -EFAULT;
> -	}
> -
> -	flag = buffer[0] - '0';
> -
> -	if (flag > 0)
> -		flag = DEBUG | ERR;
> -	else if (flag < 0)
> -		flag = 100;
> +	ret = kstrtouint_from_user(buf, count, 16, &flag);
> +	if (ret)
> +		return ret;
>  
> -	if (flag > DBG_LEVEL_ALL) {
> -		printk("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&DEBUG_LEVEL));

Why did you remove this warning value?


> -		return -EFAULT;

I agree, this should be changed to -EINVAL like you did, but please put
back the printk for now.

thanks,

greg k-h
