Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17BBDC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 20:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D217920700
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 20:57:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fs6CsIQs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732762AbfCZU5h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 16:57:37 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42502 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732716AbfCZU5g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 16:57:36 -0400
Received: by mail-pf1-f195.google.com with SMTP id r15so8614593pfn.9
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2019 13:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1WfNCB8CH0hw5Q7s1Q9qn6taOssBihwEIc0dGkVVsGE=;
        b=fs6CsIQsSNlMtgmkQKpGzspEUzubgHMsXLS4Lywxt+pL3/SG6RMgtJIMrDRMV8Zjsy
         bwR9tlx/sD+VdUUlIH1iYxoz3BxTc683VwPBei0TtNgAG+ApYaUc7UNPE+vbA6l2zwbY
         Alof6CL/g/z3je9x6IfUBGYt3xu9R33TtfdAg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1WfNCB8CH0hw5Q7s1Q9qn6taOssBihwEIc0dGkVVsGE=;
        b=ebxmhclaoWR5sR7gIc7wLxeL04smnJfA3LI3cN+eXWVYEWEU6fUoIiRjO0a5lermkk
         mNZHlnm9VajZbSydHVbZD8gEy0tX25HoxWmSdmOEyVevKZ9YBduadJ23osBDABehkyHw
         3YKwZFracEIzchd54w/wB65mFeRXeExPYRrSa/WC3KPJrzqO0aI2SyseCqSYLfVfYj9B
         Pmui323IrOwkrGYszjLe7tNc78oYm+x+Jy8RE5SBYaKHBNy1kWNCBl5lqQSuOz1qJyP/
         4E0fooPFRqnEx+OWeA/NxNdlqBZcCBmA4mThLzNLKWAzS4Gr8m6N68SFvGD+19YA99Zw
         T2Yw==
X-Gm-Message-State: APjAAAUil7rEF2lgrQI/fDtMiSiOTdfRtpYHVVnCzRZ5dL5i6av+nSaa
        e1u8VlD12/qFvOaSCVjBFWq+c6bAqyw=
X-Google-Smtp-Source: APXvYqyVTIYyHAC3zrMndzLxY2kVv5SL06C5CtgxKa2GLO2zV+BYW8n/hBx2IU6/xsHPJifM9AQydw==
X-Received: by 2002:a65:6259:: with SMTP id q25mr3033072pgv.103.1553633854550;
        Tue, 26 Mar 2019 13:57:34 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id p34sm32509131pgb.18.2019.03.26.13.57.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Mar 2019 13:57:33 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     linux-wireless@vger.kernel.org
Cc:     ath10k@lists.infradead.org, Carl Huang <cjhuang@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>,
        =?UTF-8?q?Micha=C5=82=20Kazior?= <kazikcz@gmail.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH for-5.1] ath10k: perform crash dump collection in workqueue
Date:   Tue, 26 Mar 2019 13:57:28 -0700
Message-Id: <20190326205728.168973-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Commit 25733c4e67df ("ath10k: pci: use mutex for diagnostic window CE
polling") introduced a regression where we try to sleep (grab a mutex)
in an atomic context:

[  233.602619] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:254
[  233.602626] in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/0
[  233.602636] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W         5.1.0-rc2 #4
[  233.602642] Hardware name: Google Scarlet (DT)
[  233.602647] Call trace:
[  233.602663]  dump_backtrace+0x0/0x11c
[  233.602672]  show_stack+0x20/0x28
[  233.602681]  dump_stack+0x98/0xbc
[  233.602690]  ___might_sleep+0x154/0x16c
[  233.602696]  __might_sleep+0x78/0x88
[  233.602704]  mutex_lock+0x2c/0x5c
[  233.602717]  ath10k_pci_diag_read_mem+0x68/0x21c [ath10k_pci]
[  233.602725]  ath10k_pci_diag_read32+0x48/0x74 [ath10k_pci]
[  233.602733]  ath10k_pci_dump_registers+0x5c/0x16c [ath10k_pci]
[  233.602741]  ath10k_pci_fw_crashed_dump+0xb8/0x548 [ath10k_pci]
[  233.602749]  ath10k_pci_napi_poll+0x60/0x128 [ath10k_pci]
[  233.602757]  net_rx_action+0x140/0x388
[  233.602766]  __do_softirq+0x1b0/0x35c
[...]

ath10k_pci_fw_crashed_dump() is called from NAPI contexts, and firmware
memory dumps are retrieved using the diag memory interface.

A simple reproduction case is to run this on QCA6174A /
WLAN.RM.4.4.1-00132-QCARMSWP-1, which happens to be a way to b0rk the
firmware:

  dd if=/sys/kernel/debug/ieee80211/phy0/ath10k/mem_value bs=4K count=1
of=/dev/null

(NB: simulated firmware crashes, via debugfs, don't trigger firmware
dumps.)

The fix is to move the crash-dump into a workqueue context, and avoid
relying on 'data_lock' for most mutual exclusion. We only keep using it
here for protecting 'fw_crash_counter', while the rest of the coredump
buffers are protected by a new 'dump_mutex'.

I've tested the above with simulated firmware crashes (debugfs 'reset'
file), real firmware crashes (the 'dd' command above), and a variety of
reboot and suspend/resume configurations on QCA6174A.

Reported here:
http://lkml.kernel.org/linux-wireless/20190325202706.GA68720@google.com

