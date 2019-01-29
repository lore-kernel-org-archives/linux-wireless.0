Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AE9C282C7
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 17:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F15A214DA
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 17:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbfA2RrW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 12:47:22 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38923 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728628AbfA2RrV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 12:47:21 -0500
Received: by mail-wr1-f67.google.com with SMTP id t27so23066423wra.6
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2019 09:47:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bh0zsBPSBGkuAdxFZdw6PpDhMNDKcm/mjRqz+wSzY/o=;
        b=SI2iVM0/gUUfBDqjYIXgoyYGYuAO3V930rAwcYatdj7SDhmaYQgU4OtxsmZ9ZCIkbo
         tB/CATcFSTRuCDVAPZxbMmXf8JzGT9RvRmF+iMUHHHMGOb1xsXOIbvE3e27ZEkywFUbv
         IvEqY399HQL9FbhTSv0pCj98dvgjIbuRtLIsi0YRLNfg4CFtmxyXYjcuhCyktQ5C9YJo
         fZKXCh5zX4teBnUK5Usr27D4swSETSFm35USBYB611ygE3nz8QPYxWMOF9IlWB2R/e0w
         E7bO/7b3r1Haj9prfbsOEqGWU6PU1S4BIcEHon3jCaYuJdsiGMfKXe5ygBX0GoqNGe74
         +dwg==
X-Gm-Message-State: AJcUukeCQJo9hhObOlDWCbxqUuzAvi3sxJPlUvpcTkp7AWkG07FIlYbJ
        yPlLVQfxK3PzmehPbOC8zKTZ/xuO7/w=
X-Google-Smtp-Source: ALg8bN41JKB9Gl0cD85jl3HK+dh57YFjLwLeTCftASoTmobIXU1Bh9xUvcP+DY12iGetrCfaxpcLUg==
X-Received: by 2002:adf:cc91:: with SMTP id p17mr27293570wrj.118.1548784039753;
        Tue, 29 Jan 2019 09:47:19 -0800 (PST)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 67sm193203966wra.37.2019.01.29.09.47.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jan 2019 09:47:18 -0800 (PST)
From:   Matteo Croce <mcroce@redhat.com>
To:     linux-wireless@vger.kernel.org, brcm80211-dev-list@cypress.com
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] brcm80211: fix typos
Date:   Tue, 29 Jan 2019 18:47:17 +0100
Message-Id: <20190129174717.30566-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix spelling mistakes in brcm80211: "lenght" -> "length".
The typos are also in the special comment blocks which
translates to documentation.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h     | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h     | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c      | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index dcf6e27cc16f..d8085ce579f4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -36,7 +36,7 @@
 #define BRCMF_DCMD_MEDLEN	1536
 #define BRCMF_DCMD_MAXLEN	8192
 
-/* IOCTL from host to device are limited in lenght. A device can only handle
+/* IOCTL from host to device are limited in length. A device can only handle
  * ethernet frame size. This limitation is to be applied by protocol layer.
  */
 #define BRCMF_TX_IOCTL_MAX_MSG_SIZE	(ETH_FRAME_LEN+ETH_FCS_LEN)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 14b948917a1a..cf1ddf988476 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -47,7 +47,7 @@ enum nvram_parser_state {
  * @state: current parser state.
  * @data: input buffer being parsed.
  * @nvram: output buffer with parse result.
- * @nvram_len: lenght of parse result.
+ * @nvram_len: length of parse result.
  * @line: current line.
  * @column: current column in line.
  * @pos: byte offset in input buffer.
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h
index 816f80ea925b..31f3e8e83a21 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h
@@ -266,7 +266,7 @@ struct brcmf_event {
  * @status: status information.
  * @reason: reason code.
  * @auth_type: authentication type.
- * @datalen: lenght of event data buffer.
+ * @datalen: length of event data buffer.
  * @addr: ether address.
  * @ifname: interface name.
  * @ifidx: interface index.
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index a4308c6e72d7..0b7d977510c8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -508,7 +508,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 	skb = req->skb;
 	req->skb = NULL;
 
-	/* zero lenght packets indicate usb "failure". Do not refill */
+	/* zero length packets indicate usb "failure". Do not refill */
 	if (urb->status != 0 || !urb->actual_length) {
 		brcmu_pkt_buf_free_skb(skb);
 		brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req, NULL);
-- 
2.20.1

