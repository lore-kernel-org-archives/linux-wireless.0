Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:34336 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab3HLWye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 18:54:34 -0400
Received: by mail-ie0-f180.google.com with SMTP id aq17so8871734iec.25
        for <linux-wireless@vger.kernel.org>; Mon, 12 Aug 2013 15:54:33 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 12 Aug 2013 15:54:33 -0700
Message-ID: <CAN3-2D7=P=9VyV7xoANw_6B8VhOaTRC1iMw+mwUH2-g8YOmPMg@mail.gmail.com> (sfid-20130813_005437_519018_A7B90963)
Subject: issues with RTL8188CE device and rtl8192ce driver
From: Colleen Josephson <cjoseph@mit.edu>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have been having consistent issues with certain networks with my
RTL8188CE device and the rtl8192ce driver (using kernel 3.8.13). I am
running Gentoo linux and use NetworkManager to manage connections. I
can utilize many networks fine, but some networks enter a
connect/reconnect cycle where the device connects (and gets an IP/DNS
info), but as soon as I try to actually transmit anything it
immediately disconnects.

When I look at /var/log/messages, I see this pattern happening a lot
around the time the connection fails:
wlan0: disassociated from 00:18:0a:36:83:36 (Reason: 2)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: deauthenticating from 00:18:0a:36:83:36 by local choice (reason=3)

(sometimes it says "Calling CRDA for country: US" instead)

lspci -v:
03:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8188CE
802.11b/g/n WiFi Adapter (rev 01)
Subsystem: Realtek Semiconductor Co., Ltd. Device 8195
Flags: bus master, fast devsel, latency 0, IRQ 17
I/O ports at 5000 [size=256]
Memory at f3800000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [40] Power Management version 3
Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
Capabilities: [70] Express Endpoint, MSI 00
Capabilities: [100] Advanced Error Reporting
Capabilities: [140] Virtual Channel
Capabilities: [160] Device Serial Number 01-91-81-fe-ff-4c-e0-00
Kernel driver in use: rtl8192ce
Kernel modules: rtl8192ce

some relevant logging:
http://pastebin.com/4jSQAhuM

Any help with resolving this issue is greatly appreciated!
