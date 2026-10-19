Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9EC340A7F;
	Mon, 19 Oct 2026 01:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792373571; cv=none; b=VrZbLrdIGuBEsIcjCGXWwdaJYoDVQ/sWzEQDW0CyFNK66leK4G7F9XDUXoRI8ZU1Ur14SKUI5mr+Kli1tjejljY9l7/cwN5Sx5w2l47ewEZ3/FyRih8wxPwda44dnAMgDggmTCBimEEzp48WlufQsLiYKG4+ct9Z6XKbM0lTOsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792373571; c=relaxed/simple;
	bh=B8X1he2DFceeSbMn0r4UVQQET3xXXGrrY5D6tulfmRw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RnnX+84rQs673/HQkgq7T/N/lQ9QMeXi1m4t72Y45NtIDTviZWevkBklLlJSBkRtGIUwhD8eJsGiJ1JB6dtRODQweo4PVksSJV8rv1ZpXGeZJEQKuDT2myaAoHtAJt0RQgbi3nDbZUob0j1HAVbwWuvqoWq3sFZUAtujP2XovEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=M60pe/VF; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="M60pe/VF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=XS
	pRY0TbqAVNgur9Ad6ZwZu/FMFS6D8VxJNRGkZYXmc=; b=M60pe/VFRA6r+F4sXX
	H7w4qQGxzefgIpOMKRv3qV6pld3P5uElcHnSUJZSLsRBy3lnPefkHG2otOgMOz2Z
	s7UaY9kVZf8y2pSXia/8FvAAPX1BPjtxIScnSN9/DVLwCnr/+eJutVOmJWZiuvIL
	3rBBWlao4rMVJjnNIQv2CH6Ls=
Received: from pc.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgB3sQgpc9VqLZuVAg--.15458S4;
	Mon, 19 Oct 2026 09:32:30 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 2/2] wifi: wlcore: unwind failed interface additions
Date: Mon, 19 Oct 2026 09:32:24 +0800
Message-Id: <20261019013224.1489500-3-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019013224.1489500-1-yaojiale02@163.com>
References: <20261019013224.1489500-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgB3sQgpc9VqLZuVAg--.15458S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxtr4rZw4kCry8CF4DKF15urg_yoW7AF15pF
	4UKFWYyF1DtF4UCFW5JFnrX3sYkay8C3yjkFykC34jy3Z0k340gF1IyrZrZFW8CFWkJFWa
	93WqqF45GFy7K37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zR1xRgUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzQ73MmrVcy4BZAAA3B

wl12xx_init_vif_data() allocates per-interface host resources before
firmware setup. Later failures return without releasing those resources,
and failures after role enablement also leave the firmware role active
because mac80211 does not call remove_interface.

Factor the per-vif resource release into a helper, use it from removal
and add failure paths, and disable an enabled role when subsequent
initialization fails.

Fixes: 2f01a1f58889 ("wl12xx: add driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 66 +++++++++++++++++----------
 1 file changed, 42 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 26aabf4ea127..9a0350b9d280 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2374,6 +2374,30 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 	return 0;
 }
 
