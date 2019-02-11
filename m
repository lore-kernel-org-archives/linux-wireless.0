Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F67EC169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71AD6222A7
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:12:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EVxLyZ/i";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F4iG+mMN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403918AbfBKPJ7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 10:09:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43086 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391736AbfBKPJz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 10:09:55 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E25D061981; Mon, 11 Feb 2019 15:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549897795;
        bh=1c38RoAYFWuQaP3caHB3h5toGYUf1hiPzrjOP3sdvcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVxLyZ/i3mPH/B1ed8MJJ5/ad29qB+blHZEWT/mD7CnH8jwJglYmqrSwBfoR47l1r
         gH2dhIozRBcsnlSTTgeF5p7Jb8Q6jDJ677K6X4qVMk2/CsNEMFbc8sfW/JEbSto9SU
         C3XmkS4IPTPwLZF/AZUXXWeVKHEx1MJIgl+XmUMQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 54CC86191A;
        Mon, 11 Feb 2019 15:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549897794;
        bh=1c38RoAYFWuQaP3caHB3h5toGYUf1hiPzrjOP3sdvcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4iG+mMNW/0EXpi+VqwEezJgwJD5JGEA6KLDCQ51Gol65peojpuEgoQcCjZL0tsXS
         QmSrCRJ/riteYNo+ekNx1s1yw/9SUWJJKJgGsvul5D9i2InzqH+nPGCIJ7BURh3Mj3
         U35NWFMuWph2IOnd9WrysbwXLo7D1vagmGgxL1iQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 54CC86191A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH 2/6] ath10k: make wmi_service_name() warn about missing service ids
Date:   Mon, 11 Feb 2019 17:09:43 +0200
Message-Id: <1549897787-28537-2-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1549897787-28537-1-git-send-email-kvalo@codeaurora.org>
References: <1549897787-28537-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When adding a new value to enum wmi_service it's very easy to miss that the new
value should be also added to wmi_service_name() mapping function. Modify the
function so that GCC can now warn about this:

drivers/net/wireless/ath/ath10k/wmi.h:385:2: warning: enumeration value 'WMI_SERVICE_FOO' not handled in switch [-Wswitch]

And also add a reminder to the enum.

Thanks to Jouni Malinen for the idea.

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 529f5a26f3f3..74ce1a4c0e8f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -212,6 +212,8 @@ enum wmi_service {
 	WMI_SERVICE_PER_PACKET_SW_ENCRYPT,
 	WMI_SERVICE_REPORT_AIRTIME,
 
+	/* Remember to add the new value to wmi_service_name()! */
+
 	/* keep last */
 	WMI_SERVICE_MAX,
 };
@@ -378,7 +380,7 @@ enum wmi_10_4_service {
 	WMI_10_4_SERVICE_REPORT_AIRTIME,
 };
 
-static inline char *wmi_service_name(int service_id)
+static inline char *wmi_service_name(enum wmi_service service_id)
 {
 #define SVCSTR(x) case x: return #x
 
@@ -501,11 +503,13 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_PER_PACKET_SW_ENCRYPT);
 	SVCSTR(WMI_SERVICE_REPORT_AIRTIME);
 
-	default:
+	case WMI_SERVICE_MAX:
 		return NULL;
 	}
 
 #undef SVCSTR
+
+	return NULL;
 }
 
 #define WMI_SERVICE_IS_ENABLED(wmi_svc_bmap, svc_id, len) \
-- 
2.7.4

