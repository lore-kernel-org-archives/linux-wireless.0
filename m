Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33FD9C433F5
	for <linux-wireless@archiver.kernel.org>; Mon, 20 Sep 2021 13:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C89960F12
	for <linux-wireless@archiver.kernel.org>; Mon, 20 Sep 2021 13:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbhITNc7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 20 Sep 2021 09:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbhITNc4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Sep 2021 09:32:56 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81759C061574
        for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2021 06:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=ExezkQGRktKr3roic1zPJJFf5+JfgUIRng9DlVNBUlk=; t=1632144689; x=1633354289; 
        b=IXeA1dvJxpBZkkNGIeZgwbIQLHGDxjqR14XpiG1N6s0mshx1A59F0SRTrY3RQ6jGcJT/2Vr9SOt
        zDhMwp2tE8TzTmTb3v3sUheZwe2/zfEZAggLsnMLUSSN/vf8DyIsYtpx5WPD1B7fh3Ra4A1ZE42zQ
        L9r0HqoSkLbX/01Jl4SeYV2UHQWXFiFBqbtnV3aYdm7r7Qmk0v9N1HsNhMt3igG/0crorYo18Ybax
        AzZWA1Z2r83vwfWqpGsXcjeYBox7acL36WrUOfrm0hqTof2mm9fV30K+XxLYLCDOfihnRGu9KrZWf
        9jSxSA/BoJX1NbWBlr3DlJiDg/xbt8sM2v9A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95-RC2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mSJOI-009S8n-9M;
        Mon, 20 Sep 2021 15:31:26 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/6] mac80211: mesh: fix potentially unaligned access
Date:   Mon, 20 Sep 2021 15:31:18 +0200
Message-Id: <20210920153122.e733e4d412bf.Ib6a2ff9e9cc9bc6fca50fce631ec1ce725cc926b@changeid>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The pointer here points directly into the frame, so the
access is potentially unaligned. Use get_unaligned_le16
to avoid that.

Fixes: 3f52b7e328c5 ("mac80211: mesh power save basics")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh_ps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 204830a55240..eda6a25a7a20 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -588,7 +588,7 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
 
 	/* only transmit to PS STA with announced, non-zero awake window */
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) &&
-	    (!elems->awake_window || !le16_to_cpu(*elems->awake_window)))
+	    (!elems->awake_window || !get_unaligned_le16(elems->awake_window)))
 		return;
 
 	if (!test_sta_flag(sta, WLAN_STA_MPSP_OWNER))
-- 
2.31.1

