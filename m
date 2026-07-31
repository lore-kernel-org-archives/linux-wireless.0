Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CECA3D9DD1
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 12:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501347; cv=none; b=LPPyQaIqGcTJ5PuwCJsM1MKCyV3D6V0i3ctSN0oVRpRNCyPx/beO8W4H9svRW7eJww9A7YgUKyh/zJX91giDsULeQEvWMvprespcTrDMyv3E92Tpp1iN7QjVGpJAgrfMwuQKWK3s5c+WEek/K/DBMeMjDL1kmNyMa/88/WlN0RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501347; c=relaxed/simple;
	bh=Fd9S7GoVgA9AUUQZnyBho3QYI5nHmJn+m1qHrl8qwp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3Vdore5EHG9ShT39V54bQIZBGOJNBsJbo7NL18Xb935bMVSVQNVbVvKlMHTLOtvZmVEF8uxfXhu7sAokwKTptsFgR7u5c94paKsU3kF6MdwjKa+X03J6wkbY2uKAlsByVW+KFRPopy/pNbbyXHLZGsDfWemJOL5Zrk8YPQcv8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=SpnvHHBG; arc=none smtp.client-ip=209.85.216.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SpnvHHBG"
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-38dfe910e9dso845825a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785501345; x=1786106145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JCr4OwNdnSUGOHZ+1eXMW3aSWSeCYVJUNP1nccEh1Gc=;
        b=m8qrmZwRKgzIuQ15EYXZK0ktZNSpQXTr07iVHlX0KzivCSIgCn8rli8jGC9q/07D/F
         AwXIn75dSqY9Lg8GvKADXewVMQJGuFGQ5ClYeYc5CftQusxgbQNsI6WubcShtTAGIxUe
         LRlQWPDRR/jrRopmRL0d/D7whklvY5JgySxdYk0kRkZ6u9/sH0KEwQNFRv8f+z0dqGmP
         cV1kcmgk2EbI1DmnShJXQXwtyYvcpADQKzn4ZQdtSkCmj6MxOiYN/JQsXvi2e/hq7Pn9
         dRa+gstdHBulBMtwmO0YttxoCVQyDTPwNTv57ljTiY3bFjunn2mkAfH1mMxEtU6J/+yE
         g6AA==
X-Gm-Message-State: AOJu0YzVQ3PxOF+NINPFlHO01vU4/o4W3IrJSGLTcB2lYrTKH3hPULmC
	WkrmTxM8S1WS3zLH+6MO+krp0ppKipip0GJAhJcJhhBD9bt6TElW6abxKq0/xUfTcqHYVXYzfub
	JYu0/lhaT9eqY2C0/r4Z8RUT2yyPSmA5z/0mwVJ8yDH8oojpKwBoHK8UHmaQCYR4PnvpWdxIfvm
	7CgrL+eplrHncBTJGfRN5RlMzPm5zDssi7/5tKnNzPIoeKtZSYORGB/ohMPfxixHpFxKqRht6+e
	UuVdl3ccmS6bbtMMJtxaoMQVA==
X-Gm-Gg: AR+sD11TTBG+1JlGVWBGCzpDQzOEPdVtk3rjjLXLZiunwir13cxjleA8FUiStnXJ09p
	tx+5LB8OehmVQsRn8rmsGNHX8MShzjLw91mjFtEmtJgPj07m5geJhg3RDAPryYxTtGEWh43G6tW
	DhJG1qklszJx8YM3JG2PNBLZfyGzgWZoDgaaaMiWFzxtKLEsT3EMLJwxBCCxW5Dcxsdnp2+7ANy
	RJrhs8p04/eYnNYliL4/sa9Kj1YvkGZDhf9Mu1dJt5eGZwlSZXHElmlraLgdSAUfCHGT4Ppg1Tr
	JjM6IzR35nJDhhAWTayMLog6dZ6ctAkXjsgBYhYtleF8jg07gn3tC1QIO9EgUw4JyylmxpETpL+
	7l4Wy3PEQMueBoOpk4ZUXUsb3omPVkqrSjSO/fIqSQI8c9cgrPHOnuiNUaCXmAJfUO2h+TIbz/1
	tmxnp0hWEzjdqmFVgy/O2Mhu8Ryex7yYfUdc2DJH0=
X-Received: by 2002:a17:90b:1b42:b0:38d:fda6:4873 with SMTP id 98e67ed59e1d1-38fb110fa32mr1876643a91.10.1785501344837;
        Fri, 31 Jul 2026 05:35:44 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-38fb2b322b7sm103964a91.5.2026.07.31.05.35.43
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2026 05:35:44 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e8e864ef0so1609249a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785501342; x=1786106142; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JCr4OwNdnSUGOHZ+1eXMW3aSWSeCYVJUNP1nccEh1Gc=;
        b=SpnvHHBGfrFeHgPlYUYC9TERwO+bMEvXi/CJIOrcKmA5b0tzEA4OSKfaFxoKbtAXLJ
         qK8do6qCQwYFO3eZnxHWpPHk1NDlhkDRkRt1mOOl8hfLUkMDR1KTPaMdBYhByqWIyeKp
         xZJkzMm54dOXAg13pAkXLH5mVsPApvutHkACY=
