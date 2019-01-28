Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A644C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4020B20881
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548697891;
	bh=h4bYPE8tgq+3qOo8AIQCvjIJi5Lm5fppydrzclmr9eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=I4w1dcIjynvs/xwl1IZ22H9MXasSnj3dojJ01E8EDJskSN+F8sxjK8hFvb9zXV9Um
	 IBss+GDche+OZDPsMd+m3H2V+Q9S7KTugvv/5T03YhcMPO6ClJoxrfQ6tfPLtxtHkc
	 j57+Wp+qFel8Rm+o9W1qJ40Dw9nEZ/f4InDzCgew=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbfA1PoO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:44:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:57508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbfA1PoN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:44:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E86C320880;
        Mon, 28 Jan 2019 15:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548690253;
        bh=h4bYPE8tgq+3qOo8AIQCvjIJi5Lm5fppydrzclmr9eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i415dDWBX/g01bly0i3YHBK6RbXf042CRUfUa6ygA+x+S24Dj1+RPElJ9qTGYsw/0
         0M8d5RrWF4+0yUy0QWKLQQRgSF1Gf6loD+PjgVTaDc6RoQzSwmcxXVgirJzK1qtAHt
         Q1Ip85FDcv7UXTOyKidRmTAt1/icaKB3VRZdXdhI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 018/304] ath9k: dynack: use authentication messages for 'late' ack
Date:   Mon, 28 Jan 2019 10:38:55 -0500
Message-Id: <20190128154341.47195-18-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
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

