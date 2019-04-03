Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F259C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 07:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D30A820830
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 07:23:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ra1ct9CC";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="T7p8/Jjm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbfDCHXJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 03:23:09 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34924 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfDCHXI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 03:23:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6466F607EB; Wed,  3 Apr 2019 07:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554276187;
        bh=PjR8g1A71+K+0Yge7Fbhkf4paFD5YuKUEPizcvQIBqU=;
        h=From:To:Cc:Subject:Date:From;
        b=Ra1ct9CCdGH3L3Q1DvOwUAVHMHsbI0NaAi9CrsQfQZ24cpQJXNITWqj2e1f3CasPp
         Ls+zNz2CHfy0RbBJ+hUF0IlT3QnFc16hlZXq8s6Ak0cAI+3sE0CIoLsRzXFsmCwZLb
         npW3NfvoCpkhkcUUfSprE0eM97nuDyclury5XbD0=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 514EB606DB;
        Wed,  3 Apr 2019 07:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554276186;
        bh=PjR8g1A71+K+0Yge7Fbhkf4paFD5YuKUEPizcvQIBqU=;
        h=From:To:Cc:Subject:Date:From;
        b=T7p8/JjmZ2K86gxRA+OWB0zCYrs73IAPFwiWZPPiUMCYzzh2yu37IVIpU6NUeANY8
         G9WyGB1aT8BM0CFbbku095+xY5mWgZ2pMIhQSXLx6d1NPbrAD0fBfYWu9h/9PwPRpD
         02fnw5f9qU/5BpB/NBc2XJBIIlsUxbY5PTeqKgH4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 514EB606DB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH v2] ath10k: Report low ack rssi based on the reason code
Date:   Wed,  3 Apr 2019 12:53:01 +0530
Message-Id: <1554276181-7879-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Firmware sends peer sta kickout event to the driver
along with the reason code for a particular peer.

Currently the sta kickout event is delivered to the
upper layer without checking if the reason code is
valid or not. This causes frequent disconnection of
the STA.

Report low ack rssi event to mac80211 only if the reason
code is valid.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
Changes from v1:
- Added reason code in tlv structure, so that it does not break non-tlv wmi event parsing.
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  4 +++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  5 +++++
 drivers/net/wireless/ath/ath10k/wmi.c     |  9 ++++++---
 drivers/net/wireless/ath/ath10k/wmi.h     | 11 +++++++++++
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 582fb11..9d6ee92 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -876,7 +876,7 @@ static int ath10k_wmi_tlv_op_pull_peer_kick_ev(struct ath10k *ar,
 					       struct wmi_peer_kick_ev_arg *arg)
 {
 	const void **tb;
-	const struct wmi_peer_sta_kickout_event *ev;
+	const struct wmi_tlv_peer_sta_kickout_event *ev;
 	int ret;
 
 	tb = ath10k_wmi_tlv_parse_alloc(ar, skb->data, skb->len, GFP_ATOMIC);
@@ -893,6 +893,8 @@ static int ath10k_wmi_tlv_op_pull_peer_kick_ev(struct ath10k *ar,
 	}
 
 	arg->mac_addr = ev->peer_macaddr.addr;
+	arg->reason = __le32_to_cpu(ev->reason);
+	arg->reason_code_valid = true;
 
 	kfree(tb);
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 65e6aa5..be68ac6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1984,6 +1984,11 @@ struct wmi_tlv_diag_data_ev {
 	__le32 num_items;
 } __packed;
 
+struct wmi_tlv_peer_sta_kickout_event {
+	struct wmi_mac_addr peer_macaddr;
+	__le32 reason;
+} __packed;
+
 struct wmi_tlv_sta_keepalive_cmd {
 	__le32 vdev_id;
 	__le32 enabled;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 98a90e4..6603c31 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3428,9 +3428,6 @@ void ath10k_wmi_event_peer_sta_kickout(struct ath10k *ar, struct sk_buff *skb)
 		return;
 	}
 
-	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi event peer sta kickout %pM\n",
-		   arg.mac_addr);
-
 	rcu_read_lock();
 
 	sta = ieee80211_find_sta_by_ifaddr(ar->hw, arg.mac_addr, NULL);
@@ -3440,6 +3437,12 @@ void ath10k_wmi_event_peer_sta_kickout(struct ath10k *ar, struct sk_buff *skb)
 		goto exit;
 	}
 
+	if (arg.reason_code_valid &&
+	    arg.reason == WMI_PEER_STA_KICKOUT_REASON_UNSPECIFIED)
+		goto exit;
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi event peer sta kickout %pM reason code %d\n",
+		   arg.mac_addr, arg.reason);
 	ieee80211_report_low_ack(sta, 10);
 
 exit:
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index e1c40bb..3ccd79e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6797,6 +6797,8 @@ struct wmi_vdev_start_ev_arg {
 
 struct wmi_peer_kick_ev_arg {
 	const u8 *mac_addr;
+	u32 reason;
+	bool reason_code_valid;
 };
 
 struct wmi_swba_ev_arg {
@@ -6887,6 +6889,15 @@ struct wmi_pdev_bss_chan_info_event {
 	__le32 reserved;
 } __packed;
 
+enum wmi_peer_sta_kickout_reason {
+	WMI_PEER_STA_KICKOUT_REASON_UNSPECIFIED,
+	WMI_PEER_STA_KICKOUT_REASON_XRETRY,
+	WMI_PEER_STA_KICKOUT_REASON_INACTIVITY,
+	WMI_PEER_STA_KICKOUT_REASON_IBSS_DISCONNECT,
+	WMI_PEER_STA_KICKOUT_REASON_TDLS_DISCONNECT,
+	WMI_PEER_STA_KICKOUT_REASON_SA_QUERY_TIMEOUT,
+};
+
 /* WOW structures */
 enum wmi_wow_wakeup_event {
 	WOW_BMISS_EVENT = 0,
-- 
2.7.4

