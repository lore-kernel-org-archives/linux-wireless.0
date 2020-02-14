Return-Path: <SRS0=dpF5=4C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FA9C2BA83
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 18:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C9D32086A
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 18:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581704571;
	bh=iuyIbYzgZDi9u7sIMIx8Fd9TnuJLfU1RqCaPaTF+SmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=aDCvmYdlklBi/15dmY4mk38HMfI6FA24fNnZ9bq5ftVzdvUkUBBBtN3yBeEMX82Di
	 2OXe2FHO40CWAkxABF5uYIXMdyxGSI7N9j8TQLs3RlUvbHZPrdZEtevgODYSJeT4kn
	 3aX9AgVFPJhpzx/lHxPDtrCHHLKKagFaQvIWFABU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbgBNPta (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Feb 2020 10:49:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:52410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729953AbgBNPt3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Feb 2020 10:49:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBF0224687;
        Fri, 14 Feb 2020 15:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695368;
        bh=iuyIbYzgZDi9u7sIMIx8Fd9TnuJLfU1RqCaPaTF+SmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORHK1QJVabjLDsbGFSl0uk+bWOwMCMruSJIX23aDOoRrh0Os4DQss7KiLSqGPP8MB
         kbLCa3zbfeDDXOEVWkdr3hpYd3m+VW5FoMclQV2Wrhb7vcy5Tzdql0HN85gPjhho4r
         A0R77pDk3Gk8IEHtcO2O3Bf3+CiA3fm9LyzHgoRI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 026/542] brcmfmac: Fix memory leak in brcmf_p2p_create_p2pdev()
Date:   Fri, 14 Feb 2020 10:40:18 -0500
Message-Id: <20200214154854.6746-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 5cc509aa83c6acd2c5cd94f99065c39d2bd0a490 ]

In the implementation of brcmf_p2p_create_p2pdev() the allocated memory
for p2p_vif is leaked when the mac address is the same as primary
interface. To fix this, go to error path to release p2p_vif via
brcmf_free_vif().

Fixes: cb746e47837a ("brcmfmac: check p2pdev mac address uniqueness")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 7ba9f6a686459..1f5deea5a288e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -2092,7 +2092,8 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	/* firmware requires unique mac address for p2pdev interface */
 	if (addr && ether_addr_equal(addr, pri_ifp->mac_addr)) {
 		bphy_err(drvr, "discovery vif must be different from primary interface\n");
-		return ERR_PTR(-EINVAL);
+		err = -EINVAL;
+		goto fail;
 	}
 
 	brcmf_p2p_generate_bss_mac(p2p, addr);
-- 
2.20.1

