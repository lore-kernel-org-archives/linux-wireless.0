Return-Path: <SRS0=BG2g=C6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C12AC43465
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Sep 2020 15:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3B0320B1F
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Sep 2020 15:45:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="oRyMur1f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgIUPpw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Sep 2020 11:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbgIUPpw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Sep 2020 11:45:52 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECE4C061755
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2020 08:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=S70rH2hZ0k5ktmjPDxH4K3+WfVQ1DMepSPdVd/chVYg=; b=oRyMur1fHOTDdiDY6ll444Ziuy
        FmyGQCT39nkVatK13eBOBKrHkjRfkXlLL6PzTh+XCvw75Yn2AxfUzFIf/H2/cfQh+FDr6Jwfd0cGX
        bw6g/YtW6hExv4Nvc9d6003MKDeUeXNH4UzyawQMWQge7NWeVk3L8hZ0EeqdJJcyWntg=;
Received: from p4ff134da.dip0.t-ipconnect.de ([79.241.52.218] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kKO0g-0007Ef-Qm; Mon, 21 Sep 2020 17:45:46 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, Georgi Valkov <gvalkov@abv.bg>
Subject: [PATCH] mac80211: fix regression in sta connection monitor
Date:   Mon, 21 Sep 2020 17:45:45 +0200
Message-Id: <20200921154545.91971-1-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When the nulldata frame was acked, the probe send count needs to be reset,
otherwise it will keep increasing until the connection is considered dead,
even though it fine.

Fixes: 9abf4e49830d ("mac80211: optimize station connection monitor")
Reported-by: Georgi Valkov <gvalkov@abv.bg>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/mlme.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 50a9b9025725..7c04d8e30482 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2508,7 +2508,9 @@ void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
 	    !sdata->u.mgd.probe_send_count)
 		return;
 
-	if (!ack)
+	if (ack)
+		sdata->u.mgd.probe_send_count = 0;
+	else
 		sdata->u.mgd.nullfunc_failed = true;
 	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 }
-- 
2.28.0

