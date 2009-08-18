Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54292 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZHROzQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 10:55:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] wl1271: remove print_mac usage
Date: Tue, 18 Aug 2009 10:55:01 -0400
Message-Id: <1250607301-24944-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/wl12xx/wl1271_main.o
drivers/net/wireless/wl12xx/wl1271_main.c: In function ‘wl1271_op_add_interface’:
drivers/net/wireless/wl12xx/wl1271_main.c:611: warning: ‘print_mac’ is deprecated (declared at include/linux/if_ether.h:142)

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 754be81..d9169b4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -605,11 +605,10 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_if_init_conf *conf)
 {
 	struct wl1271 *wl = hw->priv;
-	DECLARE_MAC_BUF(mac);
 	int ret = 0;
 
-	wl1271_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %s",
-		     conf->type, print_mac(mac, conf->mac_addr));
+	wl1271_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
+		     conf->type, conf->mac_addr);
 
 	mutex_lock(&wl->mutex);
 
-- 
1.6.2.5

