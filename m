Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51455 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2EHEAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 00:00:47 -0400
Received: by mail-ob0-f174.google.com with SMTP id tb18so9215680obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 21:00:47 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	javier@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 3/4] mac80211: Modify mesh_set_ht_prot_mode() to have less identation
Date: Mon,  7 May 2012 21:00:31 -0700
Message-Id: <1336449632-9057-3-git-send-email-ashok@cozybit.com> (sfid-20120508_060116_203551_C981DC7E)
In-Reply-To: <1336449632-9057-1-git-send-email-ashok@cozybit.com>
References: <1336449632-9057-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Determining types of peers is modified to have less indentation. This change is
suggested by Johannes. This patch also corrects the reference in comment to
IEEE 802.11-2012 version.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 net/mac80211/mesh_plink.c |   47 +++++++++++++++++++++++----------------------
 1 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 8cc8461..9744c51 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -105,15 +105,15 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 	return sta;
 }
 
-/** mesh_set_ht_prot_mode - set correct HT protection mode
+/*
+ * mesh_set_ht_prot_mode - set correct HT protection mode
  *
- * Section 9.23.3.5 of IEEE 80211s standard describes the protection rules for
- * HT mesh STA in a MBSS. Three HT protection modes are supported for now,
- * non-HT mixed mode, 20MHz-protection and no-protection mode. non-HT mixed
- * mode is selected if any non-HT peers are present in our MBSS.
- * 20MHz-protection mode is selected if all peers in our 20/40MHz MBSS support
- * HT and atleast one HT20 peer is present. Otherwise no-protection mode is
- * selected.
+ * Section 9.23.3.5 of IEEE 80211-2012 describes the protection rules for HT
+ * mesh STA in a MBSS. Three HT protection modes are supported for now, non-HT
+ * mixed mode, 20MHz-protection and no-protection mode. non-HT mixed mode is
+ * selected if any non-HT peers are present in our MBSS.  20MHz-protection mode
+ * is selected if all peers in our 20/40MHz MBSS support HT and atleast one
+ * HT20 peer is present. Otherwise no-protection mode is selected.
  */
 static u32 mesh_set_ht_prot_mode(struct ieee80211_sub_if_data *sdata)
 {
@@ -128,21 +128,22 @@ static u32 mesh_set_ht_prot_mode(struct ieee80211_sub_if_data *sdata)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
-		if (sdata == sta->sdata &&
-		    sta->plink_state == NL80211_PLINK_ESTAB) {
-			switch (sta->ch_type) {
-			case NL80211_CHAN_NO_HT:
-				mpl_dbg("mesh_plink %pM: nonHT sta (%pM) is present",
-					sdata->vif.addr, sta->sta.addr);
-				non_ht_sta = true;
-				goto out;
-			case NL80211_CHAN_HT20:
-				mpl_dbg("mesh_plink %pM: HT20 sta (%pM) is present",
-					sdata->vif.addr, sta->sta.addr);
-				ht20_sta = true;
-			default:
-				break;
-			}
+		if (sdata != sta->sdata ||
+		    sta->plink_state != NL80211_PLINK_ESTAB)
+			continue;
+
+		switch (sta->ch_type) {
+		case NL80211_CHAN_NO_HT:
+			mpl_dbg("mesh_plink %pM: nonHT sta (%pM) is present",
+				sdata->vif.addr, sta->sta.addr);
+			non_ht_sta = true;
+			goto out;
+		case NL80211_CHAN_HT20:
+			mpl_dbg("mesh_plink %pM: HT20 sta (%pM) is present",
+				sdata->vif.addr, sta->sta.addr);
+			ht20_sta = true;
+		default:
+			break;
 		}
 	}
 out:
-- 
1.7.5.4

