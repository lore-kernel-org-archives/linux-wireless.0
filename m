Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFC4C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 19:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44B1D217D9
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 19:42:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="umkTn9Fz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfBRTmV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:42:21 -0500
Received: from nbd.name ([46.4.11.11]:56644 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbfBRTmV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 14:42:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NSisfJghNKlApCKBkquWAagm/W7AoHEsbzilpC0A4c0=; b=umkTn9FzD2vVTiyBEL6J8oFo+p
        NokEy5+qNo+UVF/e+Nh4FoXABDxQ9Sroi8uoefmKxCnl2U+3DIdPaYx/86g/pWxK09C9p8PmjXcRP
        0MIOho+PRjC+kjJqJSGJA9smqNn+FhShWqbng8rIDdAKXrFozADuffqyiupKwDChHFiE=;
Received: by maeck.lan (Postfix, from userid 501)
        id 208785004553; Mon, 18 Feb 2019 20:42:18 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] mt76: fix resetting software IV flag on key delete
Date:   Mon, 18 Feb 2019 20:42:17 +0100
Message-Id: <20190218194218.41314-3-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190218194218.41314-1-nbd@nbd.name>
References: <20190218194218.41314-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

It needs to be unset instead of set

Fixes: 23405236460b9 ("mt76: fix transmission of encrypted management frames")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 87ed00768bc7..11b5f664f5b1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -431,7 +431,7 @@ int mt76x02_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	} else {
 		if (idx == wcid->hw_key_idx) {
 			wcid->hw_key_idx = -1;
-			wcid->sw_iv = true;
+			wcid->sw_iv = false;
 		}
 
 		key = NULL;
-- 
2.17.0

