Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:38419 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755148Ab0LPC3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 21:29:53 -0500
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0581016591
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 11:29:51 +0900 (JST)
Subject: [PATCH 3/3] ath5k: Set available antenna information for cfg80211
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: dhalperi@cs.washington.edu, linux-wireless@vger.kernel.org
Date: Thu, 16 Dec 2010 11:30:33 +0900
Message-ID: <20101216023033.24356.32238.stgit@localhost6.localdomain6>
In-Reply-To: <20101216023022.24356.22416.stgit@localhost6.localdomain6>
References: <20101216023022.24356.22416.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bruno Randolf <br1@einfach.org>

---

v3:	rebased and updated for separate RX and TX availability
v2:	rebased
---
 drivers/net/wireless/ath/ath5k/base.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 4e3b97c..3c65fef 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2351,6 +2351,10 @@ ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
+	/* both antennas can be configured as RX or TX */
+	hw->wiphy->available_antennas_tx = 0x3;
+	hw->wiphy->available_antennas_rx = 0x3;
+
 	hw->extra_tx_headroom = 2;
 	hw->channel_change_time = 5000;
 

