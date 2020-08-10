Return-Path: <SRS0=Pq/w=BU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B01C433E0
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Aug 2020 19:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D81012080C
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Aug 2020 19:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597087677;
	bh=KOJL2c+I4mdDAdRYWnBoY+tYmEj3vH857XWtspWJIuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Sita5DXfYv/tvP+e7QptG1CbrtVuX9jkaqy01VNE5/ZO3PcYVJ3pNme95JQxZPFhh
	 ZRqi4Fc2BPpXFbQZekfdW6eXb+oXnEIYpysMbz0WrkdFxghi5SV4xQe7mSPhl/E6y0
	 54R/K4b3vtI63rufm0jDl9BLCN7VCK+zZh5nE3Ng=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgHJTLX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Aug 2020 15:11:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728321AbgHJTLW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Aug 2020 15:11:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E466422B49;
        Mon, 10 Aug 2020 19:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086681;
        bh=KOJL2c+I4mdDAdRYWnBoY+tYmEj3vH857XWtspWJIuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdlUxqOXOptSrq8khQw9Ix2M9u1dfy4XpRWQkwyAu10dYPZSKfyfLTArDntn5jaYc
         TFbx0eRnhPRCIPqWbeRouOT9yMqs6fuimpOBl8Yf5cePf8AW6UFh6Q40YWmk6+cEAz
         lsTtB8TD0iv2Am0dCEzQ75qNFuzkVVIEiu/ITlsY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wright Feng <wright.feng@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 38/60] brcmfmac: keep SDIO watchdog running when console_interval is non-zero
Date:   Mon, 10 Aug 2020 15:10:06 -0400
Message-Id: <20200810191028.3793884-38-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191028.3793884-1-sashal@kernel.org>
References: <20200810191028.3793884-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

[ Upstream commit eccbf46b15bb3e35d004148f7c3a8fa8e9b26c1e ]

brcmfmac host driver makes SDIO bus sleep and stops SDIO watchdog if no
pending event or data. As a result, host driver does not poll firmware
console buffer before buffer overflow, which leads to missing firmware
logs. We should not stop SDIO watchdog if console_interval is non-zero
in debug build.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200604071835.3842-4-wright.feng@cypress.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 3a08252f1a53f..0dbbb467c2291 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3689,7 +3689,11 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 			if (bus->idlecount > bus->idletime) {
 				brcmf_dbg(SDIO, "idle\n");
 				sdio_claim_host(bus->sdiodev->func1);
-				brcmf_sdio_wd_timer(bus, false);
+#ifdef DEBUG
+				if (!BRCMF_FWCON_ON() ||
+				    bus->console_interval == 0)
+#endif
+					brcmf_sdio_wd_timer(bus, false);
 				bus->idlecount = 0;
 				brcmf_sdio_bus_sleep(bus, true, false);
 				sdio_release_host(bus->sdiodev->func1);
-- 
2.25.1

