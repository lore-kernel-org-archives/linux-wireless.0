Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:3266 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752451Ab0LFDpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Dec 2010 22:45:44 -0500
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0830387141
	for <linux-wireless@vger.kernel.org>; Mon,  6 Dec 2010 12:45:42 +0900 (JST)
Subject: [PATCH 3/3] ath5k: Set available antenna information for cfg80211
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Dec 2010 12:45:40 +0900
Message-ID: <20101206034540.11462.95009.stgit@localhost6.localdomain6>
In-Reply-To: <20101206034529.11462.48097.stgit@localhost6.localdomain6>
References: <20101206034529.11462.48097.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index d74ee0d..e648467 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2350,6 +2350,8 @@ ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
+	hw->wiphy->available_antennas = 0x3; /* both can be configured */
+
 	hw->extra_tx_headroom = 2;
 	hw->channel_change_time = 5000;
 

