Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:32996 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbbFJSCo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 14:02:44 -0400
Received: by iebgx4 with SMTP id gx4so39842076ieb.0
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2015 11:02:43 -0700 (PDT)
Message-ID: <55787BA1.9030807@cococorp.com> (sfid-20150610_200248_160035_CE5FAF39)
Date: Wed, 10 Jun 2015 11:02:09 -0700
From: Alexis Green <agreen@cococorp.com>
Reply-To: agreen@cococorp.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, Jesse Jones <jjones@cococorp.com>
Subject: [PATCH] mac80211: Add missing case to PERR processing
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the nexthop is unable to resolve its own nexthop it will send back a
PERR with a zero target_sn. According to section 13.10.11.4.3 step b in the
2012 standard that perr should be forwarded and the associated mpath->sn
should be incremented. Neither one of those was happening whichis rather
bad because the originator was not told that packets are black holing.

Signed-off-by: Alexis Green <agreen@cococorp.com>
CC: Jesse Jones <jjones@cococorp.com>

---

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 3c7cf3c..28c18cb 100755
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -736,9 +736,12 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 		if (mpath->flags & MESH_PATH_ACTIVE &&
 		    ether_addr_equal(ta, sta->sta.addr) &&
 		    (!(mpath->flags & MESH_PATH_SN_VALID) ||
-		    SN_GT(target_sn, mpath->sn))) {
+		    SN_GT(target_sn, mpath->sn)  || target_sn == 0)) {
 			mpath->flags &= ~MESH_PATH_ACTIVE;
-			mpath->sn = target_sn;
+			if (target_sn != 0)
+				mpath->sn = target_sn;
+			else
+				mpath->sn += 1;
 			spin_unlock_bh(&mpath->state_lock);
 			if (!ifmsh->mshcfg.dot11MeshForwarding)
 				goto endperr;
