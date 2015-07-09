Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:11253 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbbGISI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 14:08:26 -0400
Message-ID: <559EB897.1020509@broadcom.com> (sfid-20150709_200844_299083_EC68BBA1)
Date: Thu, 9 Jul 2015 20:08:23 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Subject: Re: brcmfmac: _brcmf_set_mac_address: Setting cur_etheraddr failed,
 -52
References: <CACna6rzfb5-eGD8EgEHM05nJ5FWPnkEkW_fTxNg-3-=PCknv-Q@mail.gmail.com>
In-Reply-To: <CACna6rzfb5-eGD8EgEHM05nJ5FWPnkEkW_fTxNg-3-=PCknv-Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2015 09:07 AM, Rafał Miłecki wrote:
> Hey guys, I'm afraid I hit another brcmfmac bug.
>
> First of all, I implemented a trivial workaround for the previous bug
> reported in the:
> brcmfmac: one faulty "iw interface add" command breaks in-firmware BSS state
> See my workaround in OpenWrt git:
> http://git.openwrt.org/?p=openwrt.git;a=commitdiff;h=0e6c9bd9556eea98b476ad371d64d8d16e3a9f9c
>
> So now OpenWrt's user space calls using "iw" tool don't trigger
> brcmfmac BSSes bug anymore. I can successfully use one AP interface
> per device.
>
> The problem appears when trying to use more than 1 interface. It gets
> created correctly, but setting its MAC fails. It results in wlan0-1
> having the same MAC as wlan0 and finally having two networks (SSIDs)
> using the same MAC. That obviously doesn't work.

Can we please take one step back. I am not understanding how you guys 
use the multiple interfaces. The multiple AP interfaces in brcmfmac are 
only intended for Multiple-BSS feature as described in hostapd.conf 
which changes wlan0 from STA to AP and creates additional AP interfaces, 
but you seem to be creating an AP interface with iw next to a STA interface.

I actually have patches pending that correct the announced interface 
combinations. I am currently on vacation as my family expanded with a 
baby girl.

Regards,
Arend

> The error I see is:
> brcmfmac: _brcmf_set_mac_address: Setting cur_etheraddr failed, -52
> with -52 meaning BCME_IE_NOTFOUND.
>

