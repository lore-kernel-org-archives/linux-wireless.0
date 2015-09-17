Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49160 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbbIQQlb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 12:41:31 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wil6210: remove MCS radiotap field
Date: Thu, 17 Sep 2015 18:41:22 +0200
Message-Id: <1442508082-16518-1-git-send-email-johannes@sipsolutions.net> (sfid-20150917_184140_490451_C41B8363)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The MCS radiotap field was really intended for HT MCS (and the
radiotap spec does indiciate that) and dissectors treat it as
meaning the frame was a HT frame. Therefore, inclusion of it
in a 60GHz device is misleading.

Cf. the thread at
http://mid.gmane.org/CACyXjPzq-ePB1ux6wi_Rv3onPKXomcJcm15XJwA51u0E4W2txw@mail.gmail.com

Remove the field for now, until a proper 60 GHz PHY information
field is defined.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 6229110d558a..19bf5d4d3e44 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -270,10 +270,6 @@ static void wil_rx_add_radiotap_header(struct wil6210_priv *wil,
 		/* channel */
 		__le16 chnl_freq __aligned(2);
 		__le16 chnl_flags;
-		/* MCS */
-		u8 mcs_present;
-		u8 mcs_flags;
-		u8 mcs_index;
 	} __packed;
 	struct wil6210_rtap_vendor {
 		struct wil6210_rtap rtap;
@@ -329,18 +325,13 @@ static void wil_rx_add_radiotap_header(struct wil6210_priv *wil,
 	rtap_vendor->rtap.rthdr.it_len = cpu_to_le16(rtap_len);
 	rtap_vendor->rtap.rthdr.it_present = cpu_to_le32(
 			(1 << IEEE80211_RADIOTAP_FLAGS) |
-			(1 << IEEE80211_RADIOTAP_CHANNEL) |
-			(1 << IEEE80211_RADIOTAP_MCS));
+			(1 << IEEE80211_RADIOTAP_CHANNEL));
 	if (d->dma.status & RX_DMA_STATUS_ERROR)
 		rtap_vendor->rtap.flags |= IEEE80211_RADIOTAP_F_BADFCS;
 
 	rtap_vendor->rtap.chnl_freq = cpu_to_le16(ch ? ch->center_freq : 58320);
 	rtap_vendor->rtap.chnl_flags = cpu_to_le16(0);
 
-	rtap_vendor->rtap.mcs_present = IEEE80211_RADIOTAP_MCS_HAVE_MCS;
-	rtap_vendor->rtap.mcs_flags = 0;
-	rtap_vendor->rtap.mcs_index = wil_rxdesc_mcs(d);
-
 	if (rtap_include_phy_info) {
 		rtap_vendor->rtap.rthdr.it_present |= cpu_to_le32(1 <<
 				IEEE80211_RADIOTAP_VENDOR_NAMESPACE);
-- 
2.5.1

