Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C3EEC282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6785220857
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfDILhv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:37:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfDILhu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:37:50 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B6F047F769;
        Tue,  9 Apr 2019 11:37:50 +0000 (UTC)
Received: from localhost (ovpn-204-224.brq.redhat.com [10.40.204.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5541D6199A;
        Tue,  9 Apr 2019 11:37:50 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Gabor Juhos <juhosg@openwrt.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 18/21] rt2x00: rt2800lib: fix LNA gain configuration for RT3883
Date:   Tue,  9 Apr 2019 13:37:05 +0200
Message-Id: <1554809828-13500-19-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
References: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 09 Apr 2019 11:37:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 8fca5e26f36e..a3b5b51d7779 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -2197,7 +2197,8 @@ static void rt2800_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 		eeprom = rt2800_eeprom_read(rt2x00dev, EEPROM_LNA);
 		lna_gain = rt2x00_get_field16(eeprom, EEPROM_LNA_A0);
 	} else if (libconf->rf.channel <= 128) {
-		if (rt2x00_rt(rt2x00dev, RT3593)) {
+		if (rt2x00_rt(rt2x00dev, RT3593) ||
+		    rt2x00_rt(rt2x00dev, RT3883)) {
 			eeprom = rt2800_eeprom_read(rt2x00dev, EEPROM_EXT_LNA2);
 			lna_gain = rt2x00_get_field16(eeprom,
 						      EEPROM_EXT_LNA2_A1);
@@ -2207,7 +2208,8 @@ static void rt2800_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 						      EEPROM_RSSI_BG2_LNA_A1);
 		}
 	} else {
-		if (rt2x00_rt(rt2x00dev, RT3593)) {
+		if (rt2x00_rt(rt2x00dev, RT3593) ||
+		    rt2x00_rt(rt2x00dev, RT3883)) {
 			eeprom = rt2800_eeprom_read(rt2x00dev, EEPROM_EXT_LNA2);
 			lna_gain = rt2x00_get_field16(eeprom,
 						      EEPROM_EXT_LNA2_A2);
-- 
2.7.5

