Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:63755 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173AbaDPMd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2014 08:33:26 -0400
Received: by mail-ig0-f173.google.com with SMTP id hl10so949412igb.12
        for <linux-wireless@vger.kernel.org>; Wed, 16 Apr 2014 05:33:25 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, larrymaxwell@agilemesh.com,
	Bob Copeland <me@bobcopeland.com>,
	Bob Copeland <bob@cozybit.com>
Subject: [PATCH] mac80211: fixup radiotap tx flags for RTS/CTS
Date: Wed, 16 Apr 2014 08:32:41 -0400
Message-Id: <1397651561-29820-1-git-send-email-me@bobcopeland.com> (sfid-20140416_143330_146904_AAB621C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using RTS/CTS, the CTS-to-Self bit in radiotap TX flags is
getting set instead of the RTS bit.  Set the correct one.

Reported-by: Larry Maxwell <larrymaxwell@agilemesh.com>
Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/status.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index e6e574a..ea432ca 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -314,10 +314,9 @@ ieee80211_add_tx_radiotap_header(struct ieee80211_local *local,
 	    !is_multicast_ether_addr(hdr->addr1))
 		txflags |= IEEE80211_RADIOTAP_F_TX_FAIL;
 
-	if ((info->status.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) ||
-	    (info->status.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT))
+	if (info->status.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT)
 		txflags |= IEEE80211_RADIOTAP_F_TX_CTS;
-	else if (info->status.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
+	if (info->status.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
 		txflags |= IEEE80211_RADIOTAP_F_TX_RTS;
 
 	put_unaligned_le16(txflags, pos);
-- 
1.9.1

