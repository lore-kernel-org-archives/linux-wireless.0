Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:48964 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3F0KrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 06:47:16 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr13so742958pbb.20
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jun 2013 03:47:16 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v2] mac80211: prevent the buffering or frame transmission to non-assoc mesh STA
Date: Thu, 27 Jun 2013 18:42:56 +0800
Message-Id: <1372329776-20363-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130627_124719_593550_11E11CA9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is intended to avoid the buffering to non-assoc mesh STA
and also to avoid the triggering of frame to non-assoc mesh STA which
could cause kernel panic in specific hw.

One of the examples, is kernel panic happens to ath9k if user space
inserts the mesh STA and not proceed with the SAE and AMPE, and later
the same mesh STA is detected again. The sta_state of the mesh STA remains
at IEEE80211_STA_NONE and if the ieee80211_sta_ps_deliver_wakeup is called
and subsequently the ath_tx_aggr_wakeup, the kernel panic due to
ath_tx_node_init is not called before to initialize the require data
structures.

This issue is reported by Cedric Voncken before.
http://www.spinics.net/lists/linux-wireless/msg106342.html

[<831ea6b4>] ath_tx_aggr_wakeup+0x44/0xcc [ath9k]
[<83084214>] ieee80211_sta_ps_deliver_wakeup+0xb8/0x208 [mac80211]
[<830b9824>] ieee80211_mps_sta_status_update+0x94/0x108 [mac80211]
[<83099398>] ieee80211_sta_ps_transition+0xc94/0x34d8 [mac80211]
[<8022399c>] nf_iterate+0x98/0x104
[<8309bb60>] ieee80211_sta_ps_transition+0x345c/0x34d8 [mac80211]

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
v2: 
	change the subject to be less ath9k-centric (Johannes)
	push the checking higher to prevent buffering for non-assoc STA (Bob Copeland)

 net/mac80211/mesh_ps.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 3b7bfc0..22290a9 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -229,6 +229,10 @@ void ieee80211_mps_sta_status_update(struct sta_info *sta)
 	enum nl80211_mesh_power_mode pm;
 	bool do_buffer;
 
+	/* For non-assoc STA, prevent buffering or frame transmission */
+	if (sta->sta_state < IEEE80211_STA_ASSOC)
+		return;
+
 	/*
 	 * use peer-specific power mode if peering is established and the
 	 * peer's power mode is known
-- 
1.7.0.4

