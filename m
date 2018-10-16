Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA21C04EB9
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 02:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02316208D9
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 02:24:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02316208D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbeJPKMm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 06:12:42 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13658 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726917AbeJPKMm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 06:12:42 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7D8384015E0B4;
        Tue, 16 Oct 2018 10:24:37 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.399.0; Tue, 16 Oct 2018 10:24:32 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@codeaurora.org>
CC:     Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-wireless@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] mac80211: fix missing unlock on error in ieee80211_mark_sta_auth()
Date:   Tue, 16 Oct 2018 02:35:30 +0000
Message-ID: <1539657330-35956-1-git-send-email-weiyongjun1@huawei.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add the missing unlock before return from function
ieee80211_mark_sta_auth() in the error handling case.

Fixes: fc107a933071 ("mac80211: Helper function for marking STA authenticated")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 net/mac80211/mlme.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d2bc8d5..755ca4d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2778,10 +2778,12 @@ static bool ieee80211_mark_sta_auth(struct ieee80211_sub_if_data *sdata,
 	sta = sta_info_get(sdata, bssid);
 	if (!sta) {
 		WARN_ONCE(1, "%s: STA %pM not found", sdata->name, bssid);
+		mutex_unlock(&sdata->local->sta_mtx);
 		return false;
 	}
 	if (sta_info_move_state(sta, IEEE80211_STA_AUTH)) {
 		sdata_info(sdata, "failed moving %pM to auth\n", bssid);
+		mutex_unlock(&sdata->local->sta_mtx);
 		return false;
 	}
 	mutex_unlock(&sdata->local->sta_mtx);