X-Received: by 2002:a17:90b:4d0a:b0:37f:9cdf:f0ab with SMTP id 98e67ed59e1d1-38fb1237cbbmr1922684a91.26.1785501341980;
        Fri, 31 Jul 2026 05:35:41 -0700 (PDT)
X-Received: by 2002:a17:90b:4d0a:b0:37f:9cdf:f0ab with SMTP id 98e67ed59e1d1-38fb1237cbbmr1922649a91.26.1785501341319;
        Fri, 31 Jul 2026 05:35:41 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9be04sm5187041eec.9.2026.07.31.05.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 05:35:40 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v3 11/13] wifi: cfg80211: convert cookie output to input parameter
Date: Fri, 31 Jul 2026 14:35:07 +0200
Message-ID: <20260731123509.1975281-12-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
References: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The remain_on_channel, mgmt_tx, and probe_peer ops previously used
a u64 *cookie output parameter. Now that cfg80211 pre-assigns the
cookie value before invoking drivers, the parameter conveys a value
from caller to driver, not the other way around. Convert it to a
plain u64 input parameter across the ops struct (cfg80211.h),
rdev-ops.h wrappers, nl80211.c/mlme.c call sites, mac80211, and
all driver implementations.

The tx_control_port op is excluded: its cookie pointer is nullable
(passed as NULL when dont_wait_for_ack is set), so the nullable
pointer semantics are still required.

Internal mac80211 helpers ieee80211_start_roc_work() and
ieee80211_attach_ack_skb() still take u64 *cookie because they
assign to the pointee; their callers now pass &cookie to take the
address of the local value parameter.

wil6210's internal wil_p2p_listen() is also updated to take u64
cookie since it is called directly from the remain_on_channel
callback.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c     | 10 +++++-----
 drivers/net/wireless/ath/wil6210/cfg80211.c    | 10 +++++-----
 drivers/net/wireless/ath/wil6210/debugfs.c     |  2 +-
 drivers/net/wireless/ath/wil6210/p2p.c         |  6 +++---
 drivers/net/wireless/ath/wil6210/wil6210.h     |  4 ++--
 .../broadcom/brcm80211/brcmfmac/cfg80211.c     | 10 +++++-----
 .../broadcom/brcm80211/brcmfmac/cfg80211.h     |  2 +-
 .../broadcom/brcm80211/brcmfmac/cyw/core.c     |  7 +++----
 .../wireless/broadcom/brcm80211/brcmfmac/p2p.c |  6 +++---
 .../wireless/broadcom/brcm80211/brcmfmac/p2p.h |  2 +-
 .../net/wireless/marvell/mwifiex/cfg80211.c    | 18 +++++++++---------
 .../net/wireless/microchip/wilc1000/cfg80211.c | 12 ++++++------
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c    | 18 +++++++++---------
 .../net/wireless/quantenna/qtnfmac/cfg80211.c  |  2 +-
 .../staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |  4 ++--
 include/net/cfg80211.h                         |  6 +++---
 net/mac80211/cfg.c                             |  4 ++--
 net/mac80211/ieee80211_i.h                     |  4 ++--
 net/mac80211/offchannel.c                      | 10 +++++-----
 net/wireless/core.h                            |  2 +-
 net/wireless/mlme.c                            |  2 +-
 net/wireless/nl80211.c                         |  6 +++---
 net/wireless/rdev-ops.h                        | 12 ++++++------
 23 files changed, 79 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index e9d6e6a53d7d..34025d64d615 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3034,14 +3034,14 @@ static int ath6kl_remain_on_channel(struct wiphy *wiphy,
 				    struct wireless_dev *wdev,
 				    struct ieee80211_channel *chan,
 				    unsigned int duration,
-				    u64 *cookie, const u8 *rx_addr)
+				    u64 cookie, const u8 *rx_addr)
 {
 	struct ath6kl_vif *vif = ath6kl_vif_from_wdev(wdev);
 	struct ath6kl *ar = ath6kl_priv(vif->ndev);
 
 	/* TODO: if already pending or ongoing remain-on-channel,
 	 * return -EBUSY */
-	vif->last_roc_id = *cookie;
+	vif->last_roc_id = cookie;
 
 	return ath6kl_wmi_remain_on_chnl_cmd(ar->wmi, vif->fw_vif_idx,
 					     chan->center_freq, duration);
@@ -3186,7 +3186,7 @@ static bool ath6kl_is_p2p_go_ssid(const u8 *buf, size_t len)
 }
 
 static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
