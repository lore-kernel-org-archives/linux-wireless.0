Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:53935 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab2LJRuj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 12:50:39 -0500
Message-ID: <1355161791.3738.67.camel@cumari.coelho.fi> (sfid-20121210_185042_349560_8B8AA23D)
Subject: wl12xx over spi with no scan results (was: Re: [PATCH 20/20]
 wlcore: Always pass DMA-able buffers to mmc functions)
From: Luciano Coelho <coelho@ti.com>
To: Alberto Garau <Alberto.Garau@inpeco.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ido Yariv" <ido@wizery.com>, Arik Nemtsov <arik@wizery.com>
Date: Mon, 10 Dec 2012 19:49:51 +0200
In-Reply-To: <0294E4ABF3EF28409B75AAF7EAC3D41A0C360305@DB3PRD0510MB381.eurprd05.prod.outlook.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-21-git-send-email-arik@wizery.com>
	 <1355159205.3738.63.camel@cumari.coelho.fi>
	 <0294E4ABF3EF28409B75AAF7EAC3D41A0C360305@DB3PRD0510MB381.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alberto,

On Mon, 2012-12-10 at 17:24 +0000, Alberto Garau wrote:
> I’m trying to make working the WL1271 TI Murata chip with our custom board.  The SPI driver seems to be running but I cannot scan from our Wifi Network. 
> 
> After booting the board I’m doing:
> 
> •	insmod /media/red/root/wl1271/wl1271.ko
> •	insmod /media/red/root/wl1271/wl1271_spi.ko
> •	iwconfig wlan0 mode managed
> •	iwconfig wlan0 essid xxxxxxx
> •	ifconfig wlan0 hw ether 00:80:E1:12:26:17 
> •	ifconfig wlan0 192.168.40.100 netmask 255.255.255.0 up
> 
> Then I botain:
> 
> chip_id read from memory: 04030111
> wl1271_fetch_firmware - fetching firmware wl1271-fw.bin
> wl1271_fetch_nvs - fetching firmware wl1271-nvs.bin
> wl1271: firmware booted (Rev 6.1.0.50.350)
> 
> but unfortunately the when I run “iwlist wlan0 scan”
> 
> I obtain “wlan0 No scan results”
> 
> 
> Could you please help us in fixing this issue ?

This could be many different things.  The first thing that comes to my
mind is that the scan results are the first thing that comes as a real
interrupt (before this all the interrupts are polled).  So are you sure
the interrupt line is working properly?

--
Luca.

