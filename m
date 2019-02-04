Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A2BC282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 06:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44F822177E
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 06:33:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XRU8yBlh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfBDGdw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 01:33:52 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43872 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfBDGdw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 01:33:52 -0500
Received: by mail-pg1-f193.google.com with SMTP id v28so5836238pgk.10
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2019 22:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N962v1NYYO1siutE7EpJRXlUasnp8tyEzinNsSx9Z9I=;
        b=XRU8yBlhKQoch4sQXyOwr/Tq6FtuPbFvHkAk54/GZSZA3lEc6DUUF38PugAMm/T/r2
         6SeXixbzoFBfgTDb6uDM0SWib7W9z3XugoZs/vLhQOnFMY6OjyRkmGHYjIMk3Ig6ftIH
         Aaw5bf5IgpPhSfOgH3KiRS9FYB0u8PTaxAgy7HV/2CXTzHSnUA0Gwu1M6y3mAnzM5F0c
         /vR+hIkNhiXLqZ3eX15IBgKq0E6Xzs4MmJh8h2xU/5qcaXJ+Quun2cumWK7NVSGDLV++
         w9csbyC09Nv/w9Ut2tY0i+1TOhurNEAFlyJn6732TGn+LS38HdWcZ5vhevuLyhzyE5id
         43Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=N962v1NYYO1siutE7EpJRXlUasnp8tyEzinNsSx9Z9I=;
        b=NW5MIR965MjYvkkbkZzVNKd/3Sz5CQLVxUKfTroSEWc9/O4eV2geY6Q3N8xp9omCe7
         lNFzfTt3Ju2iLsNlWTzf+E143+rQ+9hZYvlWUDO9QIWx7kRJfyd1z7Y1A2qaDIxScQB5
         U6tgI69YXRdr9nzdmeY8i2FwJ0p4ycAZVEcBVyhRIrWOW5TbD3Hnmf1nJHGybcQKf3lc
         teSYZJYBsLkBrklKd/gRaVhqGU6ImMvHJs/wNZSuPTzxuAmRGifc52Q56+xMcOZ2frNB
         PUWpnDKg/SyH+43tBVV+Xy4B9pNSmrk851v6tgE6BQZJ54qlCPi+4tvL94sWFJ6/aJkX
         Ah2g==
X-Gm-Message-State: AHQUAuY/WKCBGBPtmmoK5QOYsf/b60WxB+gOIuZ94AeYtuarhiapNAwc
        aPQUo1uPuxvqCDuaLbBpjlQ=
X-Google-Smtp-Source: AHgI3IbiS45oVh9C83JvO2XI1L8d1a+NI3VSLkxy0HAn+W4VjzbyStRpnERTtvxYGOAdUviRaWEfFg==
X-Received: by 2002:a63:160d:: with SMTP id w13mr12079272pgl.43.1549262030919;
        Sun, 03 Feb 2019 22:33:50 -0800 (PST)
Received: from cpu459.localdomain ([27.59.252.63])
        by smtp.gmail.com with ESMTPSA id t21sm20240438pgg.24.2019.02.03.22.33.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 22:33:50 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, rishikesh.basu@redpinesignals.com,
        siva.rebbagondla@redpinesignals.com,
        krishna.pedda@redpinesignals.com, amitkarwar@gmail.com
Subject: [v3 1/5] rsi: Add debug support for wowlan wakeup confirmation
Date:   Mon,  4 Feb 2019 12:03:25 +0530
Message-Id: <1549262009-8766-2-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1549262009-8766-1-git-send-email-siva8118@gmail.com>
References: <1549262009-8766-1-git-send-email-siva8118@gmail.com>
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

