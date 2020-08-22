Return-Path: <SRS0=4i1v=CA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D60C433DF
	for <linux-wireless@archiver.kernel.org>; Sat, 22 Aug 2020 23:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C7762080D
	for <linux-wireless@archiver.kernel.org>; Sat, 22 Aug 2020 23:20:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0O4J3QQ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgHVXUM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 22 Aug 2020 19:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbgHVXUL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Aug 2020 19:20:11 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9A8C061573;
        Sat, 22 Aug 2020 16:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=mUAIXl9ziS9Dy527yDyaaODRWy/HydfseT9udN/NtsU=; b=0O4J3QQ3eCbKVcLFNG1IJgMPOW
        5M9VAM7aqJYYYzrFgKIHE64Ci0md0bcbW4xAIUit9819ir1Cc80MBWaXrJ7GrE0GBM2Ca2KdKnMcd
        7KIKQitEMWasNxI7nadpWhdJBJgf3jSNmP5daayApyisZcLhAshmAlTKdXt9Y5GcLmWBbX3swHcn+
        Fy6NMDtwAFuW2NuzvQ7KaEuD2cpbAfhWr+7mJpgZtje4Z4A2lU132Eq0o8rhJMQrezFEH9NPiM8K/
        0ZAfSDjYNE/7ays+PvNboJ3WMncW+3hgQ3DuDxMMhndvy5GW7R0pM6MQC5YZZnd5lx3kXrZ1gXcQd
        2xHUQ2ZQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9cnw-0006fS-Vr; Sat, 22 Aug 2020 23:20:09 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 5/7] net: wireless: scan.c: delete or fix duplicated words
Date:   Sat, 22 Aug 2020 16:19:51 -0700
Message-Id: <20200822231953.465-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231953.465-1-rdunlap@infradead.org>
References: <20200822231953.465-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Drop repeated word "stored".
Change "is is" to "it is".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
---
 net/wireless/scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200731.orig/net/wireless/scan.c
+++ linux-next-20200731/net/wireless/scan.c
@@ -55,7 +55,7 @@
  *
  * Also note that the hidden_beacon_bss pointer is only relevant
  * if the driver uses something other than the IEs, e.g. private
- * data stored stored in the BSS struct, since the beacon IEs are
+ * data stored in the BSS struct, since the beacon IEs are
  * also linked into the probe response struct.
  */
 
@@ -1488,7 +1488,7 @@ static const struct element
 					 ielen - (mbssid_end - ie));
 
 	/*
-	 * If is is not the last subelement in current MBSSID IE or there isn't
+	 * If it is not the last subelement in current MBSSID IE or there isn't
 	 * a next MBSSID IE - profile is complete.
 	*/
 	if ((sub_elem->data + sub_elem->datalen < mbssid_end - 1) ||
