Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35594C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0301520882
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WvcAn775"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfDCENo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 00:13:44 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33081 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfDCENo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 00:13:44 -0400
Received: by mail-pf1-f194.google.com with SMTP id i19so7467866pfd.0
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2019 21:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6dBcrYj0UhuGns5a0hOKLNuWZBN8wl89X8AQf3P64r0=;
        b=WvcAn775pODAm6JxDwbeiiVh+93FALLPqHlZVuAQ4h92tOwa98YPRgaahPHojOb2pp
         7Z6xnskHf8239V11+NizC+nMks8Rxdd1cNmykzHQDW+hgVTV1td16HAgjJ4EkjPSy1tf
         aP4iTaJu8EMLFenjamiKMse33Vx95ybMZzJIna5HQFZ14YZDQm98bDiRC6U0jpxy3cXo
         XA91PeEX9AinembRtjriZI0qySwOIh8TU6ik34QZxJlMmH0SBh3TzmIF88cOSAkT5MGq
         dA3Vr8dTFWJfX6RQsmiKcMkJ8zEuQpLCvqcqtaKzI8OqUPhziOYDbM6lNhsVmQa8qXcV
         k14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6dBcrYj0UhuGns5a0hOKLNuWZBN8wl89X8AQf3P64r0=;
        b=pOxexvUYSH5lyk28YmoDD2PY4z3kwuLeDCy2kKdgnoLHJYduVWKGjc3bpIl7fdKS5c
         uQw4bAmADXF7e0FdCO3O1X/Znr5TQdHkeGm0COy6qajbXzJ7bzbhDmjeNhtlIt+Q3DzK
         pfKSk9GURKrvNJ9NKwiw7Y5S5Il+4ylm1lXaFWn938AZUG89UB6KZdGGdB3BpvIW7Z0m
         GAHvcX5dCh8V9N+5wKWp6uQcTxK0cgu14ZldMC1pJU5pgMb1QjyR4wWc4iKBonBn6WeD
         l4AC84NIuOPf2pKX8zDmw5d/aPbOYDuuFm9yOsy2qxFSfqYBoak5tN3g1w8hDw1e7Ppf
         PFWg==
X-Gm-Message-State: APjAAAVHGrE94eNL7l/Go1+D+FifP5Xgikju5uvX1sIMhniERCmrWR7H
        o0MqGp6L1byShh6Xk1nc25IGvpkCjq+sW1U5
X-Google-Smtp-Source: APXvYqyIymn9DRmHHKUWs9bzYJeyMPga0tLYKfSP/c1NRq5v92QuIRx55F0QQcSJ1v5cA5NxHgA9rA==
X-Received: by 2002:a63:c706:: with SMTP id n6mr37048256pgg.310.1554264822816;
        Tue, 02 Apr 2019 21:13:42 -0700 (PDT)
Received: from siva.domain.name ([123.201.77.78])
        by smtp.gmail.com with ESMTPSA id r3sm42290239pgb.82.2019.04.02.21.13.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 21:13:42 -0700 (PDT)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        krishna.pedda@redpinesignals.com,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 8/8] rsi: miscallaneous changes for 9116 and common
Date:   Wed,  3 Apr 2019 09:43:09 +0530
Message-Id: <20190403041309.12829-9-siva8118@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190403041309.12829-1-siva8118@gmail.com>
References: <20190403041309.12829-1-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Below changes are done:
* Device 80MHz clock should be disabled for 9116 in 20MHz band.
* Default edca parameters should be used initially before
  connection.
* Default TA aggregation is 3 for 9116.
* Bootup parameters should be loaded first when channel is
  changed.
* 4 byte register writes are possible for 9116.

Signed-off-by: Siva Rebbagondla <siva8118@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 27 +++++++++++++++++--------
 drivers/net/wireless/rsi/rsi_91x_usb.c  | 20 +++++++++---------
 2 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index f328532fef88..6c7f26ef6476 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -424,6 +424,10 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 	}
 	radio_caps->radio_info |= radio_id;
 
+	if (adapter->device_model == RSI_DEV_9116 &&
+	    common->channel_width == BW_20MHZ)
+		radio_caps->radio_cfg_info &= ~0x3;
+
 	radio_caps->sifs_tx_11n = cpu_to_le16(SIFS_TX_11N_VALUE);
 	radio_caps->sifs_tx_11b = cpu_to_le16(SIFS_TX_11B_VALUE);
 	radio_caps->slot_rx_11n = cpu_to_le16(SHORT_SLOT_VALUE);
