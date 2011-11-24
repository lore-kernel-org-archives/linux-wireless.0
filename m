Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59993 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab1KXTP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 14:15:27 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Make __check_htcap_disable static.
Date: Thu, 24 Nov 2011 11:15:21 -0800
Message-Id: <1322162121-21639-1-git-send-email-greearb@candelatech.com> (sfid-20111124_201530_181000_FC0E37F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

:100644 100644 810cfbe... d3eafae... M	net/mac80211/ht.c
 net/mac80211/ht.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 810cfbe..d3eafae 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -28,9 +28,9 @@ bool ieee80111_cfg_override_disables_ht40(struct ieee80211_sub_if_data *sdata)
 	return false;
 }
 
-void __check_htcap_disable(struct ieee80211_sub_if_data *sdata,
-			   struct ieee80211_sta_ht_cap *ht_cap,
-			   u16 flag)
+static void __check_htcap_disable(struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_sta_ht_cap *ht_cap,
+				  u16 flag)
 {
 	__le16 le_flag = cpu_to_le16(flag);
 	if (sdata->u.mgd.ht_capa_mask.cap_info & le_flag) {
-- 
1.7.3.4

