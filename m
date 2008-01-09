Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:16069 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752781AbYAIJQM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 04:16:12 -0500
From: Bruno Randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 5/6] ath5k: configure beacons
Date: Wed,  9 Jan 2008 18:16:08 +0900
Message-Id: <1199870169-10476-6-git-send-email-bruno@thinktube.com> (sfid-20080109_091628_974169_FFAC487E)
In-Reply-To: <1199870169-10476-5-git-send-email-bruno@thinktube.com>
References: <1199870169-10476-1-git-send-email-bruno@thinktube.com>
 <1199870169-10476-2-git-send-email-bruno@thinktube.com>
 <1199870169-10476-3-git-send-email-bruno@thinktube.com>
 <1199870169-10476-4-git-send-email-bruno@thinktube.com>
 <1199870169-10476-5-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

call ath5k_beacon_config() on beacon_update and after channel changes. this is
necessary to ensure beacons are sent.

Changes-licensed-under: 3-clause-BSD
Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---
 drivers/net/wireless/ath5k/base.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 30b16fd..92361df 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1056,6 +1056,7 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 		 */
 /*		ath5k_chan_change(sc, chan); */
 
+		ath5k_beacon_config(sc);
 		/*
 		 * Re-enable interrupts.
 		 */
@@ -2813,6 +2814,8 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	ret = ath5k_beacon_setup(sc, sc->bbuf, ctl);
 	if (ret)
 		sc->bbuf->skb = NULL;
+	else
+		ath5k_beacon_config(sc);
 
 end:
 	mutex_unlock(&sc->lock);
-- 
1.5.3.4

