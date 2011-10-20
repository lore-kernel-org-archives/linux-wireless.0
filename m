Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63056 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab1JTAXb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 20:23:31 -0400
Received: by mail-iy0-f174.google.com with SMTP id k3so2741475iae.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2011 17:23:31 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 2/3] mac80211: find correct IE offset in mesh beacons
Date: Wed, 19 Oct 2011 17:23:22 -0700
Message-Id: <1319070203-22097-2-git-send-email-thomas@cozybit.com> (sfid-20111020_022335_388455_9774B786)
In-Reply-To: <1319070203-22097-1-git-send-email-thomas@cozybit.com>
References: <1319070203-22097-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index a7078fd..19ec8bd 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -569,6 +569,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	u32 supp_rates = 0;
 	size_t baselen;
 	int freq;
+	u8 *ies;
 	enum ieee80211_band band = rx_status->band;
 
 	/* ignore ProbeResp to foreign address */
@@ -576,12 +577,22 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	    compare_ether_addr(mgmt->da, sdata->vif.addr))
 		return;
 
-	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
+	switch (stype) {
+	case IEEE80211_STYPE_PROBE_RESP:
+		ies = (u8 *) mgmt->u.probe_resp.variable;
+		break;
+	case IEEE80211_STYPE_BEACON:
+		ies = (u8 *) mgmt->u.beacon.variable;
+		break;
+	default:
+		return;
+	}
+
+	baselen = ies - (u8 *) mgmt;
 	if (baselen > len)
 		return;
 
-	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
-			       &elems);
+	ieee802_11_parse_elems(ies, len - baselen, &elems);
 
 	/* ignore beacons from secure mesh peers if our security is off */
 	if (elems.rsn_len && sdata->u.mesh.security == IEEE80211_MESH_SEC_NONE)
-- 
1.7.5.4

