Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 778B6C5ACCA
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 18:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 407292098A
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 18:43:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Is/vWkzb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gcoTMYZa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 407292098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbeJQCer (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 22:34:47 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51798 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbeJQCer (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 22:34:47 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B20E461326; Tue, 16 Oct 2018 18:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539715380;
        bh=CYEYBNcn/sBlpt1MycMnFGEJ2cN1njvKHe/uBmtiU2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Is/vWkzbfbLk1wcjV6Fs6CfhpFDw7Vl1zRx3dKDN+XFi1GpANQKY6xXXmzLkPMddq
         h7Y1Eqb7a43hyAHovfKncUW15vRJqlh757xDhmPAgnu4bAaMaouP5UeGFbqineWG71
         s96hYJGaLbwxRXBuzY6I54/+6658fhxBSp3stDpc=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 522BB60558;
        Tue, 16 Oct 2018 18:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539715379;
        bh=CYEYBNcn/sBlpt1MycMnFGEJ2cN1njvKHe/uBmtiU2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gcoTMYZaSJP6MRZtgkHhJR1rxhNBFAmXVNlD9OCJiG3K72AyvRLHpbgxsAWTcfaH6
         wBt8D5h/v93HAdE8EMpJFk3qONN66nZ995kWdJVxBEB7sgVWR4P/6HLm5R1AWbvFOa
         m+CC99bdNuCHn01IY9L4fNSLQUibYofzzWjxEPbE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 522BB60558
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     ath10k@lists.infradead.org, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 4/6] mac80211: Advertise per-peer NoAck policy support
Date:   Wed, 17 Oct 2018 00:11:09 +0530
Message-Id: <1539715271-14325-5-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1539715271-14325-1-git-send-email-tamizhr@codeaurora.org>
References: <1539715271-14325-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>

This enables per-peer NoAck handling in mac80211 when
the functionality is not offloaded to the drivers.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 net/mac80211/main.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 83e71e6..698cf56 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -597,6 +597,10 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_RRM);
 
+	if (!ops->set_noack_tid_bitmap)
+		wiphy_ext_feature_set(wiphy,
+				      NL80211_EXT_FEATURE_PER_STA_NOACK_MAP);
+
 	wiphy->bss_priv_size = sizeof(struct ieee80211_bss);
 
 	local = wiphy_priv(wiphy);
-- 
1.7.9.5

