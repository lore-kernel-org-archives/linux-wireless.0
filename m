Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35570 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1CIKSu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 05:18:50 -0500
Received: by gyh20 with SMTP id 20so165311gyh.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 02:18:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=WEp6rgqzwv-AQR65WUj3ux-D-Thj+F1eE3368@mail.gmail.com>
References: <AANLkTi=WEp6rgqzwv-AQR65WUj3ux-D-Thj+F1eE3368@mail.gmail.com>
Date: Wed, 9 Mar 2011 11:18:50 +0100
Message-ID: <AANLkTi=HTnXgvOUm3zN1yxFUwWrS8f1_rTF=peWVJNMW@mail.gmail.com>
Subject: ath9k with the TL-WN951N, TX RX DMA,
From: ath9k.org_ath9k-devel@yknott.cjb.net
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwlist scanning always shows no networks.

$ sudo iwlist wlan0 scanning
wlan0     No scan results


ath9k was loaded automatically.


(OS: using kubuntu 10.10, amd64, linux 2.6.35)
(Device: TP-Link TL-WN951N;
03:06.0 Network controller: Atheros Communications Inc. AR5008
Wireless Network Adapter (rev 01);
03:06.0 Network controller [0280]: Atheros Communications Inc. AR5008
Wireless Network Adapter [168c:0023] (rev 01);
ieee80211 phy1: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
mem=0xffffc900112e0000, irq=21)



Each iwlist scanning request results in several failed to stop tx dma
and dma failed to stop entries in the system log.


Mar 6 19:58:14 kernel: [ 1758.089779] ath: Failed to stop TX DMA in
100 msec after killing last frame
Mar 6 19:58:14 kernel: [ 1758.098734] ath: Failed to stop TX DMA in
100 msec after killing last frame
Mar 6 19:58:14 kernel: [ 1758.098836] ath: Failed to stop TX DMA!
Mar 6 19:58:14 kernel: [ 1758.112192] ath: DMA failed to stop in 10 ms
AR_CR=0x00000024 AR_DIAG_SW=0x42000020
Mar 6 19:58:14 kernel: [ 1758.112200] ath: Could not stop RX, we could
be confusing the DMA engine when we start RX up
Mar 6 19:58:14 kernel: [ 1758.125541] ath: DMA failed to stop in 10 ms
AR_CR=0x00000024 AR_DIAG_SW=0x42000020
Mar 6 19:58:14 kernel: [ 1758.141709] ath: DMA failed to stop in 10 ms
AR_CR=0x00000024 AR_DIAG_SW=0x42000020
Mar 6 19:58:14 kernel: [ 1758.141712] ath: Could not stop RX, we could
be confusing the DMA engine when we start RX up
Mar 6 19:58:14 kernel: [ 1758.154747] ath: DMA failed to stop in 10 ms
AR_CR=0x00000024 AR_DIAG_SW=0x42000020


I have tried ath9k from
http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2
 2011-03-08 as well as the linux-backports-modules

I am actually not using an access point using n, just b and g.

So two questions, should this card be supported by the ath9k and
should it work with b and g networks?


According to linuxwireless.org/en/users/Drivers/ath9k
this combination
AR5416+AR5133 (>= 2.6.27)
is supported.

(Although http://linuxwireless.org/en/users/Drivers/ath9k/devices
indicates that the TL-WN951N is not supported while the TL-WN961N is.)

According to
http://wiki.debian.org/ath9k
ath9k is meant to support both

PCI: 168C:0023 Atheros Communications Inc. AR5008 Wireless Network Adapter
PCI: 168C:0024 Atheros Communications Inc. AR5008 Wireless Network Adapter



So what might I be doing wrong?

Thanks for any suggestions as well as instructions of whatever
debugging data might be helpful.
