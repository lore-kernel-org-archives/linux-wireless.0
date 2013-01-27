Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.active-venture.com ([67.228.131.205]:57363 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3A0Sza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2013 13:55:30 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] net: iwlegacy: remove unused variable
Date: Sun, 27 Jan 2013 10:55:41 -0800
Message-Id: <1359312941-30661-1-git-send-email-linux@roeck-us.net> (sfid-20130127_195535_894267_8CEC20F3)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix:

drivers/net/wireless/iwlegacy/4965.c: In function ‘il4965_post_associate’:
drivers/net/wireless/iwlegacy/4965.c:1751:25: warning: variable ‘conf’ set but
not used [-Wunused-but-set-variable]

seen when building allmodconfig on x86_64 with W=1 by removing the unused
variable.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/wireless/iwlegacy/4965.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 5db1171..91eb2d0 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -1748,7 +1748,6 @@ static void
 il4965_post_associate(struct il_priv *il)
 {
 	struct ieee80211_vif *vif = il->vif;
-	struct ieee80211_conf *conf = NULL;
 	int ret = 0;
 
 	if (!vif || !il->is_open)
@@ -1759,8 +1758,6 @@ il4965_post_associate(struct il_priv *il)
 
 	il_scan_cancel_timeout(il, 200);
 
-	conf = &il->hw->conf;
-
 	il->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	il_commit_rxon(il);
 
-- 
1.7.9.7

