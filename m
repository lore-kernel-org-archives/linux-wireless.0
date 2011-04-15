Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:45359 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1DOFBX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 01:01:23 -0400
Date: Fri, 15 Apr 2011 10:23:29 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH 1/2] mac80211: Adding HW flag IEEE80211_HW_CRYPTO_ENABLED
Message-ID: <20110415045321.GA11504@hertz.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When drivers use HW crypto, reservation for tail room is not needed for
any crypto suite. Do not reserve tail room in such cases, this helps in
optimizing the transmit path.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 include/net/mac80211.h |    5 +++++
 net/mac80211/tx.c      |    9 +++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6c9c4e9..dcd7828 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1081,6 +1081,10 @@ enum ieee80211_tkip_key_type {
  *	stations based on the PM bit of incoming frames.
  *	Use ieee80211_start_ps()/ieee8021_end_ps() to manually configure
  *	the PS mode of connected stations.
+ *
+ *	@IEEE80211_HW_SUPPORTS_HW_CRYPTO:
+ *  Set by drivers when crypto is being done in the hardware. Drivers using SW
+ *  crypto should not set this flag.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1106,6 +1110,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_CQM_RSSI			= 1<<20,
 	IEEE80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
 	IEEE80211_HW_AP_LINK_PS				= 1<<22,
+	IEEE80211_HW_CRYPTO_ENABLED			= 1<<23,
 };
 
 /**
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 17b10be..a80fc1a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1483,11 +1483,12 @@ static int ieee80211_skb_resize(struct ieee80211_local *local,
 	int tail_need = 0;
 
 	/*
-	 * This could be optimised, devices that do full hardware
-	 * crypto (including TKIP MMIC) need no tailroom... But we
-	 * have no drivers for such devices currently.
+	 * When full HW crypto is being used by the driver,
+	 * no tail room is needed. Hence do not ask for tail room
+	 * in such cases. This will avoid copying the skb in
+	 * pskb_expand_head.
 	 */
-	if (may_encrypt) {
+	if (!(local->hw.flags & IEEE80211_HW_CRYPTO_ENABLED) && may_encrypt) {
 		tail_need = IEEE80211_ENCRYPT_TAILROOM;
 		tail_need -= skb_tailroom(skb);
 		tail_need = max_t(int, tail_need, 0);
-- 
1.7.3.5

