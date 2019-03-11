Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27590C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 20:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED89A2087C
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 20:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552334587;
	bh=bcEvkN1ZOQ8Fjy0fK2k173n6cXMzdRPtAnyHsFZZpB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=R9tqMRlS94x8czWREM0LFmMuZ1D0RGl8/A0T3xcZIuNkTSV8box2NTPfBlKe3s7s3
	 Wvvd46alRsS1lg5EKqcPUpLok1USvFoV9NpyAc/U0UhpvXmdUfSyLbNlPmlzEIcUga
	 wafJ2GzX0YgLdttzlEeMQgH47xAaROCw1lXEI+Ow=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbfCKT6w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 15:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729443AbfCKT6u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 15:58:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD3C82087C;
        Mon, 11 Mar 2019 19:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552334329;
        bh=bcEvkN1ZOQ8Fjy0fK2k173n6cXMzdRPtAnyHsFZZpB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9HvVRL1dYDrAaZw99l+xWCkimf/JecTE/vhyikuN6Tc7+nxGPc4VcA3lFDE3R19h
         towvT1Qchi4uDpMkDCrU1O0AXhSZdZ/aWxTmD7o+44cq9BWCHK97eqx6tRhOo2nEik
         V6FS40pKiAatu4lQIvJzhGynen58A2At+Ndxp1iU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 16/27] mac80211: Fix Tx aggregation session tear down with ITXQs
Date:   Mon, 11 Mar 2019 15:58:13 -0400
Message-Id: <20190311195824.139043-16-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190311195824.139043-1-sashal@kernel.org>
References: <20190311195824.139043-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 6157ca0d6bfe437691b1e98a62e2efe12b6714da ]

When mac80211 requests the low level driver to stop an ongoing
Tx aggregation, the low level driver is expected to call
ieee80211_stop_tx_ba_cb_irqsafe() to indicate that it is ready
to stop the session. The callback in turn schedules a worker
to complete the session tear down, which in turn also handles
the relevant state for the intermediate Tx queue.

However, as this flow in asynchronous, the intermediate queue
should be stopped and not continue servicing frames, as in
such a case frames that are dequeued would be marked as part
of an aggregation, although the aggregation is already been
stopped.

Fix this by stopping the intermediate Tx queue, before
calling the low level driver to stop the Tx aggregation.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/agg-tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 197947a07f83..ed57db9b6086 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -8,7 +8,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2010, Intel Corporation
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -361,6 +361,8 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 
 	set_bit(HT_AGG_STATE_STOPPING, &tid_tx->state);
 
+	ieee80211_agg_stop_txq(sta, tid);
+
 	spin_unlock_bh(&sta->lock);
 
 	ht_dbg(sta->sdata, "Tx BA session stop requested for %pM tid %u\n",
-- 
2.19.1

