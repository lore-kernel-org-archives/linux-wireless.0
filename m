Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C95FC4360F
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4A20206C0
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553714044;
	bh=RC1QrTZVyDohPLWE8WHfDddcQujpyQpNXq9433w0ay4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=T3tq1buGW6lk+vtguylzhq+4o7aqI3SUeTaLrIf+qqoNDoVPfgMOXbilv4z8FVnsv
	 VMPuLizO3xk3YTZuIL3XxY0wtRAfXxqJSDnCSlwUZRUDecf4C1jaSB78E0JpT5HTC3
	 HEhwqr02esl9qyg5xi8Bwz7Aie5NrhI15MXBag24=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388691AbfC0SJ5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388678AbfC0SJ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 14:09:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03B652147C;
        Wed, 27 Mar 2019 18:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710196;
        bh=RC1QrTZVyDohPLWE8WHfDddcQujpyQpNXq9433w0ay4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GMRs+7xSmwNXsVyZzU5+DAXEOIJEpHp5IMV8+PwfAd8Qnoen2IVSz+Fkc6/EVhyTu
         jwKwKMMf2m779bbvFTvK//+Jzqsy2WcrHUyyeCf/SArr/s2M00NRkIFPEHP5He3c0p
         LKs4owEbx3y24OnGeW23TgzW+PTRzGpS0x8lUWxM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 245/262] brcmfmac: Use firmware_request_nowarn for the clm_blob
Date:   Wed, 27 Mar 2019 14:01:40 -0400
Message-Id: <20190327180158.10245-245-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 4ad0be160544ffbdafb7cec39bb8e6dd0a97317a ]

The linux-firmware brcmfmac firmware files contain an embedded table with
per country allowed channels and strength info.

For recent hardware these versions of the firmware are specially build for
linux-firmware, the firmware files directly available from Cypress rely on
a separate clm_blob file for this info.

For some unknown reason Cypress refuses to provide the standard firmware
files + clm_blob files it uses elsewhere for inclusion into linux-firmware,
instead relying on these special builds with the clm_blob info embedded.
This means that the linux-firmware firmware versions often lag behind,
but I digress.

The brcmfmac driver does support the separate clm_blob file and always
tries to load this. Currently we use request_firmware for this. This means
that on any standard install, using the standard combo of linux-kernel +
linux-firmware, we will get a warning:
"Direct firmware load for ... failed with error -2"

On top of this, brcmfmac itself prints: "no clm_blob available (err=-2),
device may have limited channels available".

This commit switches to firmware_request_nowarn, fixing almost any brcmfmac
device logging the warning (it leaves the brcmfmac info message in place).

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 1f1e95a15a17..0ce1d8174e6d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -149,7 +149,7 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 		return err;
 	}
 
-	err = request_firmware(&clm, clm_name, bus->dev);
+	err = firmware_request_nowarn(&clm, clm_name, bus->dev);
 	if (err) {
 		brcmf_info("no clm_blob available (err=%d), device may have limited channels available\n",
 			   err);
-- 
2.19.1

