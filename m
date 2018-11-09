Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C845C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 10:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F17620827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 10:24:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eqAlwpEW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F17620827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbeKIUEW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 15:04:22 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40497 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbeKIUEV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 15:04:21 -0500
Received: by mail-wm1-f68.google.com with SMTP id b203-v6so1436092wme.5
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 02:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=udkfn3yVvuCceV04j1gaobWyIMbXJgFe43wdapuUuMA=;
        b=eqAlwpEWY1w2BD8bTMx0QQZSowZ62pP7bHJZDLXd+mVmCKT9zzfPeGaVw1yCbbkVvJ
         EL2S+RYDhZAFQb5ed3zEmgsYLV6UYFRIwJBuKlRorHUiBdCttJonetHjMKIyU1KUqhOR
         SJP6yfg84JXuUVlE5S0GeLwsXaQdA3fwq0XSdNoslckIh+tHezTi7sZtM6dGJg7lMC4e
         JFp6iaPjQBri59mZczvIqxjLmTR81NzEq5384dMMopaX5pMRwo1FCOpRDolZkn3y/ooO
         Yb4x9T6oZaIUONslSc3Jk7ya2q9ZHJZXk4WBY6P7XaXB+CPsc8yj1Ts4uc9bUHIgldDn
         VNtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=udkfn3yVvuCceV04j1gaobWyIMbXJgFe43wdapuUuMA=;
        b=lJr5ash2DUR6V59rIUsdt/X/vQ44nkDF/sQlVIJqOmUSlu7KRMWkRvF7nEKtWeReUO
         4475FOrfYcaJ3Fruw7bN+pOdt1umsbf2rAbTtGpskZsyzZP6aP0VM1jvm7J932aZgBmP
         y35aj5y+vahmR0CrJSwXdRBRLPkrE9but3r6BxemcHCcxeYgKKLiDQqRm1Zrr7pRUE+n
         0R4PEEU3CY1WHvgGlB0YodlJfRtYWzOvwD+JNnKHinEgXAxD8GAbIb77cxSP3vTCes2s
         k9WfqYA8RFcS82341tlZUJMDyptk9gIyB6e8OzZayOuyElf038L9vdwXWQJcg3rnkpl+
         5VCw==
X-Gm-Message-State: AGRZ1gJTjDj5/RZI9v0qOXGp9tHY2AFlLytYX4JhAX4JGpP9fs3WFM+1
        uKOuprzKNHg9kCLAOE5QvQ==
X-Google-Smtp-Source: AJdET5e1A+lXnIfwvpL+BJpwY8ObeBbiaLw7dr53IP9ZzS2GnDWJQ9+kp26R1RmxMZVVQNx/NL4yuQ==
X-Received: by 2002:a1c:38c5:: with SMTP id f188-v6mr4064552wma.19.1541759062496;
        Fri, 09 Nov 2018 02:24:22 -0800 (PST)
Received: from localhost (1.red-83-37-105.dynamicip.rima-tde.net. [83.37.105.1])
        by smtp.gmail.com with ESMTPSA id t2-v6sm9562073wrr.12.2018.11.09.02.24.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Nov 2018 02:24:21 -0800 (PST)
From:   Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc:     Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        WIRELESS ML <linux-wireless@vger.kernel.org>,
        REGDB ML <wireless-regdb@lists.infradead.org>
Subject: [PATCH] wireless-regdb: delete outdated comment for DE
Date:   Fri,  9 Nov 2018 11:24:20 +0100
Message-Id: <20181109102420.3539-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

d46d731c made it obsolete.

Cc: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: WIRELESS ML <linux-wireless@vger.kernel.org>
Cc: REGDB ML <wireless-regdb@lists.infradead.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 db.txt | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/db.txt b/db.txt
index 8f356f7..fa5c0e0 100644
--- a/db.txt
+++ b/db.txt
@@ -359,13 +359,6 @@ country CZ: DFS-ETSI
 # Funkanwendungen zur breitbandigen Datenübertragung, WAS/WLAN („Wireless
 # Access Systems including Wireless Local Area Networks“).
 # https://www.bundesnetzagentur.de/SharedDocs/Downloads/DE/Sachgebiete/Telekommunikation/Unternehmen_Institutionen/Frequenzen/Allgemeinzuteilungen/2010_07_WLAN_5GHz_pdf.pdf
-# The values for the 5 GHz have been reduced by a factor of 2 (3db) for non TPC
-# devices (in other words: devices with TPC can use twice the tx power of this
-# table). Note that the docs do not require TPC for 5150--5250; the reduction
-# to 100mW thus is not strictly required -- however the conservative 100mW
-# limit is used here as the non-interference with radar and satellite
-# apps relies on the attenuation by the building walls only in the
-# absence of DFS; the neighbour countries have 100mW limit here as well.
 #
 # The ETSI EN 300 440-1 standard for short range devices in the 5 GHz band has
 # been implemented in Germany:
-- 
2.19.1

