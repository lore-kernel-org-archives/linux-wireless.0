Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60402 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbYBTSb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:31:57 -0500
Subject: [PATCH] adm8211: fix sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 12:06:47 +0100
Message-Id: <1203505607.17534.24.camel@johannes.berg> (sfid-20080220_183200_343589_E1E964EB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both of these seem to be actual errors, the first is just wrong
and the second is my mistake introduced by the cfg80211 API
update.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/adm8211.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- everything.orig/drivers/net/wireless/adm8211.c	2008-02-20 11:51:01.000000000 +0100
+++ everything/drivers/net/wireless/adm8211.c	2008-02-20 11:55:17.000000000 +0100
@@ -1109,7 +1109,7 @@ static void adm8211_hw_init(struct ieee8
 	u32 reg;
 	u8 cline;
 
-	reg = le32_to_cpu(ADM8211_CSR_READ(PAR));
+	reg = ADM8211_CSR_READ(PAR);
 	reg |= ADM8211_PAR_MRLE | ADM8211_PAR_MRME;
 	reg &= ~(ADM8211_PAR_BAR | ADM8211_PAR_CAL);
 
@@ -1702,13 +1702,9 @@ static int adm8211_tx(struct ieee80211_h
 	int plcp, dur, len, plcp_signal, short_preamble;
 	struct ieee80211_hdr *hdr;
 
-	if (control->tx_rate < 0) {
-		short_preamble = 1;
-		plcp_signal = -control->tx_rate->bitrate;
-	} else {
-		short_preamble = 0;
-		plcp_signal = control->tx_rate->bitrate;
-	}
+	short_preamble = !!(control->tx_rate->flags &
+					IEEE80211_TXCTL_SHORT_PREAMBLE);
+	plcp_signal = control->tx_rate->bitrate;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = le16_to_cpu(hdr->frame_control) & ~IEEE80211_FCTL_PROTECTED;


