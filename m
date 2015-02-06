Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:22568 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbbBFQAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 11:00:14 -0500
Message-ID: <54D4E509.3090308@broadcom.com> (sfid-20150206_170019_521851_622E94B6)
Date: Fri, 6 Feb 2015 17:00:09 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Ben Adler <ben@phoenix-aerial.com>
CC: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4330 linux support
References: <54D3FF89.502@phoenix-aerial.com> <54D4851F.8020402@broadcom.com> <54D4D37C.2060007@phoenix-aerial.com>
In-Reply-To: <54D4D37C.2060007@phoenix-aerial.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/15 15:45, Ben Adler wrote:
> Arend, thanks for your prompt reply!
>
> On 06.02.2015 09:10, Arend van Spriel wrote:
>>> Arend, is it possible to make this chip work? Just STA, or also AP? If
>>> so, which firmware and NVRAM files will I need?
>>
>> Well, I have this chip running on regular x86 laptop using special
>> adapter boards and it also runs on i.MX6 board. The windows firmware and
>> nvram should work.
>
> Did you compare the md5 hash to your firmware? Are there different
> versions with different feature sets?

The dmesg.txt contains the version info:

version 5.97.39.4 FWID 01-c7b9d775

The FWID should tell me what specific build this was and what feature 
set it contains. Unfortunately I can not access our database.

> Does AP also work for you?

Yes, but not sure if your firmware supports it.

>  > Can you send a kernel log preferably with
>  > driver module loaded with 'debug=0xd416'.
>
> Ok, added the module options and powercycled:
>
> # cat /sys/module/brcmfmac/parameters/debug
> 54294
>
> Please find attached:
>
> 1) output of iw_list
>
> 2) dmesg.txt: simple bootup, nothing done to wlan0.
>
> 3) dmesg_sta.txt: I added wlan0 client configuration in ubuntu's
> /etc/network/interfaces, so it has launched wpa_supplicant, which
> probably is repsonsible for the errors at the end.

The errors are direct result of wpa_supplicant request, but it is not 
root cause. I suspend the sdhci-acpi controller driver to use 
runtime-pm. Could you try disabling that through sysfs? If I am not 
mistaken the bcm4330 is in mmc1.

mmc1: SDHCI controller on ACPI [INT33BB:00] using ADMA

So following should do the trick (as root):

# echo on > /sys/bus/acpi/INT33BB:00/power/control

Regards,
Arend

> 4) dmesg_hostapd.txt: dmesg output, hostapd config and output
>
> When I start neither wpa_supplicant nor hostapd, iwconfig says:
>
> wlan0 IEEE 802.11abgn ESSID:off/any
> Mode:Managed Access Point: Not-Associated
> Retry short limit:7 RTS thr:off Fragment thr:off
> Encryption key:off
> Power Management:on
>
> When I configure wlan0 as STA, I get
>
> wlan0 IEEE 802.11abgn ESSID:off/any
> Mode:Managed Access Point: Not-Associated Tx-Power=1496 dBm
> Retry short limit:7 RTS thr:off Fragment thr:off
> Encryption key:off
> Power Management:on
>
> (Note the txpower :)
>
> It seems like the debug options haven't really added much detail to
> dmesg. Do you need to see anything else? It's just a test install right
> now; I don't mind sharing SSH access.
>
> Thanks!
> Ben

