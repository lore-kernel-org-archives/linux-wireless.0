Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE908C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 02:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3F1E20643
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 02:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550197266;
	bh=e0Y7LJADeVMuJ+mO1s/4mB5ItRHgoGsPN8tILdPKlmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1xg1kX5+uLt2RWrnd8bhi14v7r8nGsgjC2tG48S67XXWMKyEBZKGWfyFcPQDFZQUb
	 yuPlWR72IfjQr5NL+BKVdZ53zRiGZmk37rdUQUO+b9fySZqq5TBRzVtj0g9p5Cg1qN
	 mWereAaKKunxdH0Eg6Ur4swOufQxw23JmvTVN2G8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732908AbfBOCVE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 21:21:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405453AbfBOCPI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 21:15:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 947872229F;
        Fri, 15 Feb 2019 02:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550196907;
        bh=e0Y7LJADeVMuJ+mO1s/4mB5ItRHgoGsPN8tILdPKlmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8bB2czGxvRjQumT6s8W3uKdIGSBCECmSNesYlx01eEqOEVOo9GL0dyok+2KNQGt9
         hSnUxXNDbquGOs3s+ip+O5LyXGPedCje6ZdeuUqkOBtKg22asl3kpX2CuMpG9qen7y
         JM0pbOSZCGyhPsNOqmcZi2BL5nYNRf5boVbpKebg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mathieu Malaterre <malat@debian.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 24/27] mac80211: Add attribute aligned(2) to struct 'action'
Date:   Thu, 14 Feb 2019 21:14:21 -0500
Message-Id: <20190215021424.178979-24-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190215021424.178979-1-sashal@kernel.org>
References: <20190215021424.178979-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mathieu Malaterre <malat@debian.org>

[ Upstream commit 7c53eb5d87bc21464da4268c3c0c47457b6d9c9b ]

During refactor in commit 9e478066eae4 ("mac80211: fix MU-MIMO
follow-MAC mode") a new struct 'action' was declared with packed
attribute as:

  struct {
          struct ieee80211_hdr_3addr hdr;
          u8 category;
          u8 action_code;
  } __packed action;

But since struct 'ieee80211_hdr_3addr' is declared with an aligned
keyword as:

  struct ieee80211_hdr {
  	__le16 frame_control;
  	__le16 duration_id;
  	u8 addr1[ETH_ALEN];
  	u8 addr2[ETH_ALEN];
  	u8 addr3[ETH_ALEN];
  	__le16 seq_ctrl;
  	u8 addr4[ETH_ALEN];
  } __packed __aligned(2);

Solve the ambiguity of placing aligned structure in a packed one by
adding the aligned(2) attribute to struct 'action'.

This removes the following warning (W=1):

  net/mac80211/rx.c:234:2: warning: alignment 1 of 'struct <anonymous>' is less than 2 [-Wpacked-not-aligned]

Cc: Johannes Berg <johannes.berg@intel.com>
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Mathieu Malaterre <malat@debian.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fdbfdb04abe8..10e8b85e017f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -216,7 +216,7 @@ static void ieee80211_handle_mu_mimo_mon(struct ieee80211_sub_if_data *sdata,
 		struct ieee80211_hdr_3addr hdr;
 		u8 category;
 		u8 action_code;
-	} __packed action;
+	} __packed __aligned(2) action;
 
 	if (!sdata)
 		return;
-- 
2.19.1

