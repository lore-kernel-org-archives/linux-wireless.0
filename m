Return-Path: <SRS0=Ysg0=ZR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D552EC432C0
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Nov 2019 18:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFC5E2082F
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Nov 2019 18:32:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jpIP5Ns0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbfKYSce (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Nov 2019 13:32:34 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:33778 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbfKYScd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Nov 2019 13:32:33 -0500
Received: by mail-oi1-f193.google.com with SMTP id x21so6958961oic.0
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2019 10:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MocHzPBywBb1DdSbu9zFMre4HBSb8SEFOWoUrMzDlb4=;
        b=jpIP5Ns0zT11w1Ef7GvcQD/dQTuG4rEcC5n4pJrvIpxy8Jmycy6bJNMgTXNDa8tw6E
         V26IBhrB8r0VaWNYUhjwgWVljhn9TGwxdCwPAgHyihgah8A/VhyCFFq8xpHJ3UPNGz/2
         Vx0dmivpUbM3bQR7ZNCgGPe3BVnt0+uixwrxzbA7/xFKNkT8uwLZ+TAZLPqNcI+bWY96
         6t6oo8UE9lvMc6nSANM6h0w3Pyz19wkeR2zzLCwUWVFOlfLFbiPfKZOa5Qs/uisU48kt
         qkSHcKnPR2ltL4wGRQDm6nbCgjRA5EduGluIEqkEPyR+TMjmL7nGTe1A9UHqkQMahenB
         l9dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=MocHzPBywBb1DdSbu9zFMre4HBSb8SEFOWoUrMzDlb4=;
        b=oXnm2DB5SoYpLGlDQGgGNd29fJABTf+H/eFo5PcdmG+QuDzMMTy11vu4VualYun6cb
         0o7/sMVp6bwVknOUmwY0bu54+vpo/iLv/BhwdWXRUrpA/DiU8VTacb1eaQYmJYID1FOa
         eSoYy1JudKDPfX7aSmYQSVSGme6fdhy0+1TZv/RqdgYeA2IFNQ2BI4mzv+a9kYh6PzWb
         u4fGe/rFC3aOB6la2dwKnwd42mXOCYvIIeoGQcYKH4XjggpnALgyu8GrXchsNCF/y1MG
         Sred03dVjbNaipkBiRS0W845tvSOS3Et4YQGlTtmszh6YGzaaRkJlIoxh6uSvdpqvDwB
         um7A==
X-Gm-Message-State: APjAAAU6wnguOONJgG2Hms2taNxExo+yNlVbqqhOHM2/X4q2oMY7EvNu
        Vw6xd4rt2IAGtI1LWZRk9HmIp+j+
X-Google-Smtp-Source: APXvYqxxjYClKh4q5tuvnG2BrJG8IoUSJ097IYlTWIzPBKtGPmoEKk89hVnhr3d/03Nb+FiCJ+nbiA==
X-Received: by 2002:aca:3c86:: with SMTP id j128mr170383oia.153.1574706752709;
        Mon, 25 Nov 2019 10:32:32 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id w10sm2831824oif.9.2019.11.25.10.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 10:32:32 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v2 0/4] rtlwifi: rtl8192de:  Replace local TX and RX bit manipulation macro
Date:   Mon, 25 Nov 2019 12:32:25 -0600
Message-Id: <20191125183229.19063-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

These patches are part of a series intended to replace the bit-manipulation
macros used to set and read the various descriptors with a set of inline
routines.

v2 - Fixed some endian issues reported by tthe kbuild test robot.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
Kalle,

There is no particular urgency for these patches as they are part of
a general cleanup.

Larry
---

Larry Finger (4):
  rtlwifi: rtl8192de: Remove unused GET_XXX and SET_XXX macros
  rtlwifi: rtl8192de: Replace local bit manipulation macros
  rtlwifi: rtl8192de: Convert macros that set descriptor
  rtlwifi: rtl8192de: Convert inline routines to little-endian words

 .../wireless/realtek/rtlwifi/rtl8192de/trx.c  | 252 +++---
 .../wireless/realtek/rtlwifi/rtl8192de/trx.h  | 853 +++++++-----------
 2 files changed, 479 insertions(+), 626 deletions(-)

-- 
2.24.0

