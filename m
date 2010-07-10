Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62618 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab0GJTkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jul 2010 15:40:14 -0400
Received: by gye5 with SMTP id 5so1993345gye.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Jul 2010 12:40:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C38BE1D.2020107@openwrt.org>
References: <AANLkTilq_VFbOPHmMuf1EFmewc_WBBpgvW0t7ogZdbdl@mail.gmail.com>
	<4C38BE1D.2020107@openwrt.org>
Date: Sat, 10 Jul 2010 20:40:13 +0100
Message-ID: <AANLkTinNmQONdkT_f7aNykH0t4o7Zdybi96hcd4K4UUp@mail.gmail.com>
Subject: Re: Issues with ath9k dropping connectivity - now no connectivity
From: Norman Henderson <norm.audrey@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks very much Felix for the quick comment. I'll follow up on it
over the next few days as I get time to move to "bleeding edge"
(something I've sworn from my youth to never do...).

However I guess I was more concerned about the regression from an
environment that worked (with disconnections) to one that doesn't
connect at all - is that just the luck of the draw or did I do
something stupid? (more precisely, what was it that I did stupid,
because that's inevitably true :~

- Norm Henderson

On Sat, Jul 10, 2010 at 7:38 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2010-07-10 8:32 PM, Norman Henderson wrote:
>> Hi,
>>
>> I'm a bit new to all of this - here's the short story. I would
>> appreciate any help available!
>>
>> I was building a WAP using a PC Engines ALIX board (AMD Geode LX800),
>> DNMA92 wireless card (Atheros 92xx) and Voyage Linux (based on Debian
>> Lenny, 2.6.30 kernel with hostapd 0.6.9 and libnl1.1). It was all
>> working but, the wireless card would drop connectivity for no apparent
>> reason after an undetermined time (minutes to hours). Stations (Win or
>> cellphone) would no longer see it at all, as if it was no longer
>> transmitting.
>>
>> The Voyage maintainer advised that ath9k isn't that stable at 2.6.30.
>> So, I upgraded the kernel to 2.6.32 using the Debian Lenny backport. I
>> then installed the "stable" compat-wireless, 2.6.32.16.
>>
>> Hostapd appears to start OK. However, the wireless SSID is only
>> visible to the Windows clients for a short time - seconds/minutes -
>> and they aren't able to connect. There were no errors in the hostapd
>> startup and it does its key rotations periodically. All that's logged
>> from hostapd -dd during the actual time that the Win clients can see
>> it and are trying to connect is:
>> 1278785975.350851: STA 00:13:02:be:7b:f9 sent probe request for broadcast SSID
>> 1278785975.353034: MGMT (TX callback) ACK
>> 1278785975.353073: mgmt::proberesp cb
>> (repeated a few times)
>>
>> The Win7 station used to connect automatically but now doesn't and
>> when I click "connect" it fails and shortly thereafter the SSID
>> disappears from the list.
>>
>> Nothing in /var/log. iw phy phy0 info and iw dev wlan0 info appear to
>> report sensible info as does iwconfig.
>>
>> During boot I do get messages about "VIA Padlock Hash Engine not detected" and
>> modprobe: FATAL: Error inserting padlock_sha
>> (/lib/modules/2.6.32-bpo.5-686/kern...): No such device
>> From googling it's not clear to me at least whether this is relevant.
>>
>> Suggestions? What further diagnostics could I do?
> I'd suggest using a 'bleeding edge' compat-wireless along with hostapd
> version 0.7.2.
>
> In OpenWrt we're using a compat-wireless based on wireless-testing
> 2010-07-06, along with two ath9k patches that were merged in a later
> version.
>
> According to my own testing and various user feedback, this is the most
> stable version that we had so far.
>
> I think 2.6.36 is probably going to be the first Linux Kernel version
> with ath9k working in AP mode *reliably*.
>
> - Felix
>
