Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D427AC04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 19:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99BC220848
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 19:16:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99BC220848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbeLCTQN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 14:16:13 -0500
Received: from mga12.intel.com ([192.55.52.136]:12797 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbeLCTQN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 14:16:13 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Dec 2018 11:16:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,311,1539673200"; 
   d="scan'208";a="97703405"
Received: from localhost.jer.intel.com ([10.12.190.32])
  by orsmga006.jf.intel.com with ESMTP; 03 Dec 2018 11:16:08 -0800
From:   Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] mac80211: ignore NullFunc frames in the duplicate detection
Date:   Mon,  3 Dec 2018 21:16:07 +0200
Message-Id: <1543864567-16947-1-git-send-email-emmanuel.grumbach@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

NullFunc packets should never be duplicate just like
QoS-NullFunc packets.

We saw a client that enters / exits power save with
NullFunc frames (and not with QoS-NullFunc) despite the
fact that the association supports HT.
This specific client also re-uses a non-zero sequence number
for different NullFunc frames.
At some point, the client had to send a retransmission of
the NullFunc frame and we dropped it, leading to a
misalignment in the power save state.
Fix this by never consider a NullFunc frame as duplicate,
just like we do for QoS NullFunc frames.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=201449

CC: <stable@vger.kernel.org>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3bd3b57..2c6515a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1403,6 +1403,7 @@ ieee80211_rx_h_check_dup(struct ieee80211_rx_data *rx)
 		return RX_CONTINUE;
 
 	if (ieee80211_is_ctl(hdr->frame_control) ||
+	    ieee80211_is_nullfunc(hdr->frame_control) ||
 	    ieee80211_is_qos_nullfunc(hdr->frame_control) ||
 	    is_multicast_ether_addr(hdr->addr1))
 		return RX_CONTINUE;
-- 
2.7.4

