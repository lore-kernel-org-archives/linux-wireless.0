Return-Path: <SRS0=80ln=XE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30353C4360D
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Sep 2019 02:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 045AF20863
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Sep 2019 02:00:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ONbMYcVe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732647AbfIICAD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 8 Sep 2019 22:00:03 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:40812 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732416AbfIICAC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Sep 2019 22:00:02 -0400
Received: by mail-oi1-f193.google.com with SMTP id b80so9249356oii.7
        for <linux-wireless@vger.kernel.org>; Sun, 08 Sep 2019 19:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JfJceDjBRXhhRN3a47LasO6WN7hQmKEe9vrZuAEi+iU=;
        b=ONbMYcVegrgr/+KzKIs5D+4EXHaNn3ee5HMVKJgvIxzsdTuIYaZjC80V1MlCzHvn0T
         l60DDBHz3gWgs8DNod9KJIr1/r+uCJOXRNgcb1X+Z3RaLFlzewKYVVsAjsfP9Fx6Zcin
         HAph5nlNshY4/e+0ZhyNf/uuV519lGHu4Sm1hWItbmb2WtIUoi59iGK3amO/bNXu0fg2
         FwCHEBrr4gzLHZRIjXBC4svl1hcEhwLZI1pQGeL5mq29wqIZ8Y5w652J7m492+rB3hRt
         MkW1Pj6L3LzXK4QBGNJ/nohhyzMy55pEm8caIMI7LxIAbi4RjmH+XRUioeCu/SCq1pgn
         fNZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=JfJceDjBRXhhRN3a47LasO6WN7hQmKEe9vrZuAEi+iU=;
        b=B+yURsTEAub3wzfEmmZei6P3gJCwyxcd0OyuoF87ZFzJZdvN7gb30eStpYuLSHaLX9
         p/oNuA66O6EoElqZ36bywsCRl1EHG5g7Eipzwpwb/aLVo9Vgk/jpejg2tYxvNMf1bIrX
         5nagWFNqPi2LhKWQ0ULNwZQgLkaOZ9I3vD1kjRCzsRtQI7yQnzNY/3APRJ0UPLCw3r/1
         Euh4D7KRXMaFarlNMGVstW9Xj8WmtePMiU9OOTyjLVGDzeu5Zfj6VCz1/8eWEflu7YpE
         Qqt1xe/cfBNEZtZ97t+AcLw6cSI/qJ3OSCFn5xnBP8C1xUD+3+ayFtoTa+PkTpAbhrL0
         X1Qw==
X-Gm-Message-State: APjAAAWXzyoRnhYM1T6RvVLTEug5etLD4V+rl6mf/kqoVftn4DyN9aQF
        8rTSUKgt40h/rN9xIpReUW8=
X-Google-Smtp-Source: APXvYqxQIRabWPoYjzbkG0LtdjFEJ4cqO0nM7KgbmxiZXVQV9/9SoDoh3ZaMJHRiORxt0a6Ojkbj3w==
X-Received: by 2002:aca:c641:: with SMTP id w62mr15582225oif.24.1567994401866;
        Sun, 08 Sep 2019 19:00:01 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id k10sm1468420oij.16.2019.09.08.19.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Sep 2019 19:00:01 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v2 0/9] rtlwifi: Remove special macros used to manipulate RX and TX descriptors
Date:   Sun,  8 Sep 2019 20:59:49 -0500
Message-Id: <20190909015958.29834-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

These patches continue the set of changes that remove the special macros
to read or write the RX and TX descriptors. The bit manipulations in the
__le32 words use GENMASK() and BIT() operations.

The final patch removes unused macros for C2H operations.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

---
V2 - Add a missing inline direective in rtl8723be/trx.h

Larry Finger (9):
  rtlwifi: rtl8723ae: Remove unused GET_XXX and SET_XXX macros
  rtlwifi: rtl8723ae: Replace local bit manipulation macros
  rtlwifi: rtl8723ae: Convert macros that set descriptor
  rtlwifi: rtl8723ae: Convert inline routines to little-endian words
  rtlwifi: rtl8723be: Remove unused SET_XXX and GET_XXX macros
  rtlwifi: rtl8723be: Replace local bit manipulation macros
  rtlwifi: rtl8723be: Convert macros that set descriptor
  rtlwifi: rtl8723be: Convert inline routines to little-endian words
  rtlwifi: rtl8188ee: rtl8192ce: rtl8192de: rtl8723ae: rtl8821ae: Remove
    some unused bit manipulation macros

 drivers/net/wireless/realtek/rtlwifi/base.h   |  27 -
 .../wireless/realtek/rtlwifi/rtl8188ee/def.h  |  29 -
 .../wireless/realtek/rtlwifi/rtl8192ce/def.h  |  33 -
 .../wireless/realtek/rtlwifi/rtl8192de/def.h  |  31 -
 .../wireless/realtek/rtlwifi/rtl8723ae/def.h  |  31 -
 .../wireless/realtek/rtlwifi/rtl8723ae/trx.c  | 212 ++---
 .../wireless/realtek/rtlwifi/rtl8723ae/trx.h  | 794 +++++++-----------
 .../wireless/realtek/rtlwifi/rtl8723be/trx.c  | 236 +++---
 .../wireless/realtek/rtlwifi/rtl8723be/trx.h  | 718 ++++++++--------
 .../wireless/realtek/rtlwifi/rtl8821ae/def.h  |  31 -
 10 files changed, 922 insertions(+), 1220 deletions(-)

-- 
2.23.0

