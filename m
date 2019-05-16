Return-Path: <SRS0=+b/P=TQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF453C04AAF
	for <linux-wireless@archiver.kernel.org>; Thu, 16 May 2019 12:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D97720818
	for <linux-wireless@archiver.kernel.org>; Thu, 16 May 2019 12:04:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ma3juoGx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbfEPME1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 May 2019 08:04:27 -0400
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:50378 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727245AbfEPME0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 May 2019 08:04:26 -0400
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.224.233])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 2F3E630C041;
        Thu, 16 May 2019 05:04:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com 2F3E630C041
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1558008265;
        bh=XUoxOUGI73bfpT33voRcLP+H09HL/WJPnYUbgt+amFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ma3juoGxwQKyZyqmK07ANdrwlqM46RPAsalgVVLLHfHv03PkPSPp0tJbFuGItQS0X
         5DQx9kWfbXBUAdeGFGpmF4nndGWqx69Jj/LoOmw9+2LegpHj3ue4W5+2FYazWeAoIm
         Ap56kx1qfgYUeJxtrK8M7oezVFYdehukNB2VFtLQ=
Received: from bld-bun-01.bun.broadcom.com (bld-bun-01.bun.broadcom.com [10.176.128.83])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id 91FEA60D5D;
        Thu, 16 May 2019 05:04:25 -0700 (PDT)
Received: by bld-bun-01.bun.broadcom.com (Postfix, from userid 25152)
        id A255CB03774; Thu, 16 May 2019 14:04:23 +0200 (CEST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 7/7] brcm80211: select WANT_DEV_COREDUMP conditionally for brcmfmac
Date:   Thu, 16 May 2019 14:04:11 +0200
Message-Id: <1558008251-13692-8-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1558008251-13692-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1558008251-13692-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

CONFIG_BRCMDBG selects WANT_DEV_COREDUMP but is only used by
brcmfmac so reflect that in the Kconfig.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/Kconfig b/drivers/net/wireless/broadcom/brcm80211/Kconfig
index 580f666..21dc4ca 100644
--- a/drivers/net/wireless/broadcom/brcm80211/Kconfig
+++ b/drivers/net/wireless/broadcom/brcm80211/Kconfig
@@ -33,6 +33,6 @@ config BRCM_TRACING
 config BRCMDBG
 	bool "Broadcom driver debug functions"
 	depends on BRCMSMAC || BRCMFMAC
-	select WANT_DEV_COREDUMP
+	select WANT_DEV_COREDUMP if BRCMFMAC
 	---help---
 	  Selecting this enables additional code for debug purposes.
-- 
1.9.1

