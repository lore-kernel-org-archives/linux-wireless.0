Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:58691 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab1KQRGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 12:06:21 -0500
Subject: [PATCH] nl80211: add testmode to the list of supported commands
To: linville@tuxdriver.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 17 Nov 2011 19:06:10 +0200
Message-ID: <20111117170610.21114.57859.stgit@localhost6.localdomain6> (sfid-20111117_180625_317829_8709F7BE)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

User space might want to test if driver supports testmode. Adding testmode
to the list of supported commands makes this easier.

I omitted testmode_dump() in purpose. I assume all drivers implementing
testmode_dump() will also implement testmode_cmd().

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 net/wireless/nl80211.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 864fcb6..5ab8e97 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -897,6 +897,10 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		NLA_PUT_U32(msg, i, NL80211_CMD_REGISTER_BEACONS);
 	}
 
+#ifdef CONFIG_NL80211_TESTMODE
+	CMD(testmode_cmd, TESTMODE);
+#endif
+
 #undef CMD
 
 	if (dev->ops->connect || dev->ops->auth) {

