Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35890 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbeHINIa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 09:08:30 -0400
Date: Thu, 9 Aug 2018 13:43:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH] staging: wilc1000: fix undefined reference to
 `__this_module' compilation error
Message-ID: <20180809104358.gg7mwmw57eawyqvd@mwanda> (sfid-20180809_124418_012695_BCCB37C8)
References: <1533796986-8832-1-git-send-email-ajay.kathat@microchip.com>
 <20180809100838.pduj5s5lvbpjuljn@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180809100838.pduj5s5lvbpjuljn@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 09, 2018 at 01:08:38PM +0300, Dan Carpenter wrote:
> On Thu, Aug 09, 2018 at 12:13:06PM +0530, Ajay Singh wrote:
> >  	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
> > -	for (i = 0; i < ARRAY_SIZE(debugfs_info); i++) {
> > -		info = &debugfs_info[i];
> > -		debugfs_create_file(info->name,
> > -				    info->perm,
> > -				    wilc_dir,
> > -				    &info->data,
> > -				    &info->fops);
> > +	if (IS_ERR_OR_NULL(wilc_dir)) {
> > +		pr_err("Error creating debugfs\n");
> > +		return -EFAULT;
> >  	}
> 
> Just check for NULL.  If someone builds without debugfs enabled in their
> .config, that's their choice.  No need to print a warning.
> 

Reading it again, I'm not sure my email was clear...  Just do this:

	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
	if (!wilc_dir)) {
		pr_err("Error creating debugfs/wilc_wifi/\n");
		return;
	}

If debugfs_create_dir() returns an error pointer it means all the other
debugfs functions are also just no-op stub functions.  Passing an error
pointer to them is harmless.

regards,
dan carpenter
