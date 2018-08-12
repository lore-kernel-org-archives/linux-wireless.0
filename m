Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56686 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbeHLSCs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Aug 2018 14:02:48 -0400
Date: Sun, 12 Aug 2018 17:24:21 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: devel@driverdev.osuosl.org, venkateswara.kaja@microchip.com,
        linux-wireless@vger.kernel.org, ganesh.krishna@microchip.com,
        adham.abozaeid@microchip.com, aditya.shankar@microchip.com
Subject: Re: [PATCH 1/5] staging: wilc1000: avoid arrray of
 'wilc_debugfs_info_t' type
Message-ID: <20180812152421.GB30273@kroah.com> (sfid-20180812_172431_442111_A098CC2D)
References: <1534049265-5600-1-git-send-email-ajay.kathat@microchip.com>
 <1534049265-5600-2-git-send-email-ajay.kathat@microchip.com>
 <20180812112930.GB25209@kroah.com>
 <20180812171829.1187a0cd@ajaysk-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180812171829.1187a0cd@ajaysk-VirtualBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 12, 2018 at 05:18:29PM +0530, Ajay Singh wrote:
> Hi Greg,
> 
> On Sun, 12 Aug 2018 13:29:30 +0200
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Sun, Aug 12, 2018 at 10:17:41AM +0530, Ajay Singh wrote:
> > > Refactor code by removing array of 'wilc_debugfs_info_t' type and
> > > use single variable to store 'wilc_debugfs_info_t' struct value.
> > > 
> > > Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > > ---
> > >  drivers/staging/wilc1000/wilc_debugfs.c | 26
> > > +++++++++----------------- 1 file changed, 9 insertions(+), 17
> > > deletions(-)
> > > 
> > > diff --git a/drivers/staging/wilc1000/wilc_debugfs.c
> > > b/drivers/staging/wilc1000/wilc_debugfs.c index edc7287..c5f67c9
> > > 100644 --- a/drivers/staging/wilc1000/wilc_debugfs.c
> > > +++ b/drivers/staging/wilc1000/wilc_debugfs.c
> > > @@ -78,29 +78,21 @@ struct wilc_debugfs_info_t {
> > >  	const struct file_operations fops;
> > >  };
> > >  
> > > -static struct wilc_debugfs_info_t debugfs_info[] = {
> > > -	{
> > > -		"wilc_debug_level",
> > > -		0666,
> > > -		(DEBUG | ERR),
> > > -		FOPS(NULL, wilc_debug_level_read,
> > > wilc_debug_level_write, NULL),
> > > -	},
> > > +static struct wilc_debugfs_info_t debugfs_info = {
> > > +	"wilc_debug_level",
> > > +	0666,
> > > +	(DEBUG | ERR),
> > > +	FOPS(NULL, wilc_debug_level_read, wilc_debug_level_write,
> > > NULL), };
> > >  
> > >  int wilc_debugfs_init(void)
> > >  {
> > > -	int i;
> > > -	struct wilc_debugfs_info_t *info;
> > > +	struct wilc_debugfs_info_t *info = &debugfs_info;
> > >  
> > >  	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
> > > -	for (i = 0; i < ARRAY_SIZE(debugfs_info); i++) {
> > > -		info = &debugfs_info[i];
> > > -		debugfs_create_file(info->name,
> > > -				    info->perm,
> > > -				    wilc_dir,
> > > -				    &info->data,
> > > -				    &info->fops);
> > > -	}
> > > +	debugfs_create_file(info->name, info->perm, wilc_dir,
> > > &info->data,
> > > +			    &info->fops);
> > > +
> > 
> > Why go through the extra step here in changing this variable from an
> > array to a single value and not just make the call to
> > debugfs_create_file() directly with the individual values like you do
> > in patch 3?  It feels like this step isn't needed at all here, right?
> > 
> > What am I missing?
> 
> Actually, while calling debugfs_create_file() it also passed the
> "info->data", "info->perm" which was maintained in a static variable.
> So to have the changes in multiple patches, I first tried by removing
> the dependency of array and later changed the individual parameters
> for this debugfs_create_file().

But you don't need/want that here anyway, it would have been simpler to
just do it correct in one patch.  That would have also been easier to
review :)

But for now, just delete this file as it is not used at all.  Want me to
do it for you?

thanks,

greg k-h
