Return-Path: <SRS0=jAIi=VI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB61C74A4B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Jul 2019 09:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B70120872
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Jul 2019 09:05:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="mm4gSLpd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbfGKJFX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Jul 2019 05:05:23 -0400
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:59760 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728045AbfGKJFX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jul 2019 05:05:23 -0400
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.224.233])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id D28AC30C01C;
        Thu, 11 Jul 2019 02:05:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com D28AC30C01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1562835921;
        bh=9jIAzrw1KYRJbrxHPofEDN+pgwmnpkK0np0plEghnVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mm4gSLpdbXBaaOdTdfdqd2diqLMhTgf977Iz6WrSxsbEOC4HqHfHA19uPzmKILibm
         Zxu/ID9bKIZz5AJeHdt25I3xMkAdaAh+A8GIvXWB3WOHnq7/dtpVDumr3ZCuIkdTC4
         Rn5k5WO1a8UtOyKZFYyCn9ZTuTOv3GuLGer9yxm0=
Received: from bld-bun-01.bun.broadcom.com (bld-bun-01.bun.broadcom.com [10.176.128.83])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id CD1BC60CB1;
        Thu, 11 Jul 2019 02:05:21 -0700 (PDT)
Received: by bld-bun-01.bun.broadcom.com (Postfix, from userid 25152)
        id 13C76B02A93; Thu, 11 Jul 2019 11:05:19 +0200 (CEST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 4/7] brcmfmac: clear events in brcmf_fweh_detach() will always fail
Date:   Thu, 11 Jul 2019 11:05:09 +0200
Message-Id: <1562835912-1404-5-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1562835912-1404-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1562835912-1404-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Clearing firmware events in brcmf_fweh_detach() is always failing
because it is called only upon driver remove and communication
with firmware is no longer possible.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index adedd4f..79c8a85 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -303,16 +303,7 @@ void brcmf_fweh_attach(struct brcmf_pub *drvr)
 void brcmf_fweh_detach(struct brcmf_pub *drvr)
 {
 	struct brcmf_fweh_info *fweh = &drvr->fweh;
-	struct brcmf_if *ifp = brcmf_get_ifp(drvr, 0);
-	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
 
-	if (ifp) {
-		/* clear all events */
-		memset(eventmask, 0, BRCMF_EVENTING_MASK_LEN);
-		(void)brcmf_fil_iovar_data_set(ifp, "event_msgs",
-					       eventmask,
-					       BRCMF_EVENTING_MASK_LEN);
-	}
 	/* cancel the worker */
 	cancel_work_sync(&fweh->event_work);
 	WARN_ON(!list_empty(&fweh->event_q));
-- 
1.9.1

