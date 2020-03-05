Return-Path: <SRS0=q56x=4W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CBEC3F2D1
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 14:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59C75206D5
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 14:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgCEOEl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Mar 2020 09:04:41 -0500
Received: from mailext.lri.fr ([129.175.15.10]:48416 "HELO mailext.lri.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
        id S1726222AbgCEOEl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Mar 2020 09:04:41 -0500
Received: from [129.175.15.10] (mailext.lri.fr [129.175.15.10])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailext.lri.fr (Postfix) with ESMTPSA id B782FC0F9E;
        Thu,  5 Mar 2020 14:58:02 +0100 (CET)
From:   Nicolas Cavallari <cavallar@lri.fr>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.com>
Subject: [PATCH v3 2/2] mac80211: Allow deleting stations in ibss mode to reset their state
Date:   Thu,  5 Mar 2020 14:57:54 +0100
Message-Id: <20200305135754.12094-2-cavallar@lri.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200305135754.12094-1-cavallar@lri.fr>
References: <20200305135754.12094-1-cavallar@lri.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

Set the NL80211_EXT_FEATURE_DEL_IBSS_STA if the interface support IBSS
mode, so that stations can be reset from user space.

mac80211 already deletes stations by itself, so mac80211 drivers must
already support this.

This has been successfully tested with ath9k.

Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.=
fr>

---
v3: spelling fixes in commit message.
---
 net/mac80211/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 944e86da5c65..bc7fd67dc987 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1081,6 +1081,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 				      NL80211_EXT_FEATURE_EXT_KEY_ID);
 	}
=20
+	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_ADHOC))
+		wiphy_ext_feature_set(local->hw.wiphy,
+				      NL80211_EXT_FEATURE_DEL_IBSS_STA);
+
 	/*
 	 * Calculate scan IE length -- we need this to alloc
 	 * memory and to subtract from the driver limit. It
--=20
2.25.1

