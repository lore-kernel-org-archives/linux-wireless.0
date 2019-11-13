Return-Path: <SRS0=dvfj=ZF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 444CCC43331
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 01:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D8512245A
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 01:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573610281;
	bh=FdIf39HYp99A1BoW7/Xn0oQ/GrnSVyevPFLPkhzblec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=DN+tyi+mkb3QFmF6p7S3PRA5q1sTyQlBYzEQUUCstNvYqSNJTIU4yA87quhdZIJff
	 KoGszrAb3ItcMQ2RF3Tpu2CGE9QO9ten8S3z+yKf2xkJX7Xe6qjIb1+JPafqRf6+5g
	 9Y95pU4RymYKPk3pKDsmBQxvhmONX7TjMnM3BJ5M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbfKMB57 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Nov 2019 20:57:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729900AbfKMB5y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Nov 2019 20:57:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A965D2245A;
        Wed, 13 Nov 2019 01:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610273;
        bh=FdIf39HYp99A1BoW7/Xn0oQ/GrnSVyevPFLPkhzblec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SgciO+HFUPPyDkenwqeLS39EjSduH1KMq1LlOG1Z+Ny3EFLA4hLDwb9Xilgr6vD95
         pSMOVloAGVY4kb0jZgAkQZf0KgS3AVQHchYNtYJiFJKq5WBZ1Nene0x68YlC29/hW9
         iMU64gWEaQ6m0eHrdmGN6AuLbjS7McRRWbO/ERFI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 059/115] brcmfmac: reduce timeout for action frame scan
Date:   Tue, 12 Nov 2019 20:55:26 -0500
Message-Id: <20191113015622.11592-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

[ Upstream commit edb6d6885bef82d1eac432dbeca9fbf4ec349d7e ]

Finding a common channel to send an action frame out is required for
some action types. Since a loop with several scan retry is used to find
the channel, a short wait time could be considered for each attempt.
This patch reduces the wait time from 1500 to 450 msec for each action
frame scan.

This patch fixes the WFA p2p certification 5.1.20 failure caused by the
long action frame send time.

Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 450f2216fac2d..c9566c9036721 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -74,7 +74,7 @@
 #define P2P_AF_MAX_WAIT_TIME		msecs_to_jiffies(2000)
 #define P2P_INVALID_CHANNEL		-1
 #define P2P_CHANNEL_SYNC_RETRY		5
-#define P2P_AF_FRM_SCAN_MAX_WAIT	msecs_to_jiffies(1500)
+#define P2P_AF_FRM_SCAN_MAX_WAIT	msecs_to_jiffies(450)
 #define P2P_DEFAULT_SLEEP_TIME_VSDB	200
 
 /* WiFi P2P Public Action Frame OUI Subtypes */
@@ -1139,7 +1139,6 @@ static s32 brcmf_p2p_af_searching_channel(struct brcmf_p2p_info *p2p)
 {
 	struct afx_hdl *afx_hdl = &p2p->afx_hdl;
 	struct brcmf_cfg80211_vif *pri_vif;
-	unsigned long duration;
 	s32 retry;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -1155,7 +1154,6 @@ static s32 brcmf_p2p_af_searching_channel(struct brcmf_p2p_info *p2p)
 	 * pending action frame tx is cancelled.
 	 */
 	retry = 0;
-	duration = msecs_to_jiffies(P2P_AF_FRM_SCAN_MAX_WAIT);
 	while ((retry < P2P_CHANNEL_SYNC_RETRY) &&
 	       (afx_hdl->peer_chan == P2P_INVALID_CHANNEL)) {
 		afx_hdl->is_listen = false;
@@ -1163,7 +1161,8 @@ static s32 brcmf_p2p_af_searching_channel(struct brcmf_p2p_info *p2p)
 			  retry);
 		/* search peer on peer's listen channel */
 		schedule_work(&afx_hdl->afx_work);
-		wait_for_completion_timeout(&afx_hdl->act_frm_scan, duration);
+		wait_for_completion_timeout(&afx_hdl->act_frm_scan,
+					    P2P_AF_FRM_SCAN_MAX_WAIT);
 		if ((afx_hdl->peer_chan != P2P_INVALID_CHANNEL) ||
 		    (!test_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL,
 			       &p2p->status)))
@@ -1176,7 +1175,7 @@ static s32 brcmf_p2p_af_searching_channel(struct brcmf_p2p_info *p2p)
 			afx_hdl->is_listen = true;
 			schedule_work(&afx_hdl->afx_work);
 			wait_for_completion_timeout(&afx_hdl->act_frm_scan,
-						    duration);
+						    P2P_AF_FRM_SCAN_MAX_WAIT);
 		}
 		if ((afx_hdl->peer_chan != P2P_INVALID_CHANNEL) ||
 		    (!test_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL,
-- 
2.20.1

