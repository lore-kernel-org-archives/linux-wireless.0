Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB521C10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 18:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FF7D208E4
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 18:52:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="Nn9AGseI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfDXSwg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 14:52:36 -0400
Received: from 9.mo69.mail-out.ovh.net ([46.105.56.78]:50863 "EHLO
        9.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbfDXSwg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 14:52:36 -0400
Received: from player690.ha.ovh.net (unknown [10.108.54.108])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id 14F174D6B6
        for <linux-wireless@vger.kernel.org>; Wed, 24 Apr 2019 19:33:13 +0200 (CEST)
Received: from awhome.eu (p57B7E5B2.dip0.t-ipconnect.de [87.183.229.178])
        (Authenticated sender: postmaster@awhome.eu)
        by player690.ha.ovh.net (Postfix) with ESMTPSA id 374BE4F97E44;
        Wed, 24 Apr 2019 17:33:11 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1556127189;
        bh=Op+NAN7RNhR0+hiHfAXPQU6rEBT1VZqrlfttXPA8nhQ=;
        h=From:To:Cc:Subject:Date;
        b=Nn9AGseIe+RytHeyXgl16U98Andolq+jzaHT95kGoWAKy7mV1CKMUizR6McTDvtde
         EFkdOuGxIINp28009kgD3jmjeanXIIHvawny1hgCn4exDAd13ljIzsqdqgACaH9qVK
         hk8oXI0hXiZw+OxAIIfZxqbh53CI8ITE+82QspeM=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH] mac80211: Set CAN_REPLACE_PTK0 for SW crypto only drivers
Date:   Wed, 24 Apr 2019 19:32:46 +0200
Message-Id: <20190424173246.26421-1-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 11373840862340783303
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrhedvgddutdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Mac80211 SW crypto handles replacing PTK keys correctly.

Don't trigger needless warnings or workarounds when the driver can only
use the known good SW crypto provided by mac80211.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 net/mac80211/main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e56650a9838e..2b608044ae23 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1060,6 +1060,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		wiphy_ext_feature_set(local->hw.wiphy,
 				      NL80211_EXT_FEATURE_EXT_KEY_ID);
 
+	/* Mac80211 and therefore all cards only using SW crypto are able to
+	 * handle PTK rekeys correctly
+	 */
+	if (!local->ops->set_key)
+		wiphy_ext_feature_set(local->hw.wiphy,
+				      NL80211_EXT_FEATURE_CAN_REPLACE_PTK0);
+
 	/*
 	 * Calculate scan IE length -- we need this to alloc
 	 * memory and to subtract from the driver limit. It
-- 
2.21.0

