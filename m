Return-Path: <SRS0=AjYM=2X=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CD9C2D0DE
	for <linux-wireless@archiver.kernel.org>; Thu,  2 Jan 2020 02:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C71F20848
	for <linux-wireless@archiver.kernel.org>; Thu,  2 Jan 2020 02:40:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lMeMeKCs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgABCkT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 1 Jan 2020 21:40:19 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35152 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727509AbgABCkT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Jan 2020 21:40:19 -0500
Received: by mail-pf1-f194.google.com with SMTP id i23so15964692pfo.2
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jan 2020 18:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ik4sUnxhF0DvP7haKsqS0HABbUNO8O83AVhO2/FQ10M=;
        b=lMeMeKCsrEMuYCeD0WWS1FJTx2/+GoLXKrFPpyqN1OQx7VUn8YT2OYccNYm3pK65H/
         EBLvvTGlwFiDwyaISH7TUP9cQA4OJ7YZxzkFnDE4GTP4rsjXlfixKV0gyEitv/pgGzFJ
         M+JEspwAwMN7j4KgQTRU9TP8u/IaIerPyqTeCPViZKkM9S183RSEhCHsQIea5U1DeXoh
         lzqSO+vbCIcDnAms8/9w48baU5OZh7nl3t1qlwo5o19OSKafbWQDGomsBIsNRoaOFrkY
         9nHW+TJtU0P4K31F//lei5QutO8JY9rvXOsqGMySH+Yz4X+9tbX8o8UuO7NQIZwt4Nc6
         HZZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ik4sUnxhF0DvP7haKsqS0HABbUNO8O83AVhO2/FQ10M=;
        b=ayW9lDMHQhPvOfzD0xDGH03OQVjGaZ9snBus6H4Y58jv7LlZIHgLUl5aJ0iTRxkFqc
         Oog7GAiaTaL9MVMJo6wps6pdwX1jWvIDYZFv6KjRCfTIjvakKqiL19QDxbpM6L50mgVg
         2mPkcIqc1zZgFqmX/YCdmLIaecmIv8WE4vBqhZ4NCl3ExiHMNJVO/YJnTYvnbHSutBzU
         7fs9LHrDfp1RF1xujBgad1mtpVm6651Qfbmy193x+OtwNwWd9t04R1iSGpDtBTjgMyn3
         OrkEq4oGl3a8U3OmaxXvo/ihLneo9D7pbbVHtYBcHfRWbZy0JCetc3d7Jas/3+QePpax
         ilFA==
X-Gm-Message-State: APjAAAU0YfZ2Fgd94rRCYBvgFGjOBdOrJmxEmf7SgsXlnD8V9UkpVFP8
        9QglYGyRhOZ3fgcCB4HrqDCzfjfJMbk=
X-Google-Smtp-Source: APXvYqxNlITRUGqHlC8YWSDIPjshda6Mt4Va9JGL/9mmKzbKM3Ev4R2BEPOp/8aZontloZTEAWE3wg==
X-Received: by 2002:a65:5a8f:: with SMTP id c15mr78552185pgt.259.1577932818273;
        Wed, 01 Jan 2020 18:40:18 -0800 (PST)
Received: from localhost (172.96.199.36.16clouds.com. [172.96.199.36])
        by smtp.gmail.com with ESMTPSA id w11sm56214288pgs.60.2020.01.01.18.40.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Jan 2020 18:40:17 -0800 (PST)
From:   m1s5p6688@gmail.com
To:     linux-wireless@vger.kernel.org
Cc:     amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxinming820@gmail.com
Subject: [PATCH 2/2] mwifiex: Fix possible buffer overflows in mwifiex_cmd_append_vsie_tlv()
Date:   Thu,  2 Jan 2020 10:39:27 +0800
Message-Id: <20200102023927.4687-3-m1s5p6688@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200102023927.4687-1-m1s5p6688@gmail.com>
References: <20200102023927.4687-1-m1s5p6688@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Qing Xu <m1s5p6688@gmail.com>

mwifiex_cmd_append_vsie_tlv() calls memcpy() without checking 
the destination size may trigger a buffer overflower,
which a local user could use to cause denial of service 
or the execution of arbitrary code.
Fix it by putting the length check before calling memcpy().

Signed-off-by: Qing Xu <m1s5p6688@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 98f942b79..a7968a84a 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -2884,6 +2884,13 @@ mwifiex_cmd_append_vsie_tlv(struct mwifiex_private *priv,
 			vs_param_set->header.len =
 				cpu_to_le16((((u16) priv->vs_ie[id].ie[1])
 				& 0x00FF) + 2);
+			if (le16_to_cpu(vs_param_set->header.len) >
+				MWIFIEX_MAX_VSIE_LEN) {
+				mwifiex_dbg(priv->adapter, ERROR,
+					    "Invalid param length!\n");
+				break;
+			}
+
 			memcpy(vs_param_set->ie, priv->vs_ie[id].ie,
 			       le16_to_cpu(vs_param_set->header.len));
 			*buffer += le16_to_cpu(vs_param_set->header.len) +
-- 
2.17.1

