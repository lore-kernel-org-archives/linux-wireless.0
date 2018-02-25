Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from skyhawk.myhost.co.nz ([120.138.17.237]:56298 "EHLO
        skyhawk.myhost.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751760AbeBYVrK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Feb 2018 16:47:10 -0500
From: Ben Caradoc-Davies <ben@transient.nz>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org,
        Ben Caradoc-Davies <ben@transient.nz>
Subject: [PATCH] Revert "mac80211: use QoS NDP for AP probing"
Date: Mon, 26 Feb 2018 10:15:41 +1300
Message-Id: <20180225211541.29931-1-ben@transient.nz> (sfid-20180225_225013_392018_37030F79)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 7b6ddeaf27eca72795ceeae2f0f347db1b5f9a30.

The above commit causes an Atheros AR9271 ath9k_htc USB WiFi adapter
connected to an AP with QoS/WME enabled to lose all IP connectivity after
something like 10 to 90 minutes. The adapter remains up and associated
and "iw dev wlan0 station dump" shows byte and packet counters that keep
increasing, but all IP connectivity fails, including ping, DNS, and web.
The host cannot be pinged by other hosts on the WLAN. Network can be
restored by unloading and reloading the ath9k_htc module, or physically
unplugging and replugging the adapter, triggering NetworkManager to
reconnect.

The problematic commit is on torvalds/master and linux-stable/linux-4.15.y.
On linux-stable/linux-4.14.y: e23090a7d8f05f03cf564148472130286f5ca9bf.

Problem confirmed on Debian linux-image-4.14.0-3-amd64 4.14.17-1 and
Debian linux-image-4.15.0-1-amd64 4.15.4-1 and vanilla 4.14.16
(git e23090a7d8f0 from linux-stable/linux-4.14.y) and vanilla 4.16.0-rc2
(git 3664ce2d9309 from torvalds/master).

Fix tested by reverting the commit on vanilla 4.16.0-rc2 (git 3664ce2d9309
from torvalds/master) and applying the patch to Debian
linux-image-4.15.0-1-amd64 4.15.4-1. Both tests resulted in stable IP
connectivity.

See also Debian Bug#891060:
Atheros AR9271 ath9k_htc USB WiFi connected but IP traffic stops
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=891060

Signed-off-by: Ben Caradoc-Davies <ben@transient.nz>
---
 drivers/net/wireless/ath/ath9k/channel.c |  2 +-
 drivers/net/wireless/st/cw1200/sta.c     |  4 ++--
 drivers/net/wireless/ti/wl1251/main.c    |  2 +-
 drivers/net/wireless/ti/wlcore/cmd.c     |  5 ++---
 include/net/mac80211.h                   |  8 +-------
 net/mac80211/mlme.c                      |  2 +-
 net/mac80211/tx.c                        | 29 ++---------------------------
 7 files changed, 10 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 1b05b5d7a038..dfb26f03c1a2 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1113,7 +1113,7 @@ ath_chanctx_send_vif_ps_frame(struct ath_softc *sc, struct ath_vif *avp,
 		if (!avp->assoc)
 			return false;
 
-		skb = ieee80211_nullfunc_get(sc->hw, vif, false);
+		skb = ieee80211_nullfunc_get(sc->hw, vif);
 		if (!skb)
 			return false;
 
diff --git a/drivers/net/wireless/st/cw1200/sta.c b/drivers/net/wireless/st/cw1200/sta.c
index 38678e9a0562..03687a80d6e9 100644
--- a/drivers/net/wireless/st/cw1200/sta.c
+++ b/drivers/net/wireless/st/cw1200/sta.c
@@ -198,7 +198,7 @@ void __cw1200_cqm_bssloss_sm(struct cw1200_common *priv,
 
 		priv->bss_loss_state++;
 
-		skb = ieee80211_nullfunc_get(priv->hw, priv->vif, false);
+		skb = ieee80211_nullfunc_get(priv->hw, priv->vif);
 		WARN_ON(!skb);
 		if (skb)
 			cw1200_tx(priv->hw, NULL, skb);
@@ -2265,7 +2265,7 @@ static int cw1200_upload_null(struct cw1200_common *priv)
 		.rate = 0xFF,
 	};
 
-	frame.skb = ieee80211_nullfunc_get(priv->hw, priv->vif, false);
+	frame.skb = ieee80211_nullfunc_get(priv->hw, priv->vif);
 	if (!frame.skb)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 037defd10b91..99a6889a6540 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -566,7 +566,7 @@ static int wl1251_build_null_data(struct wl1251 *wl)
 		size = sizeof(struct wl12xx_null_data_template);
 		ptr = NULL;
 	} else {
-		skb = ieee80211_nullfunc_get(wl->hw, wl->vif, false);
+		skb = ieee80211_nullfunc_get(wl->hw, wl->vif);
 		if (!skb)
 			goto out;
 		size = skb->len;
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 761cf8573a80..2bfc12fdc929 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1069,8 +1069,7 @@ int wl12xx_cmd_build_null_data(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		ptr = NULL;
 	} else {
 		skb = ieee80211_nullfunc_get(wl->hw,
-					     wl12xx_wlvif_to_vif(wlvif),
-					     false);
+					     wl12xx_wlvif_to_vif(wlvif));
 		if (!skb)
 			goto out;
 		size = skb->len;
@@ -1097,7 +1096,7 @@ int wl12xx_cmd_build_klv_null_data(struct wl1271 *wl,
 	struct sk_buff *skb = NULL;
 	int ret = -ENOMEM;
 
-	skb = ieee80211_nullfunc_get(wl->hw, vif, false);
+	skb = ieee80211_nullfunc_get(wl->hw, vif);
 	if (!skb)
 		goto out;
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c96511fa9198..03280be484b2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4478,24 +4478,18 @@ struct sk_buff *ieee80211_pspoll_get(struct ieee80211_hw *hw,
  * ieee80211_nullfunc_get - retrieve a nullfunc template
  * @hw: pointer obtained from ieee80211_alloc_hw().
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
- * @qos_ok: QoS NDP is acceptable to the caller, this should be set
- *	if at all possible
  *
  * Creates a Nullfunc template which can, for example, uploaded to
  * hardware. The template must be updated after association so that correct
  * BSSID and address is used.
  *
- * If @qos_ndp is set and the association is to an AP with QoS/WMM, the
- * returned packet will be QoS NDP.
- *
  * Note: Caller (or hardware) is responsible for setting the
  * &IEEE80211_FCTL_PM bit as well as Duration and Sequence Control fields.
  *
  * Return: The nullfunc template. %NULL on error.
  */
 struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif,
-				       bool qos_ok);
+				       struct ieee80211_vif *vif);
 
 /**
  * ieee80211_probereq_get - retrieve a Probe Request template
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 39b660b9a908..cc55ff8ae979 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -896,7 +896,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 	struct ieee80211_hdr_3addr *nullfunc;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	skb = ieee80211_nullfunc_get(&local->hw, &sdata->vif, true);
+	skb = ieee80211_nullfunc_get(&local->hw, &sdata->vif);
 	if (!skb)
 		return;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 25904af38839..16bc1dacf1b3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4440,15 +4440,13 @@ struct sk_buff *ieee80211_pspoll_get(struct ieee80211_hw *hw,
 EXPORT_SYMBOL(ieee80211_pspoll_get);
 
 struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif,
-				       bool qos_ok)
+				       struct ieee80211_vif *vif)
 {
 	struct ieee80211_hdr_3addr *nullfunc;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_managed *ifmgd;
 	struct ieee80211_local *local;
 	struct sk_buff *skb;
-	bool qos = false;
 
 	if (WARN_ON(vif->type != NL80211_IFTYPE_STATION))
 		return NULL;
@@ -4457,17 +4455,7 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
 	ifmgd = &sdata->u.mgd;
 	local = sdata->local;
 
-	if (qos_ok) {
-		struct sta_info *sta;
-
-		rcu_read_lock();
-		sta = sta_info_get(sdata, ifmgd->bssid);
-		qos = sta && sta->sta.wme;
-		rcu_read_unlock();
-	}
-
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
-			    sizeof(*nullfunc) + 2);
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*nullfunc));
 	if (!skb)
 		return NULL;
 
@@ -4477,19 +4465,6 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
 	nullfunc->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
 					      IEEE80211_STYPE_NULLFUNC |
 					      IEEE80211_FCTL_TODS);
-	if (qos) {
-		__le16 qos = cpu_to_le16(7);
-
-		BUILD_BUG_ON((IEEE80211_STYPE_QOS_NULLFUNC |
-			      IEEE80211_STYPE_NULLFUNC) !=
-			     IEEE80211_STYPE_QOS_NULLFUNC);
-		nullfunc->frame_control |=
-			cpu_to_le16(IEEE80211_STYPE_QOS_NULLFUNC);
-		skb->priority = 7;
-		skb_set_queue_mapping(skb, IEEE80211_AC_VO);
-		skb_put_data(skb, &qos, sizeof(qos));
-	}
-
 	memcpy(nullfunc->addr1, ifmgd->bssid, ETH_ALEN);
 	memcpy(nullfunc->addr2, vif->addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, ifmgd->bssid, ETH_ALEN);
-- 
Ben Caradoc-Davies <ben@transient.nz>
Director
Transient Software Limited <https://transient.nz/>
New Zealand
