Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0047.hostedemail.com ([216.40.44.47]:49819 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753671AbaCXUQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 16:16:04 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/7] carl9170: Remove casts of pointer to same type
Date: Mon, 24 Mar 2014 13:15:38 -0700
Message-Id: <e378d1df6fe2f8113407fcd496bd5612a878f809.1395692043.git.joe@perches.com> (sfid-20140324_211700_236959_9D6AB4F3)
In-Reply-To: <cover.1395692043.git.joe@perches.com>
References: <cover.1395692043.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Casting a pointer to a pointer of the same type is pointless,
so remove these unnecessary casts.

Done via coccinelle script:

$ cat typecast_2.cocci
@@
type T;
T *foo;
@@

-	(T *)foo
+	foo

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/carl9170/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 536bc46a..924135b 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -572,7 +572,7 @@ static void carl9170_ps_beacon(struct ar9170 *ar, void *data, unsigned int len)
 
 static void carl9170_ba_check(struct ar9170 *ar, void *data, unsigned int len)
 {
-	struct ieee80211_bar *bar = (void *) data;
+	struct ieee80211_bar *bar = data;
 	struct carl9170_bar_list_entry *entry;
 	unsigned int queue;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

