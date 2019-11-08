Return-Path: <SRS0=s5sB=ZA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E30E7C5DF60
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Nov 2019 11:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF8C222466
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Nov 2019 11:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573213663;
	bh=HImH6DBQCdYDbrYV5nm8VU8wabB9MtuWvxvVxo2aZSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=z13lcqifGtKMJhKUvByP9lWNCVrZwuRJ8KZRdkuG30bIyD5A0/tfll4QFOlarkGGd
	 DXVowgachgQTjw51ie1p7xU8zusYySY0ocZ/yOnuB14+i2QEa704Z6/RcBwXi/RC1h
	 H+5CXkcmJgjXW1C6PqMltD1FHVXwM8jv1tmXMmqM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391618AbfKHLrn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Nov 2019 06:47:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403855AbfKHLrj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Nov 2019 06:47:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2B712245B;
        Fri,  8 Nov 2019 11:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213658;
        bh=HImH6DBQCdYDbrYV5nm8VU8wabB9MtuWvxvVxo2aZSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hnbi4LlsyAcVxk7Y5HCZ/CNV5ZorHXIMfrl2Ng2vj7z1vsqzE8xy5AuGcZWUAqPJg
         qm8nCgY/O9do3M02C2cjDWAF4bS9S6SWark6zppvrneIr3V+gFTm/2c5R5IMPARwVN
         T5Cza+W+BfpzsYT+rc2iu2OdPOlYkwDADzKk6160=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 13/44] rtl8187: Fix warning generated when strncpy() destination length matches the sixe argument
Date:   Fri,  8 Nov 2019 06:46:49 -0500
Message-Id: <20191108114721.15944-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114721.15944-1-sashal@kernel.org>
References: <20191108114721.15944-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

[ Upstream commit 199ba9faca909e77ac533449ecd1248123ce89e7 ]

In gcc8, when the 3rd argument (size) of a call to strncpy() matches the
length of the first argument, the compiler warns of the possibility of an
unterminated string. Using strlcpy() forces a null at the end.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c
index c2d5b495c179a..c089540116fa7 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c
@@ -146,7 +146,7 @@ static int rtl8187_register_led(struct ieee80211_hw *dev,
 	led->dev = dev;
 	led->ledpin = ledpin;
 	led->is_radio = is_radio;
-	strncpy(led->name, name, sizeof(led->name));
+	strlcpy(led->name, name, sizeof(led->name));
 
 	led->led_dev.name = led->name;
 	led->led_dev.default_trigger = default_trigger;
-- 
2.20.1

