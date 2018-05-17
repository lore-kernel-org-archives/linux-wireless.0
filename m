Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41164 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751293AbeEQOVK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 May 2018 10:21:10 -0400
Date: Thu, 17 May 2018 17:21:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: c_manoha@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] ath9k: Fix issue with MCS15
Message-ID: <20180517142100.GA22656@mwanda> (sfid-20180517_162113_819309_573405D9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Sujith Manoharan,

The patch 6fcbe538be43: "ath9k: Fix issue with MCS15" from Nov 14,
2013, leads to the following static checker warning:

	drivers/net/wireless/ath/ath9k/ar9003_phy.c:836 ar9003_doubler_fix()
	warn: 'ah->hw_version.macVersion == 448' 'false' implies 'ah->hw_version.macVersion == 448' is 'false'

drivers/net/wireless/ath/ath9k/ar9003_phy.c
   834  static void ar9003_doubler_fix(struct ath_hw *ah)
   835  {
   836          if (AR_SREV_9300(ah) || AR_SREV_9580(ah) || AR_SREV_9550(ah)) {

The problem is that both AR_SREV_VERSION_9300 and AR_SREV_VERSION_9580
are 0x1c0 so the test for AR_SREV_9580() is duplicative.

   837                  REG_RMW(ah, AR_PHY_65NM_CH0_RXTX2,
   838                          1 << AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK_S |
   839                          1 << AR_PHY_65NM_CH0_RXTX2_SYNTHOVR_MASK_S, 0);
   840                  REG_RMW(ah, AR_PHY_65NM_CH1_RXTX2,
   841                          1 << AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK_S |
   842                          1 << AR_PHY_65NM_CH0_RXTX2_SYNTHOVR_MASK_S, 0);
   843                  REG_RMW(ah, AR_PHY_65NM_CH2_RXTX2,
   844                          1 << AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK_S |
   845                          1 << AR_PHY_65NM_CH0_RXTX2_SYNTHOVR_MASK_S, 0);
   846  
   847                  udelay(200);
   848  

regards,
dan carpenter
