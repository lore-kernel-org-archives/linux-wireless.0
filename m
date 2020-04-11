Return-Path: <SRS0=JTkr=53=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53155C2BB86
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 23:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EDF720674
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 23:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586647719;
	bh=0XvcfMjmExThNxJ5Lf2Fhb+tyCIfM3N6i5bSIHAsSqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MUF4dJOmyEg7s42QsN/emp1xPSuMvwprc5sqQ4fk4eP1C47c8u2TMZSJtJTBj3sor
	 4tqGmpCTNW0U/blS4QhQKYrqRKeNwT4a0xta/POdbRP8qv8poiLVFcPfE+y0rrz0ZN
	 deL553UIh7J7qu8TlMh0YrNTJ+2/WQpK9NQtlIok=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbgDKX21 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:28:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729875AbgDKXLV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Apr 2020 19:11:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFD0B21D90;
        Sat, 11 Apr 2020 23:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646682;
        bh=0XvcfMjmExThNxJ5Lf2Fhb+tyCIfM3N6i5bSIHAsSqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2ihgHXjjhQ7QmAmM0S97ePRXDo7JV+SlWRSkRlg+Tqm7+rizOFV2Vu8ejXSnwluu
         teBP8Mq2JBjJq2ujL9P8LVy4Tqiaa+BvRegnWO3TZ142IL3AoZd2Xu67u1PSXnGaCu
         U/jwC1UCbenRZekzjWnOyZwnaAXrN6KYe56xF+fI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raveendran Somu <raveendran.somu@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 078/108] brcmfmac: Fix double freeing in the fmac usb data path
Date:   Sat, 11 Apr 2020 19:09:13 -0400
Message-Id: <20200411230943.24951-78-sashal@kernel.org>
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

[ Upstream commit 78179869dc3f5c0059bbf5d931a2717f1ad97ecd ]

When the brcmf_fws_process_skb() fails to get hanger slot for
queuing the skb, it tries to free the skb.
But the caller brcmf_netdev_start_xmit() of that funciton frees
the packet on error return value.
This causes the double freeing and which caused the kernel crash.

Signed-off-by: Raveendran Somu <raveendran.somu@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1585124429-97371-3-git-send-email-chi-hsien.lin@cypress.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 2bd892df83cc5..80cc45c9aa4a1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -2145,8 +2145,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 		brcmf_fws_enq(fws, BRCMF_FWS_SKBSTATE_DELAYED, fifo, skb);
 		brcmf_fws_schedule_deq(fws);
 	} else {
-		bphy_err(drvr, "drop skb: no hanger slot\n");
-		brcmf_txfinalize(ifp, skb, false);
+		bphy_err(drvr, "no hanger slot available\n");
 		rc = -ENOMEM;
 	}
 	brcmf_fws_unlock(fws);
-- 
2.20.1

