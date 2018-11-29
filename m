Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D922C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 06:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 301472086B
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 06:03:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="I9jE1Q6s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 301472086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729956AbeK2RH6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 12:07:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728038AbeK2RH6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 12:07:58 -0500
Received: from sasha-vm.mshome.net (unknown [37.142.5.207])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C76520834;
        Thu, 29 Nov 2018 06:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1543471426;
        bh=jY7+2yB08jE8HxtxUtg+NxWiQ/iXK6M0A3+UFF+CLmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9jE1Q6sqZXRYfQRE8NHlQY2lBA/4Vd6zmazhnzcYCwyiQBxcEr+4YrQOrFX8ijVR
         kNLGZKhkXdIdXgpbw++cTbDJJT46egtg1xLGFwevcQLlQwyrJ/ZLGEK28JG4b6Smoi
         l3Syfyb0TDfPw9FuILfOPbfqduznL2ZoZjeMaclM=
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 03/18] brcmutil: really fix decoding channel info for 160 MHz bandwidth
Date:   Thu, 29 Nov 2018 01:03:15 -0500
Message-Id: <20181129060331.160224-3-sashal@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181129060331.160224-1-sashal@kernel.org>
References: <20181129060331.160224-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 3401d42c7ea2d064d15c66698ff8eb96553179ce ]

Previous commit /adding/ support for 160 MHz chanspecs was incomplete.
It didn't set bandwidth info and didn't extract control channel info. As
the result it was also using uninitialized "sb" var.

This change has been tested for two chanspecs found to be reported by
some devices/firmwares:
1) 60/160 (0xee32)
   Before: chnum:50 control_ch_num:36
    After: chnum:50 control_ch_num:60
2) 120/160 (0xed72)
   Before: chnum:114 control_ch_num:100
    After: chnum:114 control_ch_num:120

Fixes: 330994e8e8ec ("brcmfmac: fix for proper support of 160MHz bandwidth")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmutil/d11.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmutil/d11.c b/drivers/net/wireless/broadcom/brcm80211/brcmutil/d11.c
index e7584b842dce..eb5db94f5745 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmutil/d11.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmutil/d11.c
@@ -193,6 +193,9 @@ static void brcmu_d11ac_decchspec(struct brcmu_chan *ch)
 		}
 		break;
 	case BRCMU_CHSPEC_D11AC_BW_160:
+		ch->bw = BRCMU_CHAN_BW_160;
+		ch->sb = brcmu_maskget16(ch->chspec, BRCMU_CHSPEC_D11AC_SB_MASK,
+					 BRCMU_CHSPEC_D11AC_SB_SHIFT);
 		switch (ch->sb) {
 		case BRCMU_CHAN_SB_LLL:
 			ch->control_ch_num -= CH_70MHZ_APART;
-- 
2.17.1

