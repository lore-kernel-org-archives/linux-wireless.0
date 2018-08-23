Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56236 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729511AbeHWQHc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 12:07:32 -0400
Date: Thu, 23 Aug 2018 15:37:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, linux-wireless@vger.kernel.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH 23/24] staging: wilc1000: move 'wilc_connecting' static
 variable to 'wilc_vif' struct
Message-ID: <20180823123740.u3dnrnmxir3fq5uw@mwanda> (sfid-20180823_143803_795072_171AC3BD)
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
 <1534229416-13254-24-git-send-email-ajay.kathat@microchip.com>
 <20180823105527.GA1404@kroah.com>
 <20180823165748.0dbc7149@ajaysk-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180823165748.0dbc7149@ajaysk-VirtualBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 23, 2018 at 04:57:48PM +0530, Ajay Singh wrote:
> Hi Greg,
> 
> On Thu, 23 Aug 2018 12:55:27 +0200
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Tue, Aug 14, 2018 at 12:20:15PM +0530, Ajay Singh wrote:
> > > --- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> > > +++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> > > @@ -151,6 +151,7 @@ struct wilc_vif {
> > >  	struct timer_list periodic_rssi;
> > >  	struct rf_info periodic_stat;
> > >  	struct tcp_ack_filter ack_filter;
> > > +	int connecting;  
> > 
> > Shouldn't this be a boolean?
> > 
> 
> Yes, 'connecting' only have value as 0 or 1. I will change it to
> bool and rename it to 'is_connecting'.

I think just the name "connecting" implies bool so there is no need for
the "is_".

regards,
dan carpenter
