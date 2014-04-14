Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:64948 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaDNJ2M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 05:28:12 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so6353318eek.36
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2014 02:28:11 -0700 (PDT)
From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc: johannes@sipsolutions.net,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH 1/2 V3] mac80211: add option to generate CCMP IVs only for mgmt frames
Date: Mon, 14 Apr 2014 11:27:21 +0200
Message-Id: <1397467642-23544-1-git-send-email-marek.kwaczynski@tieto.com> (sfid-20140414_112831_677190_53A6FB3D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some chips can encrypt managment frames in HW, but
require generated IV in the frame. Add a key flag
that allows us to achieve this.

Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
---
 include/net/mac80211.h |   16 ++++++++++------
 net/mac80211/wpa.c     |    5 ++++-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2de7ff4..80d7a5e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1202,14 +1202,18 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
  *	fall back to software crypto. Note that this flag deals only with
  *	RX, if your crypto engine can't deal with TX you can also set the
  *	%IEEE80211_KEY_FLAG_SW_MGMT_TX flag to encrypt such frames in SW.
+ * @IEEE80211_KEY_FLAG_GENERATE_IV_MGMT: This flag should be set by the
+ *	driver for a CCMP key to indicate that is requires IV generation
+ *	only for managment frames (MFP).
  */
 enum ieee80211_key_flags {
-	IEEE80211_KEY_FLAG_GENERATE_IV	= 1<<1,
-	IEEE80211_KEY_FLAG_GENERATE_MMIC= 1<<2,
-	IEEE80211_KEY_FLAG_PAIRWISE	= 1<<3,
-	IEEE80211_KEY_FLAG_SW_MGMT_TX	= 1<<4,
-	IEEE80211_KEY_FLAG_PUT_IV_SPACE = 1<<5,
-	IEEE80211_KEY_FLAG_RX_MGMT	= 1<<6,
+	IEEE80211_KEY_FLAG_GENERATE_IV		= BIT(1),
+	IEEE80211_KEY_FLAG_GENERATE_MMIC	= BIT(2),
+	IEEE80211_KEY_FLAG_PAIRWISE		= BIT(3),
+	IEEE80211_KEY_FLAG_SW_MGMT_TX		= BIT(4),
+	IEEE80211_KEY_FLAG_PUT_IV_SPACE		= BIT(5),
+	IEEE80211_KEY_FLAG_RX_MGMT		= BIT(6),
+	IEEE80211_KEY_FLAG_GENERATE_IV_MGMT	= BIT(7),
 };
 
 /**
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index b8600e3..5b16a36 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -406,7 +406,10 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 
 	if (info->control.hw_key &&
 	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) &&
-	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)) {
+	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
+	    !((info->control.hw_key->flags &
+	      IEEE80211_KEY_FLAG_GENERATE_IV_MGMT) &&
+	      ieee80211_is_mgmt(hdr->frame_control))) {
 		/*
 		 * hwaccel has no need for preallocated room for CCMP
 		 * header or MIC fields
-- 
1.7.9.5