@@ -439,14 +443,16 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 	}
 
 	for (ii = 0; ii < NUM_EDCA_QUEUES; ii++) {
-		radio_caps->qos_params[ii].cont_win_min_q =
-			cpu_to_le16(common->edca_params[ii].cw_min);
-		radio_caps->qos_params[ii].cont_win_max_q =
-			cpu_to_le16(common->edca_params[ii].cw_max);
-		radio_caps->qos_params[ii].aifsn_val_q =
-			cpu_to_le16((common->edca_params[ii].aifs) << 8);
-		radio_caps->qos_params[ii].txop_q =
-			cpu_to_le16(common->edca_params[ii].txop);
+		if (common->edca_params[ii].cw_max > 0) {
+			radio_caps->qos_params[ii].cont_win_min_q =
+				cpu_to_le16(common->edca_params[ii].cw_min);
+			radio_caps->qos_params[ii].cont_win_max_q =
+				cpu_to_le16(common->edca_params[ii].cw_max);
+			radio_caps->qos_params[ii].aifsn_val_q =
+				cpu_to_le16(common->edca_params[ii].aifs << 8);
+			radio_caps->qos_params[ii].txop_q =
+				cpu_to_le16(common->edca_params[ii].txop);
+		}
 	}
 
 	radio_caps->qos_params[BROADCAST_HW_Q].txop_q = cpu_to_le16(0xffff);
@@ -1026,6 +1032,11 @@ static int rsi_send_reset_mac(struct rsi_common *common)
 	mgmt_frame->desc_word[1] = cpu_to_le16(RESET_MAC_REQ);
 	mgmt_frame->desc_word[4] = cpu_to_le16(RETRY_COUNT << 8);
 
+#define RSI_9116_DEF_TA_AGGR	3
+	if (common->priv->device_model == RSI_DEV_9116)
+		mgmt_frame->desc_word[3] |=
+			cpu_to_le16(RSI_9116_DEF_TA_AGGR << 8);
+
 	skb_put(skb, FRAME_DESC_SZ);
 
 	return rsi_send_internal_mgmt_frame(common, skb);
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index f0475b20f153..f5048d4b8cb6 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -213,7 +213,7 @@ static int rsi_usb_reg_read(struct usb_device *usbdev,
  */
 static int rsi_usb_reg_write(struct usb_device *usbdev,
 			     u32 reg,
-			     u16 value,
+			     u32 value,
 			     u16 len)
 {
 	u8 *usb_reg_buf;
@@ -226,17 +226,17 @@ static int rsi_usb_reg_write(struct usb_device *usbdev,
 	if (!usb_reg_buf)
 		return status;
 
-	usb_reg_buf[0] = (value & 0x00ff);
-	usb_reg_buf[1] = (value & 0xff00) >> 8;
-	usb_reg_buf[2] = 0x0;
-	usb_reg_buf[3] = 0x0;
+	usb_reg_buf[0] = (cpu_to_le32(value) & 0x00ff);
+	usb_reg_buf[1] = (cpu_to_le32(value) & 0xff00) >> 8;
+	usb_reg_buf[2] = (cpu_to_le32(value) & 0x00ff0000) >> 16;
+	usb_reg_buf[3] = (cpu_to_le32(value) & 0xff000000) >> 24;
 
 	status = usb_control_msg(usbdev,
 				 usb_sndctrlpipe(usbdev, 0),
 				 USB_VENDOR_REGISTER_WRITE,
 				 RSI_USB_REQ_OUT,
-				 ((reg & 0xffff0000) >> 16),
-				 (reg & 0xffff),
+				 ((cpu_to_le32(reg) & 0xffff0000) >> 16),
+				 (cpu_to_le32(reg) & 0xffff),
 				 (void *)usb_reg_buf,
 				 len,
 				 USB_CTRL_SET_TIMEOUT);
@@ -263,8 +263,10 @@ static void rsi_rx_done_handler(struct urb *urb)
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)rx_cb->data;
 	int status = -EINVAL;
 
-	if (urb->status)
-		goto out;
+	if (urb->status) {
+		dev_kfree_skb(rx_cb->rx_skb);
+		return;
+	}
 
 	if (urb->actual_length <= 0 ||
 	    urb->actual_length > rx_cb->rx_skb->len) {
-- 
2.17.1

