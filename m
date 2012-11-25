Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1729 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab2KYSRH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 13:17:07 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH] cfg80211: change function signature of
 cfg80211_get_p2p_attr()
Date: Sun, 25 Nov 2012 19:13:28 +0100
Message-ID: <1353867208-11429-1-git-send-email-arend@broadcom.com> (sfid-20121125_191743_637380_A40A7BF9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function cfg80211_get_p2p_attr() can fail and returns
a negative error code. However, the return type is unsigned
int. The largest positive number is determined by desired_len
variable in the function, which is u16. So changing the return
type to int to allow easy error checking. Also change the type
for the attribute to enum for improved type checking.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi Johannes,

I decided to make use of cfg80211_get_p2p_attr() in brcmfmac
and would like this minor change to it.

The only other "driver" using it is mac80211 and it seems it
will not mind this change ;-)

Gr. AvS
---
 include/net/cfg80211.h |    5 +++--
 net/wireless/util.c    |    6 ++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8a1aec5..45eb8ec 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3652,8 +3652,9 @@ void cfg80211_unregister_wdev(struct wireless_dev *wdev);
  * the data is malformed or the attribute can't be found (respectively),
  * or the length of the found attribute (which can be zero).
  */
-unsigned int cfg80211_get_p2p_attr(const u8 *ies, unsigned int len,
-				   u8 attr, u8 *buf, unsigned int bufsize);
+int cfg80211_get_p2p_attr(const u8 *ies, unsigned int len,
+			  enum ieee80211_p2p_attr_id attr_id,
+			  u8 *buf, unsigned int bufsize);
 
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index b99f01c..2344077 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -980,9 +980,11 @@ u32 cfg80211_calculate_bitrate(struct rate_info *rate)
 }
 EXPORT_SYMBOL(cfg80211_calculate_bitrate);
 
-unsigned int cfg80211_get_p2p_attr(const u8 *ies, unsigned int len,
-				   u8 attr, u8 *buf, unsigned int bufsize)
+int cfg80211_get_p2p_attr(const u8 *ies, unsigned int len,
+				   enum ieee80211_p2p_attr_id attr_id,
+				   u8 *buf, unsigned int bufsize)
 {
+	u8 attr = (u8)attr_id;
 	u8 *out = buf;
 	u16 attr_remaining = 0;
 	bool desired_attr = false;
-- 
1.7.10.4


