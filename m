Return-Path: <SRS0=mT4l=QC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F2CAC282C7
	for <linux-wireless@archiver.kernel.org>; Sat, 26 Jan 2019 16:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EC4A218B0
	for <linux-wireless@archiver.kernel.org>; Sat, 26 Jan 2019 16:30:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YFbsKhMS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfAZQaX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 26 Jan 2019 11:30:23 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56262 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfAZQaX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 26 Jan 2019 11:30:23 -0500
Received: by mail-wm1-f67.google.com with SMTP id y139so9453661wmc.5
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2019 08:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xvs2gPLrwu/PCqM20ZXuY3JK8Wp6jms6vbXlDZ/MVtQ=;
        b=YFbsKhMSREs4Oo49Kr8LoXHi/QBlCyEp5SRc6u4OloSTWcT5WPElL4tfms6sMlA4dt
         e2f7CWFhjr8cn6Wl2/vOqws5rdfoC0aFIAg1K+10M/qexZ2Yih3VDtETUrPHn0o8lEMe
         dRC042K1GHf7xkxHwtONgLqpM+L3DU7i3iLdI20p0qBGevt7bnd90RJdBiuTHsmawbC9
         a9/9rz21FW4YEHJOH5xOLaqABEZm2njIubMKjICnGd4t2AQgZTwEEfxQPdcGM7MWHVRN
         kKFq0zNQE9QTN/N/V3lDr36hgi8Fquho0OUhSZxgj130mGHa34hhYcvSWQR4an2DzxIy
         qoQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xvs2gPLrwu/PCqM20ZXuY3JK8Wp6jms6vbXlDZ/MVtQ=;
        b=HrUsUaX5cgEJZUmFZTZxASQDDxWdNiyznnusiFgvz/ZkGPDCOvch4UfvU+bRaT2okR
         PjeT+9CGnRZCXb0ZfzpkQIT146JZYyTdYh9F1fs9/PMbBWVjtvr3/iwsq0ddQUVVGQAK
         ZI7ry6SBsqRVBpBu0tLIXuSzA69YKFvL+ivWF1sbJ2e32wrJspDVT/75rG/Xe4nhJB88
         Vo5NyJ1EHFMaSlt1jDP7yoAsTupXqIKdAxGUVL28Ekkl3dtIJPAqBT/nMR7wCdZq5hPJ
         LXQ0XJklVHd1BlWzdF3lz8usA/GNb/K3P2/+T62zq0gQBK1k1YQwKk2TLUn3NTb+ZczQ
         dcFg==
X-Gm-Message-State: AJcUukf7ZLcxf8ps78KNKzHXcE6YSd3usst9MmZ/VU/eKXdVcL6kUg7v
        ltIAq7EEH9YV7bJhL37ldOHFjeOj
X-Google-Smtp-Source: ALg8bN5d2eE4w+6O/k6hlO7yxOj0bgNCHzKDQ0JvE+vvnZkTtrD/5TN0gV6zSRZ5OqXhbNUlNQe3nw==
X-Received: by 2002:a1c:7a16:: with SMTP id v22mr10099395wmc.131.1548520220532;
        Sat, 26 Jan 2019 08:30:20 -0800 (PST)
Received: from debian64.daheim (p5B0D7DE3.dip0.t-ipconnect.de. [91.13.125.227])
        by smtp.gmail.com with ESMTPSA id a18sm133757262wrp.13.2019.01.26.08.30.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 26 Jan 2019 08:30:19 -0800 (PST)
Received: from chuck by debian64.daheim with local (Exim 4.92-RC4)
        (envelope-from <chunkeey@gmail.com>)
        id 1gnQqZ-0002lW-A4; Sat, 26 Jan 2019 17:30:19 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Oever Gonzalez <notengobattery@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH] ath: regd: add extra US coutry codes
Date:   Sat, 26 Jan 2019 17:30:19 +0100
Message-Id: <20190126163019.10590-1-chunkeey@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Oever Gonzalez <notengobattery@gmail.com>

This patch adds several country codes to the regd.h and regd_common.h
files in order to support devices like the Linksys EA6350v3, whose
country codes are not present in the original list. Without this patch,
all devices whose manufacturer programmed any of these code in their
EEPROM will not work.

The values for CTRY_UNITED_STATES2 and CTRY_UNITED_STATES3 were taken
from a post by Sven Eckelmann <sven.eckelmann@openmesh.com>:
<http://lists.infradead.org/pipermail/ath10k/2017-August/010014.html>

Signed-off-by: Oever Gonzalez <notengobattery@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/net/wireless/ath/regd.h        | 2 ++
 drivers/net/wireless/ath/regd_common.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
index d73e45e26547..75ddaefdd049 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -185,7 +185,9 @@ enum CountryCode {
 	CTRY_UKRAINE = 804,
 	CTRY_UNITED_KINGDOM = 826,
 	CTRY_UNITED_STATES = 840,
+	CTRY_UNITED_STATES2 = 841,
 	CTRY_UNITED_STATES_FCC49 = 842,
+	CTRY_UNITED_STATES3 = 843,
 	CTRY_URUGUAY = 858,
 	CTRY_UZBEKISTAN = 860,
 	CTRY_VENEZUELA = 862,
diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 4021e37a225a..c4bd26e65949 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -483,6 +483,8 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_UAE, NULL1_WORLD, "AE"},
 	{CTRY_UNITED_KINGDOM, ETSI1_WORLD, "GB"},
 	{CTRY_UNITED_STATES, FCC3_FCCA, "US"},
+	{CTRY_UNITED_STATES2, FCC3_FCCA, "US"},
+	{CTRY_UNITED_STATES3, FCC3_FCCA, "US"},
 	/* This "PS" is for US public safety actually... to support this we
 	 * would need to assign new special alpha2 to CRDA db as with the world
 	 * regdomain and use another alpha2 */
-- 
2.20.1

