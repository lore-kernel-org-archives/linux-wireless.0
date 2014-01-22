Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40328 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbaAVKfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 05:35:03 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/7] mac80211_hwsim: make netlink policy const
Date: Wed, 22 Jan 2014 11:34:56 +0100
Message-Id: <1390386898-14316-6-git-send-email-johannes@sipsolutions.net> (sfid-20140122_113526_258935_769DD45F)
In-Reply-To: <1390386898-14316-1-git-send-email-johannes@sipsolutions.net>
References: <1390386898-14316-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The netlink policy in hwsim should be const, there's no
reason for it not to be.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index dc7f72e..07eea5e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -451,7 +451,7 @@ static struct genl_family hwsim_genl_family = {
 
 /* MAC80211_HWSIM netlink policy */
 
-static struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
+static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_ADDR_RECEIVER] = { .type = NLA_UNSPEC, .len = ETH_ALEN },
 	[HWSIM_ATTR_ADDR_TRANSMITTER] = { .type = NLA_UNSPEC, .len = ETH_ALEN },
 	[HWSIM_ATTR_FRAME] = { .type = NLA_BINARY,
-- 
1.8.5.1

