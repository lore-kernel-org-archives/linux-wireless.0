Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89018C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 09:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DEBF2064A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 09:55:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DEBF2064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbeJAQcU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 12:32:20 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56714 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729073AbeJAQcU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 12:32:20 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g6uvA-00024a-6y; Mon, 01 Oct 2018 11:55:20 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: add error messages to nl80211_parse_chandef()
Date:   Mon,  1 Oct 2018 11:55:09 +0200
Message-Id: <20181001095509.24870-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Add some error messages to nl80211_parse_chandef() to make
failures here - especially with disabled channels - easier
to diagnose.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 62 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 22 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0b8896dca65e..fb7f07b0e123 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2292,12 +2292,14 @@ static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 				 struct genl_info *info,
 				 struct cfg80211_chan_def *chandef)
 {
+	struct netlink_ext_ack *extack = info->extack;
+	struct nlattr **attrs = info->attrs;
 	u32 control_freq;
 
-	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ])
+	if (!attrs[NL80211_ATTR_WIPHY_FREQ])
 		return -EINVAL;
 
-	control_freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
+	control_freq = nla_get_u32(attrs[NL80211_ATTR_WIPHY_FREQ]);
 
 	chandef->chan = ieee80211_get_channel(&rdev->wiphy, control_freq);
 	chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
@@ -2305,14 +2307,16 @@ static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 	chandef->center_freq2 = 0;
 
 	/* Primary channel not allowed */
-	if (!chandef->chan || chandef->chan->flags & IEEE80211_CHAN_DISABLED)
+	if (!chandef->chan || chandef->chan->flags & IEEE80211_CHAN_DISABLED) {
+		NL_SET_ERR_MSG_ATTR(extack, attrs[NL80211_ATTR_WIPHY_FREQ],
+				    "Channel is disabled");
 		return -EINVAL;
+	}
 
-	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
+	if (attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
 		enum nl80211_channel_type chantype;
 
-		chantype = nla_get_u32(
-				info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+		chantype = nla_get_u32(attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
 
 		switch (chantype) {
 		case NL80211_CHAN_NO_HT:
@@ -2322,42 +2326,56 @@ static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 			cfg80211_chandef_create(chandef, chandef->chan,
 						chantype);
 			/* user input for center_freq is incorrect */
-			if (info->attrs[NL80211_ATTR_CENTER_FREQ1] &&
-			    chandef->center_freq1 != nla_get_u32(
-					info->attrs[NL80211_ATTR_CENTER_FREQ1]))
+			if (attrs[NL80211_ATTR_CENTER_FREQ1] &&
+			    chandef->center_freq1 != nla_get_u32(attrs[NL80211_ATTR_CENTER_FREQ1])) {
+				NL_SET_ERR_MSG_ATTR(extack,
+						    attrs[NL80211_ATTR_CENTER_FREQ1],
+						    "bad center frequency 1");
 				return -EINVAL;
+			}
 			/* center_freq2 must be zero */
-			if (info->attrs[NL80211_ATTR_CENTER_FREQ2] &&
-			    nla_get_u32(info->attrs[NL80211_ATTR_CENTER_FREQ2]))
+			if (attrs[NL80211_ATTR_CENTER_FREQ2] &&
+			    nla_get_u32(attrs[NL80211_ATTR_CENTER_FREQ2])) {
+				NL_SET_ERR_MSG_ATTR(extack,
+						    attrs[NL80211_ATTR_CENTER_FREQ2],
+						    "center frequency 2 can't be used");
 				return -EINVAL;
+			}
 			break;
 		default:
+			NL_SET_ERR_MSG_ATTR(extack,
+					    attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE],
+					    "invalid channel type");
 			return -EINVAL;
 		}
-	} else if (info->attrs[NL80211_ATTR_CHANNEL_WIDTH]) {
+	} else if (attrs[NL80211_ATTR_CHANNEL_WIDTH]) {
 		chandef->width =
-			nla_get_u32(info->attrs[NL80211_ATTR_CHANNEL_WIDTH]);
-		if (info->attrs[NL80211_ATTR_CENTER_FREQ1])
+			nla_get_u32(attrs[NL80211_ATTR_CHANNEL_WIDTH]);
+		if (attrs[NL80211_ATTR_CENTER_FREQ1])
 			chandef->center_freq1 =
-				nla_get_u32(
-					info->attrs[NL80211_ATTR_CENTER_FREQ1]);
-		if (info->attrs[NL80211_ATTR_CENTER_FREQ2])
+				nla_get_u32(attrs[NL80211_ATTR_CENTER_FREQ1]);
+		if (attrs[NL80211_ATTR_CENTER_FREQ2])
 			chandef->center_freq2 =
-				nla_get_u32(
-					info->attrs[NL80211_ATTR_CENTER_FREQ2]);
+				nla_get_u32(attrs[NL80211_ATTR_CENTER_FREQ2]);
 	}
 
-	if (!cfg80211_chandef_valid(chandef))
+	if (!cfg80211_chandef_valid(chandef)) {
+		NL_SET_ERR_MSG(extack, "invalid channel definition");
 		return -EINVAL;
+	}
 
 	if (!cfg80211_chandef_usable(&rdev->wiphy, chandef,
-				     IEEE80211_CHAN_DISABLED))
+				     IEEE80211_CHAN_DISABLED)) {
+		NL_SET_ERR_MSG(extack, "(extension) channel is disabled");
 		return -EINVAL;
+	}
 
 	if ((chandef->width == NL80211_CHAN_WIDTH_5 ||
 	     chandef->width == NL80211_CHAN_WIDTH_10) &&
-	    !(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_5_10_MHZ))
+	    !(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_5_10_MHZ)) {
+		NL_SET_ERR_MSG(extack, "5/10 MHz not supported");
 		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
2.14.4

