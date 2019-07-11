Return-Path: <SRS0=jAIi=VI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEC9C74A4B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Jul 2019 09:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD47420872
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Jul 2019 09:05:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fWftlEgt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbfGKJFZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Jul 2019 05:05:25 -0400
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:59786 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728281AbfGKJFY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jul 2019 05:05:24 -0400
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.224.233])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 997B430C01D;
        Thu, 11 Jul 2019 02:05:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com 997B430C01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1562835922;
        bh=PwGYLpSP/7zmnLKvb5ZRf5PXk/HMmEU0G4uiS0XmuEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWftlEgtXMeGJ+88WVRSK+JF7UzGGHMDBLUw8AaN+NbJwk5iksKYbiKfGGIvNE0eP
         PDRRWkc2+FhZNB4G/jmEd7MxR8DPv/k7fNK+RbQaTmZsymnqPrjqwFA0EUHX4kJ6tS
         JhOb6L8twlqmn99ssjhqlFQ52a8FT9oaFIGEeUWs=
Received: from bld-bun-01.bun.broadcom.com (bld-bun-01.bun.broadcom.com [10.176.128.83])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id EE1BB60D1D;
        Thu, 11 Jul 2019 02:05:22 -0700 (PDT)
Received: by bld-bun-01.bun.broadcom.com (Postfix, from userid 25152)
        id 16288B02FA3; Thu, 11 Jul 2019 11:05:19 +0200 (CEST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 7/7] brcmfmac: remove unnecessary strlcpy() upon obtaining "ver" iovar
Date:   Thu, 11 Jul 2019 11:05:12 +0200
Message-Id: <1562835912-1404-8-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1562835912-1404-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1562835912-1404-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Recently a strcpy() was replaced by strlcpy(). However, the strcpy()
was not needed in the first place. So removing that line of code.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index aa89d62..dec25e4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -258,7 +258,6 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 
 	/* query for 'ver' to get version info from firmware */
 	memset(buf, 0, sizeof(buf));
-	strlcpy(buf, "ver", sizeof(buf));
 	err = brcmf_fil_iovar_data_get(ifp, "ver", buf, sizeof(buf));
 	if (err < 0) {
 		bphy_err(drvr, "Retrieving version information failed, %d\n",
-- 
1.9.1

