Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C4CC169C4
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 01:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5DF5217F9
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 01:41:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MtPf3lF4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfBGBlv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 20:41:51 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46627 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbfBGBlv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 20:41:51 -0500
Received: by mail-pf1-f195.google.com with SMTP id c73so4002735pfe.13
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2019 17:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AH/cPCNiW2VWKL5BecCmjq4BeZ2v1KefStsAqZ/Gd0U=;
        b=MtPf3lF4+DkY74Y7AzdGz7fIQ791q9WmA1p9KQepcICaqMu3tHc81jxFerWp3+qDNm
         RczNZK01yDe/Ffq14hXp6HnY1q2RPYKh1PBdIy+q8lfNmYWFBt/fE2niNERE5aXPVlBm
         40bgcXli2+hxdM/0zBvPrjYRq/FenhljBYANI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AH/cPCNiW2VWKL5BecCmjq4BeZ2v1KefStsAqZ/Gd0U=;
        b=hbViuVMWct701WDw9IhcJrsDcaS5n8Ixa3t0kZS8dTpwCB/ElXa7W6bWjFBmElp50Q
         vxM6tTJlirgBkgmJHqBp208GYvuJVe96aJ90RKGRi6SOPSVb1T+tRiI9FRn29MoVOWq0
         wAuyA+14oG+tnQszGohOWxQ/WrOjyCWgCSy3vcZw3u5NeFN2qrAewHg0XqwOlC3V12OO
         CSS1JAtDN9HClm0JKyXk/YX8yKChkeB2b7nf5wwwL3e34du3tonKpHV6RA885W6ekNvD
         AWzs66RYqGFhzyVZRo7Zl7ZY7jJG2k9+fynC12A8eNvYIRTlcJqvKtC8DKaL0PIn83ce
         HTww==
X-Gm-Message-State: AHQUAubTXWY0Gq0ABDvBogXZ1YNOfkq7lph+OaJIhlPS+u1cI6/PENzK
        BtsIGMO4t9LuxMyGxMwkssZkHnP9HqQ=
X-Google-Smtp-Source: AHgI3IZONWRhLbhL04+se2hDX/fga7cvaujTSBExDoZJN1MZWjkl4g81TydybcZOVFFa0e6S0fLLIw==
X-Received: by 2002:a63:a30a:: with SMTP id s10mr11812991pge.234.1549503709800;
        Wed, 06 Feb 2019 17:41:49 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id 128sm12826922pfu.129.2019.02.06.17.41.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 17:41:48 -0800 (PST)
From:   Brian Norris <briannorris@chromium.org>
To:     linux-wireless@vger.kernel.org
Cc:     ath10k@lists.infradead.org, Carl Huang <cjhuang@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] ath10k: pci: use mutex for diagnostic window CE polling
Date:   Wed,  6 Feb 2019 17:41:43 -0800
Message-Id: <20190207014143.41529-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.20.1.611.gfbb209baf1-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The DIAG copy engine is only used via polling, but it holds a spinlock
with softirqs disabled. Each iteration of our read/write loops can
theoretically take 20ms (two 10ms timeout loops), and this loop can be
run an unbounded number of times while holding the spinlock -- dependent
on the request size given by the caller.

As of commit 39501ea64116 ("ath10k: download firmware via diag Copy
Engine for QCA6174 and QCA9377."), we transfer large chunks of firmware
memory using this mechanism. With large enough firmware segments, this
becomes an exceedingly long period for disabling soft IRQs. For example,
with a 500KiB firmware segment, in testing QCA6174A, I see 200 loop
iterations of about 50-100us each, which can total about 10-20ms.

In reality, we don't really need to block softirqs for this duration.
The DIAG CE is only used in polling mode, and we only need to hold
ce_lock to make sure any CE bookkeeping is done without screwing up
another CE. Otherwise, we only need to ensure exclusion between
ath10k_pci_diag_{read,write}_mem() contexts.

This patch moves to use fine-grained locking for the shared ce_lock,
while adding a new mutex just to ensure mutual exclusion of diag
read/write operations.

Tested on QCA6174A, firmware version WLAN.RM.4.4.1-00132-QCARMSWPZ-1.

Fixes: 39501ea64116 ("ath10k: download firmware via diag Copy Engine for QCA6174 and QCA9377.")
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
I'm not quite sure if this is -stable material. It's technically an
existing bug, but it looks like previously, the DIAG interface was only
exposed via debugfs -- you could block softirqs by playing with
/sys/kernel/debug/ieee80211/phyX/ath10k/mem_value. The new usage (for
loading firmware, on QCA6174 and QCA9377) might constitute a significant
regression.

Also, I'd appreciate some review from Qualcomm folks as always.
---
 drivers/net/wireless/ath/ath10k/pci.c | 41 ++++++++++-----------------
 drivers/net/wireless/ath/ath10k/pci.h |  3 ++
 2 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 39e0b1cc2a12..f8356b3bf150 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -913,7 +913,6 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 				    int nbytes)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_ce *ce = ath10k_ce_priv(ar);
 	int ret = 0;
 	u32 *buf;
 	unsigned int completed_nbytes, alloc_nbytes, remaining_bytes;
@@ -924,8 +923,7 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 	void *data_buf = NULL;
 	int i;
 
