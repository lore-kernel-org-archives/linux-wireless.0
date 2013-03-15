Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36449
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754965Ab3COSeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 14:34:37 -0400
Date: Fri, 15 Mar 2013 14:34:33 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Wojciech.Dubowik@neratec.com, mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.9] ath9k_hw: revert chainmask to user configuration
 after calibration
Message-ID: <20130315183433.GA2676@bombadil.infradead.org> (sfid-20130315_193503_660243_E001AC5C)
References: <1363355611-10426-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363355611-10426-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 15, 2013 at 02:53:31PM +0100, Felix Fietkau wrote:
> The commit 'ath9k_hw: fix calibration issues on chainmask that don't
> include chain 0' changed the hardware chainmask to the chip chainmask
> for the duration of the calibration, but the revert to user
> configuration in the reset path runs too early.
> 
> That causes some issues with limiting the number of antennas (including
> spurious failure in hardware-generated packets).
> 
> Fix this by reverting the chainmask after the essential parts of the
> calibration that need the workaround, and before NF calibration is run.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Reported-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
> Tested-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
> Cc: stable@vger.kernel.org

This applies to v3.8 as well with the following changes, do you want
it there as well?

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 56317b0..e99f481 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -976,6 +976,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 					  AR_PHY_CL_TAB_1,
 					  AR_PHY_CL_TAB_2 };
 
+	/* Use chip chainmask only for calibration */
 	ar9003_hw_set_chain_masks(ah, ah->caps.rx_chainmask, ah->caps.tx_chainmask);
 
 	if (rtt) {
@@ -1131,6 +1132,9 @@ skip_tx_iqcal:
 		ar9003_hw_rtt_disable(ah);
 	}
 
+	/* Revert chainmask to runtime parameters */
+	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
+
 	/* Initialize list pointers */
 	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
 	ah->supp_cals = IQ_MISMATCH_CAL;
