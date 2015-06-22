Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:38055 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbbFVIGc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:06:32 -0400
Received: by igin14 with SMTP id n14so11021802igi.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:06:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5587BDA9.5000107@broadcom.com>
References: <CACna6rzr35hM-VLxgvxtGPnnxSMPx6TM18Qfc8E1Obm7iVPG4A@mail.gmail.com>
	<5587BDA9.5000107@broadcom.com>
Date: Mon, 22 Jun 2015 10:06:31 +0200
Message-ID: <CACna6rwD8A1jhMYz89r6QqcQ5Je0fN3Bx3c2PrsoGBs20fLA6g@mail.gmail.com> (sfid-20150622_100638_338828_B41CC618)
Subject: Re: brcmfmac: one faulty "iw interface add" command breaks
 in-firmware BSS state
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 June 2015 at 09:47, Arend van Spriel <arend@broadcom.com> wrote:
> On 06/21/15 21:59, Rafał Miłecki wrote:
>> I've discovered some bug in brcmfmac&  its BSS management. It was
>>
>> exposed by OpenWrt user space change ("fix") I introduced in:
>>
>> http://git.openwrt.org/?p=openwrt.git;a=commit;h=1cbb5e8de50457c1d9724ca75cc6815df5721289
>> and it's related to the "interface add" command.
>>
>> I've router with BCM43602 and I'm using a very recent brcmfmac.
>>
>> brcmfmac 0000:01:00.0: enabling device (0140 ->  0142)
>> brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Mar  3 2015
>> 04:46:51 version 7.35.177.33 (r538052) FWID 01-c8317c80
>> brcmfmac: brcmf_cfg80211_reg_notifier: not a ISO3166 code
>>
>> wlan0     Link encap:Ethernet  HWaddr 00:23:6A:A3:7D:95
>>            BROADCAST MULTICAST  MTU:1500  Metric:1
>>            RX packets:8 errors:0 dropped:4 overruns:0 frame:0
>>            TX packets:19 errors:0 dropped:0 overruns:0 carrier:0
>>            collisions:0 txqueuelen:1000
>>            RX bytes:505 (505.0 B)  TX bytes:1730 (1.6 KiB)
>>
>> I'll just describe two scenarios that should make things clear. Both
>> after a cold boot.
>>
>>
>> 1) Standard (working) scenario
>> # hostapd /etc/hostapd.conf
>> Configuration file: /etc/hostapd.conf
>> Failed to create interface mon.wlan0: -95 (Operation not supported)
>> [  105.483797] brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
>> [  105.490308] brcmfmac: brcmf_add_if: ignore IF event
>> [  105.499067] device wlan0 entered promiscuous mode
>> [  105.503939] br-lan: port 2(wlan0) entered forwarding state
>> [  105.509437] br-lan: port 2(wlan0) entered forwarding state
>> wlan0: Could not connect to kernel driver
>> Using interface wlan0 with hwaddr 00:23:6a:a3:7d:95 and ssid "OpenWrtA"
>> [  105.640966] brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
>> [  105.647478] brcmfmac: brcmf_add_if: ignore IF event
>> wlan0: interface state UNINITIALIZED->ENABLED
>> wlan0: AP-ENABLED
>> [  107.510613] br-lan: port 2(wlan0) entered forwarding state
>>
>> This results in a working AP, my devices are able to connect
>>
>>
>> 2) Scenario with iw command "mistake":
>> # iw phy phy0 interface add wlan0 type __ap
>
>
> Now this is a pretty silly scenario as there already is a wlan0 interface.
> Admittedly, this should be rejected as such. This clearly is a user mistake
> (not sure why you quoted that :-p ) and it might be good to catch this in
> cfg80211 as it probably applies to other drivers as well. This probably
> explains why register_netdev fails.

To tell the truth, it's part of bigger OpenWrt script. To make things
clean, on every configuration change, OpenWrt removes all interfaces
and (re)creates needed ones. Unfortunately brcmfmac doesn't allow
removing wlan0 and it results in OpenWrt trying to create wlan0 that
wasn't previously removed.


>> [   65.036358] brcmfmac: brcmf_net_attach: couldn't register the net
>> device
>> [   65.043080] brcmfmac: brcmf_ap_add_vif: Registering netdevice failed
>> command failed: Invalid exchange (-52)
>> # hostapd /etc/hostapd.conf
>> Configuration file: /etc/hostapd.conf
>> Failed to create interface mon.wlan0: -95 (Operation not supported)
>> [   83.393594] brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
>> [   83.400122] brcmfmac: brcmf_add_if: ignore IF event
>> [   83.409448] device wlan0 entered promiscuous mode
>> [   83.414259] br-lan: port 2(wlan0) entered forwarding state
>> [   83.419802] br-lan: port 2(wlan0) entered forwarding state
>> wlan0: Could not connect to kernel driver
>> Using interface wlan0 with hwaddr 00:23:6a:a3:7d:95 and ssid "OpenWrtA"
>> [   83.550307] brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
>> [   83.556814] brcmfmac: brcmf_add_if: ignore IF event
>> wlan0: interface state UNINITIALIZED->ENABLED
>> wlan0: AP-ENABLED
>> [   85.418417] br-lan: port 2(wlan0) entered forwarding state
>>
>> In this case in-firmware BSS state seems to be broken and BSS seems to
>> be using *different* address. Following wpa_supplicant log should make
>> it clear.
>
>
> Well, you now have a STA and AP interface in firmware, but only STA netdev
> so the AP interface is pretty useless. I am not sure about the mac address,
> but I think it is expected. Otherwise you would have two interfaces with the
> same mac address.

wlan0 is still visible as it was before calling faulty iw command.
If brcmfmac assigned different in-firmware BSS to the wlan0 we end up
with inconsistent state. We now have STA (wlan0) vs. AP (in-firmware)
and 00:23:6a:a3:7d:95 (wlan0) vs. 02:23:6a:a3:7d:96 (in-firmware).
So it's clearly not something brcmfmac should do.

-- 
Rafał
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
