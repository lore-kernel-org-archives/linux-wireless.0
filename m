Return-Path: <SRS0=u4Rx=5I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 337B8C4332B
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Mar 2020 12:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D55720788
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Mar 2020 12:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgCWMKf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Mar 2020 08:10:35 -0400
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:37701 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbgCWMKf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Mar 2020 08:10:35 -0400
Received: from isengard.fritz.box (unknown [87.147.56.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id 1FE3B58006E;
        Mon, 23 Mar 2020 13:10:33 +0100 (CET)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH 2/2] iw: update extended features in info
Date:   Mon, 23 Mar 2020 13:09:59 +0100
Message-Id: <20200323120959.12019-2-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200323120959.12019-1-markus.theil@tu-ilmenau.de>
References: <20200323120959.12019-1-markus.theil@tu-ilmenau.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
---
 info.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/info.c b/info.c
index 97240f6..45e0106 100644
--- a/info.c
+++ b/info.c
@@ -702,6 +702,10 @@ broken_combination:
 		ext_feat_print(tb, STA_TX_PWR, "TX power control per station");
 		ext_feat_print(tb, SAE_OFFLOAD, "SAE offload support");
 		ext_feat_print(tb, VLAN_OFFLOAD, "VLAN offload support");
+		ext_feat_print(tb, BEACON_PROTECTION, "beacon protection support");
+		ext_feat_print(tb, CONTROL_PORT_NO_PREAUTH, "disable pre-auth over nl80211 control port support");
+		ext_feat_print(tb, PROTECTED_TWT, "protected Target Wake Time (TWT) support");
+		ext_feat_print(tb, DEL_IBSS_STA, "deletion of IBSS station support");
 	}
 
 	if (tb_msg[NL80211_ATTR_COALESCE_RULE]) {
-- 
2.25.2

