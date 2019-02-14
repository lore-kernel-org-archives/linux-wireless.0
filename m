Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD09C4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23DC8222B6
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JMwpmvMP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393266AbfBNMoN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 07:44:13 -0500
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:48230 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390008AbfBNMoM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 07:44:12 -0500
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.224.233])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 163A694A36;
        Thu, 14 Feb 2019 04:44:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com 163A694A36
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1550148250;
        bh=FTlVg9Qvt59Exp/VH0DyFdoBfh5MQYJXo8uZwB/Dz+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMwpmvMP7xM5HxS5ALn+J/C19n2beZNnxXLgW3scRL0OPonWvzMgECuHizCQSPbKF
         E2mHFW3GWReUrF0mpMOmbcoKQhPrd4VmzSd96ytaboRrMIsoODwztMGsC0/SNbXiWp
         6pIEeI49tuIRPtlVsWstkK21ZtBWk0GIUnXaa/+Q=
Received: from bld-bun-01.bun.broadcom.com (bld-bun-01.bun.broadcom.com [10.176.128.83])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id 87CCA81EC4;
        Thu, 14 Feb 2019 04:44:10 -0800 (PST)
Received: by bld-bun-01.bun.broadcom.com (Postfix, from userid 25152)
        id 34E8CB00291; Thu, 14 Feb 2019 13:44:08 +0100 (CET)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 6/6] brcmfmac: use chipname in brcmf_fw_alloc_request() for error path as well
Date:   Thu, 14 Feb 2019 13:43:52 +0100
Message-Id: <1550148232-4309-7-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550148232-4309-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1550148232-4309-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The local variable chipname is string representation of chip id and revision
which is printed in the good flow of brcmf_fw_alloc_request(). Also use it
for the error path, ie. for unknown/unsupported devices.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index cf1ddf9..8209a42 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -719,8 +719,10 @@ struct brcmf_fw_request *
 			break;
 	}
 
+	brcmf_chip_name(chip, chiprev, chipname, sizeof(chipname));
+
 	if (i == table_size) {
-		brcmf_err("Unknown chipid %d [%d]\n", chip, chiprev);
+		brcmf_err("Unknown chip %s\n", chipname);
 		return NULL;
 	}
 
@@ -729,8 +731,6 @@ struct brcmf_fw_request *
 	if (!fwreq)
 		return NULL;
 
-	brcmf_chip_name(chip, chiprev, chipname, sizeof(chipname));
-
 	brcmf_info("using %s for chip %s\n",
 		   mapping_table[i].fw_base, chipname);
 
-- 
1.9.1

