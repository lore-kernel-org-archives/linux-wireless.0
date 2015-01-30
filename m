Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55404 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbbA3RfV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 12:35:21 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] backports: update genl-const patch for nl80211
Date: Fri, 30 Jan 2015 18:35:17 +0100
Message-Id: <1422639317-21593-1-git-send-email-johannes@sipsolutions.net> (sfid-20150130_183524_349907_92B477EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The current wireless tree changes the surrounding code to
use the exported string constants, so adjust the patch to
make it apply again.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 patches/collateral-evolutions/network/0027-genl-const/nl80211.patch | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/patches/collateral-evolutions/network/0027-genl-const/nl80211.patch b/patches/collateral-evolutions/network/0027-genl-const/nl80211.patch
index d8d67bb99577..21c2a86eda58 100644
--- a/patches/collateral-evolutions/network/0027-genl-const/nl80211.patch
+++ b/patches/collateral-evolutions/network/0027-genl-const/nl80211.patch
@@ -18,9 +18,9 @@
  
 -static const struct genl_multicast_group nl80211_mcgrps[] = {
 +static __genl_const struct genl_multicast_group nl80211_mcgrps[] = {
- 	[NL80211_MCGRP_CONFIG] = { .name = "config", },
- 	[NL80211_MCGRP_SCAN] = { .name = "scan", },
- 	[NL80211_MCGRP_REGULATORY] = { .name = "regulatory", },
+ 	[NL80211_MCGRP_CONFIG] = { .name = NL80211_MULTICAST_GROUP_CONFIG },
+ 	[NL80211_MCGRP_SCAN] = { .name = NL80211_MULTICAST_GROUP_SCAN },
+ 	[NL80211_MCGRP_REGULATORY] = { .name = NL80211_MULTICAST_GROUP_REG },
 @@ -9938,7 +9938,7 @@ static int nl80211_tdls_cancel_channel_s
  					 NL80211_FLAG_CHECK_NETDEV_UP)
  #define NL80211_FLAG_CLEAR_SKB		0x20
-- 
2.1.4

