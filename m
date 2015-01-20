Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:34141 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbbATKn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 05:43:26 -0500
Received: by mail-we0-f169.google.com with SMTP id p10so12778657wes.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2015 02:43:25 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: fix pmf for wmi-tlv on qca6174
Date: Tue, 20 Jan 2015 11:42:43 +0100
Message-Id: <1421750563-15945-2-git-send-email-michal.kazior@tieto.com> (sfid-20150120_114330_062597_3D4EB444)
In-Reply-To: <1421750563-15945-1-git-send-email-michal.kazior@tieto.com>
References: <1421750563-15945-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marek Kwaczynski <marek.kwaczynski@tieto.com>

New wmi-tlv firmware uses HTT 3.0 protocol which
uses TX_FRM command for management frames (instead
of a dedicated command). To support PMF it is
necessary to provide explicit tailroom.

Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 5c64139..5780b87 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -481,6 +481,12 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	}
 	skb_cb->htt.txbuf_paddr = paddr;
 
+	if ((ieee80211_is_action(hdr->frame_control) ||
+	     ieee80211_is_deauth(hdr->frame_control) ||
+	     ieee80211_is_disassoc(hdr->frame_control)) &&
+	     ieee80211_has_protected(hdr->frame_control))
+		skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
+
 	skb_cb->paddr = dma_map_single(dev, msdu->data, msdu->len,
 				       DMA_TO_DEVICE);
 	res = dma_mapping_error(dev, skb_cb->paddr);
-- 
1.8.5.3

