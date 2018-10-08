Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3653C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75EA72087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:03:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cmo0KH48";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cmo0KH48"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75EA72087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbeJHQNq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 12:13:46 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60482 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbeJHQNq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 12:13:46 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8FA8B607BD; Mon,  8 Oct 2018 09:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538989385;
        bh=DWBFvOQjRDwsw6Q+13JTj44Rb1sJfe9H2E559h7xjz8=;
        h=From:To:Cc:Subject:Date:From;
        b=cmo0KH4864v8Pfygv/+dB4BSITFFv9GVmX0B5Ri6mt/iabwEmmHg9qjb8jG0eX64L
         evr9K2avVxsRT0vkuBXjm4c372zx2U7lS6XCsk6KpHmLorfe21cTHJ7sx5Yvh1OFoa
         AQisQb+aZJVB186M7JNAfDTPqIfOiYeB7Dh0q5io=
Received: from localhost.localdomain (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 961BD6076A;
        Mon,  8 Oct 2018 09:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538989385;
        bh=DWBFvOQjRDwsw6Q+13JTj44Rb1sJfe9H2E559h7xjz8=;
        h=From:To:Cc:Subject:Date:From;
        b=cmo0KH4864v8Pfygv/+dB4BSITFFv9GVmX0B5Ri6mt/iabwEmmHg9qjb8jG0eX64L
         evr9K2avVxsRT0vkuBXjm4c372zx2U7lS6XCsk6KpHmLorfe21cTHJ7sx5Yvh1OFoa
         AQisQb+aZJVB186M7JNAfDTPqIfOiYeB7Dh0q5io=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 961BD6076A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: Add peer flush in ath10k_flush for STATION
Date:   Mon,  8 Oct 2018 17:02:43 +0800
Message-Id: <1538989363-12386-1-git-send-email-wgong@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In the noisy environment, if there are packets in the queue and can't
send out, the suspend timing will be more than 5 seconds due to the wait,
flush the queue to optimize the suspend timing, and let the upper layer to
retry the packets after resume.

Tested with QCA6174 PCI with firmware
WLAN.RM.4.4.1-00109-QCARMSWPZ-1, but this will also affect QCA9377 PCI.
It's not a regression with new firmware releases.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
 drivers/net/wireless/ath/ath10k/mac.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 97548f9..8df3cec 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6814,9 +6814,20 @@ static void ath10k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			 u32 queues, bool drop)
 {
 	struct ath10k *ar = hw->priv;
-
-	if (drop)
+	struct ath10k_vif *arvif;
+	u32 bitmap;
+
+	if (drop) {
+		if (vif->type == NL80211_IFTYPE_STATION) {
+			bitmap = ~(1 << WMI_MGMT_TID);
+			list_for_each_entry(arvif, &ar->arvifs, list) {
+				if (arvif->vdev_type == WMI_VDEV_TYPE_STA)
+					ath10k_wmi_peer_flush(ar, arvif->vdev_id,
+							      arvif->bssid, bitmap);
+			}
+		}
 		return;
+	}
 
 	mutex_lock(&ar->conf_mutex);
 	ath10k_mac_wait_tx_complete(ar);
-- 
1.9.1

