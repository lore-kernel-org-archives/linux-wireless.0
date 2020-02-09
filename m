Return-Path: <SRS0=ZRRt=35=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C96C3F68F
	for <linux-wireless@archiver.kernel.org>; Sun,  9 Feb 2020 16:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9B5220733
	for <linux-wireless@archiver.kernel.org>; Sun,  9 Feb 2020 16:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgBIQ7S (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 9 Feb 2020 11:59:18 -0500
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:49180 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbgBIQ7R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Feb 2020 11:59:17 -0500
Received: from isengard.fritz.box (unknown [84.174.247.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id 09B94580075;
        Sun,  9 Feb 2020 17:59:14 +0100 (CET)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH 5/8] iw: scan: fix buffer over-read in print_wifi_wps
Date:   Sun,  9 Feb 2020 17:58:59 +0100
Message-Id: <20200209165902.44110-6-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200209165902.44110-1-markus.theil@tu-ilmenau.de>
References: <20200209165902.44110-1-markus.theil@tu-ilmenau.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
---
 scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scan.c b/scan.c
index 9a02363..f57925d 100644
--- a/scan.c
+++ b/scan.c
@@ -1818,7 +1818,7 @@ static void print_wifi_wps(const uint8_t type, uint8_t len, const uint8_t *data,
 	while (len >= 4) {
 		subtype = (data[0] << 8) + data[1];
 		sublen = (data[2] << 8) + data[3];
-		if (sublen > len)
+		if (sublen > len - 4)
 			break;
 
 		switch (subtype) {
-- 
2.25.0

