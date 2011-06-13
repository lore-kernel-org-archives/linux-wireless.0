Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:40427 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab1FMWg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:36:59 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh02-2.mail.saunalahti.fi (Postfix) with SMTP id A71D1EF64A
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:36:58 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh03.mail.saunalahti.fi (Postfix) with ESMTP id 8E2AB158A63
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:36:57 +0300 (EEST)
Subject: [PATCH v2 15/27] mac80211: change ieee80211_if_wds and _vlan to use
	mac80211 prefix
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:36:56 +0300
Message-ID: <20110613223656.10517.64510.stgit@localhost6.localdomain6> (sfid-20110614_005723_911055_BDAE119C)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/mac80211_i.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index 54d0751..0a0cd8e 100644
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