-			  struct cfg80211_mgmt_tx_params *params, u64 *cookie)
+			  struct cfg80211_mgmt_tx_params *params, u64 cookie)
 {
 	struct ath6kl_vif *vif = ath6kl_vif_from_wdev(wdev);
 	struct ath6kl *ar = ath6kl_priv(vif->ndev);
@@ -3232,13 +3232,13 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	/* AP mode Power saving processing */
 	if (vif->nw_type == AP_NETWORK) {
-		queued = ath6kl_mgmt_powersave_ap(vif, id, *cookie, freq, wait,
+		queued = ath6kl_mgmt_powersave_ap(vif, id, cookie, freq, wait,
 						  buf, len, &more_data, no_cck);
 		if (queued)
 			return 0;
 	}
 
-	ar->wmi->last_mgmt_tx_cookie = *cookie;
+	ar->wmi->last_mgmt_tx_cookie = cookie;
 	return ath6kl_wmi_send_mgmt_cmd(ar->wmi, vif->fw_vif_idx, id, freq,
 					wait, buf, len, no_cck);
 }
diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 6ebd340c8ef7..9ac33d827f80 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1432,7 +1432,7 @@ static int wil_cfg80211_set_wiphy_params(struct wiphy *wiphy, int radio_idx,
 
 int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 struct cfg80211_mgmt_tx_params *params,
-			 u64 *cookie)
+			 u64 cookie)
 {
 	const u8 *buf = params->buf;
 	size_t len = params->len;
@@ -1488,7 +1488,7 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	 */
 	tx_status = (rc == 0);
 	rc = (rc == -EAGAIN) ? 0 : rc;
-	cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, tx_status, GFP_KERNEL);
+	cfg80211_mgmt_tx_status(wdev, cookie, buf, len, tx_status, GFP_KERNEL);
 
 	return rc;
 }
@@ -1734,7 +1734,7 @@ static int wil_remain_on_channel(struct wiphy *wiphy,
 				 struct wireless_dev *wdev,
 				 struct ieee80211_channel *chan,
 				 unsigned int duration,
-				 u64 *cookie, const u8 *rx_addr)
+				 u64 cookie, const u8 *rx_addr)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	int rc;
@@ -2380,7 +2380,7 @@ void wil_probe_client_flush(struct wil6210_vif *vif)
 
 static int wil_cfg80211_probe_peer(struct wiphy *wiphy,
 				   struct net_device *dev,
-				   const u8 *peer, u64 *cookie)
+				   const u8 *peer, u64 cookie)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	struct wil6210_vif *vif = ndev_to_vif(dev);
@@ -2398,7 +2398,7 @@ static int wil_cfg80211_probe_peer(struct wiphy *wiphy,
 		return -ENOMEM;
 
 	req->cid = cid;
-	req->cookie = *cookie;
+	req->cookie = cookie;
 
 	mutex_lock(&vif->probe_client_mutex);
 	list_add_tail(&req->list, &vif->probe_client_pending);
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index b8cb736a7185..e06e45323272 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -985,7 +985,7 @@ static ssize_t wil_write_file_txmgmt(struct file *file, const char __user *buf,
 	params.buf = frame;
 	params.len = len;
 
-	rc = wil_cfg80211_mgmt_tx(wiphy, wdev, &params, NULL);
+	rc = wil_cfg80211_mgmt_tx(wiphy, wdev, &params, 0);
 
 	kfree(frame);
 	wil_info(wil, "-> %d\n", rc);
diff --git a/drivers/net/wireless/ath/wil6210/p2p.c b/drivers/net/wireless/ath/wil6210/p2p.c
index 6d2cadca259f..acd8a2e35103 100644
--- a/drivers/net/wireless/ath/wil6210/p2p.c
+++ b/drivers/net/wireless/ath/wil6210/p2p.c
@@ -124,7 +124,7 @@ int wil_p2p_search(struct wil6210_vif *vif,
 
 int wil_p2p_listen(struct wil6210_priv *wil, struct wireless_dev *wdev,
 		   unsigned int duration, struct ieee80211_channel *chan,
-		   u64 *cookie)
+		   u64 cookie)
 {
 	struct wil6210_vif *vif = wdev_to_vif(wil, wdev);
 	struct wil_p2p_info *p2p = &vif->p2p;
@@ -144,7 +144,7 @@ int wil_p2p_listen(struct wil6210_priv *wil, struct wireless_dev *wdev,
 	}
 
 	memcpy(&p2p->listen_chan, chan, sizeof(*chan));
-	p2p->cookie = *cookie;
+	p2p->cookie = cookie;
 	p2p->listen_duration = duration;
 
 	mutex_lock(&wil->vif_mutex);
@@ -166,7 +166,7 @@ int wil_p2p_listen(struct wil6210_priv *wil, struct wireless_dev *wdev,
 	if (vif->mid == 0)
 		wil->radio_wdev = wdev;
 
-	cfg80211_ready_on_channel(wdev, *cookie, chan, duration,
+	cfg80211_ready_on_channel(wdev, cookie, chan, duration,
 				  GFP_KERNEL);
 
 out:
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 31e107c81e2d..f8e60be631ca 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -1301,7 +1301,7 @@ int wil_p2p_search(struct wil6210_vif *vif,
 		   struct cfg80211_scan_request *request);
 int wil_p2p_listen(struct wil6210_priv *wil, struct wireless_dev *wdev,
 		   unsigned int duration, struct ieee80211_channel *chan,
-		   u64 *cookie);
+		   u64 cookie);
 u8 wil_p2p_stop_discovery(struct wil6210_vif *vif);
 int wil_p2p_cancel_listen(struct wil6210_vif *vif, u64 cookie);
 void wil_p2p_listen_expired(struct work_struct *work);
@@ -1317,7 +1317,7 @@ int wmi_stop_discovery(struct wil6210_vif *vif);
 
 int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 struct cfg80211_mgmt_tx_params *params,
-			 u64 *cookie);
+			 u64 cookie);
 void wil_cfg80211_ap_recovery(struct wil6210_priv *wil);
 int wil_cfg80211_iface_combinations_from_fw(
 	struct wil6210_priv *wil,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 03a7a4c18279..872c48806d09 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5554,7 +5554,7 @@ brcmf_cfg80211_update_mgmt_frame_registrations(struct wiphy *wiphy,
 
 int
 brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
-		       struct cfg80211_mgmt_tx_params *params, u64 *cookie)
+		       struct cfg80211_mgmt_tx_params *params, u64 cookie)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct ieee80211_channel *chan = params->chan;
@@ -5603,7 +5603,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 					    BRCMF_VNDR_IE_PRBRSP_FLAG,
 					    &buf[ie_offset],
 					    ie_len);
-		cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, true,
+		cfg80211_mgmt_tx_status(wdev, cookie, buf, len, true,
 					GFP_KERNEL);
 	} else if (ieee80211_is_action(mgmt->frame_control)) {
 		if (len > BRCMF_FIL_ACTION_FRAME_SIZE + DOT11_MGMT_HDR_LEN) {
@@ -5619,7 +5619,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		}
 		action_frame = &af_params->action_frame;
 		/* Add the packet Id */
-		action_frame->packet_id = cpu_to_le32(*cookie);
+		action_frame->packet_id = cpu_to_le32(cookie);
 		/* Add BSSID */
 		memcpy(&action_frame->da[0], &mgmt->da[0], ETH_ALEN);
 		memcpy(&af_params->bssid[0], &mgmt->bssid[0], ETH_ALEN);
@@ -5647,12 +5647,12 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		       le16_to_cpu(action_frame->len));
 
 		brcmf_dbg(TRACE, "Action frame, cookie=%lld, len=%d, channel=%d\n",
-			  *cookie, le16_to_cpu(action_frame->len),
+			  cookie, le16_to_cpu(action_frame->len),
 			  le32_to_cpu(af_params->channel));
 
 		ack = brcmf_p2p_send_action_frame(vif->ifp, af_params);
 
