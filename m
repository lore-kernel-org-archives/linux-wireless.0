Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4670 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757901Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 024/119] staging: brcm80211: Changed comments
Date: Wed, 29 Jun 2011 16:46:48 -0700
Message-ID: <1309391303-22741-25-git-send-email-frankyl@broadcom.com> (sfid-20110630_015006_316630_D24C9E0E)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. BCM4321 is not supported by this driver. Removed 'XXX' in
comments since they do not signal a critical issue to be patched. Removed
FIXME in comment since it signalled a problem in the Minstrel algorithm,
not in our driver.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/bmac.c        |    1 -
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    7 +------
 drivers/staging/brcm80211/brcmsmac/main.c        |    2 +-
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index 735230f..bdaad20 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -3567,7 +3567,6 @@ u16 brcms_b_rate_shm_offset(struct brcms_c_hw_info *wlc_hw, u8 rate)
 	u8 phy_rate, index;
 
 	/* get the phy specific rate encoding for the PLCP SIGNAL field */
-	/* XXX4321 fixup needed ? */
 	if (IS_OFDM(rate))
 		table_ptr = M_RT_DIRMAP_A;
 	else
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index c74c186..caab99a 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -644,7 +644,7 @@ brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 				  tid);
 			return -EINVAL;
 		}
-		/* XXX: Use the starting sequence number provided ... */
+		/* Future improvement: Use the starting sequence number provided ... */
 		*ssn = 0;
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
@@ -1089,11 +1089,6 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
 
 	hw->extra_tx_headroom = brcms_c_get_header_len();
 	hw->queues = N_TX_QUEUES;
-	/* FIXME: this doesn't seem to be used properly in minstrel_ht.
-	 * mac80211/status.c:ieee80211_tx_status() checks this value,
-	 * but mac80211/rc80211_minstrel_ht.c:minstrel_ht_get_rate()
-	 * appears to always set 3 rates
-	 */
 	hw->max_rates = 2;	/* Primary rate and 1 fallback rate */
 
 	hw->channel_change_time = 7 * 1000;	/* channel change time is dependent on chip and band  */
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 64f4fe7..90293fa 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -3166,7 +3166,7 @@ void brcms_c_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 				  "\n", wlc->pub->unit);
 
 		/*
-		 * XXX we might hit this condtion in case
+		 * we might hit this condtion in case
 		 * packet flooding from mac80211 stack
 		 */
 		brcmu_pkt_buf_free_skb(sdu);
-- 
1.7.1


