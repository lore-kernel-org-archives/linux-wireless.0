Return-Path: <SRS0=WqAe=ZU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA567C432C0
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Nov 2019 10:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAA4021775
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Nov 2019 10:51:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J7c1UxJD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfK1Kv1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Nov 2019 05:51:27 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45086 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfK1Kv1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Nov 2019 05:51:27 -0500
Received: by mail-pg1-f193.google.com with SMTP id k1so12703495pgg.12
        for <linux-wireless@vger.kernel.org>; Thu, 28 Nov 2019 02:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=LndVCVdyoyZcnNWnXR3HrWqX88bh3YcihiD6qVudXCk=;
        b=J7c1UxJDWt/OxLpxsox868Htwk5+FQKl7B6w5ML5B6HzgFrklVi7bQjnRbuOM+cyVt
         6O2z6i+FtW0Hg18yELjzeNXf/pBUVI5Lncy4cnF1aYPfloXG3sAJm14VVexj0UHrkhnj
         sBV5IlfO7XKGWfjGnb/Axr3SQLjty2VyHR3QoR2QjteCr72CJpuHfC0cv7Z6jT/o5G6P
         AJ+czL3adSLlaSeI6gC5JSGZzkLm3uJEWK2PCw4fjwGomWKnGyApQqNcwkyyBmWSfBZf
         tDkT2jngewMGcsjwiqDezhcJo7lkmhfjl+Yfr4luBk1+pwL4kGHLKTPOJR5eUkCo/BAC
         baqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=LndVCVdyoyZcnNWnXR3HrWqX88bh3YcihiD6qVudXCk=;
        b=g2sTT9hcQXHq8MG2SiBSXh7MkVOAzdvDSdtlPZEeWilXsyw0JNX5v9/WNXecaDSMtv
         Vfb9CFItOW/yXH7U3drRyuD7HQ1D3aZ75aK/H7HEByQ8jN2w7tfI8jufTnQu5J5f0SSP
         DX6lDvNVmN9/za2KPkOwIWnsgil0WQ9Gr0LmMK2kuIFZCW1kS2xcWsn9XrpZDiJPFO5R
         Qbr1Se9ZDYtIQnd303JoqW0b5xvBzwZ3f8BgLEvrLgWS8VHd+dMPpZPAPqFS4C/9gnZ6
         W53QDWLYYKvBJMTgKd2tLqwEjV/p01a5HifCPSlVlbA83s2FU2Duzjdhlc7zX4n2iHK3
         4ryw==
X-Gm-Message-State: APjAAAV3cA1a3Mn+UYuibK00F+QhWMsvRPK4W7DvFsD8O2tmYJJFoyRi
        3TAoZciW1/uP7ng/WLRUaNKiT2en7Eg=
X-Google-Smtp-Source: APXvYqweuHIeDG/aJ2zD0YGzsF3EvMSUTYWUD33QVXKQJqEbvuyDO8qUutwlcDbchxSeP2wqrkdZ/Q==
X-Received: by 2002:a62:606:: with SMTP id 6mr52092878pfg.76.1574938285934;
        Thu, 28 Nov 2019 02:51:25 -0800 (PST)
Received: from localhost (123202111008.ctinets.com. [123.202.111.8])
        by smtp.gmail.com with ESMTPSA id q22sm4861232pfg.170.2019.11.28.02.51.24
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Nov 2019 02:51:25 -0800 (PST)
From:   huangwenabc@gmail.com
To:     linux-wireless@vger.kernel.org
Subject: [PATCH] libertas: Fix two buffer overflows at parsing bss descriptor
Date:   Thu, 28 Nov 2019 18:51:04 +0800
Message-Id: <20191128105104.52920-1-huangwenabc@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wen Huang <huangwenabc@gmail.com>

add_ie_rates() copys rates without checking the length 
in bss descriptor from remote AP.when victim connects to 
remote attacker, this may trigger buffer overflow.
lbs_ibss_join_existing() copys rates without checking the length 
in bss descriptor from remote IBSS node.when victim connects to 
remote attacker, this may trigger buffer overflow.
Fix them by putting the length check before performing copy.

This fix addresses CVE-2019-14896 and CVE-2019-14897.
This also fix build warning of mixed declarations and code.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Wen Huang <huangwenabc@gmail.com>
---
 drivers/net/wireless/marvell/libertas/cfg.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 57edfada0..c9401c121 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -273,6 +273,10 @@ add_ie_rates(u8 *tlv, const u8 *ie, int *nrates)
 	int hw, ap, ap_max = ie[1];
 	u8 hw_rate;
 
+	if (ap_max > MAX_RATES) {
+		lbs_deb_assoc("invalid rates\n");
+		return tlv;
+	}
 	/* Advance past IE header */
 	ie += 2;
 
@@ -1717,6 +1721,9 @@ static int lbs_ibss_join_existing(struct lbs_private *priv,
 	struct cmd_ds_802_11_ad_hoc_join cmd;
 	u8 preamble = RADIO_PREAMBLE_SHORT;
 	int ret = 0;
+	int hw, i;
+	u8 rates_max;
+	u8 *rates;
 
 	/* TODO: set preamble based on scan result */
 	ret = lbs_set_radio(priv, preamble, 1);
@@ -1775,9 +1782,12 @@ static int lbs_ibss_join_existing(struct lbs_private *priv,
 	if (!rates_eid) {
 		lbs_add_rates(cmd.bss.rates);
 	} else {
-		int hw, i;
-		u8 rates_max = rates_eid[1];
-		u8 *rates = cmd.bss.rates;
+		rates_max = rates_eid[1];
+		if (rates_max > MAX_RATES) {
+			lbs_deb_join("invalid rates");
+			goto out;
+		}
+		rates = cmd.bss.rates;
 		for (hw = 0; hw < ARRAY_SIZE(lbs_rates); hw++) {
 			u8 hw_rate = lbs_rates[hw].bitrate / 5;
 			for (i = 0; i < rates_max; i++) {
-- 
2.17.1

