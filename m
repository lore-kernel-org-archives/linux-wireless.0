Return-Path: <SRS0=yzGj=37=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8CFC3B186
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Feb 2020 01:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2526D2082F
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Feb 2020 01:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbgBKBWd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Feb 2020 20:22:33 -0500
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:56111 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727523AbgBKBWd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Feb 2020 20:22:33 -0500
Received: from isengard.fritz.box (unknown [93.209.10.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id 83ADE580065;
        Tue, 11 Feb 2020 02:22:31 +0100 (CET)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH 1/2] iw: scan: parse wps version2
Date:   Tue, 11 Feb 2020 02:22:26 +0100
Message-Id: <20200211012227.6907-1-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
---
 scan.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/scan.c b/scan.c
index 2dedd64..c03ca2a 100644
--- a/scan.c
+++ b/scan.c
@@ -1931,6 +1931,18 @@ static void print_wifi_wps(const uint8_t type, uint8_t len, const uint8_t *data,
 				data[12], data[13], data[14], data[15],
 				data[16], data[17], data[18], data[19]);
 			break;
+		case 0x1049:
+			tab_on_first(&first);
+			if (sublen == 6 && 
+			    data[4] == 0x00 &&
+			    data[5] == 0x37 &&
+			    data[6] == 0x2a &&
+			    data[7] == 0x00 &&
+			    data[8] == 0x01) {
+				uint8_t v2 = data[9];
+				printf("\t * Version2: %d.%d\n", v2 >> 4, v2 & 0xf);
+			}
+			break;
 		case 0x1054: {
 			tab_on_first(&first);
 			if (sublen != 8) {
-- 
2.25.0

