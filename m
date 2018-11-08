Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A55ECDE47
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 16:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1802E2077B
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 16:37:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1802E2077B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ni.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbeKICN3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 21:13:29 -0500
Received: from mx0a-00010702.pphosted.com ([148.163.156.75]:52638 "EHLO
        mx0b-00010702.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726584AbeKICN2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 21:13:28 -0500
Received: from pps.filterd (m0098780.ppops.net [127.0.0.1])
        by mx0a-00010702.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wA8GZqpr001590;
        Thu, 8 Nov 2018 10:37:09 -0600
Received: from ni.com (skprod2.natinst.com [130.164.80.23])
        by mx0a-00010702.pphosted.com with ESMTP id 2nkvahdqtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Nov 2018 10:37:08 -0600
Received: from us-aus-exhub1.ni.corp.natinst.com (us-aus-exhub1.ni.corp.natinst.com [130.164.68.41])
        by us-aus-skprod2.natinst.com (8.16.0.22/8.16.0.22) with ESMTPS id wA8Gb7qd022612
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 8 Nov 2018 10:37:07 -0600
Received: from us-aus-exch3.ni.corp.natinst.com (130.164.68.13) by
 us-aus-exhub1.ni.corp.natinst.com (130.164.68.41) with Microsoft SMTP Server
 (TLS) id 15.0.1395.4; Thu, 8 Nov 2018 10:37:07 -0600
Received: from us-aus-exhub2.ni.corp.natinst.com (130.164.68.32) by
 us-aus-exch3.ni.corp.natinst.com (130.164.68.13) with Microsoft SMTP Server
 (TLS) id 15.0.1395.4; Thu, 8 Nov 2018 10:37:07 -0600
Received: from senary.amer.corp.natinst.com (130.164.49.7) by
 us-aus-exhub2.ni.corp.natinst.com (130.164.68.32) with Microsoft SMTP Server
 id 15.0.1395.4 via Frontend Transport; Thu, 8 Nov 2018 10:37:07 -0600
From:   Kyle Roeschley <kyle.roeschley@ni.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Kyle Roeschley <kyle.roeschley@ni.com>
Subject: [PATCH 2/3] ath6kl: Fix off by one error in scan completion
Date:   Thu, 8 Nov 2018 10:36:58 -0600
Message-ID: <20181108163659.19535-2-kyle.roeschley@ni.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181108163659.19535-1-kyle.roeschley@ni.com>
References: <20181108163659.19535-1-kyle.roeschley@ni.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-11-08_08:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When ath6kl was reworked to share code between regular and scheduled scans
in commit 3b8ffc6a22ba ("ath6kl: Configure probed SSID list consistently"),
probed SSID entry changed from 1-index to 0-indexed. However,
ath6kl_cfg80211_scan_complete_event() was missed in that change. Fix its
indexing so that we correctly clear out the probed SSID list.

Signed-off-by: Kyle Roeschley <kyle.roeschley@ni.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 6c98d7903ffb..d7c626d9594e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1093,7 +1093,7 @@ void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, bool aborted)
 	if (vif->scan_req->n_ssids && vif->scan_req->ssids[0].ssid_len) {
 		for (i = 0; i < vif->scan_req->n_ssids; i++) {
 			ath6kl_wmi_probedssid_cmd(ar->wmi, vif->fw_vif_idx,
-						  i + 1, DISABLE_SSID_FLAG,
+						  i, DISABLE_SSID_FLAG,
 						  0, NULL);
 		}
 	}
-- 
2.19.1