-		cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, ack,
+		cfg80211_mgmt_tx_status(wdev, cookie, buf, len, ack,
 					GFP_KERNEL);
 free:
 		kfree(af_params);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 6ceb30142905..63e534523f51 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -497,6 +497,6 @@ void brcmf_cfg80211_free_vif(struct net_device *ndev);
 
 int brcmf_set_wsec(struct brcmf_if *ifp, const u8 *key, u16 key_len, u16 flags);
 int brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
-			   struct cfg80211_mgmt_tx_params *params, u64 *cookie);
+			   struct cfg80211_mgmt_tx_params *params, u64 cookie);
 
 #endif /* BRCMFMAC_CFG80211_H */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
index 5c7a475cb5e5..545eb9aae966 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
@@ -100,7 +100,7 @@ static int brcmf_cyw_activate_events(struct brcmf_if *ifp)
 
 static
 int brcmf_cyw_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
-		      struct cfg80211_mgmt_tx_params *params, u64 *cookie)
+		      struct cfg80211_mgmt_tx_params *params, u64 cookie)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct ieee80211_channel *chan = params->chan;
@@ -154,7 +154,7 @@ int brcmf_cyw_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	memcpy(&mf_params->da[0], &mgmt->da[0], ETH_ALEN);
 	memcpy(&mf_params->bssid[0], &mgmt->bssid[0], ETH_ALEN);
-	mf_params->packet_id = cpu_to_le32(*cookie);
+	mf_params->packet_id = cpu_to_le32(cookie);
 	memcpy(mf_params->data, &buf[DOT11_MGMT_HDR_LEN],
 	       le16_to_cpu(mf_params->len));
 
@@ -186,8 +186,7 @@ int brcmf_cyw_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	}
 
 tx_status:
-	cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, ack,
-				GFP_KERNEL);
+	cfg80211_mgmt_tx_status(wdev, cookie, buf, len, ack, GFP_KERNEL);
 free:
 	kfree(mf_params);
 	return err;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 3d7bf25f1985..32a015d6b769 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -998,7 +998,7 @@ brcmf_p2p_discover_listen(struct brcmf_p2p_info *p2p, u16 channel, u32 duration)
  */
 int brcmf_p2p_remain_on_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 				struct ieee80211_channel *channel,
-				unsigned int duration, u64 *cookie,
+				unsigned int duration, u64 cookie,
 				const u8 *rx_addr)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
