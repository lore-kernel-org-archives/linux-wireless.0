Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C95C282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 14:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6F70222BA
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 14:12:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="P6CUhhF1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NRldXanX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732988AbfBMOMp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 09:12:45 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39066 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732191AbfBMOMp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 09:12:45 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2E6646074F; Wed, 13 Feb 2019 14:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550067164;
        bh=FfbnkInw/xz1x7lH3WXzSutRZmdoYxn85ofqibEiAI8=;
        h=From:To:Cc:Subject:Date:From;
        b=P6CUhhF1t/XdlUtj+5S010cAkt6KBeE2Kw7Zjs8SpzITd5oknvS2U94e+e+3A/wBT
         XgPfoBmOcs9ZuNo14C7HrhsRnKiuhoKAP3O45PiUQIS+OUglIhcc9ezMyG+TVbABJv
         09oDDfvT3rktE14j0XHYxTVXkrKTdsNXKjT6KFv4=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 691D36086B;
        Wed, 13 Feb 2019 14:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550067162;
        bh=FfbnkInw/xz1x7lH3WXzSutRZmdoYxn85ofqibEiAI8=;
        h=From:To:Cc:Subject:Date:From;
        b=NRldXanX1F/8xd38OJ1aJzO96n+kg1M6zyF3FOkQDA3DPfIqU7tOWVqZTFK5xxHsB
         5VznbfQFu2Q1qL/5KjjgUyatfBsOAFDXABV0pcxvn8TrGtSwx9PKXx2KiNmzvWkBe7
         b4ouBPJHR+uS3rvo7Ovf1j4iRQrhBl2EmU299zXo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 691D36086B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH] ath10k: Report low ack rssi based on the reason code
Date:   Wed, 13 Feb 2019 19:42:30 +0530
Message-Id: <1550067150-8796-1-git-send-email-pillair@codeaurora.org>
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
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  2 ++
 drivers/net/wireless/ath/ath10k/wmi.c     |  9 ++++++---
 drivers/net/wireless/ath/ath10k/wmi.h     | 12 ++++++++++++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 90617e1..63ca9c5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -885,6 +885,8 @@ static int ath10k_wmi_tlv_op_pull_peer_kick_ev(struct ath10k *ar,
 	}
 
 	arg->mac_addr = ev->peer_macaddr.addr;
+	arg->reason = __le32_to_cpu(ev->reason);
+	arg->reason_code_valid = true;
 
 	kfree(tb);
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index b99b3a1..75707d6b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3393,9 +3393,6 @@ void ath10k_wmi_event_peer_sta_kickout(struct ath10k *ar, struct sk_buff *skb)
 		return;
 	}
 
-	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi event peer sta kickout %pM\n",
-		   arg.mac_addr);
-
 	rcu_read_lock();
 
 	sta = ieee80211_find_sta_by_ifaddr(ar->hw, arg.mac_addr, NULL);
@@ -3405,10 +3402,16 @@ void ath10k_wmi_event_peer_sta_kickout(struct ath10k *ar, struct sk_buff *skb)
 		goto exit;
 	}
 
+	if (arg.reason_code_valid &&
+	    arg.reason == WMI_PEER_STA_KICKOUT_REASON_UNSPECIFIED)
+		goto exit;
+
 	ieee80211_report_low_ack(sta, 10);
 
 exit:
 	rcu_read_unlock();
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi event peer sta kickout %pM reason code %d\n",
+		    arg.mac_addr, arg.reason);
 }
 
 /*
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 1f82f10..492ce0f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6498,6 +6498,7 @@ struct wmi_10_4_chan_info_event {
 
 struct wmi_peer_sta_kickout_event {
 	struct wmi_mac_addr peer_macaddr;
+	__le32 reason;
 } __packed;
 
 #define WMI_CHAN_INFO_FLAG_COMPLETE BIT(0)
@@ -6737,6 +6738,8 @@ struct wmi_vdev_start_ev_arg {
 
 struct wmi_peer_kick_ev_arg {
 	const u8 *mac_addr;
+	u32 reason;
+	bool reason_code_valid;
 };
 
 struct wmi_swba_ev_arg {
@@ -6827,6 +6830,15 @@ struct wmi_pdev_bss_chan_info_event {
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

