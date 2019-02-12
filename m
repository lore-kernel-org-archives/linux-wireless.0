Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3790EC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 11:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAF9C2080F
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 11:29:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nHqw0Hhx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbfBLL3A (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 06:29:00 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46745 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfBLL3A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 06:29:00 -0500
Received: by mail-pf1-f194.google.com with SMTP id g6so1137352pfh.13
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 03:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dQB05cyqgNTdWU1w5LMiOlQ2f9MRJ1sA5SNyUQFtfF4=;
        b=nHqw0Hhxkway923h9YEExomkRQb2rIG1BlKi41DVXE8I0CRceTPF70ygFb/hqmoyYZ
         ZUoDXfQQJo/c7oh8NzPLkxIqIjEmYV6/R4+HAfvr6sXFPwF8v4APkmiLTgAvB9V13kRt
         tRSU+7aSPOITmL9jMvqxSwZWxGWjSJsuX4Eo6UroMyHylDAiaZjDNDQXIFBtWBWXGFcS
         R8mOD4KyVvkUeHrxl5t1dEjFJzv4iFBCflAgHNDxqzmdYGAj3RkD7TyDx7nXI0F8u5b6
         7eiN1pYxgnowXMRSf/vrTccqFkNnKcjvaSH8vG3TuiovD3wM3+GokJe49pnIO4GixXVu
         VZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dQB05cyqgNTdWU1w5LMiOlQ2f9MRJ1sA5SNyUQFtfF4=;
        b=M/65K3pv0PBJXWlmW4WZG9FbRaJHPeFqTM5D2bUcmSHAHRQTO8NNL/RYnIstVwz1kD
         ROg7p1PCyhWX5xNnDiGwEmMnzreIw3NVPLvWOpWY6Vpg9XjLUJhtpS2Ig1fkF5pnA5aw
         STjkfU5lq7/zwVMgPD+L9Qv6jzCYW9VzASjS3BN8UpIWcxlqQ5OXHuolmuszZW9wdFku
         hVUOlkThax9W2mMhUVTH4HZEi2YU0P7o9o5WP6AVvp0o6RtPGOIm5RQcfw0Zr7KInff+
         QBp8riUzaiuP+Zeh9NrAjEI6G1ObJkn6MPK1yZG83JN4ayPef5CayP4gNFcnUa/HJMxm
         VjQw==
X-Gm-Message-State: AHQUAuaaH2PQV6JuE2y497MFi6ctnirsySF1aMfGnsP1i+XGD4icqJ3E
        cFjmI3tteVQ5a3+MOUIResA=
X-Google-Smtp-Source: AHgI3Iah3giIKc0QOh+5al9PpCdFeET6PYhW5yRzVz/NxLBd9njoJfDkAmQnxbhqvIVDuXDJj0nfiw==
X-Received: by 2002:a63:5109:: with SMTP id f9mr3192974pgb.450.1549970938169;
        Tue, 12 Feb 2019 03:28:58 -0800 (PST)
Received: from cpu459.localdomain ([203.196.161.90])
        by smtp.gmail.com with ESMTPSA id t65sm26445006pfi.117.2019.02.12.03.28.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Feb 2019 03:28:57 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        siva.rebbagondla@redpinesignals.com,
        rishikesh.basu@redpinesignals.com
Subject: [PATCH] rsi: fix spelling mistakes
Date:   Tue, 12 Feb 2019 16:58:34 +0530
Message-Id: <1549970914-3880-1-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

Trivial fixes to spelling mistakes in various files in rsi folder.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_debugfs.c  | 8 ++++----
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 2 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 8 ++++----
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 4 ++--
 drivers/net/wireless/rsi/rsi_91x_usb.c      | 2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_debugfs.c b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
index d0c35f3..c71b41e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_debugfs.c
+++ b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
@@ -59,7 +59,7 @@ static int rsi_sdio_stats_read(struct seq_file *seq, void *data)
 }
 
 /**
- * rsi_sdio_stats_open() - This funtion calls single open function of seq_file
+ * rsi_sdio_stats_open() - This function calls single open function of seq_file
  *			   to open file and read contents from it.
  * @inode: Pointer to the inode structure.
  * @file: Pointer to the file structure.
@@ -93,7 +93,7 @@ static int rsi_version_read(struct seq_file *seq, void *data)
 }
 
 /**
- * rsi_version_open() - This funtion calls single open function of seq_file to
+ * rsi_version_open() - This function calls single open function of seq_file to
  *			open file and read contents from it.
  * @inode: Pointer to the inode structure.
  * @file: Pointer to the file structure.
@@ -178,7 +178,7 @@ static int rsi_stats_read(struct seq_file *seq, void *data)
 }
 
 /**
- * rsi_stats_open() - This funtion calls single open function of seq_file to
+ * rsi_stats_open() - This function calls single open function of seq_file to
  *		      open file and read contents from it.
  * @inode: Pointer to the inode structure.
  * @file: Pointer to the file structure.
@@ -207,7 +207,7 @@ static int rsi_debug_zone_read(struct seq_file *seq, void *data)
 }
 
 /**
- * rsi_debug_read() - This funtion calls single open function of seq_file to
+ * rsi_debug_read() - This function calls single open function of seq_file to
  *		      open file and read contents from it.
  * @inode: Pointer to the inode structure.
  * @file: Pointer to the file structure.
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index aded1ae..6584f51 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1332,7 +1332,7 @@ static void rsi_fill_rx_status(struct ieee80211_hw *hw,
 }
 
 /**
- * rsi_indicate_pkt_to_os() - This function sends recieved packet to mac80211.
+ * rsi_indicate_pkt_to_os() - This function sends received packet to mac80211.
  * @common: Pointer to the driver private structure.
  * @skb: Pointer to the socket buffer structure.
  *
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 4042414..a77f0a8 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -409,8 +409,8 @@ static int rsi_load_radio_caps(struct rsi_common *common)
  * rsi_mgmt_pkt_to_core() - This function is the entry point for Mgmt module.
  * @common: Pointer to the driver private structure.
  * @msg: Pointer to received packet.
- * @msg_len: Length of the recieved packet.
- * @type: Type of recieved packet.
+ * @msg_len: Length of the received packet.
+ * @type: Type of received packet.
  *
  * Return: 0 on success, -1 on failure.
  */
