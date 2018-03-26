Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:36019 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752189AbeCZPgL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 11:36:11 -0400
Date: Mon, 26 Mar 2018 21:05:48 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Colin King <colin.king@canonical.com>
CC: Joe Perches <joe@perches.com>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: wilc1000: check for kmalloc allocation
 failures
Message-ID: <20180326210548.791f070a@ajaysk-VirtualBox> (sfid-20180326_173624_668503_5D975753)
In-Reply-To: <1521662598.7999.33.camel@perches.com>
References: <20180321191941.4126-1-colin.king@canonical.com>
        <1521662598.7999.33.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for submitting the patch.

On Wed, 21 Mar 2018 13:03:18 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2018-03-21 at 19:19 +0000, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > There are three kmalloc allocations that are not null checked which
> > potentially could lead to null pointer dereference issues. Fix this
> > by adding null pointer return checks.
> 
> looks like all of these should be kmemdup or kstrdup
> 
> >  
> > @@ -951,6 +955,10 @@ static s32 handle_connect(struct wilc_vif *vif,
> >  	if (conn_attr->ssid) {
> >  		hif_drv->usr_conn_req.ssid = kmalloc(conn_attr->ssid_len + 1,
> >  						     GFP_KERNEL);
> > +		if (!hif_drv->usr_conn_req.ssid) {
> > +			result = -ENOMEM;
> > +			goto error;
> > +		}
> >  		memcpy(hif_drv->usr_conn_req.ssid,
> >  		       conn_attr->ssid,
> >  		       conn_attr->ssid_len);

With this changes the Coverity reported warning is handled correctly.

For further improvement to the patch, as Joe Perches suggested, its better
to make use of kmemdup instead of kmalloc & memcpy. As kstrdup requires the
source string to be NULL terminated('\0') and conn_attr->ssid might not  
contains the '\0' terminated string. So kmemdup with length of 
'conn_attr->ssid_len' can be used instead.

Please include the changes by using kmemdup() for all kmalloc/memcpy in
this patch.



Regards,
Ajay
