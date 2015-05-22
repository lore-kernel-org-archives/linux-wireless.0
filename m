Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51729 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048AbbEVO0D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 10:26:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Matthieu Mauger <matthieux.mauger@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: properly send NL80211_ATTR_DISCONNECTED_BY_AP in disconnect
Date: Fri, 22 May 2015 16:25:59 +0200
Message-Id: <1432304759-31767-1-git-send-email-johannes@sipsolutions.net> (sfid-20150522_162607_978770_A0DFFECC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we disconnect from the AP, drivers call cfg80211_disconnect().
This doesn't know whether the disconnection was initiated locally
or by the AP though, which can cause problems with the supplicant,
for example with WPS. This issue obviously doesn't show up with any
mac80211 based driver since mac80211 doesn't call this function.

Fix this by requiring drivers to indicate whether the disconnect is
locally generated or not. I've tried to update the drivers, but may
not have gotten the values correct, and some drivers may currently
not be able to report correct values. In case of doubt I left it at
false, which is the current behaviour.

Reported-by: Matthieu Mauger <matthieux.mauger@intel.com>
Tested-by: Matthieu Mauger <matthieux.mauger@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c         | 4 ++--
 drivers/net/wireless/ath/wil6210/main.c            | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 4 ++--
 drivers/net/wireless/libertas/cfg.c                | 4 ++--
 drivers/net/wireless/mwifiex/join.c                | 2 +-
 drivers/net/wireless/mwifiex/sta_event.c           | 2 +-
 drivers/net/wireless/rndis_wlan.c                  | 2 +-
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  | 2 +-
 drivers/staging/wlan-ng/cfg80211.c                 | 2 +-
 include/net/cfg80211.h                             | 4 +++-
 net/wireless/core.h                                | 1 +
 net/wireless/sme.c                                 | 4 +++-
 net/wireless/util.c                                | 3 ++-
 13 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index cce4625a53ad..a511ef3614b9 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -889,7 +889,7 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 					GFP_KERNEL);
 	} else if (vif->sme_state == SME_CONNECTED) {
 		cfg80211_disconnected(vif->ndev, proto_reason,
-				      NULL, 0, GFP_KERNEL);
+				      NULL, 0, false, GFP_KERNEL);
 	}
 
 	vif->sme_state = SME_DISCONNECTED;
@@ -3467,7 +3467,7 @@ void ath6kl_cfg80211_stop(struct ath6kl_vif *vif)
 					GFP_KERNEL);
 		break;
 	case SME_CONNECTED:
-		cfg80211_disconnected(vif->ndev, 0, NULL, 0, GFP_KERNEL);
+		cfg80211_disconnected(vif->ndev, 0, NULL, 0, true, GFP_KERNEL);
 		break;
 	}
 
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index c2a238426425..38b953e108a7 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -224,7 +224,7 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
 		if (test_bit(wil_status_fwconnected, wil->status)) {
 			clear_bit(wil_status_fwconnected, wil->status);
 			cfg80211_disconnected(ndev, reason_code,
-					      NULL, 0, GFP_KERNEL);
+					      NULL, 0, false, GFP_KERNEL);
 		} else if (test_bit(wil_status_fwconnecting, wil->status)) {
 			cfg80211_connect_result(ndev, bssid, NULL, 0, NULL, 0,
 						WLAN_STATUS_UNSPECIFIED_FAILURE,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 8a15ebbce4a3..2e4e42245b8f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -1262,7 +1262,7 @@ static void brcmf_link_down(struct brcmf_cfg80211_vif *vif, u16 reason)
 		}
 		clear_bit(BRCMF_VIF_STATUS_CONNECTED, &vif->sme_state);
 		cfg80211_disconnected(vif->wdev.netdev, reason, NULL, 0,
-				      GFP_KERNEL);
+				      true, GFP_KERNEL);
 
 	}
 	clear_bit(BRCMF_VIF_STATUS_CONNECTING, &vif->sme_state);
@@ -1928,7 +1928,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 
 	clear_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state);
 	clear_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state);
-	cfg80211_disconnected(ndev, reason_code, NULL, 0, GFP_KERNEL);
+	cfg80211_disconnected(ndev, reason_code, NULL, 0, true, GFP_KERNEL);
 
 	memcpy(&scbval.ea, &profile->bssid, ETH_ALEN);
 	scbval.val = cpu_to_le32(reason_code);
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 1a4d558022d8..9e3e3176670b 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -841,7 +841,7 @@ void lbs_send_disconnect_notification(struct lbs_private *priv)
 
 	cfg80211_disconnected(priv->dev,
 		0,
-		NULL, 0,
+		NULL, 0, false,
 		GFP_KERNEL);
 
 	lbs_deb_leave(LBS_DEB_CFG80211);
