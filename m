Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50411 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbYJACXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 22:23:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/5] wireless: escape_ssid should handle non-printables
Date: Tue, 30 Sep 2008 22:15:50 -0400
Message-Id: <1222827352-1978-4-git-send-email-linville@tuxdriver.com> (sfid-20081001_042408_544933_5AB5550C)
In-Reply-To: <1222827352-1978-3-git-send-email-linville@tuxdriver.com>
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
 <1222827352-1978-1-git-send-email-linville@tuxdriver.com>
 <1222827352-1978-2-git-send-email-linville@tuxdriver.com>
 <1222827352-1978-3-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also use common backslash sequences like \t, \n, \r, and \\ as well as \0.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/lib80211.c |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/wireless/lib80211.c b/net/wireless/lib80211.c
index 872cc8d..b8e34d3 100644
--- a/net/wireless/lib80211.c
+++ b/net/wireless/lib80211.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/ctype.h>
 #include <linux/ieee80211.h>
 
 #include <net/lib80211.h>
@@ -20,19 +21,31 @@ MODULE_LICENSE("GPL");
 
 const char *escape_ssid(const char *ssid, u8 ssid_len)
 {
-	static char escaped[IEEE80211_MAX_SSID_LEN * 2 + 1];
+	static char escaped[IEEE80211_MAX_SSID_LEN * 4 + 1];
 	const char *s = ssid;
 	char *d = escaped;
 
 	ssid_len = min_t(u8, ssid_len, IEEE80211_MAX_SSID_LEN);
 	while (ssid_len--) {
-		if (*s == '\0') {
-			*d++ = '\\';
-			*d++ = '0';
-			s++;
-		} else {
+		if (isprint(*s)) {
 			*d++ = *s++;
+			continue;
 		}
+
+		*d++ = '\\';
+		if (*s == '\0')
+			*d++ = '0';
+		else if (*s == '\n')
+			*d++ = 'n';
+		else if (*s == '\r')
+			*d++ = 'r';
+		else if (*s == '\t')
+			*d++ = 't';
+		else if (*s == '\\')
+			*d++ = '\\';
+		else
+			d += snprintf(d, 3, "%03o", *s);
+		s++;
 	}
 	*d = '\0';
 	return escaped;
-- 
1.5.4.3

