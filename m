Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD66C10F14
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 08:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B5AA20850
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 08:54:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Wz6NJJqg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aimf4MNA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727214AbfDLIy5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 04:54:57 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50022 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfDLIy5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 04:54:57 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EFB2C6122D; Fri, 12 Apr 2019 08:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555059296;
        bh=6Ro2xEFCSDj2sVwTyNpdpRBRWnSLXD6xkI5YgymDcz4=;
        h=From:To:Cc:Subject:Date:From;
        b=Wz6NJJqgl9o8wHyAfQWUTc3dNBq3+5RD02/Y9dsnknhB9kepdDaI56YqU2rbfMmFS
         C20R6BKI03NRm08G5BduNSM0tPAK0U8degBZUo+sgGMsJufxu4ftee9v+5s8hxDprB
         LtjuIJUbQw5y74iZPGvFZ6YeC+Fh0B+iSBJCdSJs=
Received: from localhost.localdomain (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AA5166122D;
        Fri, 12 Apr 2019 08:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555059293;
        bh=6Ro2xEFCSDj2sVwTyNpdpRBRWnSLXD6xkI5YgymDcz4=;
        h=From:To:Cc:Subject:Date:From;
        b=aimf4MNAb19vOUQi0j0vYYlj9cPtQdkD78XamLG5lMjbUWnj5D2N/NwEaZX7NoZE2
         UnUEVGubVGlBTT4ezZKl9/9bHsiGiYWRbQI+jrQsTEWuHFITCOC6oBUCF0jfhL3kjG
         xAqMalB75HI4/Typyjcyz36EDkG/nC01dVYnekx4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AA5166122D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH v2] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
Date:   Fri, 12 Apr 2019 16:52:50 +0800
Message-Id: <1555059170-11988-1-git-send-email-wgong@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When test simulate firmware crash, it is easy to trigger error.
command:
echo soft > /sys/kernel/debug/ieee80211/phyxx/ath10k/simulate_fw_crash.

If input more than two times continuously, then it will have error.
Error message:
ath10k_pci 0000:02:00.0: failed to set vdev 1 RX wake policy: -108
ath10k_pci 0000:02:00.0: device is wedged, will not restart

It is because the state has not changed to ATH10K_STATE_ON immediately,
then it will have more than two simulate crash process running meanwhile,
and complete/wakeup some field twice, it destroy the normal recovery
process.

add flag wait-ready for this command:
echo soft wait-ready > /sys/kernel/debug/ieee80211/phyxx/ath10k/simulate_fw_crash

Tested with QCA6174 PCI with firmware
WLAN.RM.4.4.1-00109-QCARMSWPZ-1, but this will also affect QCA9377 PCI.
It's not a regression with new firmware releases.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
---
v2: add wait-ready flag
 drivers/net/wireless/ath/ath10k/debug.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 15964b3..04a20b8 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -534,7 +534,8 @@ static ssize_t ath10k_read_simulate_fw_crash(struct file *file,
 		"`soft` - this will send WMI_FORCE_FW_HANG_ASSERT to firmware if FW supports that command.\n"
 		"`hard` - this will send to firmware command with illegal parameters causing firmware crash.\n"
 		"`assert` - this will send special illegal parameter to firmware to cause assert failure and crash.\n"
-		"`hw-restart` - this will simply queue hw restart without fw/hw actually crashing.\n";
+		"`hw-restart` - this will simply queue hw restart without fw/hw actually crashing.\n"
+		"`soft wait-ready` `hard wait-ready` `assert wait-ready` `hw-restart wait-ready` - cmd only execuate when state is ATH10K_STATE_ON.\n";
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
 }
@@ -554,6 +555,9 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 	char buf[32] = {0};
 	ssize_t rc;
 	int ret;
+	char buf_cmd[32] = {0};
+	char buf_flag[32] = {0};
+	bool wait_ready;
 
 	/* filter partial writes and invalid commands */
 	if (*ppos != 0 || count >= sizeof(buf) || count == 0)
@@ -567,18 +571,25 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 	if (buf[*ppos - 1] == '\n')
 		buf[*ppos - 1] = '\0';
 
+	sscanf(buf, "%s %s", buf_cmd, buf_flag);
+	ath10k_info(ar, "buf_cmd:%s, buf_flag:%s\n", buf_cmd, buf_flag);
+
+	wait_ready = !strcmp(buf_cmd, "wait-ready");
 	mutex_lock(&ar->conf_mutex);
 
-	if (ar->state != ATH10K_STATE_ON &&
-	    ar->state != ATH10K_STATE_RESTARTED) {
+	if ((!wait_ready &&
+	     ar->state != ATH10K_STATE_ON &&
+	     ar->state != ATH10K_STATE_RESTARTED) ||
+	    (wait_ready &&
+	     ar->state != ATH10K_STATE_ON)) {
 		ret = -ENETDOWN;
 		goto exit;
 	}
 
-	if (!strcmp(buf, "soft")) {
+	if (!strcmp(buf_cmd, "soft")) {
 		ath10k_info(ar, "simulating soft firmware crash\n");
 		ret = ath10k_wmi_force_fw_hang(ar, WMI_FORCE_FW_HANG_ASSERT, 0);
-	} else if (!strcmp(buf, "hard")) {
+	} else if (!strcmp(buf_cmd, "hard")) {
 		ath10k_info(ar, "simulating hard firmware crash\n");
 		/* 0x7fff is vdev id, and it is always out of range for all
 		 * firmware variants in order to force a firmware crash.
@@ -586,10 +597,10 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 		ret = ath10k_wmi_vdev_set_param(ar, 0x7fff,
 						ar->wmi.vdev_param->rts_threshold,
 						0);
-	} else if (!strcmp(buf, "assert")) {
+	} else if (!strcmp(buf_cmd, "assert")) {
 		ath10k_info(ar, "simulating firmware assert crash\n");
 		ret = ath10k_debug_fw_assert(ar);
-	} else if (!strcmp(buf, "hw-restart")) {
+	} else if (!strcmp(buf_cmd, "hw-restart")) {
 		ath10k_info(ar, "user requested hw restart\n");
 		queue_work(ar->workqueue, &ar->restart_work);
 		ret = 0;
-- 
1.9.1

