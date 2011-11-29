Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5778 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab1K2OWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 09:22:30 -0500
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC] ath9k: validate for non-zero BSSID
Date: Tue, 29 Nov 2011 19:52:20 +0530
Message-ID: <1322576540-13751-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111129_152244_706868_4EC2D203)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

before concluding that the recieved beacon is for us, let us make sure
that the BSSID is non-zero.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 4c8e296..620230d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1824,6 +1824,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		hdr = (struct ieee80211_hdr *) (hdr_skb->data + rx_status_len);
 		rxs = IEEE80211_SKB_RXCB(hdr_skb);
 		if (ieee80211_is_beacon(hdr->frame_control) &&
+		    !is_zero_ether_addr(common->curbssid) &&
 		    !compare_ether_addr(hdr->addr3, common->curbssid))
 			rs.is_mybeacon = true;
 		else
-- 
1.7.0.4

