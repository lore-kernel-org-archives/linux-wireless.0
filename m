Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34580 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbbI3MnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 08:43:18 -0400
Date: Wed, 30 Sep 2015 18:12:50 +0530
From: Chandra Gorentla <csgorentla@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, johnny.kim@atmel.com,
	rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 1/2] drivers: staging: wilc1000: Replace message queue
 with standard Linux lists
Message-ID: <20150930124250.GB4704@gcs-HP-Notebook> (sfid-20150930_144334_930161_A4DFD63C)
References: <1443464037-3591-1-git-send-email-csgorentla@gmail.com>
 <20150929023152.GD7289@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150929023152.GD7289@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 29, 2015 at 05:31:53AM +0300, Dan Carpenter wrote:
> On Mon, Sep 28, 2015 at 11:43:55PM +0530, Chandra S Gorentla wrote:
> >  - The message queue is replaced with standard Linux linked list
> >  - kmem_cache is used for list members
> >  - A check for return value of receive method is added
> >  - GFP_ATOMIC is changed to GFP_KERNEL
> >  - A few other related minor changes
> 
> These should be listed and explained.
OK.  I will try to send seperate patches.
> 
> >  
> >  	while (1) {
> > -		wilc_mq_recv(&gMsgQHostIF, &msg, sizeof(struct host_if_msg), &u32Ret);
> > +		ret = wilc_mq_recv(&gMsgQHostIF, &msg,
> > +					sizeof(struct host_if_msg), &u32Ret);
> > +		if (ret)
> > +			continue;
> > +
> 
> I asked before if this was a forever loop and never got a response.
> Also what does this have to do with list macros?
The only exit condition of this loop is to receive a message
'HOST_IF_MSG_EXIT'.  If this check is not there and 'wilc_mq_recv'
returns an error, the switch case below it will be executed for
the previously received message.

I will send this change in a different patch.
> 
> regards,
> dan carpenter
