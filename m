Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout028.mac.com ([17.148.16.103]:52996 "EHLO
	asmtpout028.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab0LUTkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 14:40:18 -0500
MIME-version: 1.0
Content-type: text/plain; CHARSET=US-ASCII
Received: from [192.168.1.30] ([87.201.169.175])
 by asmtp028.mac.com (Oracle Communications Messaging Exchange Server 7u4-20.01
 64bit (built Nov 21 2010)) with ESMTPSA id <0LDS00BHNMMW2Y80@asmtp028.mac.com>
 for linux-wireless@vger.kernel.org; Tue, 21 Dec 2010 11:40:12 -0800 (PST)
Subject: Re: WL1271
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <1292957433.20560.109.camel@t-dhlii>
Date: Tue, 21 Dec 2010 23:39:54 +0400
Cc: linux-wireless@vger.kernel.org
Message-id: <A285AB50-982B-478D-A8A1-9153560175BD@mac.com>
References: <0826983CC0CB074798C42E77D8ACD07F01AE4A@pdtms1.pdt.com>
 <1292843841.13129.9.camel@chilepepper>
 <0826983CC0CB074798C42E77D8ACD07F01AEA8@pdtms1.pdt.com>
 <1292879085.20560.6.camel@t-dhlii>
 <4CC0832C-93B4-4212-BB5C-1901BB6A63D7@mac.com>
 <1292957433.20560.109.camel@t-dhlii>
To: "David Lynch Jr." <dhlii@dlasys.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Dec 21, 2010, at 10:50 PM, David Lynch Jr. wrote:

> 	I am essentially doing exactly the same thing as you are - but I am a
> few days behind you. I noted a post of yours about 10 days ago in
> linux-omap that you were having voltage/SDIO detection problems. I am
> having exactly that problem at this moment.  
> 	How did you work arround it ?
> 	The WL1271 is attached to MMC2 on my system. All the examples in the
> linux wireless tree are on SPI or MMC3. But I think I managed changing
> things correctly - except that the error reports are mmc1:
> 	Also the comments suggest that the WL1271 has its own internal voltage
> regulation. 
> 	That and a CY8CTMG-200 touch screen are the only major items I need
> working to polish off this project. 

If you could send me the schematics, I could comment on it.

There were a couple of hardware related problems that prevented the device from
booting up. 

Here are some of the key things to watch out for:

a. You need a slow clock (SYS 32K signal from the omap processor) to the wlan module

b. You need to ensure that you have a 26Mhz TXCO signal coming in for the fast clock.

This would be controlled by a fixed voltage regulator. The wlan module asserts a WL_CLK_REQ
signal high, which is a signal sent to the LDO to turn on the 26MHz TXCO.

c. You need to probe MMC2 CLK signals to ensure that a 24MHz signal is being generated at the 
output, when the MMC2 controller is initialized.

d. You need to update the mux settings to ensure that the MMC2 CMD, CLK, DAT 0 to DAT3, plus
GPIO pins for WLAN_EN and WLAN_IRQ are muxed correctly.

This should take care of it. 

The SDIO detection problems occured because the 26MHZ TXCO was not being turn on.

You should also be aware of the TI WL1271 power up sequence, which is 10ms pulse high, 64us low,
and then asserted high for atleast 64ms. This is taken care of in the driver code.

Also use the linux-2.6.37-rc6 kernel patch, and apply the patch to read the MAC address from the nvs file.

Also put the firmware and nvs file in /lib/firmware folder, and configure wpa_supplicant.conf to connect
to a secured access point.

Best regards,

Elvis
