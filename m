Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:40490 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaL0SSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2014 13:18:39 -0500
Message-ID: <549EF7FD.5070702@broadcom.com> (sfid-20141227_191844_069409_B0235AF0)
Date: Sat, 27 Dec 2014 19:18:37 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cmcgS3JhdXNl?= <jkrause@posteo.de>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 7/7] brcmfmac: add multiple BSS support.
References: <1417885078.22723.24.camel@posteo.de>
In-Reply-To: <1417885078.22723.24.camel@posteo.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/06/14 17:57, Jörg Krause wrote:
> First, I just subscribed to this mailing list and copied the subject
> from the archive. I didn't know better.
>
> Second, many thanks for this new feature to the Broadcom developers!
>
> I've tested this series of patches with the linux-next-20141205 kernel
> on a custom ARM board with a BCM43362 chip running a Linux system build
> with Buildroot. I'm using the wireless tools hostapd/wpa_supplicant 2.3.
>
> I was able to create a virtual interface:
>          # iw dev wlan0 interface add wlan0_ap type __ap
>
> Add IP and set MAC:
>          # ip addr add 192.168.2.1/24 broadcast 255.255.255.0 dev
>          wlan0_ap
>          # ip link set dev wlan0_ap address 12:34:56:78:ab:ce
>
> Start hostapd with the following minimal configuration:
>          # cat /etc/hostapd-minimal.conf
>          interface=wlan0_ap
>          driver=nl80211
>          ssid=myAP
>          channel=1
>          # hostapd -B /etc/hostapd-minimal.conf
>
> Start dnsmasq daemon with minimal configuration:
>          # cat /etc/dnsmasq
>          interface=wlan0_ap
>          dhcp-range=192.168.2.2,192.168.2.254,24h
>          # dnsmasq
>
>
> ifconfig shows:
>          wlan0_ap  Link encap:Ethernet  HWaddr 12:34:56:78:AB:CE
>                    inet addr:192.168.2.1  Bcast:255.255.255.0
>          Mask:255.255.255.0
>                    inet6 addr: fe80::1034:56ff:fe78:abce/64 Scope:Link
>                    UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>                    RX packets:1 errors:0 dropped:1 overruns:0 frame:0
>                    TX packets:60 errors:0 dropped:0 overruns:0 carrier:0
>                    collisions:0 txqueuelen:1000
>                    RX bytes:60 (60.0 B)  TX bytes:20728 (20.2 KiB)
>
> Looks good so far.
>
> Unfortunatly, I do not see any SSID 'myAP', but an SSID
> 'BRCM_TEST_SSID'. Trying to associate with the SSID using wpa_supplicant
> 2.3 fails.
>
> Do I missed something within the setup?

Hi Jörg,

I looked at the 43362 firmware, ie. using hexdump -C, and it contains 
the string BRCM_TEST_SSID. I already mentioned that being suspicious. So 
it may be a firmware issue. I recently bought a Cubietruck device, which 
has a 43362 module integrated, so I will try to replicate this.

Regards,
Arend

> Best regards
> Jörg Krause
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

