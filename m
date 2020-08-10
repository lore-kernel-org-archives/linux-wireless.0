Return-Path: <SRS0=Pq/w=BU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D85CAC433E0
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Aug 2020 19:23:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A280322BF3
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Aug 2020 19:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597087430;
	bh=Dvl4wZjTh9kZL21GzFmX/cOdrfrYvQ6it6+kPYs6ALY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=oGepr054fHidQHQ0tJ0ASZ7slwVtGghLbI8jAHMTtAikOX65LnIZYa18hiGHCmAiX
	 PMkPfxGS/ELHmjpTgTZKWGPcx+EcASJtNhmn21xt5SlQqk15CDYcb49g2yZuBjLD53
	 lBgVaBeTgkB6vIw/ZQV3YcwB7/wFqVcXe2jBU1pM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbgHJTXs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Aug 2020 15:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729604AbgHJTMn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Aug 2020 15:12:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D79AD22BEA;
        Mon, 10 Aug 2020 19:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086762;
        bh=Dvl4wZjTh9kZL21GzFmX/cOdrfrYvQ6it6+kPYs6ALY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLVuZGkA+mptuEM9VdwSWrNUlD68iHGEvIeGnGUgnucJeUeZ7z2zYkL4GlJhdgF9w
         IJiQlQ+R9FiWyxuHbPuaoJ1+zOScAT1mctEaMvSdyiB++8R7qq8Xao4lNtDC4erNg7
         tMCbSRpaTvbb1RHz+RniaVjfSxd4jUyYt3VCB5BU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bolarinwa Olayemi Saheed <refactormyself@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 34/45] iwlegacy: Check the return value of pcie_capability_read_*()
Date:   Mon, 10 Aug 2020 15:11:42 -0400
Message-Id: <20200810191153.3794446-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191153.3794446-1-sashal@kernel.org>
References: <20200810191153.3794446-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Bolarinwa Olayemi Saheed <refactormyself@gmail.com>

[ Upstream commit 9018fd7f2a73e9b290f48a56b421558fa31e8b75 ]

On failure pcie_capability_read_dword() sets it's last parameter, val
to 0. However, with Patch 14/14, it is possible that val is set to ~0 on
failure. This would introduce a bug because (x & x) == (~0 & x).

This bug can be avoided without changing the function's behaviour if the
return value of pcie_capability_read_dword is checked to confirm success.

Check the return value of pcie_capability_read_dword() to ensure success.

Suggested-by: Bjorn Helgaas <bjorn@helgaas.com>
Signed-off-by: Bolarinwa Olayemi Saheed <refactormyself@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200713175529.29715-3-refactormyself@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlegacy/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 746749f379964..1107b96a8a880 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -4286,8 +4286,8 @@ il_apm_init(struct il_priv *il)
 	 *    power savings, even without L1.
 	 */
 	if (il->cfg->set_l0s) {
-		pcie_capability_read_word(il->pci_dev, PCI_EXP_LNKCTL, &lctl);
-		if (lctl & PCI_EXP_LNKCTL_ASPM_L1) {
+		ret = pcie_capability_read_word(il->pci_dev, PCI_EXP_LNKCTL, &lctl);
+		if (!ret && (lctl & PCI_EXP_LNKCTL_ASPM_L1)) {
 			/* L1-ASPM enabled; disable(!) L0S  */
 			il_set_bit(il, CSR_GIO_REG,
 				   CSR_GIO_REG_VAL_L0S_ENABLED);
-- 
2.25.1

