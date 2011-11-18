Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35683 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab1KRQC0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 11:02:26 -0500
Received: by mail-bw0-f46.google.com with SMTP id 11so3593117bke.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 08:02:25 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Fix endian bug in radiotap header generation
Date: Fri, 18 Nov 2011 17:02:16 +0100
Message-Id: <1321632136-9398-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111118_170230_102725_DBCC2E15)
In-Reply-To: <1321626702.10266.59.camel@jlt3.sipsolutions.net>
References: <1321626702.10266.59.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I intoduced this bug in commit a2fe81667410723d941a688e1958a49d67ca3346
"mac80211: Build TX radiotap header dynamically"

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/status.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index a9da6ee..46222ce 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -260,7 +260,7 @@ static void ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_radiotap_header *rthdr;
 	unsigned char *pos;
-	__le16 txflags;
+	u16 txflags;
 
 	rthdr = (struct ieee80211_radiotap_header *) skb_push(skb, rtap_len);
 
@@ -290,13 +290,13 @@ static void ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band
 	txflags = 0;
 	if (!(info->flags & IEEE80211_TX_STAT_ACK) &&
 	    !is_multicast_ether_addr(hdr->addr1))
-		txflags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_FAIL);
+		txflags |= IEEE80211_RADIOTAP_F_TX_FAIL;
 
 	if ((info->status.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) ||
 	    (info->status.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT))
-		txflags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_CTS);
+		txflags |= IEEE80211_RADIOTAP_F_TX_CTS;
 	else if (info->status.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
-		txflags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_RTS);
+		txflags |= IEEE80211_RADIOTAP_F_TX_RTS;
 
 	put_unaligned_le16(txflags, pos);
 	pos += 2;
-- 
1.7.3.4

