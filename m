Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22476C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 11:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E32D020828
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 11:00:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ZpbWwsRJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfCSLAQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 07:00:16 -0400
Received: from nbd.name ([46.4.11.11]:43666 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727432AbfCSLAP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 07:00:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=md1NmmsTagiEQlPpikDNXFj5YZRr772R1CxIBKbrZnQ=; b=ZpbWwsRJU8OBYPWuzU80cp7xBA
        CjkXaMScH5vm0lv8f5Qm1JT/m5tdMSYid374xYncEdZ9EVf/fU303NqmWq8KywVcP0JCLW3E9GVeW
        QFLuZEq1Wb7IYa6INxvQJZgRoOw1HXyUXfyWGLyifGsxDrxEz+sgTemmJxzAxYCE5tYQ=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h6CTe-0006KW-2u; Tue, 19 Mar 2019 12:00:14 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id 7BC635337FE7; Tue, 19 Mar 2019 12:00:13 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH v2] mac80211: un-schedule TXQs on powersave start
Date:   Tue, 19 Mar 2019 12:00:13 +0100
Message-Id: <20190319110013.45228-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Once a station enters powersave, its queues should not be returned by
ieee80211_next_txq() anymore. They will be re-scheduled again after the
station has woken up again

Fixes: 1866760096bf4 ("mac80211: Add TXQ scheduling API")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 295535b75184..60aac91e35d0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1568,7 +1568,15 @@ static void sta_ps_start(struct sta_info *sta)
 		return;
 
 	for (tid = 0; tid < IEEE80211_NUM_TIDS; tid++) {
-		if (txq_has_queue(sta->sta.txq[tid]))
+		struct ieee80211_txq *txq = sta->sta.txq[tid];
+		struct txq_info *txqi = to_txq_info(txq);
+
+		spin_lock(&local->active_txq_lock[txq->ac]);
+		if (!list_empty(&txqi->schedule_order))
+			list_del_init(&txqi->schedule_order);
+		spin_unlock(&local->active_txq_lock[txq->ac]);
+
+		if (txq_has_queue(txq))
 			set_bit(tid, &sta->txq_buffered_tids);
 		else
 			clear_bit(tid, &sta->txq_buffered_tids);
-- 
2.17.0

