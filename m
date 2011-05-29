Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:46018 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab1E2UF4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2011 16:05:56 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh07-2.mail.saunalahti.fi (Postfix) with SMTP id 9989318CE94
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:05:55 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh05.mail.saunalahti.fi (Postfix) with ESMTP id 82B0A27D85
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:05:54 +0300 (EEST)
Subject: [RFC PATCH 15/27] mac80211: change ieee80211_if_wds and _vlan to use
	mac80211 prefix
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 29 May 2011 23:05:54 +0300
Message-ID: <20110529200554.16479.96246.stgit@localhost6.localdomain6> (sfid-20110529_220559_896938_D80ABCB8)
In-Reply-To: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
References: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/mac80211_i.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index f41a342..dc30f13 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -228,12 +228,12 @@ struct mac80211_if_ap {
 	bool dtim_bc_mc;
 };
 
-struct ieee80211_if_wds {
+struct mac80211_if_wds {
 	struct sta_info *sta;
 	u8 remote_addr[ETH_ALEN];
 };
 
-struct ieee80211_if_vlan {
+struct mac80211_if_vlan {
 	struct list_head list;
 
 	/* used for all tx if the VLAN is configured to 4-addr mode */
@@ -594,8 +594,8 @@ struct ieee80211_sub_if_data {
 
 	union {
 		struct mac80211_if_ap ap;
-		struct ieee80211_if_wds wds;
-		struct ieee80211_if_vlan vlan;
+		struct mac80211_if_wds wds;
+		struct mac80211_if_vlan vlan;
 		struct ieee80211_if_managed mgd;
 		struct ieee80211_if_ibss ibss;
 		struct ieee80211_if_mesh mesh;

