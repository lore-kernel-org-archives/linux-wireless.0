Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:60927 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab2AWOk1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 09:40:27 -0500
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH 1/2] mac80211: Add STBC RX flag to radiotap. Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Date: Mon, 23 Jan 2012 15:27:40 +0100
Message-Id: <1327328861-7223-2-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20120123_154031_588584_A7A34697)
In-Reply-To: <1327328861-7223-1-git-send-email-Wojciech.Dubowik@neratec.com>
References: <1327328861-7223-1-git-send-email-Wojciech.Dubowik@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 include/net/ieee80211_radiotap.h |    3 ++-
 include/net/mac80211.h           |    1 +
 net/mac80211/rx.c                |    5 ++++-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index 7139254..e5b89c4 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -260,6 +260,7 @@ enum ieee80211_radiotap_type {
 #define IEEE80211_RADIOTAP_MCS_HAVE_GI		0x04
 #define IEEE80211_RADIOTAP_MCS_HAVE_FMT		0x08
 #define IEEE80211_RADIOTAP_MCS_HAVE_FEC		0x10
+#define IEEE80211_RADIOTAP_MCS_HAVE_STBC	0x20
 
 #define IEEE80211_RADIOTAP_MCS_BW_MASK		0x03
 #define		IEEE80211_RADIOTAP_MCS_BW_20	0
@@ -269,7 +270,7 @@ enum ieee80211_radiotap_type {
 #define IEEE80211_RADIOTAP_MCS_SGI		0x04
 #define IEEE80211_RADIOTAP_MCS_FMT_GF		0x08
 #define IEEE80211_RADIOTAP_MCS_FEC_LDPC		0x10
-
+#define IEEE80211_RADIOTAP_MCS_STBC		0x20
 
 /* helpers */
 static inline int ieee80211_get_radiotap_len(unsigned char *data)
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d49928b..aed6ef1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -672,6 +672,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_HT		= 1<<9,
 	RX_FLAG_40MHZ		= 1<<10,
 	RX_FLAG_SHORT_GI	= 1<<11,
+	RX_FLAG_STBC		= 1<<12,
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7514091..da23b6b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -204,12 +204,15 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
 		*pos++ = IEEE80211_RADIOTAP_MCS_HAVE_MCS |
 			 IEEE80211_RADIOTAP_MCS_HAVE_GI |
-			 IEEE80211_RADIOTAP_MCS_HAVE_BW;
+			 IEEE80211_RADIOTAP_MCS_HAVE_BW |
+			 IEEE80211_RADIOTAP_MCS_HAVE_STBC;
 		*pos = 0;
 		if (status->flag & RX_FLAG_SHORT_GI)
 			*pos |= IEEE80211_RADIOTAP_MCS_SGI;
 		if (status->flag & RX_FLAG_40MHZ)
 			*pos |= IEEE80211_RADIOTAP_MCS_BW_40;
+		if (status->flag & RX_FLAG_STBC)
+			*pos |= IEEE80211_RADIOTAP_MCS_STBC;
 		pos++;
 		*pos++ = status->rate_idx;
 	}
-- 
1.7.4.1

