Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7B1C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84DC720857
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548696473;
	bh=h4bYPE8tgq+3qOo8AIQCvjIJi5Lm5fppydrzclmr9eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PwWkX4bKBBpy+mxZWox77AOfGUteJ9NGTF7gCCA/p7Sd3lkXbNIaXhCiLF4R8npsB
	 yupWDnQq6OPkyn4KQm/6wgvei1CPj7AG9NJYiHuQMpEGPR9Ylu7sKvQphkaAo0H6OD
	 0sycj7FoxGCZtUveIAvJofE7YhSM9ukOiYHBvT2k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730704AbfA1QAI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:00:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730690AbfA1QAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 11:00:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFE352175B;
        Mon, 28 Jan 2019 16:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548691204;
        bh=h4bYPE8tgq+3qOo8AIQCvjIJi5Lm5fppydrzclmr9eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DdaTCtV+FraoI1JA+RgvBJF55wcAgyEptg8Y0INud83ZlMsCLo+VLHesECvEjr5cY
         sAVe46qjaVcCGwJPoabUHQ+iD9S0a8ipQW/Z1EPemcF/CfQcLwYnolfV3GPyhnFCY1
         aIDBurBdfJGo7qnkG83VG3e8Q5LS0wfcXGz1X/RA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 014/258] ath9k: dynack: use authentication messages for 'late' ack
Date:   Mon, 28 Jan 2019 10:55:20 -0500
Message-Id: <20190128155924.51521-14-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128155924.51521-1-sashal@kernel.org>
References: <20190128155924.51521-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

[ Upstream commit 3831a2a0010c72e3956020cbf1057a1701a2e469 ]

In order to properly support dynack in ad-hoc mode running
wpa_supplicant, take into account authentication frames for
'late ack' detection. This patch has been tested on devices
mounted on offshore high-voltage stations connected through
~24Km link

Reported-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
Tested-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/dynack.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/dynack.c b/drivers/net/wireless/ath/ath9k/dynack.c
index 7334c9b09e82..cc0dc966c512 100644
--- a/drivers/net/wireless/ath/ath9k/dynack.c
+++ b/drivers/net/wireless/ath/ath9k/dynack.c
@@ -187,7 +187,8 @@ void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
 	/* late ACK */
 	if (ts->ts_status & ATH9K_TXERR_XRETRY) {
 		if (ieee80211_is_assoc_req(hdr->frame_control) ||
-		    ieee80211_is_assoc_resp(hdr->frame_control)) {
+		    ieee80211_is_assoc_resp(hdr->frame_control) ||
+		    ieee80211_is_auth(hdr->frame_control)) {
 			ath_dbg(common, DYNACK, "late ack\n");
 			ath9k_hw_setslottime(ah, (LATEACK_TO - 3) / 2);
 			ath9k_hw_set_ack_timeout(ah, LATEACK_TO);
-- 
2.19.1

