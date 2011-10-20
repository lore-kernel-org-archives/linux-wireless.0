Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49168 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1JTSfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 14:35:07 -0400
Received: by mail-gy0-f174.google.com with SMTP id 13so3086542gyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 11:35:06 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v2 6/6] mac80211: check mesh peer's WMM parameters
Date: Thu, 20 Oct 2011 11:34:39 -0700
Message-Id: <1319135679-6740-7-git-send-email-thomas@cozybit.com> (sfid-20111020_203511_256005_ED9E5FA7)
In-Reply-To: <1319135679-6740-1-git-send-email-thomas@cozybit.com>
References: <1319135679-6740-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For now, disallow peering if our WMM parameters don't match our peer's.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index b3a125f..dd83c8f7 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -103,6 +103,13 @@ bool mesh_matches_local(struct ieee802_11_elems *ie, struct ieee80211_sub_if_dat
 	     ieee80211_ht_info_to_channel_type(ie->ht_info_elem)))
 		goto mismatch;
 
+	if (ie->wmm_param) {
+		u8 wmm_local[sizeof(struct ieee80211_wmm_param_ie)];
+		ieee80211_build_wmm_ie(&sdata->vif, wmm_local);
+		if (memcmp(ie->wmm_param, wmm_local, sizeof(wmm_local)))
+			goto mismatch;
+	}
+
 	return true;
 mismatch:
 	return false;
-- 
1.7.5.4

