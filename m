Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63520 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab0JBJfk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:40 -0400
Received: by mail-wy0-f174.google.com with SMTP id 28so3658520wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:40 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 16/20] rt2x00: Enable rx aggregation in rt2800
Date: Sat, 2 Oct 2010 11:33:17 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021132.17888.IvDoorn@gmail.com> <201010021132.44146.IvDoorn@gmail.com>
In-Reply-To: <201010021132.44146.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021133.18211.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 8e507d0..0287157 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3452,8 +3452,12 @@ int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 	case IEEE80211_AMPDU_RX_STOP:
-		/* we don't support RX aggregation yet */
-		ret = -ENOTSUPP;
+		/*
+		 * The hw itself takes care of setting up BlockAck mechanisms.
+		 * So, we only have to allow mac80211 to nagotiate a BlockAck
+		 * agreement. Once that is done, the hw will BlockAck incoming
+		 * AMPDUs without further setup.
+		 */
 		break;
 	case IEEE80211_AMPDU_TX_START:
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
-- 
1.7.2.3

