Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbYCIVuv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:50:51 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:50:51 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 07/24] rt2x00: Use skbdesc fields for descriptor initialization
Date: Sun, 9 Mar 2008 22:41:53 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092241.53703.IvDoorn@gmail.com> (sfid-20080309_215058_422486_7C3ADFFA)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In rt2x00lib_write_tx_desc() the skb->data and skb->len fields
were incorrectly used. For USB drivers both of those values
contain invalid data (skb->data points to the device descriptor,
skb->len contains the frame _and_ descriptor length).

Instead of using the skbuffer fields we should use the skbdesc
fields which are correctly initialized and contain all the data
that we need.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 141b9b8..455d076 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -630,7 +630,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 {
 	struct txentry_desc txdesc;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skbdesc->data;
 	const struct rt2x00_rate *rate;
 	int tx_rate;
 	int length;
@@ -710,7 +710,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	txdesc.signal = rate->plcp;
 	txdesc.service = 0x04;
 
-	length = skb->len + FCS_LEN;
+	length = skbdesc->data_len + FCS_LEN;
 	if (rate->flags & DEV_RATE_OFDM) {
 		__set_bit(ENTRY_TXD_OFDM_RATE, &txdesc.flags);
 
-- 
1.5.4.3

