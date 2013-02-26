Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:62749 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759765Ab3BZSlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 13:41:55 -0500
Received: by mail-ie0-f176.google.com with SMTP id k13so4758993iea.7
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2013 10:41:55 -0800 (PST)
Date: Tue, 26 Feb 2013 13:41:52 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH] ath9k: simplify ATH_EP_RND
Message-ID: <20130226184152.GA7535@localhost> (sfid-20130226_194208_123595_33218216)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the embedded branch to make the ATH_EP_RND macro a little
clearer.  The new version also generates better code, saving 24
bytes of text:

   text	   data	    bss	    dec	    hex	filename
  87858	   1641	     24	  89523	  15db3	ath9k_orig.ko
  87834	   1641	     24	  89499	  15d9b	ath9k_new.ko

Although neither version handles negative values particularly well,
the lone caller clamps all negative values to zero anyway.  I have
verified that the results are the same for the range of possible
positive rssi values.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath9k/common.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 5f845be..eca95a0 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -40,7 +40,7 @@
 	x = ATH_LPF_RSSI((x), ATH_RSSI_IN((y)), ATH_RSSI_LPF_LEN);  	\
 } while (0)
 #define ATH_EP_RND(x, mul) 						\
-	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
+	(((x) + ((mul)/2)) / (mul))
 
 int ath9k_cmn_padpos(__le16 frame_control);
 int ath9k_cmn_get_hw_crypto_keytype(struct sk_buff *skb);
-- 
1.7.2.5

-- 
Bob Copeland %% www.bobcopeland.com
