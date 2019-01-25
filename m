Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B113EC282C2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 06:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81C71218D2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 06:30:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iATih+FE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfAYGaU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 01:30:20 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34941 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbfAYGaU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 01:30:20 -0500
Received: by mail-pg1-f194.google.com with SMTP id s198so3795271pgs.2
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2019 22:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N962v1NYYO1siutE7EpJRXlUasnp8tyEzinNsSx9Z9I=;
        b=iATih+FEXvKzD3RJeQZ7TMooRFLYrg7ccPUgGK+xbqY6aYowUQPO+k6i5qCBVnT5Mr
         QLChBG+Tc1mCgbLDCOhghRceAO0e5z9KPsHSw5Pkjh2hlgcmMGjh6qBBrlg1GM0TFVTz
         qInm7HZNP2qCrgjVa2ZqOSCwDlk1reqWj8lK/oRWARVn/uqFnZgBn17buErWkSaQyCHe
         RfkCt0SdNbaJvPFkRK0E5NJRQbuvzNr5VvwAq997BwDOF4vpwhF6uzQB2I1x436ryRxn
         QanOTe0Y7nNrrHgyTRw3X1Cq8QmCSJwsaZKci+q6v/fTA9tiiBYxcqHMoZvill/4XIn/
         RY2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=N962v1NYYO1siutE7EpJRXlUasnp8tyEzinNsSx9Z9I=;
        b=q3FUsWQLe4GNQTFV9IicxqEsQngkbjELjUpdp7sIpFBIODz2TrL7exBU+boRt7185i
         ClY0rXO9YD00vQMtMnEo3FXkM/HT2R1tdiUSCLJruylKvqCccgwemH0nka6gFH6KrBx5
         SQMHJc6cVwo+z4dMzOsSzZVq46zrjMStSjUwGusGye67aubjmbRzN+tnZUow4JS6rZfj
         Ih5a5Yk2LnYlMGJDO+HVAa2xbMEldvdfi5CWVmbs47QIxGW7Qd8jv07TX9EfTuaqWzHs
         CQdb29+7Lox+WQBm52EYhWhSJSyfvLfQk6trtkg3PEWzgeh0N26Q7hsiedAAb/NfLOub
         +lJw==
X-Gm-Message-State: AJcUukeBaMjznRkQS2b8WQMywIj2FF5VWeoJ0uIZk0+ws4RN8Acpf/9a
        MvEwlt6pKqcF252TbkIXFkz2Oa5OrMaA1g==
X-Google-Smtp-Source: ALg8bN6Ez5FeHfDXObtBluIkQQ9Gp5AsUSvfED5+7DlsxT2/wkkJV6emq3Q3EnXXM32gPAM5BJWsbg==
X-Received: by 2002:a62:710a:: with SMTP id m10mr9653084pfc.69.1548397819301;
        Thu, 24 Jan 2019 22:30:19 -0800 (PST)
Received: from cpu459.localdomain ([203.196.161.90])
        by smtp.gmail.com with ESMTPSA id x19sm37384793pfk.14.2019.01.24.22.30.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 22:30:18 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Rishikesh Basu <rishikesh.basu@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        krishna.pedda@redpinesignals.com
Subject: [PATCH 1/5] rsi: Add debug support for wowlan wakeup confirmation
Date:   Fri, 25 Jan 2019 11:59:58 +0530
Message-Id: <1548397802-12180-2-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1548397802-12180-1-git-send-email-siva8118@gmail.com>
References: <1548397802-12180-1-git-send-email-siva8118@gmail.com>
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

