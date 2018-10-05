Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC55AC00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 21:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E6D3208E7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 21:14:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E6D3208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hauke-m.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbeJFEPN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 00:15:13 -0400
Received: from mx1.mailbox.org ([80.241.60.212]:58212 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725761AbeJFEPM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 00:15:12 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.mailbox.org (Postfix) with ESMTPS id 610F749402;
        Fri,  5 Oct 2018 23:14:41 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id ngw0F0MPN3lG; Fri,  5 Oct 2018 23:14:40 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH iw] scan: Decode additional Authentication types
Date:   Fri,  5 Oct 2018 23:14:31 +0200
Message-Id: <20181005211431.18835-1-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This adds some more authentication types, the constants are taken from
hostapd. I only tested SAE, FT/SAE and OWE.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scan.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/scan.c b/scan.c
index a621813..7695216 100644
--- a/scan.c
+++ b/scan.c
@@ -808,6 +808,36 @@ static void print_auth(const uint8_t *data)
 		case 7:
 			printf("TDLS/TPK");
 			break;
+		case 8:
+			printf("SAE");
+			break;
+		case 9:
+			printf("FT/SAE");
+			break;
+		case 11:
+			printf("IEEE 802.1X/SUITE-B");
+			break;
+		case 12:
+			printf("IEEE 802.1X/SUITE-B-192");
+			break;
+		case 13:
+			printf("FT/IEEE 802.1X/SHA-384");
+			break;
+		case 14:
+			printf("FILS/SHA-256");
+			break;
+		case 15:
+			printf("FILS/SHA-384");
+			break;
+		case 16:
+			printf("FT/FILS/SHA-256");
+			break;
+		case 17:
+			printf("FT/FILS/SHA-384");
+			break;
+		case 18:
+			printf("OWE");
+			break;
 		default:
 			printf("%.02x-%.02x-%.02x:%d",
 				data[0], data[1] ,data[2], data[3]);
@@ -818,6 +848,9 @@ static void print_auth(const uint8_t *data)
 		case 1:
 			printf("OSEN");
 			break;
+		case 2:
+			printf("DPP");
+			break;
 		default:
 			printf("%.02x-%.02x-%.02x:%d",
 				data[0], data[1] ,data[2], data[3]);
-- 
2.11.0

