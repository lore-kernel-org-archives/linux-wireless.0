Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 221F6C433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Dec 2020 02:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE6E1205CA
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Dec 2020 02:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbgLWCVJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Dec 2020 21:21:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729220AbgLWCVI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97D3622248;
        Wed, 23 Dec 2020 02:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690051;
        bh=YwjFq9eQoOMILFRZBYqTpmj9LvL2hqjEzS9MxOIB9DQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AuicxnknObDioFiQZkaCG0Vrdr6+rEYwJvrX8NYGAcgrqyy3Wd4ZGimX32INahoTL
         JZMKtE9xLYTHmFwSsL4b51iG1c1jkJnNhfOSjSdUDjKGbxIr8/SJuXfdJOS3GYl5MS
         vsIDI0M8dRDI+Qb4ujjsBLNudiDESL0mpx51VheXAAVCU6LtqWzRG8NegeIpqG+Daw
         NdJzBUff4eOH9U2L+8OOM/k5LZrCQQL8EJS1nrrH8ARG+ZIX8b1U3ODVzFb+S73UDr
         2yybu3uAktmSBRd7b8WMOOLL0RChc+jK++XYzYB24LNBhQCAkogOUEgTC5ZRHKZi+L
         czPxAlRGNTfDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 122/130] mac80211: ignore country element TX power on 6 GHz
Date:   Tue, 22 Dec 2020 21:18:05 -0500
Message-Id: <20201223021813.2791612-122-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 2dedfe1dbdf27ac344584ed03c3876c85d2779fb ]

Updates to the 802.11ax draft are coming that deprecate the
country element in favour of the transmit power envelope
element, and make the maximum transmit power level field in
the triplets reserved, so if we parse them we'd use 0 dBm
transmit power.

Follow suit and completely ignore the element on 6 GHz for
purposes of determining TX power.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201206145305.9abf9f6b4f88.Icb6e52af586edcc74f1f0360e8f6fc9ef2bfe8f5@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 236ddc6b891c2..ba1e5cac32adb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1487,6 +1487,15 @@ ieee80211_find_80211h_pwr_constr(struct ieee80211_sub_if_data *sdata,
 	case NL80211_BAND_5GHZ:
 		chan_increment = 4;
 		break;
+	case NL80211_BAND_6GHZ:
+		/*
+		 * In the 6 GHz band, the "maximum transmit power level"
+		 * field in the triplets is reserved, and thus will be
+		 * zero and we shouldn't use it to control TX power.
+		 * The actual TX power will be given in the transmit
+		 * power envelope element instead.
+		 */
+		return false;
 	}
 
 	/* find channel */
-- 
2.27.0

