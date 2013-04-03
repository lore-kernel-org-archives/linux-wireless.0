Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58149 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758073Ab3DCKaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:30:18 -0400
Received: by mail-pa0-f49.google.com with SMTP id kp14so832841pab.36
        for <linux-wireless@vger.kernel.org>; Wed, 03 Apr 2013 03:30:17 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: fix the PREP mesh hwmp debug message
Date: Wed,  3 Apr 2013 17:49:53 +0800
Message-Id: <1364982593-30977-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130403_123022_339552_B9B52693)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh hwmp debug message is a bit confusing. The "sending PREP
to %p" should be the MAC address of mesh STA that has originated
the PREQ message and the "received PREP from %pM" should be the MAC
address of the mesh STA that has originated the PREP message.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh_hwmp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index bdb8d3b..9490433 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -144,7 +144,7 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 		*pos++ = WLAN_EID_PREQ;
 		break;
 	case MPATH_PREP:
-		mhwmp_dbg(sdata, "sending PREP to %pM\n", target);
+		mhwmp_dbg(sdata, "sending PREP to %pM\n", orig_addr);
 		ie_len = 31;
 		pos = skb_put(skb, 2 + ie_len);
 		*pos++ = WLAN_EID_PREP;
@@ -661,7 +661,7 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 	u32 target_sn, orig_sn, lifetime;
 
 	mhwmp_dbg(sdata, "received PREP from %pM\n",
-		  PREP_IE_ORIG_ADDR(prep_elem));
+		  PREP_IE_TARGET_ADDR(prep_elem));
 
 	orig_addr = PREP_IE_ORIG_ADDR(prep_elem);
 	if (ether_addr_equal(orig_addr, sdata->vif.addr))
-- 
1.7.0.4

