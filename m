Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.242]:17217 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750982AbYBCO4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:56:46 -0500
Received: by hs-out-2122.google.com with SMTP id 54so1608919hsz.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:56:45 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 14/19] rt2x00: Make use of MAC80211_LED_TRIGGERS
Date: Sun, 3 Feb 2008 15:53:40 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031553.41120.IvDoorn@gmail.com> (sfid-20080203_145654_317074_F95B9263)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From ad1724df99ba8b555edd85b0cd0ab6cdb0559086 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 2 Feb 2008 19:20:20 +0100
Subject: [PATCH] rt2x00: Make use of MAC80211_LED_TRIGGERS

Make use of the led triggers provided by mac80211 to control
the led status. This can be enabled through a per-driver
configuration option which will automatically enable the
generic handler in rt2x00lib.

This has been enabled for rt2500usb and rt73usb for the moment
since the led class will call set_brightness in irq context which
will not work correctly with the usb drivers who need to sleep.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
Patch size 37k, located on server:
http://kernel.org//pub/linux/kernel/people/ivd/rt2x00-2.1.0/0014-rt2x00-Make-use-of-MAC80211_LED_TRIGGERS.patch

 drivers/net/wireless/rt2x00/Kconfig     |   28 +++++
 drivers/net/wireless/rt2x00/Makefile    |    4 +
 drivers/net/wireless/rt2x00/rt2400pci.c |   88 ++++++++-------
 drivers/net/wireless/rt2x00/rt2500pci.c |   88 ++++++++-------
 drivers/net/wireless/rt2x00/rt2500usb.c |   91 +++++++++-------
 drivers/net/wireless/rt2x00/rt2x00.h    |   27 +++--
 drivers/net/wireless/rt2x00/rt2x00dev.c |   19 +++-
 drivers/net/wireless/rt2x00/rt2x00lib.h |   33 ++++++
 drivers/net/wireless/rt2x00/rt61pci.c   |  180 ++++++++++++++-----------------
 drivers/net/wireless/rt2x00/rt73usb.c   |  165 +++++++++++++---------------
 10 files changed, 403 insertions(+), 320 deletions(-)
