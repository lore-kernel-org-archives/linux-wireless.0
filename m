Return-Path: <SRS0=Ysg0=ZR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E44C432C0
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Nov 2019 22:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD51920740
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Nov 2019 22:09:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SO6D38NK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbfKYWJj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Nov 2019 17:09:39 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37445 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfKYWJj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Nov 2019 17:09:39 -0500
Received: by mail-oi1-f195.google.com with SMTP id 128so6627715oih.4
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2019 14:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kE3mYmHbJtGEAPl75d2IQGRrIUOPf9tww3/e+JAxXVA=;
        b=SO6D38NKqiaWDkGxwyt6xOPIqdxYYXpTrs2fEXclJdHmjyjFnLoFiyYMjxx3TS0/ol
         oU8CRpipC+iNgPxPV5v7nmhGbdwav0TCMhlPspVhIcyjKAQX5h5DcZ7hLYBO1bpRQZVz
         kcI5QLl0MxjCmxnIgex9G9YUAxDIHuGYjlw09awPdJNlJix77J2xZuiZNvjdVA/f+cu5
         GXuZSRvRF+kCkpFBkywacZ0F3GEx+EqleQDBCEctw0siRU8NL0bYZPJgUOBfiaGJeWxv
         Ii7lUfG5BPzWiArXWH+SjW3I5bPwdaSoGBbCBsxPy71dFqhUdg90kgdGeRgiJ8cxYB+7
         4nsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=kE3mYmHbJtGEAPl75d2IQGRrIUOPf9tww3/e+JAxXVA=;
        b=EwoeJc60u3riqK5cK42Wwr1CE0BDYzN10l9+4brwkVmv8FrZ9QPTNT/NAJcqH2wpj0
         xIZ01kkTCD1wcA36luDi4SklSYOBu698ninz6ZLF8NdXC0JXTDorTazYU8vn/6hqNxRd
         hEhGRYgyyT29wmhxMpJ6bUbgeQwIrgkueb+kTocfe+VMUt6DE0M3t8mHEguBCUa8cvFt
         /Qgn+oYYPSfCg97ZLz5yaFFNoImpoxs9hmCAy/4cY8jZrILBHGEa98Qn2EGN134f9CBa
         zPLpIdQZDzl5E+qXdbU5coLVH9eewe6lRS62SR4E6XWg1H74WPDSSMa9hHXDCA2IBIiK
         3jww==
X-Gm-Message-State: APjAAAXy0xEkCrJt9LoJ4sNUJnzHdd4mIwGhnJJgAq4NqDx+dDZwNi8u
        hHRArpCMnl+4TOLu4RKOIQ+mjhOG
X-Google-Smtp-Source: APXvYqyWc8/2GstSr8WXoE9gyhNFS4houRx36oRmPiJHSkROxBgUNFORxuHKu/+ghUy7iGpLwptyLA==
X-Received: by 2002:aca:fdc3:: with SMTP id b186mr968604oii.92.1574719778086;
        Mon, 25 Nov 2019 14:09:38 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id 94sm2882537otx.3.2019.11.25.14.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 14:09:37 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v2 0/9] rtlwifi: Complete removal of local bit manipulation macros
Date:   Mon, 25 Nov 2019 16:09:25 -0600
Message-Id: <20191125220934.32693-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

These patches finish the removal of the local the bit-manipulation
macros used to set and read various quantities.

v2 - fix some endian issues.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
Kalle,

There is no particular urgency for these patches as they are part of
a general cleanup.

Larry
---

Larry Finger (9):
  rtlwifi: rtl8192de: Remove usage of private bit manipulation macros
  rtlwifi: rtl8188ee: Remove usage of private bit manipulation
  rtlwifi: rtl8192ce: rtl8192c_com: Remove usage of private bit
    manipulation macros
  rtlwifi: Remove dependence on special bit manipulation macros for
    common driver
  rtlwifi: rtl88821ae: Remove usage of private bit manipulation macros
  rtlwifi: rtl8192ee: Remove usage of private bit manipulation macros
  rtlwifi: rtl8723ae: Remove usage of private bit manipulation macros
  rtlwifi: rtl8723be: Remove usage of private bit manipulation macros
  rtlwifi: Remove last definitions of local bit manipulation macros

 drivers/net/wireless/realtek/rtlwifi/base.h   |   4 +-
 drivers/net/wireless/realtek/rtlwifi/ps.c     |  20 +--
 .../wireless/realtek/rtlwifi/rtl8188ee/fw.c   |  12 +-
 .../wireless/realtek/rtlwifi/rtl8188ee/fw.h   | 103 ++++++----------
 .../wireless/realtek/rtlwifi/rtl8188ee/hw.c   |  11 +-
 .../realtek/rtlwifi/rtl8192c/dm_common.c      |  19 ++-
 .../realtek/rtlwifi/rtl8192c/fw_common.h      |  14 +--
 .../wireless/realtek/rtlwifi/rtl8192ce/hw.c   |  11 +-
 .../wireless/realtek/rtlwifi/rtl8192de/fw.h   |  61 ++--------
 .../wireless/realtek/rtlwifi/rtl8192ee/fw.h   |  36 +++---
 .../wireless/realtek/rtlwifi/rtl8723ae/fw.h   |  14 +--
 .../wireless/realtek/rtlwifi/rtl8723be/fw.h   |  30 +++--
 .../wireless/realtek/rtlwifi/rtl8821ae/fw.h   | 102 +++++++---------
 drivers/net/wireless/realtek/rtlwifi/wifi.h   | 115 ------------------
 14 files changed, 173 insertions(+), 379 deletions(-)

-- 
2.24.0

