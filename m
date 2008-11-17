Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out8.libero.it ([212.52.84.108]:33396 "EHLO
	cp-out8.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYKQUWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 15:22:47 -0500
Received: from [192.168.1.102] (151.48.11.15) by cp-out8.libero.it (8.5.016.1)
        id 49198CCD00EB2CE6 for linux-wireless@vger.kernel.org; Mon, 17 Nov 2008 21:22:45 +0100
From: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org
Subject: Re: ath5k: problems during the connection to a sitecom AP
Date: Mon, 17 Nov 2008 21:20:11 +0100
References: <200811150207.12084.rossi.f@inwind.it>
In-Reply-To: <200811150207.12084.rossi.f@inwind.it>
MIME-Version: 1.0
Message-Id: <200811172120.11299.rossi.f@inwind.it> (sfid-20081117_212252_390062_26297D25)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Which is the best way to proceed with the debug to understand why my 
card isn't going through the authentication-association process with the 
hidden SSID?

Thanks,
Fabio

On Saturday 15 November 2008, you wrote:

> I'm testing the ath5k driver (wireless-testing v2.6.28-rc4-5172-gc1a847c)
> with my 3com 3CRDAG675 PCI card (atheros AR5212). I can try alternatively
> two different access points (both configured with WEP + hidden SSID), the
> procedure I use is the same but the results are different.
>
> Here are the commands used:
>
> modprobe ath5k
> ifconfig ath0 192.168.1.2 up
> iwconfig ath0 key <MYKEY>
> iwconfig ath0 ap <AP_MAC>
> iwconfig ath0 essid <MY_ESSID>
>
>
> *** 3com AP ***
> With this one I can associate without problems at the first try (SSID not
> broadcast + WEP encryption):
>
> ath5k_pci 0000:00:0b.0: PCI INT A -> Link[LNKB] -> GSI 10 (level, low) ->
> IRQ 10
> ath5k_pci 0000:00:0b.0: registered as 'phy1'
> phy1: Selected rate control algorithm 'minstrel'
> ath5k phy1: Atheros AR5212 chip found (MAC: 0x56, PHY: 0x41)
> ath5k phy1: RF5112B multiband radio found (0x36)
> udev: renamed network interface wlan0 to ath0
> ath0: direct probe to AP <AP_MAC> try 1
> ath0 direct probe responded
> ath0: authenticate with AP <AP_MAC>
> ath0: authenticated
> ath0: associate with AP <AP_MAC>
> ath0: RX AssocResp from <AP_MAC> (capab=0x421 status=0 aid=4)
> ath0: associated
> phy1: Allocated STA <AP_MAC>
> phy1: Inserted STA <AP_MAC>
> ath0: switched to short barker preamble (BSSID=<AP_MAC>)
> ath0: switched to short slot (BSSID=<AP_MAC>)
>
> *** Sitecom AP ***
> With this one I'm able to associate only when the SSID is broadcast (with
> or without encryption). Moreover the association process isn't successful
> at first try (like for the 3com AP) and the link quality is very bad. An
> example of ping statistics is the following
>
> 629 packets transmitted, 527 received, 16% packet loss, time 711605ms
> rtt min/avg/max/mdev = 6.332/6303.120/151334.339/18133.729 ms, pipe 114
>
> and it's common to get the following error message (transmission buffer
> saturated?):
>
> ping: sendmsg: No buffer space available
>
> When I disable the SSID I can't associate anymore to the AP, the only debug
> messages are the following:
>
> ath5k_pci 0000:00:0b.0: PCI INT A -> Link[LNKB] -> GSI 10 (level, low) ->
> IRQ 10
> ath5k_pci 0000:00:0b.0: registered as 'phy12'
> phy12: Selected rate control algorithm 'minstrel'
> ath5k phy12: Atheros AR5212 chip found (MAC: 0x56, PHY: 0x41)
> ath5k phy12: RF5112B multiband radio found (0x36)
> udev: renamed network interface wlan0 to ath0
>
> How can I debug to provide more details (e.g. using debugfs)?
>
> Thank you for any help,
> Fabio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
