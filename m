Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60528 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbZGGJAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 05:00:55 -0400
Subject: [PATCH] hwsim: make testmode_cmd static
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 11:00:55 +0200
Message-Id: <1246957255.4755.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sparse correctly complains about this, no reason
for it not to be static.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-07-07 10:59:44.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-07-07 10:59:59.000000000 +0200
@@ -729,7 +729,8 @@ static const struct nla_policy hwsim_tes
 
 static int hwsim_fops_ps_write(void *dat, u64 val);
 
-int mac80211_hwsim_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
+static int mac80211_hwsim_testmode_cmd(struct ieee80211_hw *hw,
+				       void *data, int len)
 {
 	struct mac80211_hwsim_data *hwsim = hw->priv;
 	struct nlattr *tb[HWSIM_TM_ATTR_MAX + 1];


