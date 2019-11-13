Return-Path: <SRS0=dvfj=ZF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABFEAC43331
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 02:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 855B721783
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 02:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573611169;
	bh=xd9MmByD4kgF02UVppLESgoSj9OQHcqjVex2lFwXvoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=y7wsMouMPinZyST603PGPY38xqjBQX6TYKvXudkbUMCTsM9bEJksntBVgfhTWGqQ3
	 kWIKNlaLvTnEpXlknBflWZsoZvvPYzXaO0B1BvMRPGi4Lo6BptKQTip7xuVehtidtN
	 zuZh9wCcOTr6Hva+Da0IEJOnyAl1RTkFz8IBwYeM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbfKMB6J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Nov 2019 20:58:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729940AbfKMB6F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Nov 2019 20:58:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74200222D3;
        Wed, 13 Nov 2019 01:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610285;
        bh=xd9MmByD4kgF02UVppLESgoSj9OQHcqjVex2lFwXvoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DT2CaiDuuKNuxXx7s62+FakCPZMprTPX7bWJgYNitiQAqSBv1+L+mWyC/zPCBsOJ7
         zSSQkReJ5k5CMqsGZv13Sf5YY12ZuHxX1nQcv7njSynLPWfcJE2zr35XcDKUASbsOH
         ov3b+vr9Q9pH5ZI6HscEnhe/uk3q894ocnyCMCeg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 062/115] qtnfmac: drop error reports for out-of-bounds key indexes
Date:   Tue, 12 Nov 2019 20:55:29 -0500
Message-Id: <20191113015622.11592-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[ Upstream commit 35da3fe63b8647ce3cc52fccdf186a60710815fb ]

On disconnect wireless core attempts to remove all the supported keys.
Following cfg80211_ops conventions, firmware returns -ENOENT code
for the out-of-bound key indexes. This is a normal behavior,
so no need to report errors for this case.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index a450bc6bc7745..d02f68792ce41 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -509,9 +509,16 @@ static int qtnf_del_key(struct wiphy *wiphy, struct net_device *dev,
 	int ret;
 
 	ret = qtnf_cmd_send_del_key(vif, key_index, pairwise, mac_addr);
-	if (ret)
-		pr_err("VIF%u.%u: failed to delete key: idx=%u pw=%u\n",
-		       vif->mac->macid, vif->vifid, key_index, pairwise);
+	if (ret) {
+		if (ret == -ENOENT) {
+			pr_debug("VIF%u.%u: key index %d out of bounds\n",
+				 vif->mac->macid, vif->vifid, key_index);
+		} else {
+			pr_err("VIF%u.%u: failed to delete key: idx=%u pw=%u\n",
+			       vif->mac->macid, vif->vifid,
+			       key_index, pairwise);
+		}
+	}
 
 	return ret;
 }
-- 
2.20.1

