Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:44348 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752009AbeEODKl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 23:10:41 -0400
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH] cfg80211: further limit wiphy names to 64 bytes
Date: Mon, 14 May 2018 20:09:24 -0700
Message-Id: <20180515030924.27570-1-ebiggers3@gmail.com> (sfid-20180515_051106_679009_4DFEEF89)
In-Reply-To: <1526300027.8070.0.camel@sipsolutions.net>
References: <1526300027.8070.0.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

wiphy names were recently limited to 128 bytes by commit a7cfebcb7594
("cfg80211: limit wiphy names to 128 bytes").  As it turns out though,
this isn't sufficient because dev_vprintk_emit() needs the syslog header
string "SUBSYSTEM=ieee80211\0DEVICE=+ieee80211:$devname" to fit into 128
bytes.  This triggered the "device/subsystem name too long" WARN when
the device name was >= 90 bytes.  As before, this was reproduced by
syzbot by sending an HWSIM_CMD_NEW_RADIO command to the MAC80211_HWSIM
generic netlink family.

Fix it by further limiting wiphy names to 64 bytes.

Reported-by: syzbot+e64565577af34b3768dc@syzkaller.appspotmail.com
Fixes: a7cfebcb7594 ("cfg80211: limit wiphy names to 128 bytes")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/uapi/linux/nl80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9c3630146cec0..271b93783d282 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2698,7 +2698,7 @@ enum nl80211_attrs {
 #define NL80211_ATTR_KEYS NL80211_ATTR_KEYS
 #define NL80211_ATTR_FEATURE_FLAGS NL80211_ATTR_FEATURE_FLAGS
 
-#define NL80211_WIPHY_NAME_MAXLEN		128
+#define NL80211_WIPHY_NAME_MAXLEN		64
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_HT_RATES		77
-- 
2.17.0
