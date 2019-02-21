Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D556C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F8232077B
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dfDuSO7d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfBUTbW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 14:31:22 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41733 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfBUTbV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 14:31:21 -0500
Received: by mail-ot1-f68.google.com with SMTP id t7so29523544otk.8
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 11:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7xZbuB5BarjT2Un+Im7Lpx4ojwB91hzJEgvFQInOxKk=;
        b=dfDuSO7dKHJ8TWwww5uga5TKCPe1sOKtlrxQj8Y62lEmcXlAEFXNgFObx9yDVYxYIi
         aX8XGT4OdXGcsC5KsmiwWBHoQqIC7Lc+G9YvyMMenrovy/WGecNIVCQN5dKvfue+L4wO
         Gj7R2VMTwMaOhZzj+NZlCE/UcriIzjgHwdydv9gd5kYmfqXWaSugjOYbMrxnW4kK+fJi
         KsotBU+t4BgFKSA2xyl2hnO/C6cseMcM0f5LcxmRtESemPJ/5tYNKwJydl5HM3/4D9ER
         6dA/wJrHhVR1hmqj7aGt31nDLuVsJVeLQpHn0RMOPuAHc9JhrLVcomfIbESbUnkfI9Fg
         2mvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=7xZbuB5BarjT2Un+Im7Lpx4ojwB91hzJEgvFQInOxKk=;
        b=gqveVYl+VGPOV67uQ7tAvAUfvGoPF9oh388d+f5fH9FRcy7kDHbbWayqf5yx2Xi4tK
         IkR0s5+RotCqx5iX27eDhApObO2mMSwdoz1C+jxb2MZRBFDv3VFY0shTlwUG35vol1FB
         oP4g3t82/6X/syCdsv+jhvnreFRUnketFyhL/x7ngP0oBUE/bYwd/EBQQkqrin2QrZ+U
         TxRJcNLZGey1cek5/OkIFLVaYXldpmmOGdxNNzUB9YdABAwwXWYI1lkY1/L2fF+CBq+a
         tv9wNEfJi5rPpWHNntp4/yIzGYV5TQ/QTZFP+IS4G0hEGeYgBGM7uNHRhFvbXnGWAMWc
         KVJA==
X-Gm-Message-State: AHQUAuYOzaHywuQUSEzwXo+94rVJxWlCjl2WhzhtYSnV7hRQTo2zKR+a
        2qHOFR4AhBZ1A34VvhJNLF4=
X-Google-Smtp-Source: AHgI3IYO6xHBNXt+C1Qv21PYnuH7ZJKLDT+HP0yI9ZpH5mlNmknHWT9VH9h/WLB9TUuzdBeNU6IXaw==
X-Received: by 2002:a05:6830:15c3:: with SMTP id j3mr83572otr.347.1550777480473;
        Thu, 21 Feb 2019 11:31:20 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o16sm9495500otl.22.2019.02.21.11.31.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 11:31:19 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/8] rtlwifi: Fix some cosmetic errors
Date:   Thu, 21 Feb 2019 13:31:07 -0600
Message-Id: <20190221193115.30848-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This set of patches fix some of the cosmetic checks, errors, or
warnings reported by checkpatch.pl. None of these affect the
generated code.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry Finger (8):
  rtlwifi: Fix errors in spacing in wifi.h
  rtlwifi: Fix problems with block comments in wifi.h
  rtlwifi: Fix alignment errors in wifi.h
  rtlwifi: Fix blank line errors in main header files
  rtlwifi: Fix all blank line irregularities in main code files
  rtlwifi: rtl8192ce: Fix missing blank lines
  rtlwifi: rtl8192cu: Fix problems with blank lines
  rtlwifi: rtl8192com: Fix blank line problems

 drivers/net/wireless/realtek/rtlwifi/base.c   |   7 +-
 drivers/net/wireless/realtek/rtlwifi/core.c   |   8 +
 drivers/net/wireless/realtek/rtlwifi/efuse.c  |   8 +-
 drivers/net/wireless/realtek/rtlwifi/ps.c     |   1 +
 drivers/net/wireless/realtek/rtlwifi/rc.c     |   2 +
 drivers/net/wireless/realtek/rtlwifi/regd.c   |   1 -
 .../realtek/rtlwifi/rtl8192c/dm_common.c      |   6 +-
 .../realtek/rtlwifi/rtl8192c/fw_common.c      |   5 +-
 .../wireless/realtek/rtlwifi/rtl8192c/main.c  |   1 -
 .../realtek/rtlwifi/rtl8192c/phy_common.c     |   1 +
 .../wireless/realtek/rtlwifi/rtl8192ce/hw.c   |   7 +-
 .../wireless/realtek/rtlwifi/rtl8192ce/phy.c  |   1 +
 .../realtek/rtlwifi/rtl8192ce/table.c         |   1 -
 .../wireless/realtek/rtlwifi/rtl8192ce/trx.c  |   8 +
 .../wireless/realtek/rtlwifi/rtl8192cu/hw.c   |   9 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/hw.h   |   4 -
 .../wireless/realtek/rtlwifi/rtl8192cu/mac.c  |   8 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/mac.h  |   3 -
 .../wireless/realtek/rtlwifi/rtl8192cu/trx.c  |   7 +
 .../wireless/realtek/rtlwifi/rtl8192cu/trx.h  |   2 -
 drivers/net/wireless/realtek/rtlwifi/usb.c    |   3 +
 drivers/net/wireless/realtek/rtlwifi/usb.h    |   5 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h   | 351 +++++++++---------
 23 files changed, 245 insertions(+), 204 deletions(-)

-- 
2.20.1

