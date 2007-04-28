Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:52990 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965967AbXD1QmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 12:42:09 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 4/7] mac80211: eliminate forward declarations in ieee80211.c
Date: Sat, 28 Apr 2007 12:36:02 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070428163601.27203.53866.stgit@magic.sourmilk.net>
In-Reply-To: <20070428163601.27203.32016.stgit@magic.sourmilk.net>
References: <20070428163601.27203.32016.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

ieee80211_get_bssid can be moved up in ieee80211 to avoid declaring it at
the top of the file. ieee80211_mgmt_start_xmit is used after it's defined
so it doesn't need to be declared at the top.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211.c |   73 +++++++++++++++++++++-------------------------
 1 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 66fb4db..4fd2300 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -55,11 +55,6 @@ static const unsigned char eapol_header[] =
 	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00, 0x88, 0x8e };
 
 
-static u8 * ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len);
-
-static int ieee80211_mgmt_start_xmit(struct sk_buff *skb,
-				     struct net_device *dev);
-
 static inline void ieee80211_include_sequence(struct ieee80211_sub_if_data *sdata,
 					      struct ieee80211_hdr *hdr)
 {
@@ -250,6 +245,40 @@ static void ieee80211_key_threshold_notify(struct net_device *dev,
 }
 
 
+static u8 * ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len)
+{
+	u16 fc;
+
+	if (len < 24)
+		return NULL;
+
+	fc = le16_to_cpu(hdr->frame_control);
+
+	switch (fc & IEEE80211_FCTL_FTYPE) {
+	case IEEE80211_FTYPE_DATA:
+		switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
+		case IEEE80211_FCTL_TODS:
+			return hdr->addr1;
+		case (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS):
+			return NULL;
+		case IEEE80211_FCTL_FROMDS:
+			return hdr->addr2;
+		case 0:
+			return hdr->addr3;
+		}
+		break;
+	case IEEE80211_FTYPE_MGMT:
+		return hdr->addr3;
+	case IEEE80211_FTYPE_CTL:
+		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)
+			return hdr->addr1;
+		else
+			return NULL;
+	}
+
+	return NULL;
+}
+
 int ieee80211_get_hdrlen(u16 fc)
 {
 	int hdrlen = 24;
@@ -3654,40 +3683,6 @@ ieee80211_rx_h_passive_scan(struct ieee80211_txrx_data *rx)
 }
 
 
-static u8 * ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len)
-{
-	u16 fc;
-
-	if (len < 24)
-		return NULL;
-
-	fc = le16_to_cpu(hdr->frame_control);
-
-	switch (fc & IEEE80211_FCTL_FTYPE) {
-	case IEEE80211_FTYPE_DATA:
-		switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
-		case IEEE80211_FCTL_TODS:
-			return hdr->addr1;
-		case (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS):
-			return NULL;
-		case IEEE80211_FCTL_FROMDS:
-			return hdr->addr2;
-		case 0:
-			return hdr->addr3;
-		}
-		break;
-	case IEEE80211_FTYPE_MGMT:
-		return hdr->addr3;
-	case IEEE80211_FTYPE_CTL:
-		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)
-			return hdr->addr1;
-		else
-			return NULL;
-	}
-
-	return NULL;
-}
-
 static void ieee80211_rx_michael_mic_report(struct net_device *dev,
 					    struct ieee80211_hdr *hdr,
 					    struct sta_info *sta,

