Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:38384 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605Ab3AYKyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 05:54:19 -0500
Date: Fri, 25 Jan 2013 16:17:45 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: Do not call mwl8k_cmd_set_rf_channel unconditionally
Message-ID: <20130125104745.GA9165@markyou.marvell.com> (sfid-20130125_115422_164171_F57703B5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid calling mwl8k_cmd_set_rf_channel unconditionally
by checking IEEE80211_CONF_CHANGE_CHANNEL.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 0b2428d..a48b137 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4797,9 +4797,11 @@ static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
 	if (rc)
 		goto out;
 
-	rc = mwl8k_cmd_set_rf_channel(hw, conf);
-	if (rc)
-		goto out;
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		rc = mwl8k_cmd_set_rf_channel(hw, conf);
+		if (rc)
+			goto out;
+	}
 
 	if (conf->power_level > 18)
 		conf->power_level = 18;
-- 
1.8.0.3

