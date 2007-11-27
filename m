Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58715 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069AbXK0REc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 12:04:32 -0500
Date: Tue, 27 Nov 2007 11:04:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: rt2400-devel@lists.sourceforge.net
Cc: linux-wireless@vger.kernel.org
Subject: [RFC/T] rt2x00: Remove redundant code in rfkill setup
Message-ID: <474c4e19.tFKoUyFEw/5q8HAB%Larry.Finger@lwfinger.net> (sfid-20071127_170435_887669_069CF2E1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In rt2x00rfkill.c, routine input_allocate_device() is called even though
input_allocate_polled_device(), which was just called, includes a call to
that routine. This patch, which has not been tested, removes the redundant code.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/drivers/net/wireless/rt2x00/rt2x00rfkill.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ wireless-2.6/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -141,12 +141,6 @@ int rt2x00rfkill_allocate(struct rt2x00_
 	rt2x00dev->poll_dev->poll = rt2x00rfkill_poll;
 	rt2x00dev->poll_dev->poll_interval = RFKILL_POLL_INTERVAL;
 
-	rt2x00dev->poll_dev->input = input_allocate_device();
-	if (!rt2x00dev->poll_dev->input) {
-		ERROR(rt2x00dev, "Failed to allocate input device.\n");
-		goto exit_free_polldev;
-	}
-
 	rt2x00dev->poll_dev->input->name = rt2x00dev->ops->name;
 	rt2x00dev->poll_dev->input->phys = wiphy_name(rt2x00dev->hw->wiphy);
 	rt2x00dev->poll_dev->input->id.bustype = BUS_HOST;