@@ -1018,8 +1018,8 @@ int brcmf_p2p_remain_on_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 		goto exit;
 
 	memcpy(&p2p->remain_on_channel, channel, sizeof(*channel));
-	p2p->remain_on_channel_cookie = *cookie;
-	cfg80211_ready_on_channel(wdev, *cookie, channel, duration, GFP_KERNEL);
+	p2p->remain_on_channel_cookie = cookie;
+	cfg80211_ready_on_channel(wdev, cookie, channel, duration, GFP_KERNEL);
 
 exit:
 	return err;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h
index 9f3f01ade2b7..707800949170 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h
@@ -157,7 +157,7 @@ int brcmf_p2p_scan_prep(struct wiphy *wiphy,
 			struct brcmf_cfg80211_vif *vif);
 int brcmf_p2p_remain_on_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 				struct ieee80211_channel *channel,
-				unsigned int duration, u64 *cookie,
+				unsigned int duration, u64 cookie,
 				const u8 *rx_addr);
 int brcmf_p2p_notify_listen_complete(struct brcmf_if *ifp,
 				     const struct brcmf_event_msg *e,
diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 102321cf8542..7a1ba32f1fb3 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -196,7 +196,7 @@ mwifiex_form_mgmt_frame(struct sk_buff *skb, const u8 *buf, size_t len)
  */
 static int
 mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
-			 struct cfg80211_mgmt_tx_params *params, u64 *cookie)
+			 struct cfg80211_mgmt_tx_params *params, u64 cookie)
 {
 	const u8 *buf = params->buf;
 	size_t len = params->len;
@@ -263,9 +263,9 @@ mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	if (ieee80211_is_action(mgmt->frame_control))
 		skb = mwifiex_clone_skb_for_tx_status(priv,
 						      skb,
-				MWIFIEX_BUF_FLAG_ACTION_TX_STATUS, cookie);
+				MWIFIEX_BUF_FLAG_ACTION_TX_STATUS, &cookie);
 	else
-		cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, true,
+		cfg80211_mgmt_tx_status(wdev, cookie, buf, len, true,
 					GFP_ATOMIC);
 
 	mwifiex_queue_tx_pkt(priv, skb);
@@ -303,13 +303,13 @@ static int
 mwifiex_cfg80211_remain_on_channel(struct wiphy *wiphy,
 				   struct wireless_dev *wdev,
 				   struct ieee80211_channel *chan,
-				   unsigned int duration, u64 *cookie,
+				   unsigned int duration, u64 cookie,
 				   const u8 *rx_addr)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
 	int ret;
 
-	if (!chan || !cookie) {
+	if (!chan) {
 		mwifiex_dbg(priv->adapter, ERROR, "Invalid parameter for ROC\n");
 		return -EINVAL;
 	}
@@ -325,14 +325,14 @@ mwifiex_cfg80211_remain_on_channel(struct wiphy *wiphy,
 					 duration);
 
 	if (!ret) {
-		priv->roc_cfg.cookie = *cookie;
+		priv->roc_cfg.cookie = cookie;
 		priv->roc_cfg.chan = *chan;
 
-		cfg80211_ready_on_channel(wdev, *cookie, chan,
+		cfg80211_ready_on_channel(wdev, cookie, chan,
 					  duration, GFP_ATOMIC);
 
 		mwifiex_dbg(priv->adapter, INFO,
-			    "info: ROC, cookie = 0x%llx\n", *cookie);
+			    "info: ROC, cookie = 0x%llx\n", cookie);
 	}
 
 	return ret;
@@ -4558,7 +4558,7 @@ mwifiex_cfg80211_disassociate(struct wiphy *wiphy,
 static int
 mwifiex_cfg80211_probe_peer(struct wiphy *wiphy,
 			    struct net_device *dev, const u8 *peer,
-			    u64 *cookie)
+			    u64 cookie)
 {
 	/* hostapd looks for NL80211_CMD_PROBE_CLIENT support; otherwise,
 	 * it requires monitor-mode support (which mwifiex doesn't support).
diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
index 7c19ad34fda5..bb2748a19329 100644
--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -1100,7 +1100,7 @@ static void wilc_wfi_remain_on_channel_expired(struct wilc_vif *vif, u64 cookie)
 static int remain_on_channel(struct wiphy *wiphy,
 			     struct wireless_dev *wdev,
 			     struct ieee80211_channel *chan,
-			     unsigned int duration, u64 *cookie,
+			     unsigned int duration, u64 cookie,
 			     const u8 *rx_addr)
 {
 	int ret = 0;
@@ -1112,7 +1112,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 		return ret;
 	}
 
-	ret = wilc_remain_on_channel(vif, *cookie, chan->hw_value,
+	ret = wilc_remain_on_channel(vif, cookie, chan->hw_value,
 				     wilc_wfi_remain_on_channel_expired);
 	if (ret)
 		return ret;
@@ -1120,11 +1120,11 @@ static int remain_on_channel(struct wiphy *wiphy,
 	vif->wilc->op_ch = chan->hw_value;
 
 	priv->remain_on_ch_params.listen_ch = chan;
-	priv->remain_on_ch_params.listen_cookie = *cookie;
+	priv->remain_on_ch_params.listen_cookie = cookie;
 	priv->p2p_listen_state = true;
 	priv->remain_on_ch_params.listen_duration = duration;
 
-	cfg80211_ready_on_channel(wdev, *cookie, chan, duration, GFP_KERNEL);
+	cfg80211_ready_on_channel(wdev, cookie, chan, duration, GFP_KERNEL);
 	mod_timer(&vif->hif_drv->remain_on_ch_timer,
 		  jiffies + msecs_to_jiffies(duration + 1000));
 
@@ -1147,7 +1147,7 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
 static int mgmt_tx(struct wiphy *wiphy,
 		   struct wireless_dev *wdev,
 		   struct cfg80211_mgmt_tx_params *params,
-		   u64 *cookie)
+		   u64 cookie)
 {
 	struct ieee80211_channel *chan = params->chan;
 	unsigned int wait = params->wait;
@@ -1164,7 +1164,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 	const u8 *vendor_ie;
 	int ret = 0;
 
-	priv->tx_cookie = *cookie;
+	priv->tx_cookie = cookie;
 	mgmt = (const struct ieee80211_mgmt *)buf;
 
 	if (!ieee80211_is_mgmt(mgmt->frame_control))
diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index 198174ac754e..c820f08d2835 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -150,7 +150,7 @@ nxpwifi_form_mgmt_frame(struct sk_buff *skb, const u8 *buf, size_t len)
 /* cfg80211 operation handler to transmit a management frame. */
 static int
 nxpwifi_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
-			 struct cfg80211_mgmt_tx_params *params, u64 *cookie)
+			 struct cfg80211_mgmt_tx_params *params, u64 cookie)
 {
 	const u8 *buf = params->buf;
 	size_t len = params->len;
@@ -216,9 +216,9 @@ nxpwifi_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	if (ieee80211_is_action(mgmt->frame_control))
 		skb = nxpwifi_clone_skb_for_tx_status(priv,
 						      skb,
-				NXPWIFI_BUF_FLAG_ACTION_TX_STATUS, cookie);
+				NXPWIFI_BUF_FLAG_ACTION_TX_STATUS, &cookie);
 	else
