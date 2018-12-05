Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE56C04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 10:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86B4A20672
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 10:56:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QJ1IGhFc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QJ1IGhFc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86B4A20672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbeLEK42 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 05:56:28 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46256 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbeLEK42 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 05:56:28 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CDE4F60540; Wed,  5 Dec 2018 10:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544007387;
        bh=xTsP1KZKS6MgcghK5rBQelX9uuizkhkadt2WcSR/Z5k=;
        h=From:To:Cc:Subject:Date:From;
        b=QJ1IGhFcm2JuH2Pbx7dUPu2nQyRFHjPxm89Q+OLeLhTIFj9THpH6j4BzSMdFc0scS
         q0xS1hHwEQXTySi3GUoFcY3uOEM9MYrVS+38v7T8Tr4L6NsRcwaKgK+5Rs/p4bKcvC
         L67TSAh18fqusx0WJ7P+mLSqUmb0vLz2Mji+Q8UI=
Received: from jouni.codeaurora.org (37-33-76-121.bb.dnainternet.fi [37.33.76.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jouni@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4CA316014B;
        Wed,  5 Dec 2018 10:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544007387;
        bh=xTsP1KZKS6MgcghK5rBQelX9uuizkhkadt2WcSR/Z5k=;
        h=From:To:Cc:Subject:Date:From;
        b=QJ1IGhFcm2JuH2Pbx7dUPu2nQyRFHjPxm89Q+OLeLhTIFj9THpH6j4BzSMdFc0scS
         q0xS1hHwEQXTySi3GUoFcY3uOEM9MYrVS+38v7T8Tr4L6NsRcwaKgK+5Rs/p4bKcvC
         L67TSAh18fqusx0WJ7P+mLSqUmb0vLz2Mji+Q8UI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4CA316014B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=jouni@codeaurora.org
From:   Jouni Malinen <jouni@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH] cfg80211: Fix busy loop regression in ieee80211_ie_split_ric()
Date:   Wed,  5 Dec 2018 12:55:54 +0200
Message-Id: <1544007354-810-1-git-send-email-jouni@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This function was modified to support the information element extension
case (WLAN_EID_EXTENSION) in a manner that would result in an infinite
loop when going through set of IEs that include WLAN_EID_RIC_DATA and
contain an IE that is in the after_ric array. The only place where this
can currently happen is in mac80211 ieee80211_send_assoc() where
ieee80211_ie_split_ric() is called with after_ric[].

This can be triggered by valid data from user space nl80211
association/connect request (i.e., requiring GENL_UNS_ADMIN_PERM). The
only known application having an option to include WLAN_EID_RIC_DATA in
these requests is wpa_supplicant and it had a bug that prevented this
specific contents from being used (and because of that, not triggering
this kernel bug in an automated test case ap_ft_ric) and now that this
bug is fixed, it has a workaround to avoid this kernel issue.
WLAN_EID_RIC_DATA is currently used only for testing purposes, so this
does not cause significant harm for production use cases.

Fixes: 2512b1b18d07 ("mac80211: extend ieee80211_ie_split to support EXTENSION")
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
---
 net/wireless/util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index ef14d80..d473bd1 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1421,6 +1421,8 @@ size_t ieee80211_ie_split_ric(const u8 *ies, size_t ielen,
 							  ies[pos + ext],
 							  ext == 2))
 					pos = skip_ie(ies, ielen, pos);
+				else
+					break;
 			}
 		} else {
 			pos = skip_ie(ies, ielen, pos);
-- 
2.7.4

