Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:61735 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab0EHAlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 20:41:24 -0400
Received: by bwz19 with SMTP id 19so868345bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 07 May 2010 17:41:22 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: [RFC] minstrel_ht: refine STBC handling
Date: Sat, 8 May 2010 02:41:16 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201005080241.16634.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The maximum number of space time streams should be determined
by the RX STBC bits in the HT capabilities of the HT peer.

Note 1:
	The specification (I've 802.11n D8.0) also states	that the
	Rx MCS Bitmask subfield of the Supported MCS Set field also
	has some weight in the STBC stream equation.
	But unless I'm totally wrong here, minstrel_ht already takes
	that into account by filtering out unsupported MCS rates, right?

Note 2:
	The "if" check looks suspicious, OUR hardware must be have the
	IEEE80211_HT_CAP_TX_STBC capability and not the peer?!
---
And now to something completely different:

I noticed that only the peer's HT capabilities are fully evaluated,
but the actual capabilities of the sending device (stored
in sband->ht_cap.cap) are not considered.

Theoretically, this shouldn't be an issue, simply because if the
hardware does not support the feature, the driver will almost
certainly ignore the spurious flag.
---
--- a/net/mac80211/rc80211_minstrel_ht.c	2010-05-08 01:46:14.000000000 +0200
+++ b/net/mac80211/rc80211_minstrel_ht.c	2010-05-08 01:45:17.000000000 +0200
@@ -663,8 +663,10 @@ minstrel_ht_update_caps(void *priv, stru
 	}
 	mi->sample_tries = 4;
 
-	if (sta_cap & IEEE80211_HT_CAP_TX_STBC)
-		mi->tx_flags |= IEEE80211_TX_CTL_STBC;
+	if (sband->ht_cap.cap & IEEE80211_HT_CAP_TX_STBC) {
+		mi->tx_flags |= ((sta_cap >> IEEE80211_HT_CAP_RX_STBC_SHIFT)
+				& 3) << IEEE80211_TX_CTL_STBC_SHIFT;
+	}
 
 	if (sta_cap & IEEE80211_HT_CAP_LDPC_CODING)
 		mi->tx_flags |= IEEE80211_TX_CTL_LDPC;
