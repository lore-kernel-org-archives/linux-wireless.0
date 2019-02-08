Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8457BC282CC
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 14:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5396420863
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 14:24:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hZFkReF/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbfBHOYt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 09:24:49 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42414 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbfBHOYt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 09:24:49 -0500
Received: by mail-lf1-f66.google.com with SMTP id l10so2647179lfh.9
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2019 06:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AoQVMP14/aPprmvFvZlWqml54OEoelf969I8391ycyI=;
        b=hZFkReF/fIfKvnZHijpGc9PBiiKUnE9VqGfaO1K2zhu2bCSJK5mjeLuxKrMK+fqwRj
         PV5v4YOATVag8r4bfuCNwNxsDOR9YNTE6rNb0e+NZEtdLV4ng0P7wNDH5EdEhw+4dLsm
         t3cRQHFGufYOVwXveLh4LGtVckv4BkEJzmm20+j4VBLztKK2F5jnkg2khFA7C8zJMKNh
         DH7dhBHyHvrBWpCDh9dJu3xDXiu5MHfwH+1NnNHs0D5snjosEWaaR/+LAEjZb20Cdpcm
         r/Fw2PNj8nsUcQZrH60XA/MEAjNR7MI4EiKIkZhI+01wJHfpmM/Dk+3ArenEbyO3eEsw
         suRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AoQVMP14/aPprmvFvZlWqml54OEoelf969I8391ycyI=;
        b=N6MOzzIuux7Muh+kXxNB7LU1Y1qU3+X4hhCaPBbbWJd9SxRaQig5nPxQwm/lu0Qmt5
         NHtiAgv/Lfwc/lNPWUzQiSQfoN+tvDWaZmrBYMWCql9uIN9b/Rg1IG3CMx66bWGTKI4u
         RODAclFxBDPw0AqnNn7xOSqdwNDab/UzQRfADQIK3LaXwu/vexfbSix2XaGCa7aCgBOY
         owsp1HJopvt+0MgF0BUFmAJcDiP4pOEtt/EY2aH97jAvfEV4vZ/+9mTo0vJ5ok77cIhT
         1rpoj54hVuNM4V9hd2giJGccThJ1RIOEr738r5fckZWHH1T4dQ+pNa10s89Cn7o0RWkY
         Hd0Q==
X-Gm-Message-State: AHQUAubK4r4gWni0ZSoyg1ei0Ra0p3hEERqohtDsYrRcnmN7KTpPmI96
        37bNAh+/R/oVyFvdstpJOG4=
X-Google-Smtp-Source: AHgI3IZ3fv7patz6lqCZr4egYfE0wAL2BFp6tAn63eoX0dSDDCKjtQpj3qoV96l+isOoSRpJmCyFxg==
X-Received: by 2002:ac2:561a:: with SMTP id v26mr13683826lfd.38.1549635886984;
        Fri, 08 Feb 2019 06:24:46 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id d10sm390612lfa.71.2019.02.08.06.24.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 06:24:46 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] brcmfmac: print firmware reported ring status errors
Date:   Fri,  8 Feb 2019 15:24:39 +0100
Message-Id: <20190208142439.21479-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Firmware is capable of reporting ring status. It's used e.g. to signal
some problem with a specific ring setup. This patch adds support for
printing ring & error number which may be useful for debugging setup
issues.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../broadcom/brcm80211/brcmfmac/msgbuf.c      | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 4e8397a0cbc8..bbef2d41cb3b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -134,6 +134,14 @@ struct msgbuf_completion_hdr {
 	__le16				flow_ring_id;
 };
 
+/* Data struct for the MSGBUF_TYPE_RING_STATUS */
+struct msgbuf_ring_status {
+	struct msgbuf_common_hdr	msg;
+	struct msgbuf_completion_hdr	compl_hdr;
+	__le16				write_idx;
+	__le32				rsvd0[5];
+};
+
 struct msgbuf_rx_event {
 	struct msgbuf_common_hdr	msg;
 	struct msgbuf_completion_hdr	compl_hdr;
@@ -1180,6 +1188,19 @@ brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 	brcmf_netif_rx(ifp, skb);
 }
 
+static void brcmf_msgbuf_process_ring_status(struct brcmf_msgbuf *msgbuf,
+					     void *buf)
+{
+	struct msgbuf_ring_status *ring_status = buf;
+	int err;
+
+	err = le16_to_cpu(ring_status->compl_hdr.status);
+	if (err) {
+		int ring = le16_to_cpu(ring_status->compl_hdr.flow_ring_id);
+
+		brcmf_err("Firmware reported ring %d error: %d\n", ring, err);
+	}
+}
 
 static void
 brcmf_msgbuf_process_flow_ring_create_response(struct brcmf_msgbuf *msgbuf,
@@ -1241,6 +1262,10 @@ static void brcmf_msgbuf_process_msgtype(struct brcmf_msgbuf *msgbuf, void *buf)
 
 	msg = (struct msgbuf_common_hdr *)buf;
 	switch (msg->msgtype) {
+	case MSGBUF_TYPE_RING_STATUS:
+		brcmf_dbg(MSGBUF, "MSGBUF_TYPE_RING_STATUS\n");
+		brcmf_msgbuf_process_ring_status(msgbuf, buf);
+		break;
 	case MSGBUF_TYPE_FLOW_RING_CREATE_CMPLT:
 		brcmf_dbg(MSGBUF, "MSGBUF_TYPE_FLOW_RING_CREATE_CMPLT\n");
 		brcmf_msgbuf_process_flow_ring_create_response(msgbuf, buf);
-- 
2.20.1

