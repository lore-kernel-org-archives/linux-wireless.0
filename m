Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbcFZOnj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2016 10:43:39 -0400
Date: Sat, 25 Jun 2016 15:16:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, chris.park@atmel.com,
	austin.shin@atmel.com, johnny.kim@atmel.com,
	julian.calaby@gmail.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH v2 1/2] staging: wilc1000: fix error handling in
 wilc_debugfs_init()
Message-ID: <20160625221659.GA11632@kroah.com> (sfid-20160626_164414_464850_1F968BB9)
References: <1466685378-15597-1-git-send-email-luisbg@osg.samsung.com>
 <20160625213606.GA15125@kroah.com>
 <576EFB05.1060902@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <576EFB05.1060902@osg.samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 25, 2016 at 10:43:33PM +0100, Luis de Bethencourt wrote:
> On 25/06/16 22:36, Greg KH wrote:
> > On Thu, Jun 23, 2016 at 01:36:17PM +0100, Luis de Bethencourt wrote:
> >> The common format to check if a function returned an error pointer is to
> >> use PTR_ERR(). Instead of ERR_PTR() which is used to return said errors.
> >>
> >> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> >> Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
> >> ---
> >>  drivers/staging/wilc1000/wilc_debugfs.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
> >> index fcbc95d..48797dc 100644
> >> --- a/drivers/staging/wilc1000/wilc_debugfs.c
> >> +++ b/drivers/staging/wilc1000/wilc_debugfs.c
> >> @@ -107,7 +107,7 @@ static int __init wilc_debugfs_init(void)
> >>  	struct wilc_debugfs_info_t *info;
> >>  
> >>  	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
> >> -	if (wilc_dir ==  ERR_PTR(-ENODEV)) {
> >> +	if (PTR_ERR(wilc_dir) == -ENODEV) {
> >>  		/* it's not error. the debugfs is just not being enabled. */
> >>  		printk("ERR, kernel has built without debugfs support\n");
> >>  		return 0;
> > 
> > No, the best way to do this is to just ignore the return value, you
> > don't care about it.  It can be passed back into any debugfs calls just
> > fine.
> > 
> > So don't check the value and all is good, debugfs was written in a way
> > to make it _easy_ to use, no need for fancy error checking at all with
> > it.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Thanks for the review Greg.
> 
> Just to make sure. You are proposing I just drop the 3 if checks? [0]
> 
> If that's what you mean I will send a patch as soon as you confirm :)
> 
> Happy hacking,
> Luis
> 
> 
> 
> [0] Making the function look like this:
> static int __init wilc_debugfs_init(void)
> {
>         int i;
> 
>         struct dentry *debugfs_files;
>         struct wilc_debugfs_info_t *info;
> 
>         wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
>         for (i = 0; i < ARRAY_SIZE(debugfs_info); i++) {
>                 info = &debugfs_info[i];
>                 debugfs_files = debugfs_create_file(info->name,
>                                                     info->perm,
>                                                     wilc_dir,
>                                                     &info->data,
>                                                     &info->fops);

Why even assign anything to debugfs_files?
