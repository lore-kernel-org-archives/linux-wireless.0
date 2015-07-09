Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35759 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbbGITKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 15:10:54 -0400
Received: by igcqs7 with SMTP id qs7so86988883igc.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 12:10:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <559EB897.1020509@broadcom.com>
References: <CACna6rzfb5-eGD8EgEHM05nJ5FWPnkEkW_fTxNg-3-=PCknv-Q@mail.gmail.com>
	<559EB897.1020509@broadcom.com>
Date: Thu, 9 Jul 2015 21:10:54 +0200
Message-ID: <CACna6rzAn+0uahZq-74J=BfBLB30LHS9-RKmvQ0OyJG78EpS5A@mail.gmail.com> (sfid-20150709_211058_252170_53E1AE03)
Subject: Re: brcmfmac: _brcmf_set_mac_address: Setting cur_etheraddr failed, -52
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 July 2015 at 20:08, Arend van Spriel <arend@broadcom.com> wrote:
> On 07/09/2015 09:07 AM, Rafał Miłecki wrote:
>>
>> Hey guys, I'm afraid I hit another brcmfmac bug.
>>
>> First of all, I implemented a trivial workaround for the previous bug
>> reported in the:
>> brcmfmac: one faulty "iw interface add" command breaks in-firmware BSS
>> state
>> See my workaround in OpenWrt git:
>>
>> http://git.openwrt.org/?p=openwrt.git;a=commitdiff;h=0e6c9bd9556eea98b476ad371d64d8d16e3a9f9c
>>
>> So now OpenWrt's user space calls using "iw" tool don't trigger
>> brcmfmac BSSes bug anymore. I can successfully use one AP interface
>> per device.
>>
>> The problem appears when trying to use more than 1 interface. It gets
>> created correctly, but setting its MAC fails. It results in wlan0-1
>> having the same MAC as wlan0 and finally having two networks (SSIDs)
>> using the same MAC. That obviously doesn't work.
>
>
> Can we please take one step back. I am not understanding how you guys use
> the multiple interfaces. The multiple AP interfaces in brcmfmac are only
> intended for Multiple-BSS feature as described in hostapd.conf which changes
> wlan0 from STA to AP and creates additional AP interfaces, but you seem to
> be creating an AP interface with iw next to a STA interface.

OpenWrt tries to remove all existing interfaces and then create needed
ones from the scratch. So e.g. after loading brcmfmac you have:
wlan0

Lets say OpenWrt wants 2 AP interfaces, so it calls:
iw dev wlan0 del
iw phy phy0 interface add wlan0 type __ap
iw phy phy0 interface add wlan0-1 type __ap

The first command fails (brcmfmac limitation), the second one gets
rejected (wlan0 already exists) and the third one creates new virtual
interface. This results in having two interfaces: STA and AP.
Then OpenWrt finally runs hostapd which changes wlan0 to AP and starts
AP on both interfaces.


> I actually have patches pending that correct the announced interface
> combinations. I am currently on vacation as my family expanded with a baby
> girl.

Have fun! :)
