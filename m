Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEDCCC4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 897E920700
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfBVOVq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:21:46 -0500
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:46067 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726808AbfBVOVb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 09:21:31 -0500
X-IronPort-AV: E=Sophos;i="5.58,400,1544482800"; 
   d="scan'208";a="2017373"
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 22 Feb 2019 15:21:26 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9174"; a="7285580"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg02-ams.qualcomm.com with ESMTP; 22 Feb 2019 15:21:26 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 07/21] wil6210: check null pointer in _wil_cfg80211_merge_extra_ies
Date:   Fri, 22 Feb 2019 16:21:05 +0200
Message-Id: <1550845279-16103-8-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
References: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>

ies1 or ies2 might be null when code inside
_wil_cfg80211_merge_extra_ies access them.
Add explicit check for null and make sure ies1/ies2 are not
accessed in such a case.

spos might be null and be accessed inside
_wil_cfg80211_merge_extra_ies.
Add explicit check for null in the while condition statement
and make sure spos is not accessed in such a case.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 9a9d55b..a1e226652 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1580,6 +1580,12 @@ static int _wil_cfg80211_merge_extra_ies(const u8 *ies1, u16 ies1_len,
 	u8 *buf, *dpos;
 	const u8 *spos;
 
+	if (!ies1)
+		ies1_len = 0;
+
+	if (!ies2)
+		ies2_len = 0;
+
 	if (ies1_len == 0 && ies2_len == 0) {
 		*merged_ies = NULL;
 		*merged_len = 0;
@@ -1589,17 +1595,19 @@ static int _wil_cfg80211_merge_extra_ies(const u8 *ies1, u16 ies1_len,
 	buf = kmalloc(ies1_len + ies2_len, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
-	memcpy(buf, ies1, ies1_len);
+	if (ies1)
+		memcpy(buf, ies1, ies1_len);
 	dpos = buf + ies1_len;
 	spos = ies2;
-	while (spos + 1 < ies2 + ies2_len) {
+	while (spos && (spos + 1 < ies2 + ies2_len)) {
 		/* IE tag at offset 0, length at offset 1 */
 		u16 ielen = 2 + spos[1];
 
 		if (spos + ielen > ies2 + ies2_len)
 			break;
 		if (spos[0] == WLAN_EID_VENDOR_SPECIFIC &&
-		    !_wil_cfg80211_find_ie(ies1, ies1_len, spos, ielen)) {
+		    (!ies1 || !_wil_cfg80211_find_ie(ies1, ies1_len,
+						     spos, ielen))) {
 			memcpy(dpos, spos, ielen);
 			dpos += ielen;
 		}
-- 
1.9.1

