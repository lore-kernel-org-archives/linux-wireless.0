Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43914 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbZEZNwM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 09:52:12 -0400
Subject: Re: Suggestions on low-cost Linux/ARM-friendly WiFi module or
 chipset...
From: Dan Williams <dcbw@redhat.com>
To: Jean-Pierre Poulin <jeanpierrepoulin@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <394878.84106.qm@web36808.mail.mud.yahoo.com>
References: <394878.84106.qm@web36808.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 May 2009 09:51:45 -0400
Message-Id: <1243345905.2575.21.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-05-25 at 20:43 -0700, Jean-Pierre Poulin wrote:
> Hello,
>  
> May I obtain your recommendation on a Linux + ARM friendly WiFi module or chipset?
>  
> The solution we’re looking for must have the following features:
> - WiFi features: 802.11b + 802.11g with WPA & WEP encryption.
> - Driver: Binary driver built for Linux+ARM9 *or* Driver source buildable for Linux 2.6.28.2
> - Electronic Interface: SDIO (strongly) preferred, then parallel bus, then SPI, and least preferred: USB
> - Physical interface: SMD-mounting (strongly) preferred, then SD-card, then USB stick
> - Size: Smaller the better (especially on ‘thickness’), but not critical.
> - Power efficiency: Irrelevant / Not critical.
> - Cost: Extremely critical!!
> - Range: The greater the better, but low-cost is much more important.
> - Antenna considerations: Small built-in chip antenna preferred.  External whip antenna a minus.
>  
> Working backwards on this from the currently available drivers (we’re building our Linux image ontop OpenWRT for the $2.80 NXP LPC313x), the following drivers are ‘easily accessible’ in OpenWRT… but we have yet to find the low-cost manufacturers that can provide the physical WiFi solution itself…
>  
>                
> kmod-libertas............................ Marvell 88W8015 Wireless Driver 

Libertas supports the following Marvell products:

88W8381 (CF)
88W8385 (CF, SDIO, GSPI)
88W8388 (USB)
88W8686 (SDIO, GSPI)
88W8688 (SDIO)

the "88W8015" you list is actually the radio, not the MAC, and thus not
something the driver cares much about.  One thing we've found is that
the quality of the SD host controller you choose is *critical*;
low-quality controllers just suck and make your life much harder.  That
probably goes for any SDIO-capable part, not just Libertas.

These parts are not usually available from Marvell directly, instead you
buy the module from a third party manufacturer that buys the chips from
Marvell and mounts them.  They usually do not have onboard antennas, but
you may be able to find a manufacturer that does put onboard antennas
onto their module.

Dan

> kmod-mac80211..................... Linux 802.11 Wireless Networking Stack 
> kmod-mac80211-hwsim........................ mac80211 HW simulation device 
> kmod-p54-common................................. Prism54 Drivers (COMMON) 
> kmod-p54-usb....................................... Prism54 Drivers (USB) 
> kmod-rt2500-usb............. Ralink Drivers for RT2x00 cards (RT2500 USB) 
> kmod-rt2800-usb............. Ralink Drivers for RT2x00 cards (RT2870 USB) 
> kmod-rt2x00-lib.................... Ralink Drivers for RT2x00 cards (LIB) 
> kmod-rt2x00-usb.................... Ralink Drivers for RT2x00 cards (USB) 
> kmod-rt73-usb................. Ralink Drivers for RT2x00 cards (RT73 USB) 
> kmod-zd1211rw....................................... Zydas ZD1211 support 
>  
> In addition, searching through the list of drivers at Linux Wireless, we were impressed by the comprehensive selection but – as device prices are not listed – it is very difficult to ascertain which inexpensive WiFi solution can run on our board.
>  
> Finally, as the cost of the total WiFi solution is so important, our ‘upper range’ for cost is about $11 per interface (1K qty), as our ‘plan B’ is simply to insert one of the many $13 USB-WiFi interface (such as those found on eBay) inside the product enclosure.  Some questions:
>  
> Q1: Given our above-stated needs… which do you recommend: the ‘module approach’, the ‘chipset approach’ or the ‘insert consumer product’ approach?
>  
> Q2: What is the ‘most famous’ / ‘most supported’ Linux/ARM-friendly low-cost WiFi solution currently available?
>  
> Q3: Can you recommend some low-cost (Taiwanese / Chinese) WiFi manufacturers that supplies low-cost Linux-compatible solutions?
>  
> Q4: For reference, what do you think is the cost of the ‘absolute lowest cost’ WiFi solution currently available?
>  
> Many thanks for any hint / suggestion you can provide!
>  
>    Jean-Pierre
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

