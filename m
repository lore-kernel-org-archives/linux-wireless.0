Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36566 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727371AbeHIMdA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 08:33:00 -0400
Date: Thu, 9 Aug 2018 13:08:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH] staging: wilc1000: fix undefined reference to
 `__this_module' compilation error
Message-ID: <20180809100838.pduj5s5lvbpjuljn@mwanda> (sfid-20180809_120924_942765_EAA60E50)
References: <1533796986-8832-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1533796986-8832-1-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 09, 2018 at 12:13:06PM +0530, Ajay Singh wrote:
> wilc_debug.o object file is included for both SDIO and SPI module. When
> anyone(either SDIO or SPI) module is compiled as loaded module and another
> as buildin module then below compilation error occurs.
> 
> "drivers/staging/wilc1000/wilc_debugfs.o:(.data+0x10): undefined
> reference to `__this_module'"
> 
> Moved the declaration of file_operation variable in SDIO/SPI files and
> pass this as parameter to wilc_debugfs_init().
> Refactor wilc_debugfs_init() as its not required to maintain
> 'wilc_debugfs_info_t' in debugfs_info[] array. Also modified file
> permission from 0666 to 0600 & use 'data' field as 'NULL' in
> debugfs_create_file() call.
> 
> Fixes: 9abc44ba4e2f("staging: wilc1000: fix TODO to compile spi and sdio
> components in single module")
> 
> Reported-by: kbuild test robot <lkp@intel.com>

I don't think you need to resend, but the Fixes tag format isn't
right.

1) Don't line wrap it.  (Maybe checkpatch complains?  Ignore checkpatch).
2) Put a space between the git hash and the '('.
3) No blank line between the Fixes and the Reported-by.

> -int wilc_debugfs_init(void)
> +int wilc_debugfs_init(const struct file_operations *fops)

You may as well make wilc_debugfs_init() void since no one checks it.

>  {
> -	int i;
> -	struct wilc_debugfs_info_t *info;
> -
>  	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
> -	for (i = 0; i < ARRAY_SIZE(debugfs_info); i++) {
> -		info = &debugfs_info[i];
> -		debugfs_create_file(info->name,
> -				    info->perm,
> -				    wilc_dir,
> -				    &info->data,
> -				    &info->fops);
> +	if (IS_ERR_OR_NULL(wilc_dir)) {
> +		pr_err("Error creating debugfs\n");
> +		return -EFAULT;
>  	}

Just check for NULL.  If someone builds without debugfs enabled in their
.config, that's their choice.  No need to print a warning.

regards,
dan carpenter
