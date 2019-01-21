Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F7E1C31D63
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D081D20823
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:18:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Z2D7Xcvc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Z2D7Xcvc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbfAUHSF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:18:05 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46710 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfAUHSF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 02:18:05 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C5D1860886; Mon, 21 Jan 2019 07:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548054066;
        bh=zSqKlmDE3aYmidmuPQidcOZX3yNXyCpcIRvbo6IPouE=;
        h=From:To:Cc:Subject:Date:From;
        b=Z2D7XcvcIKzzakg7NRdEcWo4ab+tB6w1Z81eRrlQUoBSt+F9BWbPbXWxGfuAuLXhx
         SmplmDyfeYCI3163xBoLM0U7pMu6ny+N+9wth7qUSbjoN4LHi8WpCr+5WoMntcAw9z
         6WVuzZTYflfT5ealwjGyBk4OGwbt1w/bC/0huxRk=
Received: from checstex0244823-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bpothuno@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A198160860;
        Mon, 21 Jan 2019 07:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548054066;
        bh=zSqKlmDE3aYmidmuPQidcOZX3yNXyCpcIRvbo6IPouE=;
        h=From:To:Cc:Subject:Date:From;
        b=Z2D7XcvcIKzzakg7NRdEcWo4ab+tB6w1Z81eRrlQUoBSt+F9BWbPbXWxGfuAuLXhx
         SmplmDyfeYCI3163xBoLM0U7pMu6ny+N+9wth7qUSbjoN4LHi8WpCr+5WoMntcAw9z
         6WVuzZTYflfT5ealwjGyBk4OGwbt1w/bC/0huxRk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A198160860
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bpothuno@codeaurora.org
From:   Balaji Pothunoori <bpothuno@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH] mac80211: don't initiate TDLS connection if station is not associated to AP
Date:   Mon, 21 Jan 2019 12:30:43 +0530
Message-Id: <1548054043-446-1-git-send-email-bpothuno@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

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
---
 net/mac80211/cfg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 80d8ebc..d65aa01 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1498,6 +1498,10 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
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
2.7.4

