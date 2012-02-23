Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1403 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab2BWRii (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 12:38:38 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 2/2] brcm80211: smac: only print block-ack timeout
 message at trace level
Date: Thu, 23 Feb 2012 18:38:23 +0100
Message-ID: <1330018703-2472-3-git-send-email-arend@broadcom.com> (sfid-20120223_183842_516318_F606906D)
In-Reply-To: <1330018703-2472-1-git-send-email-arend@broadcom.com>
References: <1330018703-2472-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In regular use block-ack timeouts can happen so it does not make
sense to fill the log with these messages.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index 9265226..30b5887 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -1070,9 +1070,9 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				    IEEE80211_TX_STAT_AMPDU_NO_BACK;
 				skb_pull(p, D11_PHY_HDR_LEN);
 				skb_pull(p, D11_TXH_LEN);
-				wiphy_err(wiphy, "%s: BA Timeout, seq %d, in_"
-					"transit %d\n", "AMPDU status", seq,
-					ini->tx_in_transit);
+				BCMMSG(wiphy,
+				       "BA Timeout, seq %d, in_transit %d\n",
+				       seq, ini->tx_in_transit);
 				ieee80211_tx_status_irqsafe(wlc->pub->ieee_hw,
 							    p);
 			}
-- 
1.7.5.4


