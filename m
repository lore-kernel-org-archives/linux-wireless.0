Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33360C67863
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 00:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48A2D205F4
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 00:14:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48A2D205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbeJWIfG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 04:35:06 -0400
Received: from gateway33.websitewelcome.com ([192.185.145.239]:36180 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbeJWIfG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 04:35:06 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id B356B16D19E
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2018 19:13:11 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id EkJrgVXJrSjJAEkJrgzruE; Mon, 22 Oct 2018 19:13:11 -0500
X-Authority-Reason: nr=8
Received: from lfbn-1-466-13.w86-245.abo.wanadoo.fr ([86.245.173.13]:53540 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gEkJq-003pq0-Kd; Mon, 22 Oct 2018 19:13:11 -0500
Date:   Tue, 23 Oct 2018 02:13:08 +0200
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2] wireless: mark expected switch fall-throughs
Message-ID: <20181023001308.GA4150@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 86.245.173.13
X-Source-L: No
X-Exim-ID: 1gEkJq-003pq0-Kd
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: lfbn-1-466-13.w86-245.abo.wanadoo.fr (embeddedor) [86.245.173.13]:53540
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 8
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Warning level 3 was used: -Wimplicit-fallthrough=3

This code was not tested and GCC 7.2.0 was used to compile it.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2:
 - Explicity mention in the commit log that this the code was not
   tested.
 - Use warning level 3 instead of 2.
 - Change the form "else: fall through" to "fall through" instead.
 - Address -Wimplicit-fallthrough warnings in net/wireless/scan.c

 net/wireless/chan.c        | 2 ++
 net/wireless/nl80211.c     | 9 +++++++++
 net/wireless/scan.c        | 2 +-
 net/wireless/wext-compat.c | 2 ++
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 2db713d..0a45265 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -747,6 +747,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 	case NL80211_CHAN_WIDTH_20:
 		if (!ht_cap->ht_supported)
 			return false;
+		/* fall through */
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		prohibited_flags |= IEEE80211_CHAN_NO_20MHZ;
 		width = 20;
@@ -769,6 +770,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 		cap = vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
 		if (cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
 			return false;
+		/* fall through */
 	case NL80211_CHAN_WIDTH_80:
 		if (!vht_cap->vht_supported)
 			return false;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 744b585..0276370 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1706,6 +1706,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* fall through */
 	case 1:
 		if (nla_put(msg, NL80211_ATTR_CIPHER_SUITES,
 			    sizeof(u32) * rdev->wiphy.n_cipher_suites,
@@ -1752,6 +1753,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* fall through */
 	case 2:
 		if (nl80211_put_iftypes(msg, NL80211_ATTR_SUPPORTED_IFTYPES,
 					rdev->wiphy.interface_modes))
@@ -1759,6 +1761,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* fall through */
 	case 3:
 		nl_bands = nla_nest_start(msg, NL80211_ATTR_WIPHY_BANDS);
 		if (!nl_bands)
@@ -1784,6 +1787,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 				state->chan_start++;
 				if (state->split)
 					break;
+				/* fall through */
 			default:
 				/* add frequencies */
 				nl_freqs = nla_nest_start(
@@ -1837,6 +1841,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			state->split_start++;
 		if (state->split)
 			break;
+		/* fall through */
 	case 4:
 		nl_cmds = nla_nest_start(msg, NL80211_ATTR_SUPPORTED_COMMANDS);
 		if (!nl_cmds)
@@ -1863,6 +1868,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* fall through */
 	case 5:
 		if (rdev->ops->remain_on_channel &&
 		    (rdev->wiphy.flags & WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL) &&
@@ -1880,6 +1886,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* fall through */
 	case 6:
 #ifdef CONFIG_PM
 		if (nl80211_send_wowlan(msg, rdev, state->split))
@@ -1890,6 +1897,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 #else
 		state->split_start++;
 #endif
+		/* fall through */
 	case 7:
 		if (nl80211_put_iftypes(msg, NL80211_ATTR_SOFTWARE_IFTYPES,
 					rdev->wiphy.software_iftypes))
@@ -1902,6 +1910,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* fall through */
 	case 8:
 		if ((rdev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME) &&
 		    nla_put_u32(msg, NL80211_ATTR_DEVICE_AP_SME,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d0e7472..0f0b519 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1183,7 +1183,7 @@ cfg80211_inform_bss_data(struct wiphy *wiphy,
 	switch (ftype) {
 	case CFG80211_BSS_FTYPE_BEACON:
 		ies->from_beacon = true;
-		/* fall through to assign */
+		/* fall through - to assign */
 	case CFG80211_BSS_FTYPE_UNKNOWN:
 		rcu_assign_pointer(tmp.pub.beacon_ies, ies);
 		break;
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 06943d9..d522787 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1337,6 +1337,7 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 			wstats.qual.qual = sig + 110;
 			break;
 		}
+		/* fall through */
 	case CFG80211_SIGNAL_TYPE_UNSPEC:
 		if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_SIGNAL)) {
 			wstats.qual.updated |= IW_QUAL_LEVEL_UPDATED;
@@ -1345,6 +1346,7 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 			wstats.qual.qual = sinfo.signal;
 			break;
 		}
+		/* fall through */
 	default:
 		wstats.qual.updated |= IW_QUAL_LEVEL_INVALID;
 		wstats.qual.updated |= IW_QUAL_QUAL_INVALID;
-- 
2.7.4

