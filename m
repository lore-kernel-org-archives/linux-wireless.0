Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:32890 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbbHXQBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2015 12:01:33 -0400
Received: by qkch123 with SMTP id h123so67542306qkc.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2015 09:01:32 -0700 (PDT)
From: "=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?=" <jprvita@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>
Subject: [PATCH] rfkill: Copy "all" global state to other types
Date: Mon, 24 Aug 2015 12:01:23 -0400
Message-Id: <1440432084-20928-1-git-send-email-jprvita@endlessm.com> (sfid-20150824_180136_287694_34DC04AB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When switching the state of all RFKill switches of type all we need to
replicate the RFKILL_TYPE_ALL global state to all the other types global
state, so it is used to initialize persistent RFKill switches on
register.

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
---
 net/rfkill/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index f12149a..1626e26 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -341,7 +341,14 @@ static void __rfkill_switch_all(const enum rfkill_type type, bool blocked)
 {
 	struct rfkill *rfkill;
 
-	rfkill_global_states[type].cur = blocked;
+	if (type == RFKILL_TYPE_ALL) {
+		enum rfkill_type i;
+		for (i = 0; i < NUM_RFKILL_TYPES; i++)
+			rfkill_global_states[i].cur = blocked;
+	} else {
+		rfkill_global_states[type].cur = blocked;
+	}
+
 	list_for_each_entry(rfkill, &rfkill_list, node) {
 		if (rfkill->type != type && type != RFKILL_TYPE_ALL)
 			continue;
-- 
2.1.4

