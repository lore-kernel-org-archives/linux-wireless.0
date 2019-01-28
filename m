Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E03FC282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 16:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7F8F20989
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 16:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548691699;
	bh=ZBwx1Md24+q6FxcuEJQJWOqBm0slHwDH+/62QAZjWL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vupdH+hTfTYLQtZn0017uJ0Xr4u2rmtW00SzjHntlt9aN7wPggo9owzb4BGNjlBVE
	 ZuwqDI2+cHXMOGs9jnd6s7p8cbXteZKfAOI2FGHFji9RbWL4nFyuF2n8UWAK75QO3j
	 GFVFK2AyQdofWpl+nV44T/l2uK15EJQi7Zf2KTCo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731865AbfA1QIS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:08:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:59804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732343AbfA1QIO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 11:08:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FC9D2147A;
        Mon, 28 Jan 2019 16:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548691694;
        bh=ZBwx1Md24+q6FxcuEJQJWOqBm0slHwDH+/62QAZjWL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q7d5v6qCe3ACCFoXubFoBMXL9MywnWq2AtdbS8JUF5E8/EUjmDFCyNdAWJAd5Aswn
         G6k4jYOp9yU9OkTukCWr4catevaaqepmzTHAjB6jHdB+AhHGxJzwLjmUieyzb0xQD2
         JYNhRBhpBWcBbp5bMzSWsPmfiX87wtCHQ/pvzkmA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 187/258] mac80211: fix radiotap vendor presence bitmap handling
Date:   Mon, 28 Jan 2019 10:58:13 -0500
Message-Id: <20190128155924.51521-187-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128155924.51521-1-sashal@kernel.org>
References: <20190128155924.51521-1-sashal@kernel.org>
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
index 5e2b4a41acf1..51ad330bf8e8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -142,6 +142,9 @@ ieee80211_rx_radiotap_hdrlen(struct ieee80211_local *local,
 	/* allocate extra bitmaps */
 	if (status->chains)
 		len += 4 * hweight8(status->chains);
+	/* vendor presence bitmap */
+	if (status->flag & RX_FLAG_RADIOTAP_VENDOR_DATA)
+		len += 4;
 
 	if (ieee80211_have_rx_timestamp(status)) {
 		len = ALIGN(len, 8);
@@ -197,8 +200,6 @@ ieee80211_rx_radiotap_hdrlen(struct ieee80211_local *local,
 	if (status->flag & RX_FLAG_RADIOTAP_VENDOR_DATA) {
 		struct ieee80211_vendor_radiotap *rtap = (void *)skb->data;
 
-		/* vendor presence bitmap */
-		len += 4;
 		/* alignment for fixed 6-byte vendor data header */
 		len = ALIGN(len, 2);
 		/* vendor data header */
-- 
2.19.1

