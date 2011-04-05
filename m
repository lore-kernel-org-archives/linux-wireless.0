Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37429 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1DECQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 22:16:32 -0400
Received: by iwn34 with SMTP id 34so6347290iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2011 19:16:32 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com
Subject: [PATCH v7 04/10] mac80211: ignore peers if security is enabled for this mesh
Date: Mon,  4 Apr 2011 18:15:34 -0700
Message-Id: <1301966140-26080-5-git-send-email-thomas@cozybit.com>
In-Reply-To: <1301966140-26080-1-git-send-email-thomas@cozybit.com>
References: <1301966140-26080-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh.c       |    4 ++++
 net/mac80211/mesh_plink.c |    4 ++++
 net/wireless/mesh.c       |    1 +
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 1c244c0..47a26c0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -573,6 +573,10 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
 			       &elems);
 
+	/* ignore beacons from secure mesh peers if our security is off */
+	if (elems.rsn_len && !sdata->u.mesh.is_secure)
+		return;
+
 	if (elems.ds_params && elems.ds_params_len == 1)
 		freq = ieee80211_channel_to_frequency(elems.ds_params[0], band);
 	else
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index c705b20..bafe255 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -449,6 +449,10 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		mpl_dbg("Mesh plink: missing necessary peer link ie\n");
 		return;
 	}
+	if (elems.rsn_len && !sdata->u.mesh.is_secure) {
+		mpl_dbg("Mesh plink: can't establish link with secure peer\n");
+		return;
+	}
 
 	ftype = mgmt->u.action.u.plink_action.action_code;
 	ie_len = elems.peer_link_len;
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 0e5c122..e0226e8 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -55,6 +55,7 @@ const struct mesh_setup default_mesh_setup = {
 	.path_metric = IEEE80211_PATH_METRIC_AIRTIME,
 	.ie = NULL,
 	.ie_len = 0,
+	.is_secure = false,
 };
 
 int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
-- 
1.7.4.1

