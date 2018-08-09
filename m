Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54022 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbeHIPQz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 11:16:55 -0400
Date: Thu, 9 Aug 2018 15:51:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ajay Singh <ajay.kathat@microchip.com>, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, linux-wireless@vger.kernel.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH] staging: wilc1000: fix undefined reference to
 `__this_module' compilation error
Message-ID: <20180809125155.c4fetniqsvdvkge5@mwanda> (sfid-20180809_145212_660988_93237268)
References: <1533796986-8832-1-git-send-email-ajay.kathat@microchip.com>
 <20180809100838.pduj5s5lvbpjuljn@mwanda>
 <20180809104358.gg7mwmw57eawyqvd@mwanda>
 <20180809121324.GA6937@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180809121324.GA6937@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 09, 2018 at 02:13:24PM +0200, Greg KH wrote:
> On Thu, Aug 09, 2018 at 01:43:58PM +0300, Dan Carpenter wrote:
> > On Thu, Aug 09, 2018 at 01:08:38PM +0300, Dan Carpenter wrote:
> > > On Thu, Aug 09, 2018 at 12:13:06PM +0530, Ajay Singh wrote:
> > > >  	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
> > > > -	for (i = 0; i < ARRAY_SIZE(debugfs_info); i++) {
> > > > -		info = &debugfs_info[i];
> > > > -		debugfs_create_file(info->name,
> > > > -				    info->perm,
> > > > -				    wilc_dir,
> > > > -				    &info->data,
> > > > -				    &info->fops);
> > > > +	if (IS_ERR_OR_NULL(wilc_dir)) {
> > > > +		pr_err("Error creating debugfs\n");
> > > > +		return -EFAULT;
> > > >  	}
> > > 
> > > Just check for NULL.  If someone builds without debugfs enabled in their
> > > .config, that's their choice.  No need to print a warning.
> > > 
> > 
> > Reading it again, I'm not sure my email was clear...  Just do this:
> > 
> > 	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
> > 	if (!wilc_dir)) {
> > 		pr_err("Error creating debugfs/wilc_wifi/\n");
> > 		return;
> > 	}
> > 
> > If debugfs_create_dir() returns an error pointer it means all the other
> > debugfs functions are also just no-op stub functions.  Passing an error
> > pointer to them is harmless.
> 
> No, please never care about the return value of a debugfs call, it
> should never cause your code flow to do anything different.  THis should
> just be:
> 	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
> and then keep on going.  You can always pass the return value of a
> debugfs call to another one, no need to check anything.
> 
> I've done a large sweep of the kernel tree for most of this pattern for
> 4.18, and will keep doing it over time, as it keeps creeping back.

Yeah, that's how I thought it was supposed be but then the cleanup
doesn't work.  We end up putting all the new debugfs files in the base
debugsf directory.  Doesn't it lead to a use after free if we unload the
module?

I know that you aren't supposed to unload modules in production.

regards,
dan carpenter
