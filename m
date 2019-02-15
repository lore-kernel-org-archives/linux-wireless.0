Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB67EC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 02:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B8502192B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 02:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550198429;
	bh=iAu4afID//rMfOpd+oY+tySOsJ+NxK0yLKYuM2dPOwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TTCquqz4lKTfarjUZNzhJL7poRYLtjvSw2C7yEq+L+OKbLv5wawpmV9MbK3tmHwTL
	 A5grgtyWRACaiSm+k9MOPX/Aa/QHaYrT7RGMw+yG3Oqvh8YVkRa7a04bRBoeEH8gWC
	 9yt80VmuiveTDl+EWNuT6EQm2u6+CVW450z6Ax9c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389733AbfBOCKB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 21:10:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389658AbfBOCKA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 21:10:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32913222A1;
        Fri, 15 Feb 2019 02:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550196599;
        bh=iAu4afID//rMfOpd+oY+tySOsJ+NxK0yLKYuM2dPOwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z+E1qMhu2HN07//PRxBdVPna9KFDRMLlgzuYrWVQ1ZOTBFFrZmNU08t0jjdJSvfwJ
         1DsRYvsv+b2PRUw9DYa/kDnx03l0roxFn3wtcSdJJXKNE1FL4Jwj2LPWamYXPZZf+E
         0LSGIv8ST1IExW56gQJsx1IU5POC3rtsChDy8BME=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Copeland <me@bobcopeland.com>,
        Bob Copeland <bobcopeland@fb.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 36/77] mac80211: fix miscounting of ttl-dropped frames
Date:   Thu, 14 Feb 2019 21:08:14 -0500
Message-Id: <20190215020855.176727-36-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190215020855.176727-1-sashal@kernel.org>
References: <20190215020855.176727-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Bob Copeland <me@bobcopeland.com>

[ Upstream commit a0dc02039a2ee54fb4ae400e0b755ed30e73e58c ]

In ieee80211_rx_h_mesh_fwding, we increment the 'dropped_frames_ttl'
counter when we decrement the ttl to zero.  For unicast frames
destined for other hosts, we stop processing the frame at that point.

For multicast frames, we do not rebroadcast it in this case, but we
do pass the frame up the stack to process it on this STA.  That
doesn't match the usual definition of "dropped," so don't count
those as such.

With this change, something like `ping6 -i0.2 ff02::1%mesh0` from a
peer in a ttl=1 network no longer increments the counter rapidly.

Signed-off-by: Bob Copeland <bobcopeland@fb.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 428f7ad5f9b5..ef215d0e99b0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2710,7 +2710,9 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	skb_set_queue_mapping(skb, q);
 
 	if (!--mesh_hdr->ttl) {
-		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_ttl);
+		if (!is_multicast_ether_addr(hdr->addr1))
+			IEEE80211_IFSTA_MESH_CTR_INC(ifmsh,
+						     dropped_frames_ttl);
 		goto out;
 	}
 
-- 
2.19.1

