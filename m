Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:35675 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2LKJen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 04:34:43 -0500
Message-ID: <1355218436.3738.122.camel@cumari.coelho.fi> (sfid-20121211_103448_809196_593E626C)
Subject: Re: wl12xx over spi with no scan results
From: Luciano Coelho <coelho@ti.com>
To: Alberto Garau <Alberto.Garau@inpeco.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>, Arik Nemtsov <arik@wizery.com>
Date: Tue, 11 Dec 2012 11:33:56 +0200
In-Reply-To: <0294E4ABF3EF28409B75AAF7EAC3D41A0C360609@DB3PRD0510MB381.eurprd05.prod.outlook.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-21-git-send-email-arik@wizery.com>
	 <1355159205.3738.63.camel@cumari.coelho.fi>
	 <0294E4ABF3EF28409B75AAF7EAC3D41A0C360305@DB3PRD0510MB381.eurprd05.prod.outlook.com>
	 <1355161791.3738.67.camel@cumari.coelho.fi>
	 <0294E4ABF3EF28409B75AAF7EAC3D41A0C360609@DB3PRD0510MB381.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-12-11 at 09:16 +0000, Alberto Garau wrote:
> Hi Luca,
> 
> -----Original Message-----
> From: Luciano Coelho [mailto:coelho@ti.com] 
> Sent: lunedì 10 dicembre 2012 18:50
> To: Alberto Garau
> Cc: linux-wireless@vger.kernel.org; Ido Yariv; Arik Nemtsov
> Subject: wl12xx over spi with no scan results (was: Re: [PATCH 20/20] wlcore: Always pass DMA-able buffers to mmc functions)
> 
> Hi Alberto,
> 
> On Mon, 2012-12-10 at 17:24 +0000, Alberto Garau wrote:
> > I’m trying to make working the WL1271 TI Murata chip with our custom board.  The SPI driver seems to be running but I cannot scan from our Wifi Network. 
> > 
> > After booting the board I’m doing:
> > 
> > •	insmod /media/red/root/wl1271/wl1271.ko
> > •	insmod /media/red/root/wl1271/wl1271_spi.ko
> > •	iwconfig wlan0 mode managed
> > •	iwconfig wlan0 essid xxxxxxx
> > •	ifconfig wlan0 hw ether 00:80:E1:12:26:17 
> > •	ifconfig wlan0 192.168.40.100 netmask 255.255.255.0 up
> > 
> > Then I botain:
> > 
> > chip_id read from memory: 04030111
> > wl1271_fetch_firmware - fetching firmware wl1271-fw.bin 
> > wl1271_fetch_nvs - fetching firmware wl1271-nvs.bin
> > wl1271: firmware booted (Rev 6.1.0.50.350)
> > 
> > but unfortunately the when I run “iwlist wlan0 scan”
> > 
> > I obtain “wlan0 No scan results”
> > 
> > 
> > Could you please help us in fixing this issue ?
> 
> This could be many different things.  The first thing that comes to my
> mind is that the scan results are the first thing that comes as a real
> interrupt (before this all the interrupts are polled).  So are you
> sure the interrupt line is working properly?
> 
> The interrupt line it seems to work properly. I put a printk in the
> interrupt handler and I see it activated 

Ok.


> During the firmware fetch and when I perform the "iwlista wlan0 scan".
> I kept the IRQ association to IRQ_TYPE_EDGE_RISING as your source code
> was in 2.6.37 kernel.

That's an *ancient* kernel. :( Any chance you can try it with a newer
kernel?


> Any other idea about why the scan command it's not properly working ?

Another common problem is the clock settings.  Are you sure the correct
value for board_ref_clock in your board file?

--
Luca.

