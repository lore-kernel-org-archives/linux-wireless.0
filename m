Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B11C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 02:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB00620840
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 02:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550197792;
	bh=7N9Beok+VCOOzHubot1dzR3c/usbzEfwIHXsXXcjvvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2EoDCNVdNuzCD2U0+xMjJ8H4dniXtARY/uIIt4r7RPTe22CtwhtW0MDc2dZetqYCP
	 LC2kjgPkDJ5WHaxnY4dAYSfbx2SKvJgkc9jJw4QhGdvWhRShdZhtamm02lude/34dk
	 mtm9b/ZvkT3cxxs4xSVFsmOy3J2lD18r+00Wzk+M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730406AbfBOC3n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 21:29:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:52990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404475AbfBOCNB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 21:13:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 569C32229F;
        Fri, 15 Feb 2019 02:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550196781;
        bh=7N9Beok+VCOOzHubot1dzR3c/usbzEfwIHXsXXcjvvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOw/xsM+ZrUadLaBFFWyHNBkQ2fAGWlYizcV62514gOP7cl9/BB/Xnodwqf05/UjD
         D/4pxqpRGNqdcjh2sGH1vNgef0frPiNlu2GN+6cf9aFt7YKMMUw4b0WIIFFyTnYAp+
         cm5W0AUaOA3iP7aaHoMJAKP1sG6Dr2j6wU/nArAc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Balaji Pothunoori <bpothuno@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 59/65] mac80211: don't initiate TDLS connection if station is not associated to AP
Date:   Thu, 14 Feb 2019 21:11:15 -0500
Message-Id: <20190215021121.177674-59-sashal@kernel.org>
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
index 5d22eda8a6b1..8089af436ff7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1474,6 +1474,10 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
 		sta->sta.tdls = true;
 
+	if (sta->sta.tdls && sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    !sdata->u.mgd.associated)
+		return -EINVAL;
+
 	err = sta_apply_parameters(local, sta, params);
 	if (err) {
 		sta_info_free(local, sta);
-- 
2.19.1

