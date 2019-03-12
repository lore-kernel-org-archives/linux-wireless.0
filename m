Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBC6C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 19:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13EDE2077B
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 19:11:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TvqGoQa/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfCLTLu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 15:11:50 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51269 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfCLTLu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 15:11:50 -0400
Received: by mail-wm1-f68.google.com with SMTP id n19so3886518wmi.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 12:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eDIy0OHJPq6nK8lhKwVaH87O15Tngm+PtCIIJh57i6Q=;
        b=TvqGoQa/a1imsjnrj9C/SK7IMkQkupj1nmNJGwWogWN/4NGkdYp8H15FpSZGefhukF
         k/AO645gyCZqg6hjV1tqNAQBS94hNR8GUAhRX8kWWHKtoAF+tvQuhM8iQpXtRv41qvVF
         gzK6D/qsNUrD6OJSWQuVHCjkr9qDpuKLSEWZeVf8caP10dnrLrFa3s/0HwAfryIll/M1
         jk2LKxDmeZ+IhRLbZYqSZZkoYGjZrrWhP5+Cj9RAzPSwOwJ3o7QNOuJ8Xu1hp4Y8GS/a
         V+XhD+CYyub7n2Qq9b7jO86AuOaB8AToBN4bqMEGemq/2fLkMKjemvLH5u+1JVpupTdR
         rn1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eDIy0OHJPq6nK8lhKwVaH87O15Tngm+PtCIIJh57i6Q=;
        b=n8LlVztRdOaTbJ5WSS597XRyRoNaDNR+D7GE0NX0WhTbNeu+SRUNftXZPRndu/RTFv
         TWqYQ4tkstjCZgmWBYqsV/IT2aY+w801EBFANJ6DgwWIv/DNgo8hV/9tk1h9QgirJIsO
         HH49Mw1B+a/m5vcmQIQ67VG+sAsKYDYCWWis6DOw75qcnAkAN2eEuKGTfVCOUwBkvRqd
         KzZjlP/rIZB7KQ1EfODUW9yAwvPLPeS7WHwCdy/4hBLGDHBmzDetO/G5rHNIOEBeaMDp
         LG1dkDoZL1k4SjQUXpXbhO/tdAzV4Tl33eB4dRZeoPz3V/QZZJnREwt4slqW/5/RwSU2
         AefA==
X-Gm-Message-State: APjAAAXCHMDoE41xIRd5UvAogrC5HV4OUHBUgm3aKTOcLtAwoZXOP1fx
        oTPaVRWEDsEA2wdy3p+kADTh2rYU
X-Google-Smtp-Source: APXvYqz1IS5MwNCFfPvNDKuu6+RORhBuRJNzKoBS3wIxaayA5IwBvOc+pgi0lN0LCvTjEaJopV3stQ==
X-Received: by 2002:a7b:c3d7:: with SMTP id t23mr3389424wmj.49.1552417907701;
        Tue, 12 Mar 2019 12:11:47 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id y140sm8469525wmd.18.2019.03.12.12.11.46
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 12 Mar 2019 12:11:47 -0700 (PDT)
From:   =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, sgruszka@redhat.com, daniel@makrotopia.org,
        =?UTF-8?q?Tomislav=20Po=B8ega?= <pozega.tomislav@gmail.com>
Subject: [PATCH 2/2] rt2x00: enable experimental MFP with HW crypt
Date:   Tue, 12 Mar 2019 20:11:42 +0100
Message-Id: <1552417902-11040-2-git-send-email-pozega.tomislav@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1552417902-11040-1-git-send-email-pozega.tomislav@gmail.com>
References: <1552417902-11040-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

MFP can work with enabled HW crypt engine, but in this case
available bandwidth is reduced at least when connecting to
Archer C7 (QCA9558). Enable the feature for known to work chipsets-
MT7620, RT3070 and RT5390. Userspace setting for ieee80211w should
default to 0 in order to prevent unintentional bandwidth drop.

Signed-off-by: Tomislav Po¸ega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index a03b528..bb8204d 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -9326,6 +9326,13 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
 	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
 
+	/* Experimental: Set MFP with HW crypto enabled. */
+	if (rt2x00_rt(rt2x00dev, RT3070) || rt2x00_rt(rt2x00dev, RT5390) ||
+	    rt2x00_rt(rt2x00dev, RT6352))
+		ieee80211_hw_set(rt2x00dev->hw, MFP_CAPABLE);
+	else /* Set MFP if HW crypto is disabled. */
+		if (rt2800_hwcrypt_disabled(rt2x00dev))
+			ieee80211_hw_set(rt2x00dev->hw, MFP_CAPABLE);
 	/*
 	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
 	 * unless we are capable of sending the buffered frames out after the
@@ -9336,10 +9343,6 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	if (!rt2x00_is_usb(rt2x00dev))
 		ieee80211_hw_set(rt2x00dev->hw, HOST_BROADCAST_PS_BUFFERING);
 
-	/* Set MFP if HW crypto is disabled. */
-	if (rt2800_hwcrypt_disabled(rt2x00dev))
-		ieee80211_hw_set(rt2x00dev->hw, MFP_CAPABLE);
-
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
 				rt2800_eeprom_addr(rt2x00dev,
-- 
1.7.0.4

