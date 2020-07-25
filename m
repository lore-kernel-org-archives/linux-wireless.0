Return-Path: <SRS0=EDlr=BE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB8AC433E0
	for <linux-wireless@archiver.kernel.org>; Sat, 25 Jul 2020 20:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0746B206D7
	for <linux-wireless@archiver.kernel.org>; Sat, 25 Jul 2020 20:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgGYUk7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 25 Jul 2020 16:40:59 -0400
Received: from mars.blocktrron.ovh ([51.254.112.43]:33346 "EHLO
        mail.blocktrron.ovh" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbgGYUk6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Jul 2020 16:40:58 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Jul 2020 16:40:58 EDT
Received: from localhost.localdomain (p200300e53f2b5400ad03b3174e097e80.dip0.t-ipconnect.de [IPv6:2003:e5:3f2b:5400:ad03:b317:4e09:7e80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.blocktrron.ovh (Postfix) with ESMTPSA id 3A0FC1F0EA
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2020 22:34:13 +0200 (CEST)
From:   David Bauer <mail@david-bauer.net>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: util: don't warn on missing sband iftype data
Date:   Sat, 25 Jul 2020 22:34:05 +0200
Message-Id: <20200725203405.100415-1-mail@david-bauer.net>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The kernel currently floods the ringbuffer with warnings when adding a
mesh interface for a device not support HE 6GHz modes.

Return without warning in this case, as mesh_add_he_6ghz_cap_ie calls
ieee80211_ie_build_he_6ghz_cap regardless of the supported interface
modes.

Signed-off-by: David Bauer <mail@david-bauer.net>
---
 net/mac80211/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 21c94094a699..dbf389ee15e2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2875,7 +2875,7 @@ void ieee80211_ie_build_he_6ghz_cap(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	iftd = ieee80211_get_sband_iftype_data(sband, iftype);
-	if (WARN_ON(!iftd))
+	if (!iftd)
 		return;
 
 	cap = le16_to_cpu(iftd->he_6ghz_capa.capa);
-- 
2.27.0

