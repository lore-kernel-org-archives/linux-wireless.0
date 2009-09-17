Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:33896 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbZIQUuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 16:50:03 -0400
Received: from cpc2-whit1-0-0-cust96.cdif.cable.ntl.com ([82.13.80.97] helo=localhost.localdomain)
	by silver.sucs.swan.ac.uk with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <andy@andrewprice.me.uk>)
	id 1MoNOZ-0005UG-5M
	for linux-wireless@vger.kernel.org; Thu, 17 Sep 2009 21:15:59 +0100
From: Andrew Price <andy@andrewprice.me.uk>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2.6.31-gab86e57] rt2x00: fix the definition of rt2x00crypto_rx_insert_iv
Date: Thu, 17 Sep 2009 21:15:48 +0100
Message-Id: <1253218548-18329-1-git-send-email-andy@andrewprice.me.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the redundant l2pad parameter from the definition of
rt2x00crypto_rx_insert_iv which is used when only CONFIG_RT2500PCI but
none of the other rt2x00 family drivers is configured.

Signed-off-by: Andrew Price <andy@andrewprice.me.uk>
---
 drivers/net/wireless/rt2x00/rt2x00lib.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 5462cb5..567f029 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -380,7 +380,7 @@ static inline void rt2x00crypto_tx_insert_iv(struct sk_buff *skb,
 {
 }
 
-static inline void rt2x00crypto_rx_insert_iv(struct sk_buff *skb, bool l2pad,
+static inline void rt2x00crypto_rx_insert_iv(struct sk_buff *skb,
 					     unsigned int header_length,
 					     struct rxdone_entry_desc *rxdesc)
 {
-- 
1.6.3.3

