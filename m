Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:35151 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab2LKNzK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 08:55:10 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH 3/3] p54: zero-out rx_status
Date: Tue, 11 Dec 2012 14:55:05 +0100
Message-Id: <1355234105-12013-3-git-send-email-juhosg@openwrt.org> (sfid-20121211_145517_352823_85DAEB69)
In-Reply-To: <1355234105-12013-1-git-send-email-juhosg@openwrt.org>
References: <1355234105-12013-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 'mac80211: support radiotap vendor namespace RX data'
new fields were added to 'struct ieee80211_rx_status'.
The ath5k driver does not initializes those fields and
this can cause unexpected behaviour. The patch ensures
that each field gets initialized with zeroes.

Cc: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Compile tested only.
---
 drivers/net/wireless/p54/txrx.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 12f0a34..be2552e 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -345,6 +345,8 @@ static int p54_rx_data(struct p54_common *priv, struct sk_buff *skb)
 	if (!(hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_IN_FCS_GOOD)))
 		return 0;
 
+	memset(rx_status, 0, sizeof(*rx_status));
+
 	if (hdr->decrypt_status == P54_DECRYPT_OK)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 	if ((hdr->decrypt_status == P54_DECRYPT_FAIL_MICHAEL) ||
-- 
1.7.10

