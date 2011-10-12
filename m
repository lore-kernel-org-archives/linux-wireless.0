Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42970 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab1JLBCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 21:02:51 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so235648bkb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 18:02:51 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless.vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 12 Oct 2011 03:02:48 +0200
Cc: "Bartosz MARKOWSKI" <bartosz.markowski@tieto.com>,
	"Janusz DZIEDZIC" <janusz.dziedzic@tieto.com>
Subject: [RFC 05/07] mac80211: Purge cfg80211 beacon cache before
 authentication.
MIME-Version: 1.0
From: "Dmitry Tarnyagin" <abi.dmitryt@gmail.com>
Message-ID: <op.v27ruyliya27un@edmitar> (sfid-20111012_030254_860153_C3D1FBFD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Date: Wed, 10 Aug 2011 19:15:13 +0200

cw1200 device requires SSID to be available at AUTH stage.
cfg80211 beacon cache is designed to handle multi-SSID BSSes, so
bss struct returned by cfg80211_get_bss() has random SSID if BSS
just changed SSID before authentication (typical for p2p).

As a workaround cfg80211 beacon cache is purged to make sure
target BSS is searchable in rb-tree at the AUTH stage.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
  net/mac80211/ieee80211_i.h |    1 +
  net/mac80211/mlme.c        |    1 +
  net/mac80211/work.c        |   22 ++++++++++++++++++++++
  3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 453bdb8..3dbaeb7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -325,6 +325,7 @@ struct ieee80211_work {
  			u8 key_len, key_idx;
  			bool privacy;
  			bool synced;
+			struct cfg80211_bss *bss;
  		} probe_auth;
  		struct {
  			struct cfg80211_bss *bss;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8c13619..dde286a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2562,6 +2562,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data  
*sdata,

  	wk->probe_auth.algorithm = auth_alg;
  	wk->probe_auth.privacy = req->bss->capability & WLAN_CAPABILITY_PRIVACY;
+	wk->probe_auth.bss = req->bss;

  	/* if we already have a probe, don't probe again */
  	if (req->bss->proberesp_ies)
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 8a93de7..4acf7ca 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -488,6 +488,28 @@ ieee80211_authenticate(struct ieee80211_work *wk)
  	struct ieee80211_sub_if_data *sdata = wk->sdata;
  	struct ieee80211_local *local = sdata->local;

+	/* At least one device requires SSID to be available at AUTH stage.
+	 * cfg80211 beacon cache is designed to handle multi-SSID BSSes, so
+	 * bss struct returned by cfg80211_get_bss() has random SSID if BSS
+	 * just changed SSID before authentication (it's typical for p2p).
+	 * As a workaround cfg80211 beacon cache is purged to make sure target
+	 * BSS is searchable in rb-tree at the AUTH stage.
+	 */
+	struct cfg80211_bss *bss;
+	while (true) {
+		bss = cfg80211_get_bss(local->hw.wiphy,
+				wk->probe_auth.bss->channel,
+				wk->probe_auth.bss->bssid,
+				NULL, 0, 0, 0);
+		if (WARN_ON(!bss))
+			break;
+		if (bss == wk->probe_auth.bss) {
+			cfg80211_put_bss(bss);
+			break;
+		}
+		cfg80211_unlink_bss(local->hw.wiphy, bss);
+	}
+
  	if (!wk->probe_auth.synced) {
  		int ret = drv_tx_sync(local, sdata, wk->filter_ta,
  				      IEEE80211_TX_SYNC_AUTH);
-- 
1.7.1
