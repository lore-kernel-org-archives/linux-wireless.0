Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24366C282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F258620857
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfDILhx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:37:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44208 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727310AbfDILhw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:37:52 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5F69AC05D3FA;
        Tue,  9 Apr 2019 11:37:52 +0000 (UTC)
Received: from localhost (ovpn-204-224.brq.redhat.com [10.40.204.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF5B264285;
        Tue,  9 Apr 2019 11:37:51 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Gabor Juhos <juhosg@openwrt.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 19/21] rt2x00: rt2800lib: fix VGC setup for RT3883
Date:   Tue,  9 Apr 2019 13:37:06 +0200
Message-Id: <1554809828-13500-20-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
References: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 09 Apr 2019 11:37:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index a3b5b51d7779..b0701aba50de 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5526,7 +5526,8 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 		else
 			vgc = 0x2e + rt2x00dev->lna_gain;
 	} else { /* 5GHZ band */
-		if (rt2x00_rt(rt2x00dev, RT3593))
+		if (rt2x00_rt(rt2x00dev, RT3593) ||
+		    rt2x00_rt(rt2x00dev, RT3883))
 			vgc = 0x20 + (rt2x00dev->lna_gain * 5) / 3;
 		else if (rt2x00_rt(rt2x00dev, RT5592))
 			vgc = 0x24 + (2 * rt2x00dev->lna_gain);
@@ -5546,7 +5547,8 @@ static inline void rt2800_set_vgc(struct rt2x00_dev *rt2x00dev,
 {
 	if (qual->vgc_level != vgc_level) {
 		if (rt2x00_rt(rt2x00dev, RT3572) ||
-		    rt2x00_rt(rt2x00dev, RT3593)) {
+		    rt2x00_rt(rt2x00dev, RT3593) ||
+		    rt2x00_rt(rt2x00dev, RT3883)) {
 			rt2800_bbp_write_with_rx_chain(rt2x00dev, 66,
 						       vgc_level);
 		} else if (rt2x00_rt(rt2x00dev, RT5592)) {
@@ -5593,6 +5595,11 @@ void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
 		}
 		break;
 
+	case RT3883:
+		if (qual->rssi > -65)
+			vgc += 0x10;
+		break;
+
 	case RT5592:
 		if (qual->rssi > -65)
 			vgc += 0x20;
-- 
2.7.5

