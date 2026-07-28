Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB412BEFEF
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 14:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785249983; cv=none; b=W74iFqB5+Y5VkuE/kvpRx/QOj7fFryjy3vsJfHII+soUEDjKjge6/BXkBG+TOQa6lPOKpo7DJUL1tSZ/1V4G/7NnHfb1TJRg2do1NPCK7w92hUSsW0jsor3+2P1aVsNsaRGcH9h2NqCdLZXwc1SdrnPk9uWrxNMNSvu1MbYzDPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785249983; c=relaxed/simple;
	bh=ubbafyXkFVMrYmFMiwtYJbQVl8Iaz++cXYKUkKHpdFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpAQId9ApD8axHtGIF1Vbyaf9sJgzleA2JVgyss0qkC/k+WZkY+RD6blsq6+rznWzQqbtclC4hFp7SwIQ4Uf4ib0bFX3LfSkOMlOFJ1yt71mHNQ6xR8FfAJkhYOh4Y06z4rNJCngTmQODMZKkNTppfuXY/L7lIHuc2mG8xMkPf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=E9DsU9pJ; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="E9DsU9pJ"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2cf6d65d8a7so57809765ad.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785249981; x=1785854781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EpzH9I6y+BQT0A98VPUW5xsvx465IMTaO7ST47V1XuE=;
        b=CmCzYUxTcF43vn3mKLjjvVecazFmWHXSZ0u6IqBXf3S3avvdqTGfKNgFq75dwupOWb
         +LAdkHDCDTptQM4Mmh5NfSjYbqHSHWCvygwyWiZ0K3QWyuwFDKtWe50JEtGHWLvlriOf
         d4iBY/7hq5npPmogdH1ejSW0skWDoLkVDtd+nW52HhivIKIeUNbkpqsXIyBFZS4dnK5q
         igRgwd+u4CECwBU0huRwqOCiBenndX2pjKTx7mIqE51mBhGjCZfusIzZ6bUxAVryKvYK
         nfNNc45VtJUAiPB3ei6Q0VJeqYQerrBvZr4N2ySq68JnuAP/xHEhQsQgX4Bb8dvCnr/W
         xnlA==
X-Gm-Message-State: AOJu0Yy6iuAV/4mQvT8lrp70iQFPpqkWv/imIUSoo9h/GRdH9avABwdg
	Sw2uRGBjZKx0gdhQFGWg3Uce/4vVGhQtDOW6Vku/5+wpHl8T0W10wGdsNhiuTc7/okqhtjvQThp
	aj64eVjyza+HHDnNUJbv0Ic/+kYUgtw31DVvZ7fVMI6G9tdUpRnDvnaqAHCNKy/r34YNgsYy/6m
	+yv2QJEd4qPKvZ/lQVbzfSFc/+qLX9jQ5zR94xm3vMONbS9HFcKMa/nw6XeBqZJmBXvPUNybSd2
	7GL4kvgEvUJkgYPaSxosDBnFYio
X-Gm-Gg: AR+sD105AitY0ko9tKf7jxtwmsqqe1sMRZeWdcNQbR80yvbKeyVtexmh7nmryH1lPwd
	6exQwLHmupQCgtfw/5yVpcwgd0UY4z/PfJy3e4RcSAqtkqAZD36AwJqz/Rru2mD6Dpe/kI6OK0D
	Vfteh49BdYkObYxrYPhCTUmlocC05v7FG0Tz7wYKHsk8aLc2IrCsoFgPWT3YGcMipFbGD/MY9hP
	EwLdpXNxB9JsXQ6m11ptOLkSlJTcQXMK417AyQn3lMK7gRS0kPHqDjzYKyvNJ960cI/U6Mel7/K
	RHra3P73lRA6GznCUtDFjhIgE3kpiGbXoqSx9bR+UOjvm8hwtoL2u+QUif13BWELs1vT6YyVCSv
	747+zhB2ifGEFuLYOSuYwhhaP6pSj8nTOrn/Hz9xmDJC8B1/HezmamdC7oKGTc+Md+Z3aPf1HHs
	nhRttLj595VbJCiB7r2VYxEEGtuLuw3UU1obNx3HY=
X-Received: by 2002:a17:903:1b4c:b0:2c7:1200:bd7e with SMTP id d9443c01a7336-2d015d38f0bmr30182245ad.18.1785249980802;
        Tue, 28 Jul 2026 07:46:20 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2cfde58bd93sm10931655ad.1.2026.07.28.07.46.20
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2026 07:46:20 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93106d8affcso336510985a.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785249979; x=1785854779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EpzH9I6y+BQT0A98VPUW5xsvx465IMTaO7ST47V1XuE=;
        b=E9DsU9pJjB2UFX3FVdxzqGggrI3PKENoG9rDfttAfjlLRFkpz3JxWCLcwe6ZDG9Eyq
         vgwmvk6dsNMU5m3X3znWOu3LInnqGwUTVug7wm9KTCFM9uq4WbM5p60eJ+HIKmUMAFGh
         //2xDQCu0AASgIndeiXVSonMEcIDfQAuT/uVo=
