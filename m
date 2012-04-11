Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3501 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755188Ab2DKJxd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:53:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>, stable@vger.kernel.org
Subject: [PATCH 9/9] brcm80211: smac: resume transmit fifo upon
 receiving frames
Date: Wed, 11 Apr 2012 11:52:51 +0200
Message-ID: <1334137971-3972-10-git-send-email-arend@broadcom.com> (sfid-20120411_115338_861664_9BE75401)
In-Reply-To: <1334137971-3972-1-git-send-email-arend@broadcom.com>
References: <1334137971-3972-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There have been reports about not being able to use access-points
on channel 12 and 13 or having connectivity issues when these channels
were part of the selected regulatory domain. Upon switching to these
channels the brcmsmac driver suspends the transmit dma fifos. This
patch resumes them upon handing over the first received beacon to
mac80211.

This patch is to be applied to the stable tree for kernel versions
3.2 and 3.3.

Cc: stable@vger.kernel.org
Tested-by: Francesco Saverio Schiavarelli <fschiava@libero.it>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 231ddf4..7083db7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7614,6 +7614,7 @@ brcms_c_recvctl(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 {
 	int len_mpdu;
 	struct ieee80211_rx_status rx_status;
+	struct ieee80211_hdr *hdr;
 
 	memset(&rx_status, 0, sizeof(rx_status));
 	prep_mac80211_status(wlc, rxh, p, &rx_status);
@@ -7623,6 +7624,13 @@ brcms_c_recvctl(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 	skb_pull(p, D11_PHY_HDR_LEN);
 	__skb_trim(p, len_mpdu);
 
+	/* unmute transmit */
+	if (wlc->hw->suspended_fifos) {
+		hdr = (struct ieee80211_hdr *)p->data;
+		if (ieee80211_is_beacon(hdr->frame_control))
+			brcms_b_mute(wlc->hw, false);
+	}
+
 	memcpy(IEEE80211_SKB_RXCB(p), &rx_status, sizeof(rx_status));
 	ieee80211_rx_irqsafe(wlc->pub->ieee_hw, p);
 }
-- 
1.7.5.4


