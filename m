Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80EC3C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 463E0218FF
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:44:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="qQf/72AP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393232AbfBNMoM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 07:44:12 -0500
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:48236 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390419AbfBNMoM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 07:44:12 -0500
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.224.233])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 5A11994A37;
        Thu, 14 Feb 2019 04:44:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com 5A11994A37
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1550148250;
        bh=OHdeaSUT85xG7dZr+FmbPLrjx1PwESEkBV4BIXMfUQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQf/72APobjLZYmHD8ibiyfmjBy/C9sOAzxvxDsA506VIUnyhbycU65+BejFWOvrs
         WLnx72B5pb1771GeVodkWDSH4SdXZEqWrekNtDjFb4kV1a9W78Fokp5bHfmh0AZvdx
         DeIw5M9PR4Bobr2z7Mj/Cd1D30pAzJFBWrwcbJ0k=
Received: from bld-bun-01.bun.broadcom.com (bld-bun-01.bun.broadcom.com [10.176.128.83])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id CDCC181EC5;
        Thu, 14 Feb 2019 04:44:10 -0800 (PST)
Received: by bld-bun-01.bun.broadcom.com (Postfix, from userid 25152)
        id 35751B02AFA; Thu, 14 Feb 2019 13:44:08 +0100 (CET)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 4/6] brcmfmac: disable MBSS feature for bcm4330 device
Date:   Thu, 14 Feb 2019 13:43:50 +0100
Message-Id: <1550148232-4309-5-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550148232-4309-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1550148232-4309-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The MBSS feature was already disabled for bcm43362 as it resulted in a
beacon with BRCM_TEST_SSID regardless user configuration in hostapd. Now
the same has been reported for bcm4330 so disable the feature for this
device as well.

Reported-by: Russell King <linux@armlinux.org.uk>
Tested-by: Christopher Martin <chrsmrtn@gmail.com>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index b91b7ec..072c51c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -272,9 +272,15 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 					BIT(BRCMF_FEAT_WOWL_GTK);
 		}
 	}
-	/* MBSS does not work for 43362 */
-	if (drvr->bus_if->chip == BRCM_CC_43362_CHIP_ID)
+	/* MBSS does not work for all chips */
+	switch (drvr->bus_if->chip) {
+	case BRCM_CC_4330_CHIP_ID:
+	case BRCM_CC_43362_CHIP_ID:
 		ifp->drvr->feat_flags &= ~BIT(BRCMF_FEAT_MBSS);
+		break;
+	default:
+		break;
+	}
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_RSDB, "rsdb_mode");
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_TDLS, "tdls_enable");
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_MFP, "mfp");
-- 
1.9.1

