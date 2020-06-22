Return-Path: <SRS0=2yIc=AD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF864C433E0
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Jun 2020 06:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AF762541D
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Jun 2020 06:38:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="atfQhRd2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgFVGiI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Jun 2020 02:38:08 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:20765 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725933AbgFVGiH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jun 2020 02:38:07 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1592807887; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=RXqtcuMntGVVBMWs+ZGF5Hei6F/RdSRyyKSG5a1N4AI=; b=atfQhRd2qgaWQSMjKOk7nxdgwGa8U1QbrkpXtME5JVtUkoZyRsi0bMNms2I8FX/1gzr/uYCJ
 6Bl2wk1F0Jod8/DTRuHoCoj3BWMYFekXLRkV7kh8NNjhU0/J4WyfjmPNBxQYpw1FzKy/uPUX
 h3O+VzXknz8cu30oPut4ptH2iOk=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n12.prod.us-west-2.postgun.com with SMTP id
 5ef051c7fe1db4db8908396b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 22 Jun 2020 06:37:59
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5E9D0C433C8; Mon, 22 Jun 2020 06:37:59 +0000 (UTC)
Received: from pradeepc-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pradeepc)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 55193C433C6;
        Mon, 22 Jun 2020 06:37:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 55193C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pradeepc@codeaurora.org
From:   Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Subject: [PATCH] cfg80211: fix 6ghz starting frequency
Date:   Sun, 21 Jun 2020 23:37:49 -0700
Message-Id: <1592807869-781-1-git-send-email-pradeepc@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes channel to frequency mappings per latest specification
IEEE P802.11ax/D6.1

Fixes: d1a1646c ("cfg80211: adapt to new channelization of the 6GHz band")
Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---
 net/wireless/util.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 4d3b76f94f55..0eee55476d79 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -117,15 +117,18 @@ int ieee80211_freq_khz_to_channel(u32 freq)
 	/* see 802.11 17.3.8.3.2 and Annex J */
 	if (freq == 2484)
 		return 14;
+	/* see 802.11ax D6.1 27.3.23.2 and Annex E */
+	else if (freq == 5935)
+		return 2;
 	else if (freq < 2484)
 		return (freq - 2407) / 5;
 	else if (freq >= 4910 && freq <= 4980)
 		return (freq - 4000) / 5;
-	else if (freq < 5945)
+	else if (freq < 5950)
 		return (freq - 5000) / 5;
 	else if (freq <= 45000) /* DMG band lower limit */
-		/* see 802.11ax D4.1 27.3.22.2 */
-		return (freq - 5940) / 5;
+		/* see 802.11ax D6.1 27.3.23.2 */
+		return (freq - 5950) / 5;
 	else if (freq >= 58320 && freq <= 70200)
 		return (freq - 56160) / 2160;
 	else
-- 
1.9.1

