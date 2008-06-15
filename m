Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:65412 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbYFOGdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 02:33:44 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3882106waf.23
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2008 23:33:44 -0700 (PDT)
Subject: [PATCH 4/4] b43legacy: use frame control helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Jun 2008 23:33:40 -0700
Message-Id: <1213511620.11544.34.camel@brick> (sfid-20080615_083347_209837_62B07409)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43legacy/xmit.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/xmit.c b/drivers/net/wireless/b43legacy/xmit.c
index 82dc04d..a354078 100644
--- a/drivers/net/wireless/b43legacy/xmit.c
+++ b/drivers/net/wireless/b43legacy/xmit.c
@@ -442,7 +442,7 @@ void b43legacy_rx(struct b43legacy_wldev *dev,
 	struct b43legacy_plcp_hdr6 *plcp;
 	struct ieee80211_hdr *wlhdr;
 	const struct b43legacy_rxhdr_fw3 *rxhdr = _rxhdr;
-	u16 fctl;
+	__le16 fctl;
 	u16 phystat0;
 	u16 phystat3;
 	u16 chanstat;
@@ -480,7 +480,7 @@ void b43legacy_rx(struct b43legacy_wldev *dev,
 		goto drop;
 	}
 	wlhdr = (struct ieee80211_hdr *)(skb->data);
-	fctl = le16_to_cpu(wlhdr->frame_control);
+	fctl = wlhdr->frame_control;
 
 	if ((macstat & B43legacy_RX_MAC_DEC) &&
 	    !(macstat & B43legacy_RX_MAC_DECERR)) {
@@ -499,11 +499,11 @@ void b43legacy_rx(struct b43legacy_wldev *dev,
 
 		if (dev->key[keyidx].algorithm != B43legacy_SEC_ALGO_NONE) {
 			/* Remove PROTECTED flag to mark it as decrypted. */
-			B43legacy_WARN_ON(!(fctl & IEEE80211_FCTL_PROTECTED));
-			fctl &= ~IEEE80211_FCTL_PROTECTED;
-			wlhdr->frame_control = cpu_to_le16(fctl);
+			B43legacy_WARN_ON(!ieee80211_has_protected(fctl));
+			fctl &= ~cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+			wlhdr->frame_control = fctl;
 
-			wlhdr_len = ieee80211_get_hdrlen(fctl);
+			wlhdr_len = ieee80211_hdrlen(fctl);
 			if (unlikely(skb->len < (wlhdr_len + 3))) {
 				b43legacydbg(dev->wl, "RX: Packet size"
 					     " underrun3\n");
@@ -556,9 +556,7 @@ void b43legacy_rx(struct b43legacy_wldev *dev,
 	 * of timestamp, i.e. about 65 milliseconds after the PHY received
 	 * the first symbol.
 	 */
-	if (((fctl & (IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE))
-	    == (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON)) ||
-	    dev->wl->radiotap_enabled) {
+	if (ieee80211_is_beacon(fctl) || dev->wl->radiotap_enabled) {
 		u16 low_mactime_now;
 
 		b43legacy_tsf_read(dev, &status.mactime);
-- 
1.5.6.rc3.283.g198e

