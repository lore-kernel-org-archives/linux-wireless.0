Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:6427 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725746AbeHJI5z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Aug 2018 04:57:55 -0400
Date: Fri, 10 Aug 2018 11:59:22 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>
Subject: Re: [PATCH v2] staging: wilc1000: fix undefined reference to
 `__this_module' compilation error
Message-ID: <20180810115922.7326b271@ajaysk-VirtualBox> (sfid-20180810_082932_847017_38C8F277)
In-Reply-To: <20180809122133.GB6937@kroah.com>
References: <1533814179-21436-1-git-send-email-ajay.kathat@microchip.com>
        <20180809122133.GB6937@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

On Thu, 9 Aug 2018 14:21:33 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Thu, Aug 09, 2018 at 04:59:39PM +0530, Ajay Singh wrote:
> > wilc_debug.o object file is included for both SDIO and SPI module.
> > When anyone(either SDIO or SPI) module is compiled as loaded module
> > and another as buildin module then below compilation error occurs.
> > 
> > "drivers/staging/wilc1000/wilc_debugfs.o:(.data+0x10): undefined
> > reference to `__this_module'"
> > 
> > Moved the declaration of file_operation variable in SDIO/SPI files
> > and pass this as parameter to wilc_debugfs_init().
> > Refactor wilc_debugfs_init() as its not required to maintain
> > 'wilc_debugfs_info_t' in debugfs_info[] array. Also modified file
> > permission from 0666 to 0600 & use 'data' field as 'NULL' in
> > debugfs_create_file() call.  
> 
> That is a lot of different things all in one patch.  Please never do
> that.
> 

I started with intention to keep changes minimal but ended with these
changes :(

If you suggest, I will rework on this patch and submit a new patch
series.

> 
> > 
> > Fixes: 9abc44ba4e2f ("staging: wilc1000: fix TODO to compile spi
> > and sdio components in single module") Reported-by: kbuild test
> > robot <lkp@intel.com> Signed-off-by: Ajay Singh
> > <ajay.kathat@microchip.com> ---
> > changes since v1:
> >  1. Correct the Fixes tag format.
> >  2. Remove blank line between Fixes and Reported-by tag.
> >  3. Modified debug print and use only NULL check in
> > wilc_debugfs_init().
> > 
> >  drivers/staging/wilc1000/linux_wlan.c   |  1 -
> >  drivers/staging/wilc1000/wilc_debugfs.c | 51
> > +++++++--------------------------
> > drivers/staging/wilc1000/wilc_sdio.c    |  7 +++++
> > drivers/staging/wilc1000/wilc_spi.c     |  7 +++++
> > drivers/staging/wilc1000/wilc_wlan_if.h |  7 ++++- 5 files changed,
> > 30 insertions(+), 43 deletions(-)
> > 
> > diff --git a/drivers/staging/wilc1000/linux_wlan.c
> > b/drivers/staging/wilc1000/linux_wlan.c index 01cf4bd..37885ad
> > 100644 --- a/drivers/staging/wilc1000/linux_wlan.c
> > +++ b/drivers/staging/wilc1000/linux_wlan.c
> > @@ -1062,7 +1062,6 @@ int wilc_netdev_init(struct wilc **wilc,
> > struct device *dev, int io_type, if (!wl)
> >  		return -ENOMEM;
> >  
> > -	wilc_debugfs_init();
> >  	*wilc = wl;
> >  	wl->io_type = io_type;
> >  	wl->hif_func = ops;
> > diff --git a/drivers/staging/wilc1000/wilc_debugfs.c
> > b/drivers/staging/wilc1000/wilc_debugfs.c index edc7287..9787b3a
> > 100644 --- a/drivers/staging/wilc1000/wilc_debugfs.c
> > +++ b/drivers/staging/wilc1000/wilc_debugfs.c
> > @@ -20,8 +20,8 @@ static struct dentry *wilc_dir;
> >  #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
> >  static atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
> >  
> > -static ssize_t wilc_debug_level_read(struct file *file, char
> > __user *userbuf,
> > -				     size_t count, loff_t *ppos)
> > +ssize_t wilc_debug_level_read(struct file *file, char __user
> > *userbuf,
> > +			      size_t count, loff_t *ppos)
> >  {
> >  	char buf[128];
> >  	int res = 0;
> > @@ -36,9 +36,8 @@ static ssize_t wilc_debug_level_read(struct file
> > *file, char __user *userbuf, return
> > simple_read_from_buffer(userbuf, count, ppos, buf, res); }
> >  
> > -static ssize_t wilc_debug_level_write(struct file *filp,
> > -				      const char __user *buf,
> > size_t count,
> > -				      loff_t *ppos)
> > +ssize_t wilc_debug_level_write(struct file *filp, const char
> > __user *buf,
> > +			       size_t count, loff_t *ppos)
> >  {
> >  	int flag = 0;
> >  	int ret;
> > @@ -63,45 +62,15 @@ static ssize_t wilc_debug_level_write(struct
> > file *filp, return count;
> >  }
> >  
> > -#define FOPS(_open, _read, _write, _poll) { \
> > -		.owner	= THIS_MODULE, \
> > -		.open	= (_open), \
> > -		.read	= (_read), \
> > -		.write	= (_write), \
> > -		.poll		= (_poll), \
> > -}
> > -
> > -struct wilc_debugfs_info_t {
> > -	const char *name;
> > -	int perm;
> > -	unsigned int data;
> > -	const struct file_operations fops;
> > -};
> > -
> > -static struct wilc_debugfs_info_t debugfs_info[] = {
> > -	{
> > -		"wilc_debug_level",
> > -		0666,
> > -		(DEBUG | ERR),
> > -		FOPS(NULL, wilc_debug_level_read,
> > wilc_debug_level_write, NULL),
> > -	},
> > -};
> > -
> > -int wilc_debugfs_init(void)
> > +void wilc_debugfs_init(const struct file_operations *fops)
> >  {
> > -	int i;
> > -	struct wilc_debugfs_info_t *info;
> > -
> >  	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
> > -	for (i = 0; i < ARRAY_SIZE(debugfs_info); i++) {
> > -		info = &debugfs_info[i];
> > -		debugfs_create_file(info->name,
> > -				    info->perm,
> > -				    wilc_dir,
> > -				    &info->data,
> > -				    &info->fops);
> > +	if (!wilc_dir) {
> > +		pr_err("Error creating debugfs/wilc_wifi/\n");
> > +		return;  
> 
> The lack of checking was there for a reason, please do not add it
> back, it is not needed at all.
>

Ack.
I will take care of this point in updated patch.

Regards,
Ajay
