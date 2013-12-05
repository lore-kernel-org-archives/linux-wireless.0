Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59778 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402Ab3LEHqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 02:46:13 -0500
Message-Id: <1386229571.21963.55765989.23A91CF8@webmail.messagingengine.com> (sfid-20131205_084617_717117_06AA937A)
From: "Nikita N." <nikitan@operamail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: RTL8187 bugs
Date: Wed, 04 Dec 2013 23:46:11 -0800
In-Reply-To: <529F9550.7030604@lwfinger.net>
References: <1385589961.19021.52907237.3EE33E5B@webmail.messagingengine.com>
 <52966D64.2030805@lwfinger.net>
 <1385593188.3627.52911717.4E0712D9@webmail.messagingengine.com>
 <52968893.6060405@lwfinger.net>
 <1385812990.14905.53777877.7646278B@webmail.messagingengine.com>
 <529A1B52.6040605@lwfinger.net>
 <1385835820.6559.53858669.5FD3F3A6@webmail.messagingengine.com>
 <529A36C5.4060209@lwfinger.net>
 <1386079140.19919.54929613.506DE0D0@webmail.messagingengine.com>
 <529E0166.90302@lwfinger.net>
 <1386105710.9442.55117909.7AF98FBC@webmail.messagingengine.com>
 <529E9437.7020305@lwfinger.net>
 <1386143567.23274.55300753.5C861343@webmail.messagingengine.com>
 <529F9550.7030604@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry :)
If I can give you my humble suggestion - keep the rest of your 8187
interfaces park, far from 3.13 .. I lost both mine like that.. :P
Instead if you can, please test another working 8187 on a different safe
distro, e.g. Backtrack5 Live, any version, and install our patch, ok?
Would be nice to see logs there..
As you know, Backtrack5 is a live distro, means yes, when reboot all
changes are lost.. but you workaround that running on VMWare and
choosing "save state" (instead of power-off) 
The times I have been running on BT5, monitor mode always worked with no
issues.. kinda of, at last 3 years no-problems testing :)
As I see from your log, your 8187 goes in monitor (promiscuous) with
different patterns: priv->rx_conf shifts from 0e:fc:94:90 (0x9094fc0e)
to 0f:fc:9c:90 (0x909cfc0f) plus more options.. in mine, priv->rx_conf
shifts from 0a:fc:94:90 to 0b:fc:9c:90.
The last 3 bytes of priv->rx_conf are the same in mine and yours, just
the first is different (0b/0f) but it still doesnt put interface in
functional monitor mode.
FYI, in backports Hauke Mehrtens wrote me about a eeprom bug they
discovered.. could it be related?

thanks :)

On Wed, Dec 4, 2013, at 12:49 PM, Larry Finger wrote:

> 
> Until I fixed your patch, I could not be assured that it would work. I
> get 
> nervous when that small a patch generates that many warhings.
> 
> I was finally able to test monitor mode this morning, and found that it
> is 
> failing for kernel 3.13-rc2 as you said. The system set promiscous mode,
> but no 
> off-channel data is returned. I use openSUSE 13.1 on an ancient laptop.
> It is 
> installed without X - not enough memory. I use kismet to capture
> over-the-air 
> data. I am currently building a v3.0 kernel to see when the failure
> happened. At 
> least I am pretty sure that I used rtl8187 in monitor mode in the past.
> 
> The logged data for my most recent run is
> 
> [  295.841561] device wlan2 entered promiscuous mode
> [  295.842068] rtl8187_configure_filter
> [  295.842104] IN>changed_flags=0x3 ,total_flags=0x80000001
> ,multicast=0x3 
> ,priv->rx_conf=0x9094fc0e
> [  295.842114] >FIF_ALLMULTI
> [  295.842190] OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
> [  295.901636] rtl8187_configure_filter
> [  295.901690] IN>changed_flags=0xf3 ,total_flags=0x800000f1
> ,multicast=0x3 
> ,priv->rx_conf=0x9094fc0e
> [  295.901702] >FIF_CONTROL
> [  295.901711] >FIF_OTHER_BSS
> [  295.902016] >FIF_ALLMULTI, ***** Also has FIF_PSPOLL and FIF_PROBE_REQ
> set
> [  295.902113] OUT>total_flags=0x62 ,priv->rx_conf=0x909cfc0f
> [  296.279678] device wlan2mon entered promiscuous mode
> [  296.282327] rtl8187_configure_filter
> [  296.282363] IN>changed_flags=0x93 ,total_flags=0x800000f1
> ,multicast=0x3 
> ,priv->rx_conf=0x909cfc0f
> [  296.282373] >FIF_ALLMULTI
> [  296.282445] OUT>total_flags=0x62 ,priv->rx_conf=0x909cfc0f
> 
> Larry
> 

-- 
http://www.fastmail.fm - A no graphics, no pop-ups email service

