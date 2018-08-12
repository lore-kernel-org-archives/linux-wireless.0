Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47278 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728167AbeHLONp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Aug 2018 10:13:45 -0400
Date: Sun, 12 Aug 2018 13:35:55 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, ganesh.krishna@microchip.com,
        adham.abozaeid@microchip.com, aditya.shankar@microchip.com
Subject: Re: [PATCH 2/5] staging: wilc1000: fixes for undefined reference to
 `__this_module' error
Message-ID: <20180812113555.GC25209@kroah.com> (sfid-20180812_133601_929028_5C91EACD)
References: <1534049265-5600-1-git-send-email-ajay.kathat@microchip.com>
 <1534049265-5600-3-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534049265-5600-3-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 12, 2018 at 10:17:42AM +0530, Ajay Singh wrote:
> wilc_debug.o object file is included for both SDIO and SPI module. When
> anyone(either SDIO or SPI) module is compiled as loaded module and another
> as buildin module then below compilation error occurs.
> 
> "drivers/staging/wilc1000/wilc_debugfs.o:(.data+0x10): undefined
> reference to `__this_module'"
> 
> Moved the declaration of file_operation variable in SDIO/SPI files and
> pass this as parameter to wilc_debugfs_init(). Remove 'fops' element
> from 'wilc_debugfs_info_t' struct, as its not required.
> 
> Fixes: 9abc44ba4e2f ("staging: wilc1000: fix TODO to compile spi and sdio components in single module")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/linux_wlan.c   |  1 -
>  drivers/staging/wilc1000/wilc_debugfs.c | 23 ++++++-----------------
>  drivers/staging/wilc1000/wilc_sdio.c    |  7 +++++++
>  drivers/staging/wilc1000/wilc_spi.c     |  7 +++++++
>  drivers/staging/wilc1000/wilc_wlan_if.h |  7 ++++++-
>  5 files changed, 26 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index 01cf4bd..37885ad 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -1062,7 +1062,6 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
>  	if (!wl)
>  		return -ENOMEM;
>  
> -	wilc_debugfs_init();
>  	*wilc = wl;
>  	wl->io_type = io_type;
>  	wl->hif_func = ops;
> diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
> index c5f67c9..78c0831 100644
> --- a/drivers/staging/wilc1000/wilc_debugfs.c
> +++ b/drivers/staging/wilc1000/wilc_debugfs.c
> @@ -20,8 +20,8 @@ static struct dentry *wilc_dir;
>  #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
>  static atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
>  
> -static ssize_t wilc_debug_level_read(struct file *file, char __user *userbuf,
> -				     size_t count, loff_t *ppos)
> +ssize_t wilc_debug_level_read(struct file *file, char __user *userbuf,
> +			      size_t count, loff_t *ppos)
>  {
>  	char buf[128];
>  	int res = 0;
> @@ -36,9 +36,8 @@ static ssize_t wilc_debug_level_read(struct file *file, char __user *userbuf,
>  	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
>  }
>  
> -static ssize_t wilc_debug_level_write(struct file *filp,
> -				      const char __user *buf, size_t count,
> -				      loff_t *ppos)
> +ssize_t wilc_debug_level_write(struct file *filp, const char __user *buf,
> +			       size_t count, loff_t *ppos)
>  {
>  	int flag = 0;
>  	int ret;
> @@ -63,35 +62,25 @@ static ssize_t wilc_debug_level_write(struct file *filp,
>  	return count;
>  }
>  
> -#define FOPS(_open, _read, _write, _poll) { \
> -		.owner	= THIS_MODULE, \
> -		.open	= (_open), \
> -		.read	= (_read), \
> -		.write	= (_write), \
> -		.poll		= (_poll), \
> -}
> -
>  struct wilc_debugfs_info_t {
>  	const char *name;
>  	int perm;
>  	unsigned int data;
> -	const struct file_operations fops;
>  };
>  
>  static struct wilc_debugfs_info_t debugfs_info = {
>  	"wilc_debug_level",
>  	0666,
>  	(DEBUG | ERR),
> -	FOPS(NULL, wilc_debug_level_read, wilc_debug_level_write, NULL),
>  };
>  
> -int wilc_debugfs_init(void)
> +int wilc_debugfs_init(const struct file_operations *fops)
>  {
>  	struct wilc_debugfs_info_t *info = &debugfs_info;
>  
>  	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
>  	debugfs_create_file(info->name, info->perm, wilc_dir, &info->data,
> -			    &info->fops);
> +			    fops);
>  
>  	return 0;
>  }
> diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
> index b2080d8..c1573f5 100644
> --- a/drivers/staging/wilc1000/wilc_sdio.c
> +++ b/drivers/staging/wilc1000/wilc_sdio.c
> @@ -103,6 +103,12 @@ static int wilc_sdio_cmd53(struct wilc *wilc, struct sdio_cmd53 *cmd)
>  	return ret;
>  }
>  
> +static const struct file_operations sdio_debug_fops = {
> +	.owner		= THIS_MODULE,
> +	.read		= wilc_debug_level_read,
> +	.write		= wilc_debug_level_write,
> +};
> +
>  static int linux_sdio_probe(struct sdio_func *func,
>  			    const struct sdio_device_id *id)
>  {
> @@ -126,6 +132,7 @@ static int linux_sdio_probe(struct sdio_func *func,
>  		dev_err(&func->dev, "Couldn't initialize netdev\n");
>  		return ret;
>  	}
> +	wilc_debugfs_init(&sdio_debug_fops);
>  	sdio_set_drvdata(func, wilc);
>  	wilc->dev = &func->dev;
>  	wilc->gpio_irq = gpio;
> diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
> index 5517477..0376649 100644
> --- a/drivers/staging/wilc1000/wilc_spi.c
> +++ b/drivers/staging/wilc1000/wilc_spi.c
> @@ -102,6 +102,12 @@ static u8 crc7(u8 crc, const u8 *buffer, u32 len)
>  
>  #define USE_SPI_DMA				0
>  
> +static const struct file_operations spi_debug_fops = {
> +	.owner		= THIS_MODULE,
> +	.read		= wilc_debug_level_read,
> +	.write		= wilc_debug_level_write,
> +};

Wait, step back a second.  Why all of this work for a debugfs file that
no one uses?  In wilc_debugfs.c there seems to only provide a single
debugfs file to read and write a value that no one uses anywhere.

So why not a simple patch to just delete the wilc_debugfs.c file
entirely?  Who even uses this debugfs file?  And if they do, what is it
for?  What am I missing about how this is used?

thanks,

greg k-h