+static void wl12xx_deinit_vif_data(struct wl1271 *wl,
+				   struct wl12xx_vif *wlvif)
+{
+	int i;
+
+	if (wlvif->bss_type == BSS_TYPE_STA_BSS ||
+	    wlvif->bss_type == BSS_TYPE_IBSS) {
+		wlvif->sta.hlid = WL12XX_INVALID_LINK_ID;
+		wl12xx_free_rate_policy(wl, &wlvif->sta.basic_rate_idx);
+		wl12xx_free_rate_policy(wl, &wlvif->sta.ap_rate_idx);
+		wl12xx_free_rate_policy(wl, &wlvif->sta.p2p_rate_idx);
+		wlcore_free_klv_template(wl, &wlvif->sta.klv_template_id);
+	} else {
+		wlvif->ap.bcast_hlid = WL12XX_INVALID_LINK_ID;
+		wlvif->ap.global_hlid = WL12XX_INVALID_LINK_ID;
+		wl12xx_free_rate_policy(wl, &wlvif->ap.mgmt_rate_idx);
+		wl12xx_free_rate_policy(wl, &wlvif->ap.bcast_rate_idx);
+		for (i = 0; i < CONF_TX_MAX_AC_COUNT; i++)
+			wl12xx_free_rate_policy(wl,
+						&wlvif->ap.ucast_rate_idx[i]);
+		wl1271_free_ap_keys(wl, wlvif);
+	}
+}
+
 static int wl12xx_init_fw(struct wl1271 *wl)
 {
 	struct wlcore_platdev_data *pdev_data = dev_get_platdata(&wl->pdev->dev);
@@ -2633,12 +2657,12 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	role_type = wl12xx_get_role_type(wl, wlvif);
 	if (role_type == WL12XX_INVALID_ROLE_TYPE) {
 		ret = -EINVAL;
-		goto out_unlock;
+		goto out_deinit;
 	}
 
 	ret = wlcore_allocate_hw_queue_base(wl, wlvif);
 	if (ret < 0)
-		goto out_unlock;
+		goto out_deinit;
 
 	/*
 	 * TODO: after the nvs issue will be solved, move this block
@@ -2653,7 +2677,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 
 		ret = wl12xx_init_fw(wl);
 		if (ret < 0)
-			goto out_unlock;
+			goto out_deinit;
 	}
 
 	/*
@@ -2662,7 +2686,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	 */
 	ret = pm_runtime_resume_and_get(wl->dev);
 	if (ret < 0)
-		goto out_unlock;
+		goto out_deinit;
 
 	if (wl12xx_need_fw_change(wl, vif_count, true)) {
 		wl12xx_force_active_psm(wl);
@@ -2680,7 +2704,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 
 		ret = wl1271_init_vif_specific(wl, vif);
 		if (ret < 0)
-			goto out;
+			goto out_disable_role;
 
 	} else {
 		ret = wl12xx_cmd_role_enable(wl, vif->addr, WL1271_ROLE_DEVICE,
@@ -2691,7 +2715,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		/* needed mainly for configuring rate policies */
 		ret = wl1271_sta_hw_init(wl, wlvif);
 		if (ret < 0)
-			goto out;
+			goto out_disable_role;
 	}
 
 	list_add(&wlvif->list, &wl->wlvif_list);
@@ -2701,8 +2725,18 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		wl->ap_count++;
 	else
 		wl->sta_count++;
+	goto out;
+
+out_disable_role:
+	if (!wlcore_is_p2p_mgmt(wlvif))
+		wl12xx_cmd_role_disable(wl, &wlvif->role_id);
+	else
+		wl12xx_cmd_role_disable(wl, &wlvif->dev_role_id);
 out:
 	pm_runtime_put_autosuspend(wl->dev);
+out_deinit:
+	if (ret)
+		wl12xx_deinit_vif_data(wl, wlvif);
 out_unlock:
 	mutex_unlock(&wl->mutex);
 
@@ -2714,7 +2748,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 					 bool reset_tx_queues)
 {
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
-	int i, ret;
+	int ret;
 	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
@@ -2789,23 +2823,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	/* clear all hlids (except system_hlid) */
 	wlvif->dev_hlid = WL12XX_INVALID_LINK_ID;
 
-	if (wlvif->bss_type == BSS_TYPE_STA_BSS ||
-	    wlvif->bss_type == BSS_TYPE_IBSS) {
-		wlvif->sta.hlid = WL12XX_INVALID_LINK_ID;
-		wl12xx_free_rate_policy(wl, &wlvif->sta.basic_rate_idx);
-		wl12xx_free_rate_policy(wl, &wlvif->sta.ap_rate_idx);
-		wl12xx_free_rate_policy(wl, &wlvif->sta.p2p_rate_idx);
-		wlcore_free_klv_template(wl, &wlvif->sta.klv_template_id);
-	} else {
-		wlvif->ap.bcast_hlid = WL12XX_INVALID_LINK_ID;
-		wlvif->ap.global_hlid = WL12XX_INVALID_LINK_ID;
-		wl12xx_free_rate_policy(wl, &wlvif->ap.mgmt_rate_idx);
-		wl12xx_free_rate_policy(wl, &wlvif->ap.bcast_rate_idx);
-		for (i = 0; i < CONF_TX_MAX_AC_COUNT; i++)
-			wl12xx_free_rate_policy(wl,
-						&wlvif->ap.ucast_rate_idx[i]);
-		wl1271_free_ap_keys(wl, wlvif);
-	}
+	wl12xx_deinit_vif_data(wl, wlvif);
 
 	dev_kfree_skb(wlvif->probereq);
 	wlvif->probereq = NULL;
-- 
2.34.1

