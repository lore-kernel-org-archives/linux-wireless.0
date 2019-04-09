Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1063C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 911FC20857
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfDILhy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:37:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbfDILhy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:37:54 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DC59B308338F;
        Tue,  9 Apr 2019 11:37:53 +0000 (UTC)
Received: from localhost (ovpn-204-224.brq.redhat.com [10.40.204.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7457E5D9C9;
        Tue,  9 Apr 2019 11:37:53 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Gabor Juhos <juhosg@openwrt.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 20/21] rt2x00: rt2800lib: fix EEPROM LNA validation for RT3883
Date:   Tue,  9 Apr 2019 13:37:07 +0200
Message-Id: <1554809828-13500-21-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
References: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 09 Apr 2019 11:37:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index b0701aba50de..a401fd60f9a6 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -9261,7 +9261,8 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	word = rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2);
 	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_BG2_OFFSET2)) > 10)
 		rt2x00_set_field16(&word, EEPROM_RSSI_BG2_OFFSET2, 0);
-	if (!rt2x00_rt(rt2x00dev, RT3593)) {
+	if (!rt2x00_rt(rt2x00dev, RT3593) &&
+	    !rt2x00_rt(rt2x00dev, RT3883)) {
 		if (rt2x00_get_field16(word, EEPROM_RSSI_BG2_LNA_A1) == 0x00 ||
 		    rt2x00_get_field16(word, EEPROM_RSSI_BG2_LNA_A1) == 0xff)
 			rt2x00_set_field16(&word, EEPROM_RSSI_BG2_LNA_A1,
@@ -9281,7 +9282,8 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	word = rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_A2);
 	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_A2_OFFSET2)) > 10)
 		rt2x00_set_field16(&word, EEPROM_RSSI_A2_OFFSET2, 0);
-	if (!rt2x00_rt(rt2x00dev, RT3593)) {
+	if (!rt2x00_rt(rt2x00dev, RT3593) &&
+	    !rt2x00_rt(rt2x00dev, RT3883)) {
 		if (rt2x00_get_field16(word, EEPROM_RSSI_A2_LNA_A2) == 0x00 ||
 		    rt2x00_get_field16(word, EEPROM_RSSI_A2_LNA_A2) == 0xff)
 			rt2x00_set_field16(&word, EEPROM_RSSI_A2_LNA_A2,
@@ -9289,7 +9291,8 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	}
 	rt2800_eeprom_write(rt2x00dev, EEPROM_RSSI_A2, word);
 
-	if (rt2x00_rt(rt2x00dev, RT3593)) {
+	if (rt2x00_rt(rt2x00dev, RT3593) ||
+	    rt2x00_rt(rt2x00dev, RT3883)) {
 		word = rt2800_eeprom_read(rt2x00dev, EEPROM_EXT_LNA2);
 		if (rt2x00_get_field16(word, EEPROM_EXT_LNA2_A1) == 0x00 ||
 		    rt2x00_get_field16(word, EEPROM_EXT_LNA2_A1) == 0xff)
-- 
2.7.5