@@ -1547,7 +1547,7 @@ int rsi_send_ps_request(struct rsi_hw *adapter, bool enable,
 }
 
 /**
- * rsi_set_antenna() - This fuction send antenna configuration request
+ * rsi_set_antenna() - This function send antenna configuration request
  *		       to device
  *
  * @common: Pointer to the driver private structure.
@@ -1955,7 +1955,7 @@ int rsi_handle_card_ready(struct rsi_common *common, u8 *msg)
 
 /**
  * rsi_mgmt_pkt_recv() - This function processes the management packets
- *			 recieved from the hardware.
+ *			 received from the hardware.
  * @common: Pointer to the driver private structure.
  * @msg: Pointer to the received packet.
  *
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index b412b65e..aa9d67d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -138,7 +138,7 @@ static int rsi_issue_sdiocommand(struct sdio_func *func,
 }
 
 /**
- * rsi_handle_interrupt() - This function is called upon the occurence
+ * rsi_handle_interrupt() - This function is called upon the occurrence
  *			    of an interrupt.
  * @function: Pointer to the sdio_func structure.
  *
@@ -875,7 +875,7 @@ static int rsi_init_sdio_interface(struct rsi_hw *adapter,
 		goto fail;
 	}
 
-	rsi_dbg(INIT_ZONE, "%s: Setup card succesfully\n", __func__);
+	rsi_dbg(INIT_ZONE, "%s: Setup card successfully\n", __func__);
 
 	status = rsi_init_sdio_slave_regs(adapter);
 	if (status) {
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index f360690..5b82d29 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -252,7 +252,7 @@ static int rsi_usb_reg_write(struct usb_device *usbdev,
 
 /**
  * rsi_rx_done_handler() - This function is called when a packet is received
- *			   from USB stack. This is callback to recieve done.
+ *			   from USB stack. This is callback to receive done.
  * @urb: Received URB.
  *
  * Return: None.
-- 
2.5.5

