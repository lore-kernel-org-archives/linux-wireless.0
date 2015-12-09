Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:58341 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbbLIKWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 05:22:55 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 03/13] brcmfmac: Remove some redundant cfg80211 data.
Date: Wed, 9 Dec 2015 11:22:42 +0100
Message-ID: <1449656572-16158-4-git-send-email-arend@broadcom.com> (sfid-20151209_112310_608180_D5E3523F)
In-Reply-To: <1449656572-16158-1-git-send-email-arend@broadcom.com>
References: <1449656572-16158-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Change-Id: I99fb70fc03ea5c498f0fb12281b4c64d8e39e258
Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/5447
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |  1 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h | 10 ----------
 2 files changed, 11 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index b7b60f52..5432c46 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5203,7 +5203,6 @@ static void brcmf_init_conf(struct brcmf_cfg80211_conf *conf)
 	conf->rts_threshold = (u32)-1;
 	conf->retry_short = (u32)-1;
 	conf->retry_long = (u32)-1;
-	conf->tx_power = -1;
 }
 
 static void brcmf_register_event_handlers(struct brcmf_cfg80211_info *cfg)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index e77f137..ec8d1f8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -95,14 +95,6 @@ struct brcmf_cfg80211_conf {
 	u32 rts_threshold;
 	u32 retry_short;
 	u32 retry_long;
-	s32 tx_power;
-	struct ieee80211_channel channel;
-};
-
-/* basic structure of information element */
-struct brcmf_cfg80211_ie {
-	u16 offset;
-	u8 buf[WL_TLV_INFO_MAX];
 };
 
 /* security information with currently associated ap */
@@ -333,7 +325,6 @@ struct brcmf_cfg80211_vif_event {
  * @usr_sync: mainly for dongle up/down synchronization.
  * @bss_list: bss_list holding scanned ap information.
  * @bss_info: bss information for cfg80211 layer.
- * @ie: information element object for internal purpose.
  * @conn_info: association info.
  * @pmk_list: wpa2 pmk list.
  * @scan_status: scan activity on the dongle.
@@ -367,7 +358,6 @@ struct brcmf_cfg80211_info {
 	struct cfg80211_scan_request *scan_request;
 	struct mutex usr_sync;
 	struct wl_cfg80211_bss_info *bss_info;
-	struct brcmf_cfg80211_ie ie;
 	struct brcmf_cfg80211_connect_info conn_info;
 	struct brcmf_cfg80211_pmk_list *pmk_list;
 	unsigned long scan_status;
-- 
1.9.1