-	spin_lock_bh(&ce->ce_lock);
-
+	mutex_lock(&ar_pci->ce_diag_mutex);
 	ce_diag = ar_pci->ce_diag;
 
 	/*
@@ -960,19 +958,17 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		nbytes = min_t(unsigned int, remaining_bytes,
 			       DIAG_TRANSFER_LIMIT);
 
-		ret = ce_diag->ops->ce_rx_post_buf(ce_diag, &ce_data, ce_data);
+		ret = ath10k_ce_rx_post_buf(ce_diag, &ce_data, ce_data);
 		if (ret != 0)
 			goto done;
 
 		/* Request CE to send from Target(!) address to Host buffer */
-		ret = ath10k_ce_send_nolock(ce_diag, NULL, (u32)address, nbytes, 0,
-					    0);
+		ret = ath10k_ce_send(ce_diag, NULL, (u32)address, nbytes, 0, 0);
 		if (ret)
 			goto done;
 
 		i = 0;
-		while (ath10k_ce_completed_send_next_nolock(ce_diag,
-							    NULL) != 0) {
+		while (ath10k_ce_completed_send_next(ce_diag, NULL) != 0) {
 			udelay(DIAG_ACCESS_CE_WAIT_US);
 			i += DIAG_ACCESS_CE_WAIT_US;
 
@@ -983,10 +979,8 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		}
 
 		i = 0;
-		while (ath10k_ce_completed_recv_next_nolock(ce_diag,
-							    (void **)&buf,
-							    &completed_nbytes)
-								!= 0) {
+		while (ath10k_ce_completed_recv_next(ce_diag, (void **)&buf,
+						     &completed_nbytes) != 0) {
 			udelay(DIAG_ACCESS_CE_WAIT_US);
 			i += DIAG_ACCESS_CE_WAIT_US;
 
@@ -1019,7 +1013,7 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		dma_free_coherent(ar->dev, alloc_nbytes, data_buf,
 				  ce_data_base);
 
-	spin_unlock_bh(&ce->ce_lock);
+	mutex_unlock(&ar_pci->ce_diag_mutex);
 
 	return ret;
 }
@@ -1067,7 +1061,6 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 			      const void *data, int nbytes)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_ce *ce = ath10k_ce_priv(ar);
 	int ret = 0;
 	u32 *buf;
 	unsigned int completed_nbytes, alloc_nbytes, remaining_bytes;
@@ -1076,8 +1069,7 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	dma_addr_t ce_data_base = 0;
 	int i;
 
-	spin_lock_bh(&ce->ce_lock);
-
+	mutex_lock(&ar_pci->ce_diag_mutex);
 	ce_diag = ar_pci->ce_diag;
 
 	/*
@@ -1118,7 +1110,7 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		memcpy(data_buf, data, nbytes);
 
 		/* Set up to receive directly into Target(!) address */
-		ret = ce_diag->ops->ce_rx_post_buf(ce_diag, &address, address);
+		ret = ath10k_ce_rx_post_buf(ce_diag, &address, address);
 		if (ret != 0)
 			goto done;
 
@@ -1126,14 +1118,12 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		 * Request CE to send caller-supplied data that
 		 * was copied to bounce buffer to Target(!) address.
 		 */
-		ret = ath10k_ce_send_nolock(ce_diag, NULL, ce_data_base,
-					    nbytes, 0, 0);
+		ret = ath10k_ce_send(ce_diag, NULL, ce_data_base, nbytes, 0, 0);
 		if (ret != 0)
 			goto done;
 
 		i = 0;
-		while (ath10k_ce_completed_send_next_nolock(ce_diag,
-							    NULL) != 0) {
+		while (ath10k_ce_completed_send_next(ce_diag, NULL) != 0) {
 			udelay(DIAG_ACCESS_CE_WAIT_US);
 			i += DIAG_ACCESS_CE_WAIT_US;
 
@@ -1144,10 +1134,8 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		}
 
 		i = 0;
-		while (ath10k_ce_completed_recv_next_nolock(ce_diag,
-							    (void **)&buf,
-							    &completed_nbytes)
-								!= 0) {
+		while (ath10k_ce_completed_recv_next(ce_diag, (void **)&buf,
+						     &completed_nbytes) != 0) {
 			udelay(DIAG_ACCESS_CE_WAIT_US);
 			i += DIAG_ACCESS_CE_WAIT_US;
 
@@ -1182,7 +1170,7 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		ath10k_warn(ar, "failed to write diag value at 0x%x: %d\n",
 			    address, ret);
 
-	spin_unlock_bh(&ce->ce_lock);
+	mutex_unlock(&ar_pci->ce_diag_mutex);
 
 	return ret;
 }
@@ -3462,6 +3450,7 @@ int ath10k_pci_setup_resource(struct ath10k *ar)
 
 	spin_lock_init(&ce->ce_lock);
 	spin_lock_init(&ar_pci->ps_lock);
+	mutex_init(&ar_pci->ce_diag_mutex);
 
 	timer_setup(&ar_pci->rx_post_retry, ath10k_pci_rx_replenish_retry, 0);
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index e8d86331c539..a9270fa6463c 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -19,6 +19,7 @@
 #define _PCI_H_
 
 #include <linux/interrupt.h>
+#include <linux/mutex.h>
 
 #include "hw.h"
 #include "ce.h"
@@ -128,6 +129,8 @@ struct ath10k_pci {
 
 	/* Copy Engine used for Diagnostic Accesses */
 	struct ath10k_ce_pipe *ce_diag;
+	/* For protecting ce_diag */
+	struct mutex ce_diag_mutex;
 
 	struct ath10k_ce ce;
 	struct timer_list rx_post_retry;
-- 
2.20.1.611.gfbb209baf1-goog

