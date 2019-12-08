Return-Path: <SRS0=TB3F=Z6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B395CC2D0BF
	for <linux-wireless@archiver.kernel.org>; Sun,  8 Dec 2019 07:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DC1A206D6
	for <linux-wireless@archiver.kernel.org>; Sun,  8 Dec 2019 07:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575789970;
	bh=O69Fxb/T1nD5MHaIqAu7eFbU05WFEHFnEb33Wkauyl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=qIQLA3tDY0yj2xM/0rJYSfx/BnoadGIhStKcgzXb5FowJEaNgXBfjcs6yRgy2WmxD
	 YyoWUZjQeq2JPkwXit6Lo4JYj7QglMD6plbr+VXLmkpLW8GaXeAc4sBNG84dgy+M6d
	 WXwjBlUXHrrOM5k46Yqz1y+o+5LQRRrtreqL7Xco=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfLHH0J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 8 Dec 2019 02:26:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:58296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbfLHH0J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Dec 2019 02:26:09 -0500
Received: from localhost.localdomain (unknown [5.171.120.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 555BB20700;
        Sun,  8 Dec 2019 07:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575789968;
        bh=O69Fxb/T1nD5MHaIqAu7eFbU05WFEHFnEb33Wkauyl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6Omeb3y8t47RvlRa4/B/TON2ZzsfkVRUpxKERf9VTvAyODAhMiiw0+AgPa7hVzHx
         WCwmKJY192mqYYmcaVztt6oKabg5E8IQAMImlbkoa5DrJzveyxV7Iakksiudt6HgKP
         A4uzKVB1kTu/S59xd/4ySTfcqMyWSMgNMMomrXvc=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        ryder.lee@mediatek.com, royluo@google.com
Subject: [PATCH v4 2/3] mt76: mt7603: set 0 as min coverage_class value
Date:   Sun,  8 Dec 2019 08:25:39 +0100
Message-Id: <535c026cfb80d703ddb6508586614f5fc1c1ab96.1575789681.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1575789681.git.lorenzo@kernel.org>
References: <cover.1575789681.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Set 0 as minimum configurable value for coverage_class since mt76 does
not support dynack

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index 6da7caaaade1..5b2f354ba845 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -642,7 +642,7 @@ mt7603_set_coverage_class(struct ieee80211_hw *hw, s16 coverage_class)
 {
 	struct mt7603_dev *dev = hw->priv;
 
-	dev->coverage_class = coverage_class;
+	dev->coverage_class = max_t(s16, coverage_class, 0);
 	mt7603_mac_set_timing(dev);
 }
 
-- 
2.21.0

