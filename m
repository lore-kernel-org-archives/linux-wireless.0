Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:33558 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbeHWO5L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 10:57:11 -0400
Date: Thu, 23 Aug 2018 16:57:48 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>, <ganesh.krishna@microchip.com>,
        <adham.abozaeid@microchip.com>, <aditya.shankar@microchip.com>
Subject: Re: [PATCH 23/24] staging: wilc1000: move 'wilc_connecting' static
 variable to 'wilc_vif' struct
Message-ID: <20180823165748.0dbc7149@ajaysk-VirtualBox> (sfid-20180823_132757_522282_DE733C87)
In-Reply-To: <20180823105527.GA1404@kroah.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
        <1534229416-13254-24-git-send-email-ajay.kathat@microchip.com>
        <20180823105527.GA1404@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

On Thu, 23 Aug 2018 12:55:27 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Tue, Aug 14, 2018 at 12:20:15PM +0530, Ajay Singh wrote:
> > --- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> > +++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> > @@ -151,6 +151,7 @@ struct wilc_vif {
> >  	struct timer_list periodic_rssi;
> >  	struct rf_info periodic_stat;
> >  	struct tcp_ack_filter ack_filter;
> > +	int connecting;  
> 
> Shouldn't this be a boolean?
> 

Yes, 'connecting' only have value as 0 or 1. I will change it to
bool and rename it to 'is_connecting'.


Regards,
Ajay
