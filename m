Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3740 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760194Ab3BHO4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 15/27] brcmfmac: Use real cookie value for p2p remain on
 channel.
Date: Fri, 8 Feb 2013 15:53:50 +0100
Message-ID: <1360335242-12608-16-git-send-email-arend@broadcom.com> (sfid-20130208_160433_226410_25845F91)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

In some rare situations the wpa_supplicant can lock up on a remain
on channel command. Use actual cookies for the remain on channel
related commands and allow for additional remain on channel while
still having one set.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c |   61 +++++++++++++++++++------
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h |    6 ++-
 2 files changed, 51 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 0c42910..aac054c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -913,6 +913,47 @@ int brcmf_p2p_scan_prep(struct wiphy *wiphy,
 
 
 /**
+ * brcmf_p2p_discover_listen() - set firmware to discover listen state.
+ *
+ * @p2p: p2p device.
+ * @freq: center frequency for discover listen.
+ * #@duration: time in ms to stay on channel.
+ *
+ */
+static s32
+brcmf_p2p_discover_listen(struct brcmf_p2p_info *p2p,
+			  struct ieee80211_channel *channel, u32 duration)
+{
+	struct brcmf_cfg80211_vif *vif;
+	s32 err = 0;
+	u16 chanspec;
+
+	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+	if (!vif) {
+		brcmf_err("Discovery is not set, so we have nothing to do\n");
+		err = -EPERM;
+		goto exit;
+	}
+
+	if (test_bit(BRCMF_P2P_STATUS_DISCOVER_LISTEN, &p2p->status)) {
+		brcmf_err("Previous LISTEN is not completed yet\n");
+		/* WAR: prevent cookie mismatch in wpa_supplicant return OK */
+		goto exit;
+	}
+
+	chanspec = channel_to_chanspec(channel);
+	err = brcmf_p2p_set_discover_state(vif->ifp, WL_P2P_DISC_ST_LISTEN,
+					   chanspec, (u16)duration);
+	if (!err) {
+		set_bit(BRCMF_P2P_STATUS_DISCOVER_LISTEN, &p2p->status);
+		p2p->remain_on_channel_cookie++;
+	}
+exit:
+	return err;
+}
+
+
+/**
  * brcmf_p2p_remain_on_channel() - put device on channel and stay there.
  *
  * @wiphy: wiphy device.
@@ -926,30 +967,21 @@ int brcmf_p2p_remain_on_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
-	struct brcmf_cfg80211_vif *vif;
 	s32 err;
-	u16 chanspec;
 
 	brcmf_dbg(TRACE, "Enter, channel: %d, duration ms (%d)\n",
 		  ieee80211_frequency_to_channel(channel->center_freq),
 		  duration);
 
-	*cookie = 0;
 	err = brcmf_p2p_enable_discovery(p2p);
 	if (err)
 		goto exit;
-
-	chanspec = channel_to_chanspec(channel);
-	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
-	err = brcmf_p2p_set_discover_state(vif->ifp, WL_P2P_DISC_ST_LISTEN,
-					   chanspec, (u16)duration);
+	err = brcmf_p2p_discover_listen(p2p, channel, duration);
 	if (err)
 		goto exit;
 
-	memcpy(&p2p->remain_on_channel, channel,
-	       sizeof(p2p->remain_on_channel));
-
-	set_bit(BRCMF_P2P_STATUS_REMAIN_ON_CHANNEL, &p2p->status);
+	memcpy(&p2p->remain_on_channel, channel, sizeof(*channel));
+	*cookie = p2p->remain_on_channel_cookie;
 
 exit:
 	cfg80211_ready_on_channel(wdev, *cookie, channel, duration, GFP_KERNEL);
@@ -973,9 +1005,10 @@ int brcmf_p2p_notify_listen_complete(struct brcmf_if *ifp,
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
 
 	brcmf_dbg(TRACE, "Enter\n");
-	if (test_and_clear_bit(BRCMF_P2P_STATUS_REMAIN_ON_CHANNEL,
+	if (test_and_clear_bit(BRCMF_P2P_STATUS_DISCOVER_LISTEN,
 			       &p2p->status))
-		cfg80211_remain_on_channel_expired(&ifp->vif->wdev, 0,
+		cfg80211_remain_on_channel_expired(&ifp->vif->wdev,
+						   p2p->remain_on_channel_cookie,
 						   &p2p->remain_on_channel,
 						   GFP_KERNEL);
 	return 0;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
index 0610dcf..0594018 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
@@ -63,7 +63,7 @@ struct p2p_bss {
  * @BRCMF_P2P_STATUS_ACTION_TX_COMPLETED: action frame tx completed.
  * @BRCMF_P2P_STATUS_ACTION_TX_NOACK: action frame tx not acked.
  * @BRCMF_P2P_STATUS_GO_NEG_PHASE: P2P GO negotiation ongoing.
- * @BRCMF_P2P_STATUS_REMAIN_ON_CHANNEL: P2P listen, remaining on channel.
+ * @BRCMF_P2P_STATUS_DISCOVER_LISTEN: P2P listen, remaining on channel.
  */
 enum brcmf_p2p_status {
 	BRCMF_P2P_STATUS_IF_ADD = 0,
@@ -74,7 +74,7 @@ enum brcmf_p2p_status {
 	BRCMF_P2P_STATUS_ACTION_TX_COMPLETED,
 	BRCMF_P2P_STATUS_ACTION_TX_NOACK,
 	BRCMF_P2P_STATUS_GO_NEG_PHASE,
-	BRCMF_P2P_STATUS_REMAIN_ON_CHANNEL
+	BRCMF_P2P_STATUS_DISCOVER_LISTEN
 };
 
 /**
@@ -89,6 +89,7 @@ enum brcmf_p2p_status {
  * @ssid: ssid for P2P GO.
  * @listen_channel: channel for @WL_P2P_DISC_ST_LISTEN discover state.
  * @remain_on_channel: contains copy of struct used by cfg80211.
+ * @remain_on_channel_cookie: cookie counter for remain on channel cmd
  * @next_af_subtype: expected action frame subtype.
  * @send_af_done: indication that action frame tx is complete.
  */
@@ -102,6 +103,7 @@ struct brcmf_p2p_info {
 	struct brcmf_ssid ssid;
 	u8 listen_channel;
 	struct ieee80211_channel remain_on_channel;
+	u32 remain_on_channel_cookie;
 	u8 next_af_subtype;
 	struct completion send_af_done;
 };
-- 
1.7.10.4


