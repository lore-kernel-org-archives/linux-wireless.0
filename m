Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55FD1C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 10:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C58F20880
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 10:33:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YHrMGdre"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfBUKdi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 05:33:38 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36280 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfBUKdi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 05:33:38 -0500
Received: by mail-lf1-f66.google.com with SMTP id q11so19946996lfd.3
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 02:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nxY9KSgz2HbSexuJUIXHkbK//lhKlSJ4neACS/pGpCQ=;
        b=YHrMGdregDM746gyKCBWeUKO4I8f7hr+FztqSv8VZ9iotIakmBjdWDC4H9qgyg/6nm
         BcORkPnUJMc+uzQv45mlwyQ/RpHn3YIoUpKupNZ/xzEzpHLcyXWRsHtncBTY0XcdWcyf
         GdJSE6pZ49lum3DOfE75c8v1CacE4Cx2wIY/qnxbJDuivs7VnViU0tcrglspXaoosEhj
         Dzcl80w7k+tyQTB248i9dcL8JV2cLmmMXceRSaOv+yyHZ8M4wh7xrRa9ZNi5OCih0fGN
         7IhiUB16Kt8NV9ibrVjLGjcTOYrA5K2pXn2Q6ajpnyPyKGFvdlXE1NsxaKh+2Mj/kO1j
         EExA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nxY9KSgz2HbSexuJUIXHkbK//lhKlSJ4neACS/pGpCQ=;
        b=IdKFpq8VoLv4P/vPnhacI1+SAhRLgjqikz/myxb1pnfdxEprcry43SWg8dXGSTtlST
         +qFb0g+cAUfLDCdheoIpm8USkbDNMp/x5v6WCrDp81V5Y51Np5jhbgx4tICJuMtuq/E7
         Pg/HrZDse12Ssqv4PEpJpH8beR5nTw60Dzhe7OUtK+DdanLzL2ItWRwymJ1+WH0dxlWV
         1+ZtweCZ2vVtUCyCUMC+1Ald9weF0GM3yO+Y+13/o/mlyZIl7PKZptnmOogrw8auyggz
         fRB54GbxsRf53SwaUTetLIOVsRzTZM1ytO4rVY9DINN3FxVKBVcsoHjmCFykm6ixXhzv
         MNVA==
X-Gm-Message-State: AHQUAuayq1Od86Bz23eiSEV894fR2r7MvJC2zUB8u8tmx8/Z/5bf1orU
        5rDzrq4B632puJqLiC3eiqY=
X-Google-Smtp-Source: AHgI3IbaS+D1nJ1RoneQ115UJktRyVRGqoHCCp8oEixPz5hzxYHq6lJOh8QjfswSRvu9VkRnhi9h+Q==
X-Received: by 2002:a19:9c87:: with SMTP id f129mr6791510lfe.77.1550745214562;
        Thu, 21 Feb 2019 02:33:34 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id j14sm6059064lfc.28.2019.02.21.02.33.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 02:33:33 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH wireless-drivers-next 2/2] brcmfmac: print firmware reported general status errors
Date:   Thu, 21 Feb 2019 11:33:25 +0100
Message-Id: <20190221103325.28228-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190221103325.28228-1-zajec5@gmail.com>
References: <20190221103325.28228-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Firmware may report general errors using a special message type. Add
basic support for it by simply decoding & printing an error number.

A sample situation in which firmware reports a buf error:
CONSOLE: 027084.733 no host response IOCTL buffer available..so fail the request
will now produce a "Firmware reported general error: 9" on the host.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../broadcom/brcm80211/brcmfmac/msgbuf.c      | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index d711dc8ed606..d3780eae7f19 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -134,6 +134,14 @@ struct msgbuf_completion_hdr {
 	__le16				flow_ring_id;
 };
 
+/* Data struct for the MSGBUF_TYPE_GEN_STATUS */
+struct msgbuf_gen_status {
+	struct msgbuf_common_hdr	msg;
+	struct msgbuf_completion_hdr	compl_hdr;
+	__le16				write_idx;
+	__le32				rsvd0[3];
+};
+
 /* Data struct for the MSGBUF_TYPE_RING_STATUS */
 struct msgbuf_ring_status {
 	struct msgbuf_common_hdr	msg;
@@ -1194,6 +1202,18 @@ brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 	brcmf_netif_rx(ifp, skb);
 }
 
+static void brcmf_msgbuf_process_gen_status(struct brcmf_msgbuf *msgbuf,
+					    void *buf)
+{
+	struct msgbuf_gen_status *gen_status = buf;
+	struct brcmf_pub *drvr = msgbuf->drvr;
+	int err;
+
+	err = le16_to_cpu(gen_status->compl_hdr.status);
+	if (err)
+		bphy_err(drvr, "Firmware reported general error: %d\n", err);
+}
+
 static void brcmf_msgbuf_process_ring_status(struct brcmf_msgbuf *msgbuf,
 					     void *buf)
 {
@@ -1273,6 +1293,10 @@ static void brcmf_msgbuf_process_msgtype(struct brcmf_msgbuf *msgbuf, void *buf)
 
 	msg = (struct msgbuf_common_hdr *)buf;
 	switch (msg->msgtype) {
+	case MSGBUF_TYPE_GEN_STATUS:
+		brcmf_dbg(MSGBUF, "MSGBUF_TYPE_GEN_STATUS\n");
+		brcmf_msgbuf_process_gen_status(msgbuf, buf);
+		break;
 	case MSGBUF_TYPE_RING_STATUS:
 		brcmf_dbg(MSGBUF, "MSGBUF_TYPE_RING_STATUS\n");
 		brcmf_msgbuf_process_ring_status(msgbuf, buf);
-- 
2.20.1