@@ -1458,7 +1458,7 @@ int lbs_disconnect(struct lbs_private *priv, u16 reason)
 
 	cfg80211_disconnected(priv->dev,
 			reason,
-			NULL, 0,
+			NULL, 0, true,
 			GFP_KERNEL);
 	priv->connect_status = LBS_DISCONNECTED;
 
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 411a6c2f4aca..080ec3422db9 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1421,7 +1421,7 @@ int mwifiex_deauthenticate(struct mwifiex_private *priv, u8 *mac)
 		ret = mwifiex_deauthenticate_infra(priv, mac);
 		if (ret)
 			cfg80211_disconnected(priv->netdev, 0, NULL, 0,
-					      GFP_KERNEL);
+					      true, GFP_KERNEL);
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		return mwifiex_send_cmd(priv, HostCmd_CMD_802_11_AD_HOC_STOP,
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 0dc7a1d3993d..c9064b88d6a4 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -133,7 +133,7 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code)
 	if (priv->bss_mode == NL80211_IFTYPE_STATION ||
 	    priv->bss_mode == NL80211_IFTYPE_P2P_CLIENT) {
 		cfg80211_disconnected(priv->netdev, reason_code, NULL, 0,
-				      GFP_KERNEL);
+				      false, GFP_KERNEL);
 	}
 	eth_zero_addr(priv->cfg_bssid);
 
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index d72ff8e7125d..43db6976102f 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2861,7 +2861,7 @@ static void rndis_wlan_do_link_down_work(struct usbnet *usbdev)
 
 		deauthenticate(usbdev);
 
-		cfg80211_disconnected(usbdev->net, 0, NULL, 0, GFP_KERNEL);
+		cfg80211_disconnected(usbdev->net, 0, NULL, 0, true, GFP_KERNEL);
 	}
 
 	netif_carrier_off(usbdev->net);
diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index bc95ce89af06..5ab2f6978209 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -379,7 +379,7 @@ void rtw_cfg80211_indicate_disconnect(struct rtw_adapter *padapter)
 						GFP_ATOMIC);
 		} else {
 			cfg80211_disconnected(padapter->pnetdev, 0, NULL,
-					      0, GFP_ATOMIC);
+					      0, false, GFP_ATOMIC);
 		}
 	}
 }
diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index 7c87aecf4744..342e2b30c48f 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -722,7 +722,7 @@ void prism2_connect_result(wlandevice_t *wlandev, u8 failed)
 void prism2_disconnected(wlandevice_t *wlandev)
 {
 	cfg80211_disconnected(wlandev->netdev, 0, NULL,
-		0, GFP_KERNEL);
+		0, false, GFP_KERNEL);
 }
 
 void prism2_roamed(wlandevice_t *wlandev)
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d63ecec73090..a741678f24a2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4575,13 +4575,15 @@ void cfg80211_roamed_bss(struct net_device *dev, struct cfg80211_bss *bss,
  * @ie: information elements of the deauth/disassoc frame (may be %NULL)
  * @ie_len: length of IEs
  * @reason: reason code for the disconnection, set it to 0 if unknown
+ * @locally_generated: disconnection was requested locally
  * @gfp: allocation flags
  *
  * After it calls this function, the driver should enter an idle state
  * and not try to connect to any AP any more.
  */
 void cfg80211_disconnected(struct net_device *dev, u16 reason,
-			   const u8 *ie, size_t ie_len, gfp_t gfp);
+			   const u8 *ie, size_t ie_len,
+			   bool locally_generated, gfp_t gfp);
 
 /**
  * cfg80211_ready_on_channel - notification of remain_on_channel start
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 801cd49c5a0c..311eef26bf88 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -222,6 +222,7 @@ struct cfg80211_event {
 			const u8 *ie;
 			size_t ie_len;
 			u16 reason;
+			bool locally_generated;
 		} dc;
 		struct {
 			u8 bssid[ETH_ALEN];
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index d11454f87bac..8020b5b094d4 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -938,7 +938,8 @@ void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 }
 
 void cfg80211_disconnected(struct net_device *dev, u16 reason,
-			   const u8 *ie, size_t ie_len, gfp_t gfp)
+			   const u8 *ie, size_t ie_len,
+			   bool locally_generated, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
@@ -954,6 +955,7 @@ void cfg80211_disconnected(struct net_device *dev, u16 reason,
 	ev->dc.ie_len = ie_len;
 	memcpy((void *)ev->dc.ie, ie, ie_len);
 	ev->dc.reason = reason;
+	ev->dc.locally_generated = locally_generated;
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 70051ab52f4f..4cb34557b873 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -887,7 +887,8 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 		case EVENT_DISCONNECTED:
 			__cfg80211_disconnected(wdev->netdev,
 						ev->dc.ie, ev->dc.ie_len,
-						ev->dc.reason, true);
+						ev->dc.reason,
+						!ev->dc.locally_generated);
 			break;
 		case EVENT_IBSS_JOINED:
 			__cfg80211_ibss_joined(wdev->netdev, ev->ij.bssid,
-- 
2.1.4

