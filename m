Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A18C10F12
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 10:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5524A21773
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 10:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555495870;
	bh=PHXH7oO3YS/t6Api2JZ9ouPaDnz5jd0J4WNhC2wH6WU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=LgUY+TjkMoD3IlHbsLJ995fv0ePrNbwmtCIHIkAttwWGSBOLGdg7fpcsxd9+gXyQM
	 lHcri8hZRQY7LAA7UjLSe0xV5nliHWK+G2VZMg53UDEsulfYZd421We9iyTMbnuNoI
	 O7XLFIzSRvo0J35NpIgQ/RLOVwWokTCCD36ER6hQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730813AbfDQKLF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 06:11:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:57486 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729039AbfDQKLF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 06:11:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BA12AAF8C;
        Wed, 17 Apr 2019 10:11:03 +0000 (UTC)
Date:   Wed, 17 Apr 2019 12:11:02 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH] iwlwifi: don't panic in error path on non-msix systems
Message-ID: <20190417101102.GA5878@dhcp22.suse.cz>
References: <748205b02961167b0926d4afe8d9ad9cb37bf6ef.camel@coelho.fi>
 <20190417073516.24250-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417073516.24250-1-luca@coelho.fi>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,
which tree is this supposed to be applied on? It doesn't do apply on top
of v5.1-rc4-3-gfd008d1a7a20. iwl_trans_pcie_sync_nmi doesn't exist in
drivers/net/wireless/intel/iwlwifi/pcie/trans.c. iwl_trans_sync_nmi
looks pretty similar. My patch massaging ended up with this. Please
double check. It compiles and even boots.

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index fe8269d023de..1f3969e2bcac 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3639,20 +3639,27 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 
 void iwl_trans_sync_nmi(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	unsigned long timeout = jiffies + IWL_TRANS_NMI_TIMEOUT;
+	u32 inta_addr, sw_err_bit;
+
+	if (trans_pcie->msix_enabled) {
+		inta_addr = CSR_MSIX_HW_INT_CAUSES_AD;
+		sw_err_bit = MSIX_HW_INT_CAUSES_REG_SW_ERR;
+	} else {
+		inta_addr = CSR_INT;
+		sw_err_bit = CSR_INT_BIT_SW_ERR;
+	}
 
 	iwl_disable_interrupts(trans);
 	iwl_force_nmi(trans);
 	while (time_after(timeout, jiffies)) {
-		u32 inta_hw = iwl_read32(trans,
-					 CSR_MSIX_HW_INT_CAUSES_AD);
+		u32 inta_hw = iwl_read32(trans, inta_addr);
 
 		/* Error detected by uCode */
-		if (inta_hw & MSIX_HW_INT_CAUSES_REG_SW_ERR) {
+		if (inta_hw & sw_err_bit) {
 			/* Clear causes register */
-			iwl_write32(trans, CSR_MSIX_HW_INT_CAUSES_AD,
-				    inta_hw &
-				    MSIX_HW_INT_CAUSES_REG_SW_ERR);
+			iwl_write32(trans, inta_addr, inta_hw & sw_err_bit);
 			break;
 		}
 
-- 
Michal Hocko
SUSE Labs
