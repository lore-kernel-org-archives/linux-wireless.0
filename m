Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03ECDC282DB
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 08:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D18362084A
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 08:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbfAUIYW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 03:24:22 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40523 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728490AbfAUIYW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 03:24:22 -0500
Received: by mail-wm1-f65.google.com with SMTP id f188so9767759wmf.5
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jan 2019 00:24:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=COeqjF9qpQt7nbfGA3Bfy/K/eZP9T8sE7OKtS47vC+w=;
        b=ghLt55SpN9rlaQY2IsqVuo8T8Hoo5OHhLpO1o1ZnJzQSr/RiwwF6mSWQIYiJKrZhIN
         /DohSMNMDPyb9ITAcnfMfAEVul1vO6bK3OO6AC1DBvqU5+OEcNQoHvHcQH38SWGApQq7
         VavvVWfKMbBG6rGLKCM+6fu96h/pWalLN3knKv1Zc0Td+mzJO6WF3W/wpNow5XU3OAwf
         OMEBPrpPvrfqLFVtz6942f4WS9IKxDDW7z0EgIPd05kdUQL8ktsY8LCAqyIxbO38gSOP
         +I+HTWsqWpQSS4zV6Ar63TSwrdgWJrzInNxnwAWqzDCeCYkwZX4URgjQg0CqJjFqngPZ
         qGjg==
X-Gm-Message-State: AJcUukepsyMKHIU+k5dehEwZx+NvprGIGK6uNYcc5cAbPKVYSzJbXSP1
        yfSnOQHuKVSNHzuyEoEqMTIY3Yghxag=
X-Google-Smtp-Source: ALg8bN7eAXeB5Ei9OzbgytFcsymA4iI3U6EzyeoCbFWWQbqwLImjq5VdYtVEJN4nX+YBZffZlERKuQ==
X-Received: by 2002:a1c:868a:: with SMTP id i132mr21969447wmd.49.1548026407650;
        Sun, 20 Jan 2019 15:20:07 -0800 (PST)
Received: from raver.teknoraver.net (net-5-95-156-25.cust.vodafonedsl.it. [5.95.156.25])
        by smtp.gmail.com with ESMTPSA id 143sm101025612wml.14.2019.01.20.15.20.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 20 Jan 2019 15:20:06 -0800 (PST)
From:   Matteo Croce <mcroce@redhat.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH net-next] wireless: fix typos
Date:   Mon, 21 Jan 2019 00:20:00 +0100
Message-Id: <20190120232000.4940-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix spelling mistakes in brcm80211 and cfg80211: "lenght" -> "length".
The typos are also in the special comment blocks which
translates to documentation.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h     | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h     | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c      | 2 +-
 include/net/cfg80211.h                                      | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

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
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e0c41eb1c860..237839210a36 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5568,7 +5568,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
  * @dev: network device
  * @macaddr: the MAC address of the new candidate
  * @ie: information elements advertised by the peer candidate
- * @ie_len: lenght of the information elements buffer
+ * @ie_len: length of the information elements buffer
  * @gfp: allocation flags
  *
  * This function notifies cfg80211 that the mesh peer candidate has been
-- 
2.20.1

