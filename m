Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31893C433E0
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Feb 2021 16:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE92A64F5E
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Feb 2021 16:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238011AbhBDQ1w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Feb 2021 11:27:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238005AbhBDQ1i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Feb 2021 11:27:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A93C264F5E;
        Thu,  4 Feb 2021 16:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612456018;
        bh=7eAiSz3uE3FQW/p1sk6252RS2WSyjN+zC03YW782E9A=;
        h=From:To:Cc:Subject:Date:From;
        b=SxZKtfguKoH120d6TpQXaM8tCwTmuuOA6F4aQMGgqaXaCZs1C0FGyjTq7GIE4qVLB
         qs+Z8AycXKCdGFuMrRAkUfFyVV4R6u/TbcW7XhJU8HjAm6CmJ1QLDd4M2hLiHTWJVB
         Cw05TNJnn4tc0LDhoZSceXwIOyvMyujk2ZJmYuh6mgOx0UYBP2Rb1yGNK2RoNDM86q
         uUgpABq1ViGZ47a4l+PjznlIzbe+Iy7pWKWAhlCaedMQ+Nsyn4aR6bZAKkhJJxc28t
         VMK+Wk6UvauACffreNkMHjYN1GS7fDuRPYCs1nHpyrk4YCZ7UZbEMLouG+ofgpPDX/
         P6wg2H0ApP0pQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wl3501: fix alignment constraints
Date:   Thu,  4 Feb 2021 17:26:43 +0100
Message-Id: <20210204162653.3113749-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

struct wl3501_80211_tx_hdr contains a ieee80211_hdr structure, which is
required to have at least two byte alignment, and this conflicts with
the __packed attribute:

wireless/wl3501.h:553:1: warning: alignment 1 of 'struct wl3501_80211_tx_hdr' is less than 2 [-Wpacked-not-aligned]

Mark wl3501_80211_tx_hdr itself as having two-byte alignment to ensure the
inner structure is properly aligned.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/wl3501.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/wl3501.h b/drivers/net/wireless/wl3501.h
index b446cb369557..e98e04ee9a2c 100644
--- a/drivers/net/wireless/wl3501.h
+++ b/drivers/net/wireless/wl3501.h
@@ -550,7 +550,7 @@ struct wl3501_80211_tx_plcp_hdr {
 struct wl3501_80211_tx_hdr {
 	struct wl3501_80211_tx_plcp_hdr	pclp_hdr;
 	struct ieee80211_hdr		mac_hdr;
-} __packed;
+} __packed __aligned(2);
 
 /*
    Reserve the beginning Tx space for descriptor use.
-- 
2.29.2

