Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41772 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbeG3NHT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 09:07:19 -0400
Date: Mon, 30 Jul 2018 14:32:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: devel@driverdev.osuosl.org, venkateswara.kaja@microchip.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH 05/23] staging: wilc1000: rename goto to avoid leading
 '_' in label name
Message-ID: <20180730113231.gwqliakpdgbchrre@mwanda> (sfid-20180730_133249_273129_C9666A57)
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
 <1531953919-20804-6-git-send-email-ajay.kathat@microchip.com>
 <20180719092744.5gx2ctgj7etvk7uh@mwanda>
 <20180720043524.5a8d1c7e@ajaysk-VirtualBox>
 <20180730084113.fixf2zeb5tgbcovj@mwanda>
 <20180730154024.4324b0cd@ajaysk-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180730154024.4324b0cd@ajaysk-VirtualBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 30, 2018 at 03:40:24PM +0530, Ajay Singh wrote:
> Hi Dan,
> 
> On Mon, 30 Jul 2018 11:41:13 +0300
> Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> > On Fri, Jul 20, 2018 at 04:35:24AM +0530, Ajay Singh wrote:
> > > Hi Dan,
> > > 
> > > On Thu, 19 Jul 2018 12:27:44 +0300
> > > Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > >   
> > > > On Thu, Jul 19, 2018 at 04:15:01AM +0530, Ajay Singh wrote:  
> > > > > diff --git a/drivers/staging/wilc1000/wilc_wlan.c
> > > > > b/drivers/staging/wilc1000/wilc_wlan.c index 85af365..8e71c28
> > > > > 100644 --- a/drivers/staging/wilc1000/wilc_wlan.c
> > > > > +++ b/drivers/staging/wilc1000/wilc_wlan.c
> > > > > @@ -850,13 +850,13 @@ static void
> > > > > wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status) if
> > > > > (wilc->rx_buffer) buffer = &wilc->rx_buffer[offset];
> > > > >  		else
> > > > > -			goto _end_;
> > > > > +			goto end;    
> > > > 
> > > > This isn't related to your patch but this goto doesn't appear to
> > > > make any sort of sense.  I have no idea what was intended.
> > > >   
> > > 
> > > Thanks for pointing it out. I will include these changes in separate
> > > patchset.
> > > 
> > > Yes, the position of goto label can be moved just before
> > > wilc_wlan_handle_rxq(wilc), as 'ret' will always be '0' when goto
> > > statement is executed.
> > > 
> > > Actually earlier there were few more goto statement in this function
> > > and single label 'end' was used to handle for different cases. But
> > > in previous cleanup patches those cases were removed.
> > > Now this function can be further refactor by either moving
> > > goto label before wilc_wlan_handle_rxq(wilc) or avoid goto use by
> > > adding the rx_buffer validation along with size check.
> > > 
> > > i.e 
> > > 
> > > end:
> > >     wilc_wlan_handle_rxq(wilc)
> > > 
> > > 
> > > OR
> > > 
> > > 	if (size > 0 && wilc->rx_buffer) {
> > > 
> > > 	....
> > > 	}
> > >     	wilc_wlan_handle_rxq(wilc)
> > >   
> > 
> > Actually looking at it now, you could probably just remove the if
> > statement.  Hopefully wilc->rx_buffer is non-NULL at this point? Is
> > there really any need to call wilc_wlan_handle_rxq() when we haven't
> > called wilc_wlan_rxq_add()?
> > 
> 
> Yes, wilc->rx_buffer would be non NULL value as its only one time
> allocated buffer. wilc_wlan_handle_rxq() was called without
> wilc_wlan_rxq_add() just as a fail safe to ensure there are no pending
> packets in the queue.

The only thing is wilc->quit can be set.  Otherwise if ->rx_buffer is
NULL it would just result in a NULL dereference.  (We are deep into
hypotheticals here because we're discussing impossible code).

regards,
dan carpenter