-		cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, true,
+		cfg80211_mgmt_tx_status(wdev, cookie, buf, len, true,
 					GFP_ATOMIC);
 
 	nxpwifi_queue_tx_pkt(priv, skb);
@@ -253,14 +253,14 @@ static int
 nxpwifi_cfg80211_remain_on_channel(struct wiphy *wiphy,
 				   struct wireless_dev *wdev,
 				   struct ieee80211_channel *chan,
-				   unsigned int duration, u64 *cookie,
+				   unsigned int duration, u64 cookie,
 				   const u8 *rx_addr)
 {
 	struct nxpwifi_private *priv = nxpwifi_netdev_get_priv(wdev->netdev);
 	struct nxpwifi_adapter *adapter = priv->adapter;
 	int ret;
 
-	if (!chan || !cookie) {
+	if (!chan) {
 		nxpwifi_dbg(adapter, ERROR, "Invalid parameter for ROC\n");
 		return -EINVAL;
 	}
@@ -276,14 +276,14 @@ nxpwifi_cfg80211_remain_on_channel(struct wiphy *wiphy,
 					 duration);
 
 	if (!ret) {
-		priv->roc_cfg.cookie = *cookie;
+		priv->roc_cfg.cookie = cookie;
 		priv->roc_cfg.chan = *chan;
 
-		cfg80211_ready_on_channel(wdev, *cookie, chan,
+		cfg80211_ready_on_channel(wdev, cookie, chan,
 					  duration, GFP_ATOMIC);
 
 		nxpwifi_dbg(adapter, INFO,
-			    "info: ROC, cookie = 0x%llx\n", *cookie);
+			    "info: ROC, cookie = 0x%llx\n", cookie);
 	}
 
 	return ret;
@@ -3616,7 +3616,7 @@ nxpwifi_cfg80211_disassociate(struct wiphy *wiphy,
 static int
 nxpwifi_cfg80211_probe_peer(struct wiphy *wiphy,
 			      struct net_device *dev, const u8 *peer,
-			      u64 *cookie)
+			      u64 cookie)
 {
 	/*
 	 * hostapd looks for NL80211_CMD_PROBE_CLIENT support; otherwise,
diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 284bc61c46d0..45e2b7ae9633 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -446,7 +446,7 @@ qtnf_update_mgmt_frame_registrations(struct wiphy *wiphy,
 
 static int
 qtnf_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
-	     struct cfg80211_mgmt_tx_params *params, u64 *cookie)
+	     struct cfg80211_mgmt_tx_params *params, u64 cookie)
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(wdev->netdev);
 	const struct ieee80211_mgmt *mgmt_frame = (void *)params->buf;
diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index 0e6b40336123..b58dda129ff6 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -2530,7 +2530,7 @@ static int _cfg80211_rtw_mgmt_tx(struct adapter *padapter, u8 tx_ch, const u8 *b
 
 static int cfg80211_rtw_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 				struct cfg80211_mgmt_tx_params *params,
-				u64 *cookie)
+				u64 cookie)
 {
 	struct net_device *ndev = wdev_to_ndev(wdev);
 	struct ieee80211_channel *chan = params->chan;
@@ -2553,7 +2553,7 @@ static int cfg80211_rtw_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	padapter = rtw_netdev_priv(ndev);
 
 	/* indicate ack before issue frame to avoid racing with rsp frame */
-	rtw_cfg80211_mgmt_tx_status(padapter, *cookie, buf, len, ack, GFP_KERNEL);
+	rtw_cfg80211_mgmt_tx_status(padapter, cookie, buf, len, ack, GFP_KERNEL);
 
 	if (!rtw_action_frame_parse(buf, len, &category, &action))
 		goto exit;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ee395e3a021a..74e267f72c19 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5458,14 +5458,14 @@ struct cfg80211_ops {
 				     struct wireless_dev *wdev,
 				     struct ieee80211_channel *chan,
 				     unsigned int duration,
-				     u64 *cookie, const u8 *rx_addr);
+				     u64 cookie, const u8 *rx_addr);
 	int	(*cancel_remain_on_channel)(struct wiphy *wiphy,
 					    struct wireless_dev *wdev,
 					    u64 cookie);
 
 	int	(*mgmt_tx)(struct wiphy *wiphy, struct wireless_dev *wdev,
 			   struct cfg80211_mgmt_tx_params *params,
-			   u64 *cookie);
+			   u64 cookie);
 	int	(*mgmt_tx_cancel_wait)(struct wiphy *wiphy,
 				       struct wireless_dev *wdev,
 				       u64 cookie);
@@ -5512,7 +5512,7 @@ struct cfg80211_ops {
 			     const u8 *peer, enum nl80211_tdls_operation oper);
 
 	int	(*probe_peer)(struct wiphy *wiphy, struct net_device *dev,
-			      const u8 *peer, u64 *cookie);
+			      const u8 *peer, u64 cookie);
 
 	int	(*set_noack_map)(struct wiphy *wiphy,
 				  struct net_device *dev,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b6d02d2b28f5..0c2c7afd59c4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -4940,7 +4940,7 @@ static int ieee80211_set_rekey_data(struct wiphy *wiphy,
 }
 
 static int ieee80211_probe_peer(struct wiphy *wiphy, struct net_device *dev,
-				const u8 *peer, u64 *cookie)
+				const u8 *peer, u64 cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -5047,7 +5047,7 @@ static int ieee80211_probe_peer(struct wiphy *wiphy, struct net_device *dev,
 	if (qos)
 		nullfunc->qos_ctrl = cpu_to_le16(7);
 
-	ret = ieee80211_attach_ack_skb(local, skb, cookie, GFP_ATOMIC);
+	ret = ieee80211_attach_ack_skb(local, skb, &cookie, GFP_ATOMIC);
 	if (ret) {
 		kfree_skb(skb);
 		return ret;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3760319ab079..d74da4e9ebf3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2150,12 +2150,12 @@ void ieee80211_roc_purge(struct ieee80211_local *local,
 			 struct ieee80211_sub_if_data *sdata);
 int ieee80211_remain_on_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 				struct ieee80211_channel *chan,
-				unsigned int duration, u64 *cookie,
+				unsigned int duration, u64 cookie,
 				const u8 *rx_addr);
 int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
 				       struct wireless_dev *wdev, u64 cookie);
 int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
-		      struct cfg80211_mgmt_tx_params *params, u64 *cookie);
+		      struct cfg80211_mgmt_tx_params *params, u64 cookie);
 int ieee80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
 				  struct wireless_dev *wdev, u64 cookie);
 
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 94be6497f259..7acef80d5f1f 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -702,7 +702,7 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 
 int ieee80211_remain_on_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 				struct ieee80211_channel *chan,
