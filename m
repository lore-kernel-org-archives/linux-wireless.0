Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93621C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AE2C206A2
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbeLOJMP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:12:15 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42344 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726030AbeLOJMP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:12:15 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rG-0002oc-4M; Sat, 15 Dec 2018 11:03:38 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 15 Dec 2018 11:03:11 +0200
Message-Id: <20181215090325.31604-11-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/24] mac80211: never pass NULL params to ieee80211_if_add()
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This isn't really a problem now, but it means that the function
has a few NULL checks that are only relevant when coming from
the initial interface added in mac80211, and that's confusing.
Just pass non-NULL (but equivalently empty) in that case and
remove all the NULL checks.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/iface.c | 10 ++++------
 net/mac80211/main.c  |  4 +++-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 90ffdd9f756f..a9e08e200780 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1800,7 +1800,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		}
 
 		ieee80211_assign_perm_addr(local, ndev->perm_addr, type);
-		if (params && is_valid_ether_addr(params->macaddr))
+		if (is_valid_ether_addr(params->macaddr))
 			memcpy(ndev->dev_addr, params->macaddr, ETH_ALEN);
 		else
 			memcpy(ndev->dev_addr, ndev->perm_addr, ETH_ALEN);
@@ -1869,11 +1869,9 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	ieee80211_setup_sdata(sdata, type);
 
 	if (ndev) {
-		if (params) {
-			ndev->ieee80211_ptr->use_4addr = params->use_4addr;
-			if (type == NL80211_IFTYPE_STATION)
-				sdata->u.mgd.use_4addr = params->use_4addr;
-		}
+		ndev->ieee80211_ptr->use_4addr = params->use_4addr;
+		if (type == NL80211_IFTYPE_STATION)
+			sdata->u.mgd.use_4addr = params->use_4addr;
 
 		ndev->features |= local->hw.netdev_features;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7b8320d4a8e4..87a729926734 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1221,8 +1221,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	/* add one default STA interface if supported */
 	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION) &&
 	    !ieee80211_hw_check(hw, NO_AUTO_VIF)) {
+		struct vif_params params = {0};
+
 		result = ieee80211_if_add(local, "wlan%d", NET_NAME_ENUM, NULL,
-					  NL80211_IFTYPE_STATION, NULL);
+					  NL80211_IFTYPE_STATION, &params);
 		if (result)
 			wiphy_warn(local->hw.wiphy,
 				   "Failed to add default virtual iface\n");
-- 
2.19.2

