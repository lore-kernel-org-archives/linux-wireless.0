Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631CAC43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 12:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 271AC206C1
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 12:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556282452;
	bh=8VQs7IP01S212vBCFVD2ZB20HkAoEs97byM+u14ZCUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mp8mjNejcJAS13ZC8Ua70r1IKpYlBQ4zGinb9pzjnz5ynpnz8Wsj3V6F+5w9X2B3P
	 XA26oOwONcwSnKxJAZQThSLMyjJb2oqUzDzQ/D7P10sJP2y9Gd6WWGEGuQ9gd7EVQM
	 4lM2Ypds7RGuQB0PPO46Si6G5/wVfGM9e2votr6k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfDZMkv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 08:40:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbfDZMkv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 08:40:51 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3B02206A3;
        Fri, 26 Apr 2019 12:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556282450;
        bh=8VQs7IP01S212vBCFVD2ZB20HkAoEs97byM+u14ZCUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mv8YLDad44mRagUfAD8mJvTL0iYMtu8XKK4OcYM7seoCjvfN2hLFLL55+anGQpTSh
         LaWQPhNdZEsBRaf5dJ+T/ytYeh4Ui1Z3pUG8AAKKVKk5jhe7qwn66nwnPfaMYZWV6Y
         2kpXN8+6RDeBujixoJjndn+7Yoh4gaRhK5O8mgfU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt7603: wait for pre_tbtt_tasklet before scanning
Date:   Fri, 26 Apr 2019 14:40:40 +0200
Message-Id: <e7bc3645ce73a15ef9fa16a40f2bdb8577494769.1556280002.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1556280002.git.lorenzo@kernel.org>
References: <cover.1556280002.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Disable pre_tbtt_tasklet tasklet before performing frequency scanning

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index 18a33d921601..184ed4cead0a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -535,6 +535,7 @@ mt7603_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct mt7603_dev *dev = hw->priv;
 
 	set_bit(MT76_SCANNING, &dev->mt76.state);
+	tasklet_disable(&dev->pre_tbtt_tasklet);
 	mt7603_beacon_set_timer(dev, -1, 0);
 }
 
@@ -545,6 +546,7 @@ mt7603_sw_scan_complete(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	clear_bit(MT76_SCANNING, &dev->mt76.state);
 	mt7603_beacon_set_timer(dev, -1, dev->beacon_int);
+	tasklet_enable(&dev->pre_tbtt_tasklet);
 }
 
 static void
-- 
2.20.1

