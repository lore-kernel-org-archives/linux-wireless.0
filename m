Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50612 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2H3ULV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 16:11:21 -0400
Received: by iahk25 with SMTP id k25so63067iah.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Aug 2012 13:11:20 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 Aug 2012 23:11:20 +0300
Message-ID: <CAK678xgwEwjoxciyNe5qv0N_+Bxi8EmUjzf9E07dLPt2nf-wHg@mail.gmail.com> (sfid-20120830_221125_000236_FBD7F3D9)
Subject: rtl8192cu: no beacon transmission in AP mode with Asus USB-N13
From: coekbe <coekbe@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

I created an Access Point using hostapd and the following USB stick:

ID 0b05:17ab ASUSTek Computer, Inc. USB-N13 802.11n Network Adapter
(rev. B1) [Realtek RTL8192CU]

The problem is that I cannot see any beacon frames in data captured
from the air. I cannot see beacon frames in the hostapd created
mon.wlan0 interface on the AP either.

I believe this is why my (power saving) phone doesn't work properly
with the AP. When the AP is trying to send IP packets to the phone, I
can see the packets on the AP's wlan0 interface using tcpdump, but the
packets are not being transmitted over the air. The packets are only
aired when the phone sends some packet to the AP. Then all of AP's
packets go at once, so they must have been just queued. For example, I
cannot successfully (ICMP) ping my phone from the AP. The echo
requests are not leaving the AP. A workaround in this case is to ARP
(broadcast) ping the phone from the AP. This causes the phone to wake
up to respond with an ARP reply, which in turn makes the AP send all
the queued ICMP echo requests at one go. Actually, if I leave arping
running I can browse the web and use internet on the phone without
much trouble. If I stop ARP pinging, it all stops working.

The following post suggests that rtl8192cu has beaconed in the past:

http://marc.info/?l=linux-wireless&m=132207376529915&w=2

I've tried kernel 3.2.23, as it currently comes in Debian Wheezy, with
the stable compat-wireless-3.5.1-1-snpc.tar.bz2, and
compat-wireless-2012-08-29-p.tar.bz2. Makes no difference. Wheezy's
hostapd version is 1.0.

(In Windows, the USB stick does work properly in AP mode and I can
also capture beacon frames from the air. No trouble with the phone
either.)

Regards,
Colin
