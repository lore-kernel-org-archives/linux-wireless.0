Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F937C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10118222B8
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:09:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="a6RVXdop";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ds7tejan"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403799AbfBKPJ4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 10:09:56 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43054 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391733AbfBKPJy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 10:09:54 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 76B07608C6; Mon, 11 Feb 2019 15:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549897793;
        bh=NOfeJC8Q3GgkEVMREeb0m1P7I26EZcJ28D1CYATd2Ng=;
        h=From:To:Cc:Subject:Date:From;
        b=a6RVXdopmmKCBffNzfGT0uwVNJTOdHxCA1Xzt/0Hwl0ZAmK9pdhr3f7TL1e2uWLmo
         Q3BkTLbnGdbvi0MPYewvTkgbdsVPjaff2glRW8UbK5En2DbYTdGXoHCcHeu1spKnf+
         MKZzANCXlMnOX4c61fp8ZJ+vR72LSP4TpKspsV2c=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C7E3860C8E;
        Mon, 11 Feb 2019 15:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549897792;
        bh=NOfeJC8Q3GgkEVMREeb0m1P7I26EZcJ28D1CYATd2Ng=;
        h=From:To:Cc:Subject:Date:From;
        b=Ds7tejanJ4TwjqfNqQMsIXn4U2TM22aYPZFhPW/nXy3pPb662N12Fyp5RtqnaRwDa
         kTlXqfxnNCI8xVmc3QjG3uuGMtmF93sn3yi0Iog20YUxP32wO3jg9n5xf30f9ZtHke
         uEHiy1UFjZSYt+IsZZW52bAfUq/YzbQ9R8IZGbl0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C7E3860C8E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH 1/6] ath10k: add missing values to wmi_service_name()
Date:   Mon, 11 Feb 2019 17:09:42 +0200
Message-Id: <1549897787-28537-1-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

After implementing the next patch GCC reported:

drivers/net/wireless/ath/ath10k/wmi.h:385:2: warning: enumeration value 'WMI_SERVICE_BTCOEX' not handled in switch [-Wswitch]
drivers/net/wireless/ath/ath10k/wmi.h:385:2: warning: enumeration value 'WMI_SERVICE_MGMT_TX_WMI' not handled in switch [-Wswitch]
drivers/net/wireless/ath/ath10k/wmi.h:385:2: warning: enumeration value 'WMI_SERVICE_SPOOF_MAC_SUPPORT' not handled in switch [-Wswitch]
drivers/net/wireless/ath/ath10k/wmi.h:385:2: warning: enumeration value 'WMI_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT' not handled in switch [-Wswitch]
drivers/net/wireless/ath/ath10k/wmi.h:385:2: warning: enumeration value 'WMI_SERVICE_BB_TIMING_CONFIG_SUPPORT' not handled in switch [-Wswitch]
drivers/net/wireless/ath/ath10k/wmi.h:385:2: warning: enumeration value 'WMI_SERVICE_THERM_THROT' not handled in switch [-Wswitch]

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index b10ed523b99e..529f5a26f3f3 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -475,6 +475,7 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_TX_MODE_PUSH_PULL);
 	SVCSTR(WMI_SERVICE_TX_MODE_DYNAMIC);
 	SVCSTR(WMI_SERVICE_VDEV_RX_FILTER);
+	SVCSTR(WMI_SERVICE_BTCOEX);
 	SVCSTR(WMI_SERVICE_CHECK_CAL_VERSION);
 	SVCSTR(WMI_SERVICE_DBGLOG_WARN2);
 	SVCSTR(WMI_SERVICE_BTCOEX_DUTY_CYCLE);
@@ -484,13 +485,18 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_SMART_LOGGING_SUPPORT);
 	SVCSTR(WMI_SERVICE_TDLS_CONN_TRACKER_IN_HOST_MODE);
 	SVCSTR(WMI_SERVICE_TDLS_EXPLICIT_MODE_ONLY);
+	SVCSTR(WMI_SERVICE_MGMT_TX_WMI);
 	SVCSTR(WMI_SERVICE_TDLS_WIDER_BANDWIDTH);
 	SVCSTR(WMI_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS);
 	SVCSTR(WMI_SERVICE_HOST_DFS_CHECK_SUPPORT);
 	SVCSTR(WMI_SERVICE_TPC_STATS_FINAL);
 	SVCSTR(WMI_SERVICE_RESET_CHIP);
+	SVCSTR(WMI_SERVICE_SPOOF_MAC_SUPPORT);
 	SVCSTR(WMI_SERVICE_TX_DATA_ACK_RSSI);
 	SVCSTR(WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT);
+	SVCSTR(WMI_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT);
+	SVCSTR(WMI_SERVICE_BB_TIMING_CONFIG_SUPPORT);
+	SVCSTR(WMI_SERVICE_THERM_THROT);
 	SVCSTR(WMI_SERVICE_RTT_RESPONDER_ROLE);
 	SVCSTR(WMI_SERVICE_PER_PACKET_SW_ENCRYPT);
 	SVCSTR(WMI_SERVICE_REPORT_AIRTIME);
-- 
2.7.4

