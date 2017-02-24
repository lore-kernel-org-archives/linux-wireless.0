Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36022 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751121AbdBXRYg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 12:24:36 -0500
Received: by mail-lf0-f65.google.com with SMTP id p197so1896181lfp.3
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2017 09:24:35 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH RFC] brcmfmac: shutdown interfaces on PSM's watchdog fire
Date: Fri, 24 Feb 2017 18:24:23 +0100
Message-Id: <20170224172423.10980-1-zajec5@gmail.com> (sfid-20170224_182439_687089_8193CF09)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

When PSM's watchdog fires hardware / firmware is not operational. It
seems there isn't a way to restart firmware & reapply all settings so
instead shut all interfaces down. This is at least some signal for the
user things went wrong and allows reacting to it.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
This patch is RFC as I'm wondering if there is any other way to handle
such errors. I couldn't find anything except for that
cfg80211_shutdown_all_interfaces.

Unfortunately hostapd doesn't seem to react to this except for sth like:
Fri Feb 24 13:41:07 2017 daemon.notice hostapd: wlan0: INTERFACE-DISABLED

Shall we introduce some nl80211 even for such cases maybe?

Or maybe I'm totally wrong and there is some simple way for a driver to
request reconfiguration of all interfaces?
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 5 +++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c     | 4 ++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 10098b7586f3..520d397bb963 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6981,3 +6981,8 @@ void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
 	wl_deinit_priv(cfg);
 	brcmf_free_wiphy(cfg->wiphy);
 }
+
+void brcmf_cfg80211_shutdown(struct brcmf_cfg80211_info *cfg)
+{
+	cfg80211_shutdown_all_interfaces(cfg->wiphy);
+}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 8f19d95d4175..77dafe03bb31 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -385,6 +385,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 						  struct device *busdev,
 						  bool p2pdev_forced);
 void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg);
+void brcmf_cfg80211_shutdown(struct brcmf_cfg80211_info *cfg);
 s32 brcmf_cfg80211_up(struct net_device *ndev);
 s32 brcmf_cfg80211_down(struct net_device *ndev);
 enum nl80211_iftype brcmf_cfg80211_get_iftype(struct brcmf_if *ifp);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 2f2f3a5ad86a..c6c0f3e8ef00 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -753,6 +753,10 @@ static int brcmf_psm_watchdog_notify(struct brcmf_if *ifp,
 	if (err)
 		brcmf_err("Failed to get memory dump, %d\n", err);
 
+	brcmf_cfg80211_shutdown(ifp->drvr->config);
+
+	/* TODO: Stop the firmware */
+
 	return err;
 }
 
-- 
2.11.0