Fixes: 25733c4e67df ("ath10k: pci: use mutex for diagnostic window CE polling")
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/ce.c       |  2 +-
 drivers/net/wireless/ath/ath10k/core.c     |  1 +
 drivers/net/wireless/ath/ath10k/core.h     |  3 +++
 drivers/net/wireless/ath/ath10k/coredump.c |  6 +++---
 drivers/net/wireless/ath/ath10k/pci.c      | 24 +++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/pci.h      |  2 ++
 6 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 24b983edb357..eca87f7c5b6c 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1855,7 +1855,7 @@ void ath10k_ce_dump_registers(struct ath10k *ar,
 	struct ath10k_ce_crash_data ce_data;
 	u32 addr, id;
 
-	lockdep_assert_held(&ar->data_lock);
+	lockdep_assert_held(&ar->dump_mutex);
 
 	ath10k_err(ar, "Copy Engine register dump:\n");
 
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 835b8de92d55..aff585658fc0 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -3119,6 +3119,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 		goto err_free_wq;
 
 	mutex_init(&ar->conf_mutex);
+	mutex_init(&ar->dump_mutex);
 	spin_lock_init(&ar->data_lock);
 
 	INIT_LIST_HEAD(&ar->peers);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index e08a17b01e03..e35aae5146f1 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1063,6 +1063,9 @@ struct ath10k {
 	/* prevents concurrent FW reconfiguration */
 	struct mutex conf_mutex;
 
+	/* protects coredump data */
+	struct mutex dump_mutex;
+
 	/* protects shared structure data */
 	spinlock_t data_lock;
 
diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index 33838d9c1cb6..45a355fb62b9 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -1102,7 +1102,7 @@ struct ath10k_fw_crash_data *ath10k_coredump_new(struct ath10k *ar)
 {
 	struct ath10k_fw_crash_data *crash_data = ar->coredump.fw_crash_data;
 
-	lockdep_assert_held(&ar->data_lock);
+	lockdep_assert_held(&ar->dump_mutex);
 
 	if (ath10k_coredump_mask == 0)
 		/* coredump disabled */
@@ -1146,7 +1146,7 @@ static struct ath10k_dump_file_data *ath10k_coredump_build(struct ath10k *ar)
 	if (!buf)
 		return NULL;
 
-	spin_lock_bh(&ar->data_lock);
+	mutex_lock(&ar->dump_mutex);
 
 	dump_data = (struct ath10k_dump_file_data *)(buf);
 	strlcpy(dump_data->df_magic, "ATH10K-FW-DUMP",
@@ -1213,7 +1213,7 @@ static struct ath10k_dump_file_data *ath10k_coredump_build(struct ath10k *ar)
 		sofar += sizeof(*dump_tlv) + crash_data->ramdump_buf_len;
 	}
 
-	spin_unlock_bh(&ar->data_lock);
+	mutex_unlock(&ar->dump_mutex);
 
 	return dump_data;
 }
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 271f92c24d44..2c27f407a851 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1441,7 +1441,7 @@ static void ath10k_pci_dump_registers(struct ath10k *ar,
 	__le32 reg_dump_values[REG_DUMP_COUNT_QCA988X] = {};
 	int i, ret;
 
-	lockdep_assert_held(&ar->data_lock);
+	lockdep_assert_held(&ar->dump_mutex);
 
 	ret = ath10k_pci_diag_read_hi(ar, &reg_dump_values[0],
 				      hi_failure_state,
@@ -1656,7 +1656,7 @@ static void ath10k_pci_dump_memory(struct ath10k *ar,
 	int ret, i;
 	u8 *buf;
 
-	lockdep_assert_held(&ar->data_lock);
+	lockdep_assert_held(&ar->dump_mutex);
 
 	if (!crash_data)
 		return;
@@ -1734,14 +1734,19 @@ static void ath10k_pci_dump_memory(struct ath10k *ar,
 	}
 }
 
-static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
+static void ath10k_pci_fw_dump_work(struct work_struct *work)
 {
+	struct ath10k_pci *ar_pci = container_of(work, struct ath10k_pci,
+						 dump_work);
 	struct ath10k_fw_crash_data *crash_data;
+	struct ath10k *ar = ar_pci->ar;
 	char guid[UUID_STRING_LEN + 1];
 
-	spin_lock_bh(&ar->data_lock);
+	mutex_lock(&ar->dump_mutex);
 
+	spin_lock_bh(&ar->data_lock);
 	ar->stats.fw_crash_counter++;
+	spin_unlock_bh(&ar->data_lock);
 
 	crash_data = ath10k_coredump_new(ar);
 
@@ -1756,11 +1761,18 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 	ath10k_ce_dump_registers(ar, crash_data);
 	ath10k_pci_dump_memory(ar, crash_data);
 
-	spin_unlock_bh(&ar->data_lock);
+	mutex_unlock(&ar->dump_mutex);
 
 	queue_work(ar->workqueue, &ar->restart_work);
 }
 
+static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
+	queue_work(ar->workqueue, &ar_pci->dump_work);
+}
+
 void ath10k_pci_hif_send_complete_check(struct ath10k *ar, u8 pipe,
 					int force)
 {
@@ -3442,6 +3454,8 @@ int ath10k_pci_setup_resource(struct ath10k *ar)
 	spin_lock_init(&ar_pci->ps_lock);
 	mutex_init(&ar_pci->ce_diag_mutex);
 
+	INIT_WORK(&ar_pci->dump_work, ath10k_pci_fw_dump_work);
+
 	timer_setup(&ar_pci->rx_post_retry, ath10k_pci_rx_replenish_retry, 0);
 
 	if (QCA_REV_6174(ar) || QCA_REV_9377(ar))
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 3773c79f322f..4455ed6c5275 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -121,6 +121,8 @@ struct ath10k_pci {
 	/* For protecting ce_diag */
 	struct mutex ce_diag_mutex;
 
+	struct work_struct dump_work;
+
 	struct ath10k_ce ce;
 	struct timer_list rx_post_retry;
 
-- 
2.21.0.392.gf8f6787159e-goog

