Return-Path: <SRS0=pdv6=UY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3483FC48BD4
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 11:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 007D220656
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 11:20:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="jiu51N28"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730667AbfFYLUj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Jun 2019 07:20:39 -0400
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:48878 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727138AbfFYLUf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jun 2019 07:20:35 -0400
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.224.233])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 07D4130C02C;
        Tue, 25 Jun 2019 04:10:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com 07D4130C02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1561461032;
        bh=bGicLqcp1/dHgg4bDICFA/Z0PBvU7+StOn1XcGfHNdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jiu51N28f/4qtTzmoQZZjObl4ihHeN3rH8Ek6acOKfVWV34aZ8yH2uSTWpKA8FGbv
         CBJet+EU9QW5JhhDlWJkQHKmV35eN8WmXQRdLYAJrnIGAci2LEwzNXWjFs3seKnzl1
         paSrjRopfSacCZ7eSe1/WI4nJgGDlgRBFFbIUFQQ=
Received: from bld-bun-01.bun.broadcom.com (bld-bun-01.bun.broadcom.com [10.176.128.83])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id 571F260D83;
        Tue, 25 Jun 2019 04:10:32 -0700 (PDT)
Received: by bld-bun-01.bun.broadcom.com (Postfix, from userid 25152)
        id CEB87B02DEB; Tue, 25 Jun 2019 13:10:29 +0200 (CEST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC V2 2/8] cfg80211: add 6GHz UNII band definitions
Date:   Tue, 25 Jun 2019 13:10:21 +0200
Message-Id: <1561461027-10793-3-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1561461027-10793-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1561461027-10793-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

For the new 6GHz there are new UNII band definitions as listed
in the FCC notice [1].

[1] https://docs.fcc.gov/public/attachments/FCC-18-147A1_Rcd.pdf

Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Leon Zegers <leon.zegers@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/wireless/reg.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4831ad74..646107a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3806,8 +3806,9 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 }
 
 /*
- * See http://www.fcc.gov/document/5-ghz-unlicensed-spectrum-unii, for
- * UNII band definitions
+ * See FCC notices for UNII band definitions
+ *  5GHz: https://www.fcc.gov/document/5-ghz-unlicensed-spectrum-unii
+ *  6GHz: https://www.fcc.gov/document/fcc-proposes-more-spectrum-unlicensed-use-0
  */
 int cfg80211_get_unii(int freq)
 {
@@ -3831,6 +3832,22 @@ int cfg80211_get_unii(int freq)
 	if (freq > 5725 && freq <= 5825)
 		return 4;
 
+	/* UNII-5 */
+	if (freq > 5925 && freq <= 6425)
+		return 5;
+
+	/* UNII-6 */
+	if (freq > 6425 && freq <= 6525)
+		return 6;
+
+	/* UNII-7 */
+	if (freq > 6525 && freq <= 6875)
+		return 7;
+
+	/* UNII-8 */
+	if (freq > 6875 && freq <= 7125)
+		return 8;
+
 	return -EINVAL;
 }
 
-- 
1.9.1

