Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:61844 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbZAFIuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 03:50:52 -0500
Received: by mail-ew0-f17.google.com with SMTP id 10so8320605ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 00:50:51 -0800 (PST)
Message-ID: <eb3ff54b0901060050q42b2883ew177df650e36bf1b9@mail.gmail.com> (sfid-20090106_095057_202154_F2DA7278)
Date: Tue, 6 Jan 2009 10:50:51 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 2/6] mac80211: remove an unused parameter in ieee80211_rx_mgmt_probe_req().
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes an unused parameter (rx_status) in
ieee80211_rx_mgmt_probe_req(),
in mlme.c.

(wireless-testing).

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e317c6d..439c301 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1848,8 +1848,7 @@ static void ieee80211_rx_mgmt_beacon(struct
ieee80211_sub_if_data *sdata,
 static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_if_sta *ifsta,
 					struct ieee80211_mgmt *mgmt,
-					size_t len,
-					struct ieee80211_rx_status *rx_status)
+					size_t len)
 {
 	struct ieee80211_local *local = sdata->local;
 	int tx_last_beacon;
@@ -1969,8 +1968,7 @@ static void ieee80211_sta_rx_queued_mgmt(struct
ieee80211_sub_if_data *sdata,

 	switch (fc & IEEE80211_FCTL_STYPE) {
 	case IEEE80211_STYPE_PROBE_REQ:
-		ieee80211_rx_mgmt_probe_req(sdata, ifsta, mgmt, skb->len,
-					    rx_status);
+		ieee80211_rx_mgmt_probe_req(sdata, ifsta, mgmt, skb->len);
 		break;
 	case IEEE80211_STYPE_PROBE_RESP:
 		ieee80211_rx_mgmt_probe_resp(sdata, mgmt, skb->len, rx_status);
