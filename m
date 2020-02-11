Return-Path: <SRS0=yzGj=37=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DCD1C352A4
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Feb 2020 01:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED8E62082F
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Feb 2020 01:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbgBKBWe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Feb 2020 20:22:34 -0500
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:56116 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbgBKBWd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Feb 2020 20:22:33 -0500
Received: from isengard.fritz.box (unknown [93.209.10.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id EC5B0580068;
        Tue, 11 Feb 2020 02:22:31 +0100 (CET)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH 2/2] iw: scan: parse AP Channel Report
Date:   Tue, 11 Feb 2020 02:22:27 +0100
Message-Id: <20200211012227.6907-2-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200211012227.6907-1-markus.theil@tu-ilmenau.de>
References: <20200211012227.6907-1-markus.theil@tu-ilmenau.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
---
 scan.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/scan.c b/scan.c
index c03ca2a..e6c3736 100644
--- a/scan.c
+++ b/scan.c
@@ -732,6 +732,21 @@ static void print_erp(const uint8_t type, uint8_t len, const uint8_t *data,
 	printf("\n");
 }
 
+static void print_ap_channel_report(const uint8_t type, uint8_t len, const uint8_t *data,
+				    const struct print_ies_data *ie_buffer)
+{
+	uint8_t oper_class = data[0];
+	int i;
+
+	printf("\n");
+	printf("\t\t * operating class: %d\n", oper_class);
+	printf("\t\t * channel(s):");
+	for (i = 1; i < len; ++i) {
+		printf(" %d", data[i]);
+	}
+	printf("\n");
+}
+
 static void print_cipher(const uint8_t *data)
 {
 	if (memcmp(data, ms_oui, 3) == 0) {
@@ -1697,6 +1712,7 @@ static const struct ie_print ieprinters[] = {
 	[42] = { "ERP", print_erp, 1, 255, BIT(PRINT_SCAN), },
 	[45] = { "HT capabilities", print_ht_capa, 26, 26, BIT(PRINT_SCAN), },
 	[47] = { "ERP D4.0", print_erp, 1, 255, BIT(PRINT_SCAN), },
+	[51] = { "AP Channel Report", print_ap_channel_report, 1, 255, BIT(PRINT_SCAN), },
 	[59] = { "Supported operating classes", print_supp_op_classes, 1, 255, BIT(PRINT_SCAN), },
 	[66] = { "Measurement Pilot Transmission", print_measurement_pilot_tx, 1, 255, BIT(PRINT_SCAN), },
 	[74] = { "Overlapping BSS scan params", print_obss_scan_params, 14, 255, BIT(PRINT_SCAN), },
-- 
2.25.0

