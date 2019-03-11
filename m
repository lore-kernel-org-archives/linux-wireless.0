Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E842DC4360F
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 20:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4C332147C
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 20:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552335128;
	bh=d2Bgcs2belQVKRimstdtTzausWvXb8sIkcEQ0lrDXP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tU70uUkiwOs2nQOSp1xaQAjlGwQqvjf5CeSdEjwwgYqxjknB2gvdInWfR+4O0MGUA
	 GkOZnb24qfgk23lcn+TOHpvN7QKW9dxgvgldsKJZGtpIBh1G16XUpTW+4l9VNyJprm
	 P6BP/NzSO2UU7fFY4d4/ms/tlGZ57cLjNZQdfozM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbfCKT4O (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 15:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728468AbfCKT4N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 15:56:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FC0E214AF;
        Mon, 11 Mar 2019 19:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552334173;
        bh=d2Bgcs2belQVKRimstdtTzausWvXb8sIkcEQ0lrDXP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWIepKm1Nxjt/IBPwCAouoo6fGzURe1o2ipr+USXAbzfKo/XBZVD7YybhCyX1KR3h
         lQy28tR6aDa6DS6WCWG5a9C0aaJDFIKF5PE+FNPKxknkpQy5fk9esCHKbLMo36C84+
         yA8P5AGh6cm/FexaHOf8y8eoXBKQO1iVGAAozsyM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 30/52] mac80211: Fix Tx aggregation session tear down with ITXQs
Date:   Mon, 11 Mar 2019 15:54:54 -0400
Message-Id: <20190311195516.137772-30-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190311195516.137772-1-sashal@kernel.org>
References: <20190311195516.137772-1-sashal@kernel.org>
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
index 69e831bc317b..54821fb1a960 100644
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
@@ -366,6 +366,8 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 
 	set_bit(HT_AGG_STATE_STOPPING, &tid_tx->state);
 
+	ieee80211_agg_stop_txq(sta, tid);
+
 	spin_unlock_bh(&sta->lock);
 
 	ht_dbg(sta->sdata, "Tx BA session stop requested for %pM tid %u\n",
-- 
2.19.1

