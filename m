Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF3FC43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 21:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9F7B206DD
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 21:59:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l+F9NWI8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfCDV7r (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 16:59:47 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35275 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfCDV7r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 16:59:47 -0500
Received: by mail-ot1-f68.google.com with SMTP id z19so5624402otm.2
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2019 13:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g8gWUCjj3dTVmremvd9LrRPXxxoTmyeREfFq05iZY9I=;
        b=l+F9NWI8KW5N6MRBgz2Sv67mQqeGrQLd6gkLUJGRHcjR6djkWVmmCk9dDr9zCv0FiX
         xCDT2bQA18ffO59GTMbc3bVpUy+D12wwBvBnvdCfoHySKLjGTR5i5WZa66BVl9RCVVDn
         x4Gt21jqWEV5/h3T0pOtKVtZZ59NeVDYAl+9IA+v9icn1ihlL+aufIAhhvYvq4H3Hrzf
         xYh50RUqyMxmiC7F/uCico9SO+7/dXKboOMv5/mI8l7RMctzHGUhCB/FQgTD7PE11BtH
         hEO38VmrfiVlvrQFZzkQhIdVYJrEGhWx333NGRApupjQZ25veyY8k+56WxPoah+TeUbu
         8yNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=g8gWUCjj3dTVmremvd9LrRPXxxoTmyeREfFq05iZY9I=;
        b=G9+pq6gS9FSp4boUATiX8giC/aAQrjcP8qpw+cOpgzU7h8kQ1qSXKrI2NVNhE8xNLf
         lK6QqO+hDbntdqGRf6dGVAEzttrte6AhWv2rDWlBMiSu8F+1wpTYNUOLb1ParI45EKZj
         YytvZAF+CYzSlCTcyxyMECPgA7g97kLukiHIiGtFFwxocCoSUD4MSq+r6J1p3vdY4sOQ
         ojnHEwrNCbYrk+opVlKIWmV4+QCbhgvmusSFVIA/Q851H1LYGwwtoZf3ht4e05462T85
         ZuZ9mbH7ogl9RU6lCwhPE/Bvrmf5fNpvKMyuCMAOo0eyd7psBeqjLim6rJtT81DT6Wj6
         XFKw==
X-Gm-Message-State: APjAAAVaS3WU69Ol8WHuDGGjeIfCgVfkgepBj7cER1vQp0kheYYf4Li7
        XdezoiQ5on7HVooGyNFo4Vc=
X-Google-Smtp-Source: APXvYqziqcz5bsfwroAFZ+F4EMhGlH07HGYoatwpi3/9R2oxKxecn1opSNLa1SBXPn+5x0CaEO3Sbw==
X-Received: by 2002:a9d:6496:: with SMTP id g22mr13433867otl.47.1551736786604;
        Mon, 04 Mar 2019 13:59:46 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id e125sm2923744oia.18.2019.03.04.13.59.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Mar 2019 13:59:44 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/2]  Modify the handling of the reason for a wakeup
Date:   Mon,  4 Mar 2019 15:59:38 -0600
Message-Id: <20190304215940.2608-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Some of the drivers test the wrong bit in an RX descriptor. That is
fixed. In a second patch, that variable is moved out of a struct and
made local to the routine that uses it.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
Larry Finger (2):
  rtlwifi: Fix duplicate tests of one of the RX descriptors
  rtlwifi: Convert the wake_match variable to local

 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c | 15 ++++++++-------
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c | 15 ++++++++-------
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c | 16 ++++++++--------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c | 14 +++++++-------
 drivers/net/wireless/realtek/rtlwifi/wifi.h      |  1 -
 5 files changed, 31 insertions(+), 30 deletions(-)

-- 
2.21.0

