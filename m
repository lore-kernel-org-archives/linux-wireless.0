Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F10EDC10F00
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B858120449
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553711664;
	bh=CNyzgmQlVVZObtHTQXU+S8sVQB1oL3W9h1AuiRvSM/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hY/7j74/KAdbk51cQPj2krAHHfq0nMkPZ4QB4TjBRR0AqgKl7/uBze0lElvyA7gEV
	 7FBhgNuJa/EoWeHqh1jampwP62uzvv466Lsfo0GuTCBMI9OUgxxKV1cHXT9LXCBn/6
	 dH7pJvWSJ5YAhFOyA2Jb8VFbyZb/VKkwhmlCaaZI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391596AbfC0SYw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:24:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404055AbfC0SYs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 14:24:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 091C72070B;
        Wed, 27 Mar 2019 18:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553711087;
        bh=CNyzgmQlVVZObtHTQXU+S8sVQB1oL3W9h1AuiRvSM/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pP5cBLFD0YtNbhMg4OOKMnVYWw29VyByqXsOcPsjQjP18Dj4jd02IL5GLAhL19Pvm
         rGqwNt6XrXNYe8L2koN9Wqd3c0TFvq3xNuj4nBDSbnup7zolR49fOsN3FKOmoT+M37
         SKiekdSrfm2scxqgRfkrMOorOZB1P54V9pd2ryyo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 48/63] mt7601u: bump supported EEPROM version
Date:   Wed, 27 Mar 2019 14:23:08 -0400
Message-Id: <20190327182323.18577-48-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327182323.18577-1-sashal@kernel.org>
References: <20190327182323.18577-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Stanislaw Gruszka <sgruszka@redhat.com>

[ Upstream commit 3bd1505fed71d834f45e87b32ff07157fdda47e0 ]

As reported by Michael eeprom 0d is supported and work with the driver.

Dump of /sys/kernel/debug/ieee80211/phy1/mt7601u/eeprom_param
with 0d EEPORM looks like this:

RSSI offset: 0 0
Reference temp: f9
LNA gain: 8
Reg channels: 1-14
Per rate power:
	 raw:05 bw20:05 bw40:05
	 raw:05 bw20:05 bw40:05
	 raw:03 bw20:03 bw40:03
	 raw:03 bw20:03 bw40:03
	 raw:04 bw20:04 bw40:04
	 raw:00 bw20:00 bw40:00
	 raw:00 bw20:00 bw40:00
	 raw:00 bw20:00 bw40:00
	 raw:02 bw20:02 bw40:02
	 raw:00 bw20:00 bw40:00
Per channel power:
	 tx_power  ch1:09 ch2:09
	 tx_power  ch3:0a ch4:0a
	 tx_power  ch5:0a ch6:0a
	 tx_power  ch7:0b ch8:0b
	 tx_power  ch9:0b ch10:0b
	 tx_power  ch11:0b ch12:0b
	 tx_power  ch13:0b ch14:0b

Reported-and-tested-by: Michael <ZeroBeat@gmx.de>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Jakub Kicinski <kubakici@wp.pl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt7601u/eeprom.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/eeprom.h b/drivers/net/wireless/mediatek/mt7601u/eeprom.h
index 662d12703b69..57b503ae63f1 100644
--- a/drivers/net/wireless/mediatek/mt7601u/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt7601u/eeprom.h
@@ -17,7 +17,7 @@
 
 struct mt7601u_dev;
 
-#define MT7601U_EE_MAX_VER			0x0c
+#define MT7601U_EE_MAX_VER			0x0d
 #define MT7601U_EEPROM_SIZE			256
 
 #define MT7601U_DEFAULT_TX_POWER		6
-- 
2.19.1

