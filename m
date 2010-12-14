Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:27121 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759046Ab0LNCUM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 21:20:12 -0500
Received: from vs3012.wh2.ocn.ne.jp (125.206.180.183)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0294483209
	for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 11:20:10 +0900 (JST)
Subject: [PATCH 2/2] ath5k: Set available antenna information for cfg80211
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Dec 2010 11:20:24 +0900
Message-ID: <20101214022024.2343.78861.stgit@localhost6.localdomain6>
In-Reply-To: <20101214022018.2343.8216.stgit@localhost6.localdomain6>
References: <20101214022018.2343.8216.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bruno Randolf <br1@einfach.org>

---

v2:	rebased
---
 drivers/net/wireless/ath/ath5k/base.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 4e3b97c..e2a5b45 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2351,6 +2351,8 @@ ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
+	hw->wiphy->available_antennas = 0x3; /* both can be configured */
+
 	hw->extra_tx_headroom = 2;
 	hw->channel_change_time = 5000;
 

