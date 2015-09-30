Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31616 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293AbbI3NWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 09:22:42 -0400
Date: Wed, 30 Sep 2015 16:22:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chandra Gorentla <csgorentla@gmail.com>
Cc: rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	linux-kernel@vger.kernel.org, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 1/2] drivers: staging: wilc1000: Replace message queue
 with standard Linux lists
Message-ID: <20150930132207.GH7340@mwanda> (sfid-20150930_152259_454127_C90D7408)
References: <1443464037-3591-1-git-send-email-csgorentla@gmail.com>
 <20150929023152.GD7289@mwanda>
 <20150930124250.GB4704@gcs-HP-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150930124250.GB4704@gcs-HP-Notebook>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 30, 2015 at 06:12:50PM +0530, Chandra Gorentla wrote:
> > >  	while (1) {
> > > -		wilc_mq_recv(&gMsgQHostIF, &msg, sizeof(struct host_if_msg), &u32Ret);
> > > +		ret = wilc_mq_recv(&gMsgQHostIF, &msg,
> > > +					sizeof(struct host_if_msg), &u32Ret);
> > > +		if (ret)
> > > +			continue;
> > > +
> > 
> > I asked before if this was a forever loop and never got a response.
> > Also what does this have to do with list macros?
> The only exit condition of this loop is to receive a message
> 'HOST_IF_MSG_EXIT'.  If this check is not there and 'wilc_mq_recv'
> returns an error, the switch case below it will be executed for
> the previously received message.

Oh, hm...  It looks like wilc_mq_recv() can return -EFAULT, -EOVERFLOW
or success here.  If it returns -EFUALT is calling wilc_mq_recv() again
really the right thing?  I suspect we should break in that case.  We
should probably at least sleep for a bit intsead of looping so tightly
if it returns -EOVERFLOW?

I'm not sure.

regards,
dan carpenter

