Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6FD3C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9250D2084D
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbeLOJDv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:03:51 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42304 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730022AbeLOJDv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:03:51 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rN-0002oc-HF; Sat, 15 Dec 2018 11:03:46 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 15 Dec 2018 11:03:21 +0200
Message-Id: <20181215090325.31604-21-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 20/24] cfg80211: add some missing fall through annotations
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

There are talks about enabling -Wimplicit-fallthrough warnings in the
mainline and it is already enabled in linux-next.  Add all the
missing annotations to prevent warnings when this happens.

And in one case, remove the extra text from the annotation so that the
compiler recognizes it.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/chan.c    | 3 +++
 net/wireless/nl80211.c | 9 +++++++++
 net/wireless/scan.c    | 2 +-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 2db713d18f71..7dc1bbd0888f 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -6,6 +6,7 @@
  *
  * Copyright 2009	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright 2018       Intel Corporation
  */
 
 #include <linux/export.h>
@@ -747,6 +748,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 	case NL80211_CHAN_WIDTH_20:
 		if (!ht_cap->ht_supported)
 			return false;
+		/* fall through */
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		prohibited_flags |= IEEE80211_CHAN_NO_20MHZ;
 		width = 20;
@@ -769,6 +771,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 		cap = vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
 		if (cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
 			return false;
+		/* fall through */
 	case NL80211_CHAN_WIDTH_80:
 		if (!vht_cap->vht_supported)
 			return false;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 323cd91cf1e4..669cbdb6f849 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1851,6 +1851,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* fall through */
 	case 1:
 		if (nla_put(msg, NL80211_ATTR_CIPHER_SUITES,
 			    sizeof(u32) * rdev->wiphy.n_cipher_suites,
@@ -1897,6 +1898,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* fall through */
 	case 2:
 		if (nl80211_put_iftypes(msg, NL80211_ATTR_SUPPORTED_IFTYPES,
 					rdev->wiphy.interface_modes))
@@ -1904,6 +1906,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* fall through */
 	case 3:
 		nl_bands = nla_nest_start(msg, NL80211_ATTR_WIPHY_BANDS);
 		if (!nl_bands)
@@ -1929,6 +1932,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 				state->chan_start++;
 				if (state->split)
 					break;
+				/* fall through */
 			default:
 				/* add frequencies */
 				nl_freqs = nla_nest_start(
@@ -1982,6 +1986,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			state->split_start++;
 		if (state->split)
 			break;
+		/* fall through */
 	case 4:
 		nl_cmds = nla_nest_start(msg, NL80211_ATTR_SUPPORTED_COMMANDS);
 		if (!nl_cmds)
@@ -2008,6 +2013,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* fall through */
 	case 5:
 		if (rdev->ops->remain_on_channel &&
 		    (rdev->wiphy.flags & WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL) &&
@@ -2025,6 +2031,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* fall through */
 	case 6:
 #ifdef CONFIG_PM
 		if (nl80211_send_wowlan(msg, rdev, state->split))
@@ -2035,6 +2042,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 #else
 		state->split_start++;
 #endif
+		/* fall through */
 	case 7:
 		if (nl80211_put_iftypes(msg, NL80211_ATTR_SOFTWARE_IFTYPES,
 					rdev->wiphy.software_iftypes))
@@ -2047,6 +2055,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* fall through */
 	case 8:
 		if ((rdev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME) &&
 		    nla_put_u32(msg, NL80211_ATTR_DEVICE_AP_SME,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d0e7472dd9fd..5123667f4569 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1183,7 +1183,7 @@ cfg80211_inform_bss_data(struct wiphy *wiphy,
 	switch (ftype) {
 	case CFG80211_BSS_FTYPE_BEACON:
 		ies->from_beacon = true;
-		/* fall through to assign */
+		/* fall through */
 	case CFG80211_BSS_FTYPE_UNKNOWN:
 		rcu_assign_pointer(tmp.pub.beacon_ies, ies);
 		break;
-- 
2.19.2

