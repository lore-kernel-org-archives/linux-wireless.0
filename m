Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52144 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab0HQOk0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 10:40:26 -0400
Received: by wyb32 with SMTP id 32so7108736wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Aug 2010 07:40:25 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 17 Aug 2010 20:10:25 +0530
Message-ID: <AANLkTikQ+mYbt1gEx7DkV8Jt=Mqe+ojLrUmPCfKKg4Fj@mail.gmail.com>
Subject: STA mode bandwidth issues
From: ramakanth varala <ramakanth.varala@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I have the following setup.

HostPC <-eth-> STA <-Wifi-> AP <-eth-> WAN …. ServerPC

Our Target Board topology have three interfaces eth0 , br0 and ath0 .
eth0 physical interface through this HostPC is connected and  eth0  is
in bridge of br0,  ath0 is wireless interface ( acting as a wan
interface for the target board when it is in client mode, this is
outside of bridge)

HostPC will be getting the IP from DHCP running in the STA. After all
the client mode successfull setup following is the ips  .

HostPC :192.168.1.2
br0:192.168.1.1
ath0 :192.168.3.2

AP :  br0 interface ip is  192.168.3.1 , in AP br0 contain ath0 in it.

Iam configuring the sta mode by using following commands

ifconfig ath0 down
wlanconfig ath0 destroy
wlanconfig ath0 create wlandev wifi0 wlanmode sta
iwconfig ath0 key <wep key>
iwconfig ap <AP mac>
iwconfig ath0 rate auto
ifconfig ath0 up

my target board in running with mips linux of kernel version 2.6.20
and driver by atheros .

Here my concern is iam experiencing very very low bandwidth .

There are no inferences as such. If i take ftp for testing between
hostpc and server
after nearly 1mb of download from Hostpc ftp service is getting time out.

We sniffed the packets and observed that the type/subtype is set QoS Data.
Does this also contributes to the bandwidth issue

You'r views would be highly appreciated.

regards
