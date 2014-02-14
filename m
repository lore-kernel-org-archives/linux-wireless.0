Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:54802 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaBNMRa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 07:17:30 -0500
Message-ID: <1392380269.5384.36.camel@tkhai> (sfid-20140214_131733_527212_66A4B574)
Subject: [PATCH] hostap: Do not free priv until timer handler hasn't
 actually stopped using it
From: Kirill Tkhai <ktkhai@parallels.com>
To: Jouni Malinen <j@w1.fi>, John Linville <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 14 Feb 2014 16:17:49 +0400
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Function del_timer() does not guarantee that timer was really deleted.
If the timer handler is beeing executed at the moment, the function
does nothing. So, it's possible to use already freed memory in the handler:

[ref: Documentation/DocBook/kernel-locking.tmpl]

This was found using grep and compile-tested only. Please, consider
applying or something similar to it.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Jouni Malinen <j@w1.fi>
CC: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/hostap/hostap_ap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/hostap/hostap_ap.c b/drivers/net/wireless/hostap/hostap_ap.c
index d36e252..5965255 100644
--- a/drivers/net/wireless/hostap/hostap_ap.c
+++ b/drivers/net/wireless/hostap/hostap_ap.c
@@ -147,7 +147,7 @@ static void ap_free_sta(struct ap_data *ap, struct sta_info *sta)
 
 	if (!sta->ap && sta->u.sta.challenge)
 		kfree(sta->u.sta.challenge);
-	del_timer(&sta->timer);
+	del_timer_sync(&sta->timer);
 #endif /* PRISM2_NO_KERNEL_IEEE80211_MGMT */
 
 	kfree(sta);



