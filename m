Return-Path: <SRS0=eQwY=T2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91035C282E3
	for <linux-wireless@archiver.kernel.org>; Sun, 26 May 2019 14:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D7B02075E
	for <linux-wireless@archiver.kernel.org>; Sun, 26 May 2019 14:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558879533;
	bh=MDHJhHzMw7bEpHnOFH/Eoypul4YQM7NGfu76/SLURg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xpJ+yBw9sRMo6zelnfWptkevOHQDzHbQoxA2xIF/JHioAEjUGw+Ek2xWJYh0S8hQs
	 T5OQSdW8d27sipd3M4qo/ySFIOWa38N0eVEe3lOKSC1lnh2wIfRZhz+tljG40UWlk6
	 pp82klt7b9D/I0acfWuamhe/QNYj8K3eD21zz75I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfEZOFc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 26 May 2019 10:05:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727767AbfEZOFc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 May 2019 10:05:32 -0400
Received: from lore-desk-wlan.lan (unknown [151.66.36.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEF5B2085A;
        Sun, 26 May 2019 14:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558879532;
        bh=MDHJhHzMw7bEpHnOFH/Eoypul4YQM7NGfu76/SLURg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TdB+bNC2ebgIshh8tv55v+0qeb/H+OXJE6jDCk8/cquDBZHLNhUurwVUt+LGWRUGh
         AOKZlY/X+ISpU8AkQkdcU5UA/1ZAsePOkbcnuKUw/2xGioyUNoS1xjcdx42FVN3Qlc
         9beuJsTM26rME8TNuUT/7miKRookxr84jvMfOb+E=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        ryder.lee@mediatek.com, royluo@google.com
Subject: [PATCH 1/4] mt76: generalize mt76_get_txpower for 4x4:4 devices
Date:   Sun, 26 May 2019 16:05:10 +0200
Message-Id: <ecc361067a93fe6239dbf11851d0701312a5bbd5.1558879234.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1558879234.git.lorenzo@kernel.org>
References: <cover.1558879234.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Genralize mt76_get_txpower routine for 4x4:4 capable devices
in order to be reused in mt7615 driver

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index e70507a4b14d..f9e83971902e 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -766,10 +766,21 @@ int mt76_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	*dbm = DIV_ROUND_UP(dev->txpower_cur, 2);
 
 	/* convert from per-chain power to combined
-	 * output on 2x2 devices
+	 * output power
 	 */
-	if (n_chains > 1)
+	switch (n_chains) {
+	case 4:
+		*dbm += 6;
+		break;
+	case 3:
+		*dbm += 4;
+		break;
+	case 2:
 		*dbm += 3;
+		break;
+	default:
+		break;
+	}
 
 	return 0;
 }
-- 
2.21.0

