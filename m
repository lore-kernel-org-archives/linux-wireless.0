Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B40C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 02:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7DA720840
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 02:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550197984;
	bh=OCMBr16ERQc7kvl3wRG4Hj1hV26H8yMFZkg/cCRhyM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=T/Uy7B5GZ0w6SHkRAvCrALdNhu6YpqSZz10E9qOiaUqOBzMgCt3lfwImmQ8RTz73/
	 VC9CeGiNACzcObjPzP+mqLV0xHL8jjvmMyiFIHRoNNBXeuKohQlo4vu+HPaokqTftm
	 kuHBDinjXGJC0EdST6h+oyE1OVwjuYxbYL3mb3A0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404086AbfBOCMM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 21:12:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404028AbfBOCMK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 21:12:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A876C206BA;
        Fri, 15 Feb 2019 02:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550196729;
        bh=OCMBr16ERQc7kvl3wRG4Hj1hV26H8yMFZkg/cCRhyM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/cZ0bOEhroduaC3elZXpEXIbZQqoZUeQzVgAwe2+oKaFZB8lNwmkgJzTT9zlpm26
         //Ny3/zIL/yqY91MC1gaDjSlIn29gCUmFtSassM++2OawSTKwMYGwATXP/rMIut1/V
         sKZLzhzGUHLHpNhu+nVb9BUHiZ5hfc9Kf8r5Mt1w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Copeland <me@bobcopeland.com>,
        Bob Copeland <bobcopeland@fb.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 29/65] mac80211: fix miscounting of ttl-dropped frames
Date:   Thu, 14 Feb 2019 21:10:45 -0500
Message-Id: <20190215021121.177674-29-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190215021121.177674-1-sashal@kernel.org>
References: <20190215021121.177674-1-sashal@kernel.org>
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
index 5e2b4a41acf1..77cfa62274f3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2676,7 +2676,9 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
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

