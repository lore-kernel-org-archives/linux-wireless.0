Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36689 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506Ab0LUD7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 22:59:22 -0500
Date: Tue, 21 Dec 2010 06:59:06 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kernel-janitors@vger.kernel.org
Subject: [patch -next] ath9k: unlock on error path in
 ath9k_change_interface()
Message-ID: <20101221035906.GC1936@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a missing unlock when we hit the "No beacon slot available"
error condition.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index cb53fbb..0ffa115 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1481,6 +1481,7 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	int ret = 0;
 
 	ath_dbg(common, ATH_DBG_CONFIG, "Change Interface\n");
 	mutex_lock(&sc->mutex);
@@ -1490,7 +1491,8 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_ADHOC:
 		if (sc->nbcnvifs >= ATH_BCBUF) {
 			ath_err(common, "No beacon slot available\n");
-			return -ENOBUFS;
+			ret = -ENOBUFS;
+			goto out;
 		}
 		break;
 	case NL80211_IFTYPE_STATION:
@@ -1504,14 +1506,15 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	default:
 		ath_err(common, "Interface type %d not yet supported\n",
 				vif->type);
-		mutex_unlock(&sc->mutex);
-		return -ENOTSUPP;
+		ret = -ENOTSUPP;
+		goto out;
 	}
 	vif->type = new_type;
 	vif->p2p = p2p;
 
+out:
 	mutex_unlock(&sc->mutex);
-	return 0;
+	return ret;
 }
 
 static void ath9k_remove_interface(struct ieee80211_hw *hw,
