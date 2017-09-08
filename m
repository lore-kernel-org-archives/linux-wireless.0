Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge01.uni-rostock.de ([139.30.8.12]:32077 "EHLO
        edge01.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752955AbdIHOQp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 10:16:45 -0400
Content-Type: text/plain
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [RFC 3/4] mac80211_hwsim: explicitly set netlink parallel ops to false
Date: Fri, 8 Sep 2017 16:11:36 +0200
In-Reply-To: <20170908141137.3941-1-benjamin.beichler@uni-rostock.de>
References: <20170908141137.3941-1-benjamin.beichler@uni-rostock.de>
MIME-Version: 1.0
Message-ID: <593fec4f-fc0c-4610-b144-35760ee92102@MAIL1.uni-rostock.de> (sfid-20170908_161758_882324_D8A75D23)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ops field is zero initialized, therefore parallel ops is already false. This implicates that the netlink callbacks are not
processed in parallel. Maybe this could be utilized to reduce locking overhead or maybe also parallel ops could be implemented.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 62c5a00a76c3..5dd4be2a8487 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3499,6 +3499,7 @@ static struct genl_family hwsim_genl_family __ro_after_init = {
 	.n_ops = ARRAY_SIZE(hwsim_ops),
 	.mcgrps = hwsim_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(hwsim_mcgrps),
+	.parallel_ops = false
 };
 
 static void destroy_radio(struct work_struct *work)
-- 
2.14.1
