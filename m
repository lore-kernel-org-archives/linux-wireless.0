Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:29781 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbXJ1NUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 09:20:15 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1111146nfb
        for <linux-wireless@vger.kernel.org>; Sun, 28 Oct 2007 06:20:13 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Block adhoc & master mode
Date: Sun, 28 Oct 2007 14:39:52 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710281439.53115.IvDoorn@gmail.com> (sfid-20071028_132022_118223_D4B582B8)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00 is broken when it comes down to adhoc and master mode.
The main problem is the beaconing, which is completely failing.
Untill a solution has been found, both beacon requiring modes
must be disabled to prevent numerous bug reports.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John, please send this patch upstream for 2.6.24

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 4a6a0bd..85ea8a8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -196,6 +196,14 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct interface *intf = &rt2x00dev->interface;
 
+	/* FIXME: Beaconing is broken in rt2x00. */
+	if (conf->type == IEEE80211_IF_TYPE_IBSS ||
+	    conf->type == IEEE80211_IF_TYPE_AP) {
+		ERROR(rt2x00dev,
+		      "rt2x00 does not support Adhoc or Master mode");
+		return -EOPNOTSUPP;
+	}
+
 	/*
 	 * Don't allow interfaces to be added while
 	 * either the device has disappeared or when