X-Received: by 2002:a05:620a:4109:b0:930:b19a:9d5e with SMTP id af79cd13be357-93302641151mr255925785a.1.1785249978800;
        Tue, 28 Jul 2026 07:46:18 -0700 (PDT)
X-Received: by 2002:a05:620a:4109:b0:930:b19a:9d5e with SMTP id af79cd13be357-93302641151mr255919985a.1.1785249977987;
        Tue, 28 Jul 2026 07:46:17 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de519154sm878659685a.5.2026.07.28.07.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 07:46:16 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v2 10/12] wifi: cfg80211: convert cookie output to input parameter
Date: Tue, 28 Jul 2026 16:45:47 +0200
Message-ID: <20260728144549.2207061-11-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
References: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
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
 include/net/cfg80211.h                         |  6 +++---
 net/mac80211/cfg.c                             |  4 ++--
 net/mac80211/ieee80211_i.h                     |  4 ++--
 net/mac80211/offchannel.c                      | 10 +++++-----
 net/wireless/core.h                            |  2 +-
 net/wireless/mlme.c                            |  2 +-
 net/wireless/nl80211.c                         |  6 +++---
 net/wireless/rdev-ops.h                        | 12 ++++++------
 22 files changed, 77 insertions(+), 78 deletions(-)

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
index 7e0368f6860e..8093724e6d22 100644
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
index f0f3a45d7cde..49b33efe22b4 100644
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
index 7f446a22a370..de9953ecbefd 100644
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
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d503648bb25b..7e2ef8f0e2e1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5457,14 +5457,14 @@ struct cfg80211_ops {
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
@@ -5511,7 +5511,7 @@ struct cfg80211_ops {
 			     const u8 *peer, enum nl80211_tdls_operation oper);
 
 	int	(*probe_peer)(struct wiphy *wiphy, struct net_device *dev,
-			      const u8 *peer, u64 *cookie);
+			      const u8 *peer, u64 cookie);
 
 	int	(*set_noack_map)(struct wiphy *wiphy,
 				  struct net_device *dev,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3f9954338707..310c14560065 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -4936,7 +4936,7 @@ static int ieee80211_set_rekey_data(struct wiphy *wiphy,
 }
 
 static int ieee80211_probe_peer(struct wiphy *wiphy, struct net_device *dev,
-				const u8 *peer, u64 *cookie)
+				const u8 *peer, u64 cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -5043,7 +5043,7 @@ static int ieee80211_probe_peer(struct wiphy *wiphy, struct net_device *dev,
 	if (qos)
 		nullfunc->qos_ctrl = cpu_to_le16(7);
 
-	ret = ieee80211_attach_ack_skb(local, skb, cookie, GFP_ATOMIC);
+	ret = ieee80211_attach_ack_skb(local, skb, &cookie, GFP_ATOMIC);
 	if (ret) {
 		kfree_skb(skb);
 		return ret;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a8ea55265f93..eecaaa2752db 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2148,12 +2148,12 @@ void ieee80211_roc_purge(struct ieee80211_local *local,
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
index 399037514943..b3ead98aee07 100644
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
index 2a2c173058ba..34f9003d5c54 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -851,7 +851,7 @@ static bool cfg80211_allowed_random_address(struct wireless_dev *wdev,
 
 int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  struct wireless_dev *wdev,
-			  struct cfg80211_mgmt_tx_params *params, u64 *cookie)
+			  struct cfg80211_mgmt_tx_params *params, u64 cookie)
 {
 	const struct ieee80211_mgmt *mgmt;
 	u16 stype;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bfb3005c23a7..cf2fece5a1e1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14632,7 +14632,7 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 
 	cookie = cfg80211_assign_cookie(rdev);
 	err = rdev_remain_on_channel(rdev, wdev, chandef.chan,
-				     duration, &cookie, rx_addr);
+				     duration, cookie, rx_addr);
 
 	if (err)
 		goto free_msg;
@@ -14873,7 +14873,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 
 	params.chan = chandef.chan;
 	cookie = cfg80211_assign_cookie(rdev);
-	err = cfg80211_mlme_mgmt_tx(rdev, wdev, &params, &cookie);
+	err = cfg80211_mlme_mgmt_tx(rdev, wdev, &params, cookie);
 	if (err)
 		goto free_msg;
 
@@ -16362,7 +16362,7 @@ static int nl80211_probe_peer(struct sk_buff *skb, struct genl_info *info)
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

