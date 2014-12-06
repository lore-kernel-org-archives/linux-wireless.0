Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:52825 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbaLFQ64 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2014 11:58:56 -0500
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id B08D425ACC59
	for <linux-wireless@vger.kernel.org>; Sat,  6 Dec 2014 17:58:52 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3jvxnl6G30z5vN9
	for <linux-wireless@vger.kernel.org>; Sat,  6 Dec 2014 17:58:51 +0100 (CET)
Message-ID: <1417885078.22723.24.camel@posteo.de> (sfid-20141206_175910_400120_651447F7)
Subject: Re: [PATCH 7/7] brcmfmac: add multiple BSS support.
From: =?ISO-8859-1?Q?J=F6rg?= Krause <jkrause@posteo.de>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Dec 2014 17:57:58 +0100
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First, I just subscribed to this mailing list and copied the subject
from the archive. I didn't know better.

Second, many thanks for this new feature to the Broadcom developers!

I've tested this series of patches with the linux-next-20141205 kernel
on a custom ARM board with a BCM43362 chip running a Linux system build
with Buildroot. I'm using the wireless tools hostapd/wpa_supplicant 2.3.

I was able to create a virtual interface:
        # iw dev wlan0 interface add wlan0_ap type __ap

Add IP and set MAC:
        # ip addr add 192.168.2.1/24 broadcast 255.255.255.0 dev
        wlan0_ap
        # ip link set dev wlan0_ap address 12:34:56:78:ab:ce

Start hostapd with the following minimal configuration:
        # cat /etc/hostapd-minimal.conf
        interface=wlan0_ap
        driver=nl80211
        ssid=myAP
        channel=1
        # hostapd -B /etc/hostapd-minimal.conf

Start dnsmasq daemon with minimal configuration:
        # cat /etc/dnsmasq
        interface=wlan0_ap
        dhcp-range=192.168.2.2,192.168.2.254,24h
        # dnsmasq
        

ifconfig shows:
        wlan0_ap  Link encap:Ethernet  HWaddr 12:34:56:78:AB:CE  
                  inet addr:192.168.2.1  Bcast:255.255.255.0
        Mask:255.255.255.0
                  inet6 addr: fe80::1034:56ff:fe78:abce/64 Scope:Link
                  UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
                  RX packets:1 errors:0 dropped:1 overruns:0 frame:0
                  TX packets:60 errors:0 dropped:0 overruns:0 carrier:0
                  collisions:0 txqueuelen:1000 
                  RX bytes:60 (60.0 B)  TX bytes:20728 (20.2 KiB)
        
Looks good so far.

Unfortunatly, I do not see any SSID 'myAP', but an SSID
'BRCM_TEST_SSID'. Trying to associate with the SSID using wpa_supplicant
2.3 fails.

Do I missed something within the setup?

Best regards
Jörg Krause

