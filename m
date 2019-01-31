Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF2EC169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 05:53:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5B472087F
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 05:53:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CvLcYvmY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbfAaFxd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 00:53:33 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46986 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfAaFxd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 00:53:33 -0500
Received: by mail-pf1-f194.google.com with SMTP id c73so972246pfe.13
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2019 21:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N962v1NYYO1siutE7EpJRXlUasnp8tyEzinNsSx9Z9I=;
        b=CvLcYvmYnS+/lBJWY3lEfrfk5xJLL1UqLZ1XyUt+Gg54Zte1oayYBeVn4ptda3xixb
         mrxUwu1kdCy5oTxwt6nHVV2sJOzCw7d3eeavHS3L7vioL4HPQO7W+ewZMruuVaFg6CAI
         358JscH/8UTwvmDL/IyYSSnjBxuuetHa1Uq0oBxJOTyUw+9xZ2D280/ltPoIuahDltP+
         7ThFIxmJa2jl+bd3BjDT6H2LIFo8K5uMYoezTAG5iNmNT2a0ZPkIl1NPjshuX2Acl5uw
         fkGT+SFT64T+uH141spbC7Fn9EoNnqqK7H1WsdZRspXZR1h6faNdI00P6U4UaQPOKKfr
         0a4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=N962v1NYYO1siutE7EpJRXlUasnp8tyEzinNsSx9Z9I=;
        b=clExEPiSvzAe+hQ17EYM9JGSh1MOOWvJUhZd1zhaDCdh/RgPCyIY33+1zVrOutzB3l
         knIKNxV5keIsyRV95TG66oG7InLRimVsr9OyRYjD0R/7pnmbiFKS4nYdyGFInK1IwHdE
         K0uXyD5ACMt+mrYucZyoMwkf1doetJU0oE7TUvpepcvfkTe/vWEimBzi0CqRemGMaWCF
         GtqcuunNJdSVA2qqfLdH3Kq3cSMjM0MXXK4JWYH/yQSgDJE0ljqiRLe0CJykXKfv4xGe
         lL4hUhDxuPCey8QqRE9segU4n9dLAYfPUj3tilf6s+Wj6sbNKCvD+4KBYQ1zh4UYN7KH
         Wibw==
X-Gm-Message-State: AJcUukcqbUlpWx4jscg765P39P8+ls2nrtpQaDu0D2VjLBUYVrNDDxpB
        e/HfnWYQuY7IcNnjdyBkC1kUGSEr+WqErg==
X-Google-Smtp-Source: ALg8bN6LHIuMziC4HR9iw1deqzAeeV4lfiHOCA6jl9/08/09yc1OdFyljh3kojxYNshwZzH84l0ICg==
X-Received: by 2002:a62:4bcf:: with SMTP id d76mr35044979pfj.170.1548914012559;
        Wed, 30 Jan 2019 21:53:32 -0800 (PST)
Received: from cpu459.localdomain ([203.196.161.90])
        by smtp.gmail.com with ESMTPSA id h19sm4314493pfn.114.2019.01.30.21.53.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 21:53:31 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, rishikesh.basu@redpinesignals.com,
        siva.rebbagondla@redpinesignals.com,
        krishna.pedda@redpinesignals.com,
        ganapathi.kondraju@redpinesignals.com
Subject: [v2 1/5] rsi: Add debug support for wowlan wakeup confirmation
Date:   Thu, 31 Jan 2019 11:23:01 +0530
Message-Id: <1548913985-7180-2-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1548913985-7180-1-git-send-email-siva8118@gmail.com>
References: <1548913985-7180-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

When a wowlan magic-packet has received to wake up the device, currently
driver is not taking care of what kind of packet has received. This patch
will add debug support for wakeup reason in driver.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 4042414..4c2c776 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -2003,6 +2003,35 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
 			return -1;
 		rsi_send_beacon(common);
 		break;
+	case WOWLAN_WAKEUP_REASON:
+		rsi_dbg(ERR_ZONE, "\n\nWakeup Type: %x\n", msg[15]);
+		switch (msg[15]) {
+		case RSI_UNICAST_MAGIC_PKT:
+			rsi_dbg(ERR_ZONE,
+				"*** Wakeup for Unicast magic packet ***\n");
+			break;
+		case RSI_BROADCAST_MAGICPKT:
+			rsi_dbg(ERR_ZONE,
+				"*** Wakeup for Broadcast magic packet ***\n");
+			break;
+		case RSI_EAPOL_PKT:
+			rsi_dbg(ERR_ZONE,
+				"*** Wakeup for GTK renewal ***\n");
+			break;
+		case RSI_DISCONNECT_PKT:
+			rsi_dbg(ERR_ZONE,
+				"*** Wakeup for Disconnect ***\n");
+			break;
+		case RSI_HW_BMISS_PKT:
+			rsi_dbg(ERR_ZONE,
+				"*** Wakeup for HW Beacon miss ***\n");
+			break;
+		default:
+			rsi_dbg(ERR_ZONE,
+				"##### Un-intentional Wakeup #####\n");
+			break;
+	}
+	break;
 	case RX_DOT11_MGMT:
 		return rsi_mgmt_pkt_to_core(common, msg, msg_len);
 	default:
-- 
2.5.5

