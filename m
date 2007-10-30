Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:49892 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752262AbXJ3Uxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 16:53:51 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] ieee80211: Add IEEE80211_MAX_FRAME_LEN to linux/ieee80211.h
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 30 Oct 2007 16:50:05 -0400
Message-Id: <200710301650.05747.flamingice@sourmilk.net> (sfid-20071030_205354_605701_9B656EC0)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds IEEE80211_MAX_FRAME_LEN which is useful for drivers trying
to determine how much to allocate for their RX buffers.

It also updates the comment on IEEE80211_MAX_DATA_LEN based on revisions
in 802.11e.

IEEE80211_MAX_FRAG_THRESHOLD and IEEE80211_MAX_RTS_THRESHOLD are also
revised due to the new maximum frame size.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 include/linux/ieee80211.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 30621c2..214821a 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -81,18 +81,18 @@
 
 
 /* miscellaneous IEEE 802.11 constants */
-#define IEEE80211_MAX_FRAG_THRESHOLD	2346
-#define IEEE80211_MAX_RTS_THRESHOLD	2347
+#define IEEE80211_MAX_FRAG_THRESHOLD	2352
+#define IEEE80211_MAX_RTS_THRESHOLD	2353
 #define IEEE80211_MAX_AID		2007
 #define IEEE80211_MAX_TIM_LEN		251
-#define IEEE80211_MAX_DATA_LEN		2304
 /* Maximum size for the MA-UNITDATA primitive, 802.11 standard section
    6.2.1.1.2.
 
-   The figure in section 7.1.2 suggests a body size of up to 2312
-   bytes is allowed, which is a bit confusing, I suspect this
-   represents the 2304 bytes of real data, plus a possible 8 bytes of
-   WEP IV and ICV. (this interpretation suggested by Ramiro Barreiro) */
+   802.11e clarifies the figure in section 7.1.2. The frame body is
+   up to 2304 octets long (maximum MSDU size) plus any crypt overhead. */
+#define IEEE80211_MAX_DATA_LEN		2304
+/* 30 byte 4 addr hdr, 2 byte QoS, 2304 byte MSDU, 12 byte crypt, 4 byte FCS */
+#define IEEE80211_MAX_FRAME_LEN		2352
 
 #define IEEE80211_MAX_SSID_LEN		32
 


