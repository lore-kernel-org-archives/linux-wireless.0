Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1603 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988Ab2EYUdG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 16:33:06 -0400
Message-ID: <4FBFEC6C.5080502@broadcom.com> (sfid-20120525_223310_606882_1195A782)
Date: Fri, 25 May 2012 22:32:44 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmsmac and BCM47186 (BCM5357) + brcmfmac and BCM43236 V2
References: <4FB57C61.3090302@hauke-m.de>
In-Reply-To: <4FB57C61.3090302@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/18/2012 12:32 AM, Hauke Mehrtens wrote:
> Hi Arend,

Sorry for the late response. Found it ready and waiting in my Drafts
folder :-S

> I got a new device, a Linksys E3200 with a BCM47186 (id: 0x5357) and a
> BCM43236 v2 for 5GHz wifi.
> 
> The BCM47186 has a wifi core rev 28, a N-PHY rev 9 and a 2057 radio rev
> 5 and it does not work with brcmsmac or b43. :-(
> 
> Are there plans to add support for such new N-PHY revs to brcmsmac and
> the firmware?

We are planning to add support for bcm43227/228. This requires an update
in the n-phy code.

> Here are some parts of my log with brcmsamc with firmware from
> linux-firmware.

I expect you changed some brcmsmac code allow it to handle your device.
Correct?

> 
> 
> When using the firmware from b43 (666.2, extracted from wl 5.100.138) I
> get the following messages, but iw wlan0 scan does not find any networks
> either.
> 
> [   30.088000] ieee80211 phy1: wlc_coreinit: txfifo mismatch: ucode size
> 127 driver size 29535 index 5
> [   30.164000] ieee80211 phy1: brcms_ops_bss_info_changed: qos enabled:
> false (implement)
> [   30.172000] ieee80211 phy1: brcms_ops_config: change monitor mode: false
> [   30.172000] ieee80211 phy1: brcms_ops_config: change power-save mode:
> false (implement)
> [   43.976000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC
> [   44.844000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC
> [   48.088000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC
> [   48.956000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC
> [   53.448000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC
> [   54.316000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC
> [   76.816000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC
> [   77.684000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC
> 
> Did you talk to the firmware guys, is there a limitation to core rev 23
> devices in the N-PHY firmware other than in the firmware used by wl?

I had to dive into the firmware repo myself and the answer is yes. The
published firmware for brcmsmac only supports the corerev of the chips
it currently supports.

> There is also a BCM43236 V2 (usb chip) on the board. I tried brcmfmac
> and the firmware from linux-firmware, but it did not work. This is a rev
> 2 device and brcmfmac just seams to support rev 3. Are there any plans
> to add support for rev 2 or is this an other problem and a rev 2 device
> should also work with brcmfmac?

There is no fullmac firmware for Rev 1 and 2 as these simply lack
on-chip memory to do so. These devices use a different driver model.
This model has a different split of functionality between device and
host. Neither brcmsmac nor brcmfmac can support devices using that model.

Gr. AvS

