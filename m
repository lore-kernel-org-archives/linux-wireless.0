Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ibawizard.net ([82.208.49.253]:39522 "EHLO
	mengele.ibawizard.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1CZRj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Mar 2011 13:39:26 -0400
From: =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: fix NULL pointer dereference in ieee80211_key_alloc()
Date: Sat, 26 Mar 2011 18:32:42 +0100
Message-Id: <1301160762-8409-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ieee80211_key struct can be kfree()d several times in the function, for
example if some of the key setup functions fails beforehand, but there's no
check if the struct is still valid before we call memcpy() and INIT_LIST_HEAD()
on it.  In some cases (like it was in my case), if there's missing aes-generic
module it could lead to the following kernel OOPS:

	Unable to handle kernel NULL pointer dereference at virtual address 0000018c
	....
	PC is at memcpy+0x80/0x29c
	...
	Backtrace:
	[<bf11c5e4>] (ieee80211_key_alloc+0x0/0x234 [mac80211]) from [<bf1148b4>] (ieee80211_add_key+0x70/0x12c [mac80211])
	[<bf114844>] (ieee80211_add_key+0x0/0x12c [mac80211]) from [<bf070cc0>] (__cfg80211_set_encryption+0x2a8/0x464 [cfg80211])

Signed-off-by: Petr Štetiar <ynezz@true.cz>
CC: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/key.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 8c02469..8e49850 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -364,8 +364,11 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		}
 		break;
 	}
-	memcpy(key->conf.key, key_data, key_len);
-	INIT_LIST_HEAD(&key->list);
+
+	if (!IS_ERR(key)) {
+		memcpy(key->conf.key, key_data, key_len);
+		INIT_LIST_HEAD(&key->list);
+	}
 
 	return key;
 }
-- 
1.7.1