-				unsigned int duration, u64 *cookie,
+				unsigned int duration, u64 cookie,
 				const u8 *rx_addr)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
@@ -711,7 +711,7 @@ int ieee80211_remain_on_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 	lockdep_assert_wiphy(local->hw.wiphy);
 
 	return ieee80211_start_roc_work(local, sdata, chan,
-					duration, cookie, NULL,
+					duration, &cookie, NULL,
 					IEEE80211_ROC_TYPE_NORMAL);
 }
 
@@ -808,7 +808,7 @@ int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
 }
 
 int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
-		      struct cfg80211_mgmt_tx_params *params, u64 *cookie)
+		      struct cfg80211_mgmt_tx_params *params, u64 cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 	struct ieee80211_local *local = sdata->local;
@@ -1014,7 +1014,7 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		/* make a copy to preserve the frame contents
 		 * in case of encryption.
 		 */
-		ret = ieee80211_attach_ack_skb(local, skb, cookie, GFP_KERNEL);
+		ret = ieee80211_attach_ack_skb(local, skb, &cookie, GFP_KERNEL);
 		if (ret) {
 			kfree_skb(skb);
 			goto out_unlock;
@@ -1035,7 +1035,7 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	/* This will handle all kinds of coalescing and immediate TX */
 	ret = ieee80211_start_roc_work(local, sdata, params->chan,
-				       params->wait, cookie, skb,
+				       params->wait, &cookie, skb,
 				       IEEE80211_ROC_TYPE_MGMT_TX);
 	if (ret)
 		ieee80211_free_txskb(&local->hw, skb);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 15d9f7eb58b4..b4610f6685dc 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -402,7 +402,7 @@ void cfg80211_mlme_purge_registrations(struct wireless_dev *wdev);
 int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  struct wireless_dev *wdev,
 			  struct cfg80211_mgmt_tx_params *params,
-			  u64 *cookie);
+			  u64 cookie);
 void cfg80211_oper_and_ht_capa(struct ieee80211_ht_cap *ht_capa,
 			       const struct ieee80211_ht_cap *ht_capa_mask);
 void cfg80211_oper_and_vht_capa(struct ieee80211_vht_cap *vht_capa,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 7824b7ac2770..a0d1cde26f0c 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -894,7 +894,7 @@ static bool cfg80211_allowed_random_address(struct wireless_dev *wdev,
 
 int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  struct wireless_dev *wdev,
-			  struct cfg80211_mgmt_tx_params *params, u64 *cookie)
+			  struct cfg80211_mgmt_tx_params *params, u64 cookie)
 {
 	const struct ieee80211_mgmt *mgmt;
 	u16 stype;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6ad1f9cf2dda..8a46101bfdd0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14644,7 +14644,7 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 
 	cookie = cfg80211_assign_cookie(rdev);
 	err = rdev_remain_on_channel(rdev, wdev, chandef.chan,
-				     duration, &cookie, rx_addr);
+				     duration, cookie, rx_addr);
 
 	if (err)
 		goto free_msg;
