Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258BCC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 20:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B24B320870
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 20:48:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B24B320870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hauke-m.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbeJKEMN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 00:12:13 -0400
Received: from mx2.mailbox.org ([80.241.60.215]:14472 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbeJKEMN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 00:12:13 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id 77B044062F;
        Wed, 10 Oct 2018 22:48:20 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id DKge78E_7PTE; Wed, 10 Oct 2018 22:48:19 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] iw: scan: parse OWE Transition Mode element
Date:   Wed, 10 Oct 2018 22:47:47 +0200
Message-Id: <20181010204747.1555-2-hauke@hauke-m.de>
In-Reply-To: <20181010204747.1555-1-hauke@hauke-m.de>
References: <20181010204747.1555-1-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This adds code to parse the Opportunistic Wireless Encryption Transition
Mode element.

Without this patch the output looks like this:
WFA 0x1c, data: 00 37 b7 36 dc 0c 08 4f 70 65 6e 57 72 74 34
With this patch it looks like this:
        OWE Transition Mode:
                BSSID: 00:37:b7:36:dc:0c
                SSID: OpenWrt4

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scan.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/scan.c b/scan.c
index 7695216..a798c70 100644
--- a/scan.c
+++ b/scan.c
@@ -1950,10 +1950,39 @@ static inline void print_hs20_ind(const uint8_t type, uint8_t len,
 		printf("\t\tUnexpected length: %i\n", len);
 }
 
+static void print_wifi_owe_tarns(const uint8_t type, uint8_t len,
+				 const uint8_t *data,
+				 const struct print_ies_data *ie_buffer)
+{
+	char mac_addr[20];
+	int ssid_len;
+
+	printf("\n");
+	if (len < 7)
+		return;
+
+	mac_addr_n2a(mac_addr, data);
+	printf("\t\tBSSID: %s\n", mac_addr);
+
+	ssid_len = data[6];
+	if (ssid_len > len - 7)
+		return;
+	printf("\t\tSSID: ");
+	print_ssid_escaped(ssid_len, data + 7);
+	printf("\n");
+
+	/* optional elements */
+	if (len >= ssid_len + 9) {
+		printf("\t\tBand Info: %u\n", data[ssid_len + 7]);
+		printf("\t\tChannel Info: %u\n", data[ssid_len + 8]);
+	}
+}
+
 static const struct ie_print wfa_printers[] = {
 	[9] = { "P2P", print_p2p, 2, 255, BIT(PRINT_SCAN), },
 	[16] = { "HotSpot 2.0 Indication", print_hs20_ind, 1, 255, BIT(PRINT_SCAN), },
 	[18] = { "HotSpot 2.0 OSEN", print_wifi_osen, 1, 255, BIT(PRINT_SCAN), },
+	[28] = { "OWE Transition Mode", print_wifi_owe_tarns, 7, 255, BIT(PRINT_SCAN), },
 };
 
 static void print_vendor(unsigned char len, unsigned char *data,
-- 
2.11.0

