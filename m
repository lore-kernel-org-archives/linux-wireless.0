Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:44887 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab0ALInb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 03:43:31 -0500
Subject: [PATCH PATCH v6 6/7] wl1251: create qos null data template
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	a.young.jason@gmail.com
Date: Tue, 12 Jan 2010 10:43:07 +0200
Message-ID: <20100112084307.27492.16781.stgit@tikku>
In-Reply-To: <20100112084059.27492.86738.stgit@tikku>
References: <20100112084059.27492.86738.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The qos null data template is needed for U-APSD.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 4e373f3..4cf3545 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -585,6 +585,27 @@ static int wl1251_build_null_data(struct wl1251 *wl)
 
 }
 
+static int wl1251_build_qos_null_data(struct wl1251 *wl)
+{
+	struct ieee80211_qos_hdr template;
+
+	memset(&template, 0, sizeof(template));
+
+	memcpy(template.addr1, wl->bssid, ETH_ALEN);
+	memcpy(template.addr2, wl->mac_addr, ETH_ALEN);
+	memcpy(template.addr3, wl->bssid, ETH_ALEN);
+
+	template.frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
+					     IEEE80211_STYPE_QOS_NULLFUNC |
+					     IEEE80211_FCTL_TODS);
+
+	/* FIXME: not sure what priority to use here */
+	template.qos_ctrl = cpu_to_le16(0);
+
+	return wl1251_cmd_template_set(wl, CMD_QOS_NULL_DATA, &template,
+				       sizeof(template));
+}
+
 static int wl1251_build_ps_poll(struct wl1251 *wl, u16 aid)
 {
 	struct wl12xx_ps_poll_template template;
@@ -1119,6 +1140,10 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 		if (ret < 0)
 			goto out;
 
+		ret = wl1251_build_qos_null_data(wl);
+		if (ret < 0)
+			goto out;
+
 		if (wl->bss_type != BSS_TYPE_IBSS) {
 			ret = wl1251_join(wl, wl->bss_type, wl->channel,
 					  wl->beacon_int, wl->dtim_period);

