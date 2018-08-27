Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:6358 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbeH0JZO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Aug 2018 05:25:14 -0400
Date: Mon, 27 Aug 2018 11:10:02 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Adham Abozaeid <adham.abozaeid@microchip.com>
CC: Claudiu Beznea <Claudiu.Beznea@microchip.com>,
        <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <venkateswara.kaja@microchip.com>, <aditya.shankar@microchip.com>
Subject: Re: [PATCH 10/24] staging: wilc1000: move
 wilc_multicast_mac_addr_list to 'wilc_vif' struct
Message-ID: <20180827111002.332a2539@ajaysk-VirtualBox> (sfid-20180827_074011_161199_45DC6BEA)
In-Reply-To: <20180824173246.106ffee8@edcwlt13-vm>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
        <1534229416-13254-11-git-send-email-ajay.kathat@microchip.com>
        <92faa952-6722-cc9f-cccf-2275c4158a37@microchip.com>
        <20180823153021.3ad58351@ajaysk-VirtualBox>
        <eb7b4aa5-613e-9efc-4b5e-a926f8b23fb1@microchip.com>
        <20180824173246.106ffee8@edcwlt13-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adham,

On Fri, 24 Aug 2018 17:32:46 -0700
Adham Abozaeid <adham.abozaeid@microchip.com> wrote:

> On Fri, 24 Aug 2018 11:47:14 +0300
> Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:
> 
> > 
> > 
> > On 23.08.2018 13:00, Ajay Singh wrote:  
> > > Unless ndo_set_rx_mode() gets called quickly I don't think there
> > > is any issue here.   
> > 
> > I don't agree with this.  
> 
> It would be safer that the mcast list be passed to
> wilc_setup_multicast_filter() to be copied to the msg structure then
> handled by the worker thread. In this case vif->mc_mac_addr_list can
> be removed all together.


Thanks for your suggestion.

Yes, I agree we can allocate and pass 'mac_addr_list' to worker thread
so it can be handled safely. And this solution would be better than
changing handle_set_mcast_filter() to a sync call, which i have
suggested earlier.


Regards,
Ajay
