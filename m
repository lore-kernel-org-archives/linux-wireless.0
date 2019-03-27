Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6633CC4360F
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FFEE205C9
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553712489;
	bh=CNyzgmQlVVZObtHTQXU+S8sVQB1oL3W9h1AuiRvSM/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=sq9RnJmfLnuc7vpPCXOCmn6L9k4p8IuYBOjQ9BsJ5b/ulU5ATiigUVYPzaTZSje0q
	 8mzK2vzCZsr3S4rOzG1QUEAbtLEbQ+aYe2Oh2eJs279+Lf0tVp5FPZtDEZByiHTExn
	 gPDYTprdfhkFRk1g+B9iXjgAi1CvkVjga2m5GaIY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390709AbfC0STX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:19:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390696AbfC0STU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 14:19:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F2562184E;
        Wed, 27 Mar 2019 18:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710760;
        bh=CNyzgmQlVVZObtHTQXU+S8sVQB1oL3W9h1AuiRvSM/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BY0QWCErABjp1pn5FvGexZ7rzg0Tr/tL1VZSmmNMKfdoexsN3z5f9Z2suZLDFtP2C
         QGchoEWVXGL8gsGw/IorfiquA9xkdxOKgIOmOhREh8lC/ttnRVm/uRzjs1jzUiE5lW
         TggqDQap5IFdto+PisK1iP7mRG+R0591EUdQGWyc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 091/123] mt7601u: bump supported EEPROM version
Date:   Wed, 27 Mar 2019 14:15:55 -0400
Message-Id: <20190327181628.15899-91-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327181628.15899-1-sashal@kernel.org>
References: <20190327181628.15899-1-sashal@kernel.org>
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

