Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:34317 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560Ab2DKJic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:38:32 -0400
Received: by lbom4 with SMTP id m4so826636lbo.39
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 02:38:30 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com, coelho@ti.com
Subject: [PATCH 16/16] wlcore/wl12xx: create per-chip-family private storage
Date: Wed, 11 Apr 2012 12:38:03 +0300
Message-Id: <1334137083-13490-17-git-send-email-coelho@ti.com> (sfid-20120411_113844_068014_FEA72CAA)
In-Reply-To: <1334137083-13490-1-git-send-email-coelho@ti.com>
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

This storage is allocated in wlcore_alloc_hw and freed in free_hw. The
size of the storage is determined by the low-level driver.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    6 +++++-
 drivers/net/wireless/ti/wlcore/main.c   |   13 ++++++++++++-
 drivers/net/wireless/ti/wlcore/wlcore.h |    5 ++++-
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index d24e49a..e05a1cf 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -655,12 +655,16 @@ static struct wlcore_ops wl12xx_ops = {
 	.get_mac	= wl12xx_get_mac,
 };
 
+struct wl12xx_priv {
+};
+
 static int __devinit wl12xx_probe(struct platform_device *pdev)
 {
 	struct wl1271 *wl;
 	struct ieee80211_hw *hw;
+	struct wl12xx_priv *priv;
 
-	hw = wlcore_alloc_hw();
+	hw = wlcore_alloc_hw(sizeof(*priv));
 	if (IS_ERR(hw)) {
 		wl1271_error("can't allocate hw");
 		return PTR_ERR(hw);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 5a20292..2e29baf 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5197,7 +5197,7 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 
 #define WL1271_DEFAULT_CHANNEL 0
 
-struct ieee80211_hw *wlcore_alloc_hw(void)
+struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size)
 {
 	struct ieee80211_hw *hw;
 	struct wl1271 *wl;
@@ -5216,6 +5216,13 @@ struct ieee80211_hw *wlcore_alloc_hw(void)
 	wl = hw->priv;
 	memset(wl, 0, sizeof(*wl));
 
+	wl->priv = kzalloc(priv_size, GFP_KERNEL);
+	if (!wl->priv) {
+		wl1271_error("could not alloc wl priv");
+		ret = -ENOMEM;
+		goto err_priv_alloc;
+	}
+
 	INIT_LIST_HEAD(&wl->wlvif_list);
 
 	wl->hw = hw;
@@ -5316,6 +5323,9 @@ err_wq:
 
 err_hw:
 	wl1271_debugfs_exit(wl);
+	kfree(wl->priv);
+
+err_priv_alloc:
 	ieee80211_free_hw(hw);
 
 err_hw_alloc:
@@ -5354,6 +5364,7 @@ int wlcore_free_hw(struct wl1271 *wl)
 	kfree(wl->tx_res_if);
 	destroy_workqueue(wl->freezable_wq);
 
+	kfree(wl->priv);
 	ieee80211_free_hw(wl->hw);
 
 	return 0;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 66c33b8..01ac091 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -300,11 +300,14 @@ struct wl1271 {
 	const char *plt_fw_name;
 	const char *sr_fw_name;
 	const char *mr_fw_name;
+
+	/* per-chip-family private structure */
+	void *priv;
 };
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
 int __devexit wlcore_remove(struct platform_device *pdev);
-struct ieee80211_hw *wlcore_alloc_hw(void);
+struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size);
 int wlcore_free_hw(struct wl1271 *wl);
 
 /* Firmware image load chunk size */
-- 
1.7.5.4

