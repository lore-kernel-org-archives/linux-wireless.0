Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:24560 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbeHINZD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 09:25:03 -0400
Date: Thu, 9 Aug 2018 16:30:34 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <adham.abozaeid@microchip.com>,
        <aditya.shankar@microchip.com>
Subject: Re: [PATCH] staging: wilc1000: fix undefined reference to
 `__this_module' compilation error
Message-ID: <20180809163034.28e7b1d2@ajaysk-VirtualBox> (sfid-20180809_130057_570945_053C63A5)
In-Reply-To: <20180809104358.gg7mwmw57eawyqvd@mwanda>
References: <1533796986-8832-1-git-send-email-ajay.kathat@microchip.com>
        <20180809100838.pduj5s5lvbpjuljn@mwanda>
        <20180809104358.gg7mwmw57eawyqvd@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 9 Aug 2018 13:43:58 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Thu, Aug 09, 2018 at 01:08:38PM +0300, Dan Carpenter wrote:
> > On Thu, Aug 09, 2018 at 12:13:06PM +0530, Ajay Singh wrote:  
> > >  	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
> > > -	for (i = 0; i < ARRAY_SIZE(debugfs_info); i++) {
> > > -		info = &debugfs_info[i];
> > > -		debugfs_create_file(info->name,
> > > -				    info->perm,
> > > -				    wilc_dir,
> > > -				    &info->data,
> > > -				    &info->fops);
> > > +	if (IS_ERR_OR_NULL(wilc_dir)) {
> > > +		pr_err("Error creating debugfs\n");
> > > +		return -EFAULT;
> > >  	}  
> > 
> > Just check for NULL.  If someone builds without debugfs enabled in
> > their .config, that's their choice.  No need to print a warning.
> >   
> 
> Reading it again, I'm not sure my email was clear...  Just do this:
> 
> 	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
> 	if (!wilc_dir)) {
> 		pr_err("Error creating debugfs/wilc_wifi/\n");
> 		return;
> 	}
> 
> If debugfs_create_dir() returns an error pointer it means all the
> other debugfs functions are also just no-op stub functions.  Passing
> an error pointer to them is harmless.

Thanks for sharing the code snippet.
I will include it into v2 patch.

Regards,
Ajay
