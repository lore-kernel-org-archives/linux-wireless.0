Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([188.94.250.25]:59282 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab0JDMwa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 08:52:30 -0400
From: Holger Schurig <holgerschurig@gmail.com>
To: Jochen Friedrich <jochen@scram.de>
Subject: Re: [Patch] iw: Implement set 4addr.
Date: Mon, 4 Oct 2010 15:02:14 +0200
Cc: linux-wireless@vger.kernel.org
References: <1286041239-19169-1-git-send-email-jochen@scram.de> <201010040915.58549.holgerschurig@gmail.com> <4CA997A3.7080409@scram.de>
In-Reply-To: <4CA997A3.7080409@scram.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010041502.14459.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Yes, that's the idea behind this. I'm using an OpenWRT based WLAN router 
> and a Debian client with the configuration below.

Oh, I don't have much success so far.

My setup is like this:

   Linux 2.6.35.4
   compat-wireless-2010-10-02, using
      ath5k from this
   iw from git with your patch

------------------------------------------
auto lo
iface lo inet loopback

auto wlan0
iface wlan0 inet manual
        pre-up iw wlan0 set 4addr on

auto eth0
iface eth0 inet manual

iface br0 inet static
        address 192.168.233.197
        netmask 255.255.255.0
        bridge_ports eth0 wlan0
        bridge_wait 0
        bridge_fd 0
        bridge_stp off
        post-up iw wlan0 connect TEST key 0:99999

I also tried it with wpa_supplicant, again from git. The last part of the 
/etc/network/interface file looked then like this:

        wpa_iface wlan0
        wpa_bridge br0
        wpa-conf /etc/wpa_supplicant.conf
        wpa-driver nl80211

... but in both cases, I didn't have much of success. I tried "tcpdump -i 
wlan0 -p" (-p prevents promiscuous mode) and only saw ARP, but never an ARP 
response.

I'll investigate further :-)

-- 
Homepage: http://www.holgerschurig.de
