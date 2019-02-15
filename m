Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B3D4C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 02:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01E2620643
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 02:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550197012;
	bh=Y9o8KsB+a9lG2Xg8g9q5V6wwNEdFY1dlkRFiCB4i6Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1B/PTecmdIm7751w6p78e3+bzh9JUHIEel/8dpAMU4u9HOJVtIP0CdwlcIpGOfJcg
	 xeMZksXqneqwwECsRH6hQoZt7HWYyPkFCrb7hmpLOqHP2O2RhSjeQycBnwxIqKpRRm
	 Km4lockKW68rfp6/PdjKMpsDxz9TLOb3oEa3gxUE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391077AbfBOCQv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 21:16:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392197AbfBOCQI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 21:16:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8C0E21934;
        Fri, 15 Feb 2019 02:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550196967;
        bh=Y9o8KsB+a9lG2Xg8g9q5V6wwNEdFY1dlkRFiCB4i6Fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I4v+ubAuhNJ9s7kGmqGe52VFKmsbRaWz6Y3+mKKRNvD6Uc/n7Wbufm2RjS8CkGLb2
         uhhaFeoIVUElwxhdr1hUYJIJecOUPxw0NCtPlp1UOn0XMYF+d31h3wFRe+5odKB5im
         mbEJzjQqVb+LuXU40ZL5G5OvKH05U7anJ4lajySk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Balaji Pothunoori <bpothuno@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 3.18 14/16] mac80211: don't initiate TDLS connection if station is not associated to AP
Date:   Thu, 14 Feb 2019 21:15:44 -0500
Message-Id: <20190215021546.179605-14-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190215021546.179605-1-sashal@kernel.org>
References: <20190215021546.179605-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Balaji Pothunoori <bpothuno@codeaurora.org>

[ Upstream commit 7ed5285396c257fd4070b1e29e7b2341aae2a1ce ]

Following call trace is observed while adding TDLS peer entry in driver
during TDLS setup.

Call Trace:
[<c1301476>] dump_stack+0x47/0x61
[<c10537d2>] __warn+0xe2/0x100
[<fa22415f>] ? sta_apply_parameters+0x49f/0x550 [mac80211]
[<c1053895>] warn_slowpath_null+0x25/0x30
[<fa22415f>] sta_apply_parameters+0x49f/0x550 [mac80211]
[<fa20ad42>] ? sta_info_alloc+0x1c2/0x450 [mac80211]
[<fa224623>] ieee80211_add_station+0xe3/0x160 [mac80211]
[<c1876fe3>] nl80211_new_station+0x273/0x420
[<c170f6d9>] genl_rcv_msg+0x219/0x3c0
[<c170f4c0>] ? genl_rcv+0x30/0x30
[<c170ee7e>] netlink_rcv_skb+0x8e/0xb0
[<c170f4ac>] genl_rcv+0x1c/0x30
[<c170e8aa>] netlink_unicast+0x13a/0x1d0
[<c170ec18>] netlink_sendmsg+0x2d8/0x390
[<c16c5acd>] sock_sendmsg+0x2d/0x40
[<c16c6369>] ___sys_sendmsg+0x1d9/0x1e0

Fixing this by allowing TDLS setup request only when we have completed
association.

Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6ba5240dd61d..ffe319309d03 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1194,6 +1194,10 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 		sta->sta.tdls = true;
 	}
 
+	if (sta->sta.tdls && sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    !sdata->u.mgd.associated)
+		return -EINVAL;
+
 	err = sta_apply_parameters(local, sta, params);
 	if (err) {
 		sta_info_free(local, sta);
-- 
2.19.1

