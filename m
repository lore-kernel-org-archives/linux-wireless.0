Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:42008 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763505AbYBCOvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:51:45 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1586229fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:51:45 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/19] rt2x00: Enable master and adhoc mode again
Date: Sun, 3 Feb 2008 15:48:03 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031548.03491.IvDoorn@gmail.com> (sfid-20080203_145148_534616_982F80AC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will enable the creation of master mode and adhoc
interfaces again. This does not mean the issues surrounding
beaconing have been resolved, but this will make testing
easier and perhaps we can discover which cards are actually
working and which ones not.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 380cc5b..f08c151 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -164,14 +164,6 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct interface *intf = &rt2x00dev->interface;
 
-	/* FIXME: Beaconing is broken in rt2x00. */
-	if (conf->type == IEEE80211_IF_TYPE_IBSS ||
-	    conf->type == IEEE80211_IF_TYPE_AP) {
-		ERROR(rt2x00dev,
-		      "rt2x00 does not support Adhoc or Master mode");
-		return -EOPNOTSUPP;
-	}
-
 	/*
 	 * Don't allow interfaces to be added while
 	 * either the device has disappeared or when
-- 
1.5.3.8

