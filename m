Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D573C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 09:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CCDD20663
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 09:11:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CCDD20663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408823AbeKWTzO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 14:55:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38212 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731917AbeKWTzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 14:55:14 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B1601309708F;
        Fri, 23 Nov 2018 09:11:51 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-117-249.ams2.redhat.com [10.36.117.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C32CE17F21;
        Fri, 23 Nov 2018 09:11:49 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Peter Robinson <pbrobinson@gmail.com>
Subject: [PATCH] brcmfmac: Call brcmf_dmi_probe before brcmf_of_probe
Date:   Fri, 23 Nov 2018 10:11:48 +0100
Message-Id: <20181123091148.12742-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 23 Nov 2018 09:11:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ARM systems with UEFI may have both devicetree (of) and DMI data in this
case we end up setting brcmf_mp_device.board_type twice.

In this case we should prefer the devicetree data, because:
1) The devicerree data is more reliable
2) Some ARM systems (e.g. the Raspberry Pi 3 models) support both UEFI and
   classic uboot booting, the devicetree data is always there, so using it
   makes sure we ask for the same nvram file independent of how we booted.

This commit moves the brcmf_dmi_probe call to before the brcmf_of_probe
call, so that the latter can override the value of the first if both are
set.

Fixes: bd1e82bb420a ("brcmfmac: Set board_type from DMI on x86 based ...")
Cc: Peter Robinson <pbrobinson@gmail.com>
Tested-and-reported-by: Peter Robinson <pbrobinson@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index d52774c6489b..0bb16bf574e3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -449,8 +449,8 @@ struct brcmf_mp_device *brcmf_get_module_param(struct device *dev,
 	}
 	if (!found) {
 		/* No platform data for this device, try OF and DMI data */
-		brcmf_of_probe(dev, bus_type, settings);
 		brcmf_dmi_probe(settings, chip, chiprev);
+		brcmf_of_probe(dev, bus_type, settings);
 	}
 	return settings;
 }
-- 
2.19.1

