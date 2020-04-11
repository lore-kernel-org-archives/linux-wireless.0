Return-Path: <SRS0=JTkr=53=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A12C2BBC7
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 23:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F80620674
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 23:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586647720;
	bh=a5MhkjJhLGiofqjLrUGMZvtWcls7SfWJinIAmTiwpEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wsfCgxXRBR34bOgCIHxrQ8N3er8cIfMTqUXeXWGho2f+Ooj9hQN5e5DFP5NCaZ5OT
	 p02IAPquvylp/6KNudvPLdXfS2Os2yyxgGSRVKlbhBdkHM/kL/ziwquuBD/yDQKK6b
	 BsVAkMw8R2dekEMTREuEsqeiMfJBtoBf3ke0utgY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729872AbgDKXLV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:11:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729868AbgDKXLU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Apr 2020 19:11:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80EF320708;
        Sat, 11 Apr 2020 23:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646680;
        bh=a5MhkjJhLGiofqjLrUGMZvtWcls7SfWJinIAmTiwpEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTZEHiinJ82lMHSI9T5ac+UmZVBiuK4SEqHLOCpy8CSnqAtpWgdnOFvB5yMGcVSGZ
         XIBk6Ca8C/K09OQAnzoxqLpxUxgn4dyrFm4LyujuBMOuupqSOrkOWjF/KV/Hg19RLc
         gm0VZT50tjrUwo6+LaHEkxI/4cFUFZSjcS++m6SE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raveendran Somu <raveendran.somu@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 077/108] brcmfmac: Fix driver crash on USB control transfer timeout
Date:   Sat, 11 Apr 2020 19:09:12 -0400
Message-Id: <20200411230943.24951-77-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Raveendran Somu <raveendran.somu@cypress.com>

[ Upstream commit 93a5bfbc7cad8bf3dea81c9bc07761c1226a0860 ]

When the control transfer gets timed out, the error status
was returned without killing that urb, this leads to using
the same urb. This issue causes the kernel crash as the same
urb is sumbitted multiple times. The fix is to kill the
urb for timeout transfer before returning error

Signed-off-by: Raveendran Somu <raveendran.somu@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1585124429-97371-2-git-send-email-chi-hsien.lin@cypress.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 575ed19e91951..10387a7f5d565 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -328,11 +328,12 @@ static int brcmf_usb_tx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 		return err;
 	}
 	timeout = brcmf_usb_ioctl_resp_wait(devinfo);
-	clear_bit(0, &devinfo->ctl_op);
 	if (!timeout) {
 		brcmf_err("Txctl wait timed out\n");
+		usb_kill_urb(devinfo->ctl_urb);
 		err = -EIO;
 	}
+	clear_bit(0, &devinfo->ctl_op);
 	return err;
 }
 
@@ -358,11 +359,12 @@ static int brcmf_usb_rx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	}
 	timeout = brcmf_usb_ioctl_resp_wait(devinfo);
 	err = devinfo->ctl_urb_status;
-	clear_bit(0, &devinfo->ctl_op);
 	if (!timeout) {
 		brcmf_err("rxctl wait timed out\n");
+		usb_kill_urb(devinfo->ctl_urb);
 		err = -EIO;
 	}
+	clear_bit(0, &devinfo->ctl_op);
 	if (!err)
 		return devinfo->ctl_urb_actual_length;
 	else
-- 
2.20.1

