Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbcFYVgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 17:36:31 -0400
Date: Sat, 25 Jun 2016 14:36:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, johnny.kim@atmel.com,
	austin.shin@atmel.com, chris.park@atmel.com, tony.cho@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	julian.calaby@gmail.com
Subject: Re: [PATCH v2 2/2] staging: wilc1000: fix error values in
 wilc_debugfs_init()
Message-ID: <20160625213632.GB15125@kroah.com> (sfid-20160625_233652_656094_D6BE92BE)
References: <1466685378-15597-1-git-send-email-luisbg@osg.samsung.com>
 <1466685378-15597-2-git-send-email-luisbg@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466685378-15597-2-git-send-email-luisbg@osg.samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 23, 2016 at 01:36:18PM +0100, Luis de Bethencourt wrote:
> If there was an error, returning -EINVAL is more appropriate than -1.
> 
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_debugfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
> index 48797dc..6252931 100644
> --- a/drivers/staging/wilc1000/wilc_debugfs.c
> +++ b/drivers/staging/wilc1000/wilc_debugfs.c
> @@ -115,7 +115,7 @@ static int __init wilc_debugfs_init(void)
>  
>  	if (!wilc_dir) {
>  		printk("ERR, debugfs create dir\n");
> -		return -1;
> +		return -EINVAL;
>  	}

Same here, don't check.

>  
>  	for (i = 0; i < ARRAY_SIZE(debugfs_info); i++) {
> @@ -129,7 +129,7 @@ static int __init wilc_debugfs_init(void)
>  		if (!debugfs_files) {
>  			printk("ERR fail to create the debugfs file, %s\n", info->name);
>  			debugfs_remove_recursive(wilc_dir);
> -			return -1;
> +			return -EINVAL;

And here.