@@ -14885,7 +14885,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 
 	params.chan = chandef.chan;
 	cookie = cfg80211_assign_cookie(rdev);
-	err = cfg80211_mlme_mgmt_tx(rdev, wdev, &params, &cookie);
+	err = cfg80211_mlme_mgmt_tx(rdev, wdev, &params, cookie);
 	if (err)
 		goto free_msg;
 
@@ -16374,7 +16374,7 @@ static int nl80211_probe_peer(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	cookie = cfg80211_assign_cookie(rdev);
-	err = rdev_probe_peer(rdev, dev, addr, &cookie);
+	err = rdev_probe_peer(rdev, dev, addr, cookie);
 	if (err)
 		goto free_msg;
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 6c3bad8b2d6f..c46e97c90fdc 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -736,14 +736,14 @@ static inline int
 rdev_remain_on_channel(struct cfg80211_registered_device *rdev,
 		       struct wireless_dev *wdev,
 		       struct ieee80211_channel *chan,
-		       unsigned int duration, u64 *cookie, const u8 *rx_addr)
+		       unsigned int duration, u64 cookie, const u8 *rx_addr)
 {
 	int ret;
 	trace_rdev_remain_on_channel(&rdev->wiphy, wdev, chan, duration,
 				     rx_addr);
 	ret = rdev->ops->remain_on_channel(&rdev->wiphy, wdev, chan,
 					   duration, cookie, rx_addr);
-	trace_rdev_return_int_cookie(&rdev->wiphy, ret, *cookie);
+	trace_rdev_return_int_cookie(&rdev->wiphy, ret, cookie);
 	return ret;
 }
 
@@ -761,12 +761,12 @@ rdev_cancel_remain_on_channel(struct cfg80211_registered_device *rdev,
 static inline int rdev_mgmt_tx(struct cfg80211_registered_device *rdev,
 			       struct wireless_dev *wdev,
 			       struct cfg80211_mgmt_tx_params *params,
-			       u64 *cookie)
+			       u64 cookie)
 {
 	int ret;
 	trace_rdev_mgmt_tx(&rdev->wiphy, wdev, params);
 	ret = rdev->ops->mgmt_tx(&rdev->wiphy, wdev, params, cookie);
-	trace_rdev_return_int_cookie(&rdev->wiphy, ret, *cookie);
+	trace_rdev_return_int_cookie(&rdev->wiphy, ret, cookie);
 	return ret;
 }
 
@@ -950,12 +950,12 @@ static inline int rdev_tdls_oper(struct cfg80211_registered_device *rdev,
 
 static inline int rdev_probe_peer(struct cfg80211_registered_device *rdev,
 				  struct net_device *dev, const u8 *peer,
-				  u64 *cookie)
+				  u64 cookie)
 {
 	int ret;
 	trace_rdev_probe_peer(&rdev->wiphy, dev, peer);
 	ret = rdev->ops->probe_peer(&rdev->wiphy, dev, peer, cookie);
-	trace_rdev_return_int_cookie(&rdev->wiphy, ret, *cookie);
+	trace_rdev_return_int_cookie(&rdev->wiphy, ret, cookie);
 	return ret;
 }
 
-- 
2.54.0

