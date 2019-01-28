Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CDA3C282CD
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 16:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C733A20879
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 16:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548692219;
	bh=2vum9NLq+1e6FebPh2hzCY5VNeJGqj2+PiGi1toxQq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gNIzx+7z11v8nu2PaqkeMlj55yA7xnGKIUttvOox1oCRJ0KULWYFpA/zEz9SJkLus
	 iMqcUpsHL1Cf6II9JWnxJXmaftDB8RmzH9KFiXw1FugeU8fanoOazu0CzqnAFY/iYV
	 0b93qc9uqWEC5I0fVH1VWRd82mYMmsVSN/qMM4ik=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387448AbfA1QQ7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:16:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388067AbfA1QQ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 11:16:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94E9C20879;
        Mon, 28 Jan 2019 16:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548692217;
        bh=2vum9NLq+1e6FebPh2hzCY5VNeJGqj2+PiGi1toxQq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvVmU3e/mqeLP/QgbNCVY6aX5IVREWRfKtB517JAO3Kyq5L8jslBF5GewL2Pgjjmo
         bQL2UK8NJ/qV3zt1aJawsY/Cpuvao7ccOcGfYY603fKk+QQosm5Jn2TOy6aNKk/PAB
         jL4K13rRxZ9vkbjmrXJ8qEn420I3+zWDXvINQzHA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 114/170] mac80211: fix radiotap vendor presence bitmap handling
Date:   Mon, 28 Jan 2019 11:11:04 -0500
Message-Id: <20190128161200.55107-114-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128161200.55107-1-sashal@kernel.org>
References: <20190128161200.55107-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit efc38dd7d5fa5c8cdd0c917c5d00947aa0539443 ]

Due to the alignment handling, it actually matters where in the code
we add the 4 bytes for the presence bitmap to the length; the first
field is the timestamp with 8 byte alignment so we need to add the
space for the extra vendor namespace presence bitmap *before* we do
any alignment for the fields.

Move the presence bitmap length accounting to the right place to fix
the alignment for the data properly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9e19ddbcb06e..c7ac1a480b1d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -141,6 +141,9 @@ ieee80211_rx_radiotap_hdrlen(struct ieee80211_local *local,
 	/* allocate extra bitmaps */
 	if (status->chains)
 		len += 4 * hweight8(status->chains);
+	/* vendor presence bitmap */
+	if (status->flag & RX_FLAG_RADIOTAP_VENDOR_DATA)
+		len += 4;
 
 	if (ieee80211_have_rx_timestamp(status)) {
 		len = ALIGN(len, 8);
@@ -182,8 +185,6 @@ ieee80211_rx_radiotap_hdrlen(struct ieee80211_local *local,
 	if (status->flag & RX_FLAG_RADIOTAP_VENDOR_DATA) {
 		struct ieee80211_vendor_radiotap *rtap = (void *)skb->data;
 
-		/* vendor presence bitmap */
-		len += 4;
 		/* alignment for fixed 6-byte vendor data header */
 		len = ALIGN(len, 2);
 		/* vendor data header */
-- 
2.19.1

