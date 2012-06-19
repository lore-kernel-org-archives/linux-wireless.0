Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:56578 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab2FSV7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 17:59:43 -0400
Received: from mail0.frost.chambana.net (mail0.frost.chambana.net [209.66.96.68])
	by www19.servergod.com (Postfix) with ESMTP id 6774212000B
	for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 14:59:43 -0700 (PDT)
Received: by mail0.frost.chambana.net (Postfix) with SMTP id 263BF59A06C
	for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 21:59:43 +0000
From: Will Hawkins <hawkinsw@opentechinstitute.org>
To: hawkinsw@opentechinstitute.org, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 3/3] mac80211: Allow userspace application to register for authentication frames
Date: Tue, 19 Jun 2012 17:59:14 -0400
Message-Id: <561a3f1df991c189e2c20af2ae349ca4fe79f640.1340142553.git.hawkinsw@opentechinstitute.org> (sfid-20120619_235949_311300_FE7E6A7E)
In-Reply-To: <cover.1340142553.git.hawkinsw@opentechinstitute.org>
References: <cover.1340142553.git.hawkinsw@opentechinstitute.org>
In-Reply-To: <cover.1340142553.git.hawkinsw@opentechinstitute.org>
References: <cover.1340142553.git.hawkinsw@opentechinstitute.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the necessary flags to allow user space
applications to register for authentication frames
on adhoc interfaces. This is useful for
situations where userspace applications want
to control key negotiation between stations.

Signed-off-by: Will Hawkins <hawkinsw@opentechinstitute.org>
---
 net/mac80211/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d81c178..4467162 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -455,7 +455,9 @@ static const struct ieee80211_txrx_stypes
 ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	[NL80211_IFTYPE_ADHOC] = {
 		.tx = 0xffff,
-		.rx = BIT(IEEE80211_STYPE_ACTION >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+			BIT(IEEE80211_STYPE_AUTH >> 4) |
+			BIT(IEEE80211_STYPE_DEAUTH >> 4),
 	},
 	[NL80211_IFTYPE_STATION] = {
 		.tx = 0xffff,
-- 
1.7.9.5


