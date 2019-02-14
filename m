Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD102C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A8BE21B18
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:36:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RZrNfb+K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503408AbfBNWgt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 17:36:49 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43755 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405500AbfBNWgt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 17:36:49 -0500
Received: by mail-ot1-f65.google.com with SMTP id n71so13348857ota.10
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 14:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/knKNJKtyGaiRYmFDsQe88LftBFeE8SzyfRuet195Zo=;
        b=RZrNfb+KgQIS0iyetxIxuiwRRoZ4drY73J1wc01r4899gSiOhbhAiXjW/UWrk79vpR
         WG1sC1JVJwS2bWQNrG+dLx2o3z4rOHfFLUs0VkIsWTsKzaa6PwqyUbkVaxpi+VB2MzIj
         fTOqUUBV1JtrTufC6njk9/u8MX0RvT9lJja5gzFAimuUpPbQvpJu20KYAiqRaX/AAnmq
         Kcvdcn+OsEWgxScfHlwaurvly9Az5pBpUSKBySnKEdB9pRqbOZrD/tywhAU3O0zsk34g
         1WZg9DREmtuJUKAztay67Lz0seDzcN3ykmkShEAT2SIcJGGBvJGQr3zVull6y2/FWA+R
         w5EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=/knKNJKtyGaiRYmFDsQe88LftBFeE8SzyfRuet195Zo=;
        b=LI25CsPnbEEij/tcyUE1sVhxeuPqulhrM+G6spCLb1hpTIFlR74swJ1p2vP9Qlcw+F
         hkOKWQX5cfGC5dKJMUbkFfAyvRDRYowWzRdKhVfO28ImOzT9hsV1KGyCgJWfhdWVDZnv
         1ueGbFAWjrBdtLQTsDTuf18aDUJeiID8RSnuxfj2hYNwZc0CNCLqsSA/oRwodg804+iI
         zf21MWQNWwHDVwSW+HoAQW1J82YSLW53FQGHQzkkLwaRdBcCxxUOXpwpMg+oi/EcUupF
         ahRmol2oUJWQYFNf3bQXrY5m82aRn12oRSR2L8RPMS31CjFyQl+iE0OLiFer5k3TxLUK
         GVig==
X-Gm-Message-State: AHQUAuZQC88rqG9guo/zuXPH/w7GBmeWom5AMHpA4FP6ZO/nIhh7IIPI
        /tXFoVcQuazbv6tqi0ZRX3tTWI6+
X-Google-Smtp-Source: AHgI3IZIMsOgvZud0B66l0bOaDt5ZM75IZHhjF97/FKz4yrenfF/2EByqb46DOrBd/nL04Lu4+TNoA==
X-Received: by 2002:a9d:6a41:: with SMTP id h1mr3892333otn.332.1550183808170;
        Thu, 14 Feb 2019 14:36:48 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id h1sm1463938otm.0.2019.02.14.14.36.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 14:36:47 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/8] rtlwifi: Remove CamelCase variables from all drivers
Date:   Thu, 14 Feb 2019 16:36:36 -0600
Message-Id: <20190214223644.8035-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This set of patches fix all instances of CamelCase for all the drivers.
When the symbol refers to a macro, it is converted to upper case. If a
variable or a function, then it is converted to lower case.

As noted in the comments, some of the other checkpatch exceptions are
addressed.

Larry Finger (8):
  rtlwifi: Remove CamelCase variables from base code
  rtlwifi: btcoexist: Remove CamelCase variable
  rtlwifi: rtl8188ee: Remove CamelCase variable
  rtlwifi: rtl8192{c,u}: Remove CamelCase variables
  rtlwifi: rtl8188de: Remove CamelCase variables
  rtlwifi: rtl8192se: Remove CamelCase variables
  rtlwifi: rtl8723{be,ae}: Remove CamelCase variables
  rtlwifi: rtl8821ae: Remove CamelCase variables

 .../realtek/rtlwifi/btcoexist/halbt_precomp.h |   2 -
 drivers/net/wireless/realtek/rtlwifi/debug.h  |   2 +-
 drivers/net/wireless/realtek/rtlwifi/efuse.c  |  44 +--
 drivers/net/wireless/realtek/rtlwifi/efuse.h  |   2 +-
 drivers/net/wireless/realtek/rtlwifi/regd.c   |   8 +-
 .../wireless/realtek/rtlwifi/rtl8188ee/def.h  |   3 -
 .../wireless/realtek/rtlwifi/rtl8188ee/trx.c  |   4 +-
 .../realtek/rtlwifi/rtl8192c/dm_common.h      |   4 +-
 .../realtek/rtlwifi/rtl8192c/fw_common.c      |  14 +-
 .../realtek/rtlwifi/rtl8192c/phy_common.c     |  24 +-
 .../realtek/rtlwifi/rtl8192c/phy_common.h     |   6 +-
 .../wireless/realtek/rtlwifi/rtl8192ce/dm.h   |   4 +-
 .../wireless/realtek/rtlwifi/rtl8192ce/hw.c   |  42 +--
 .../wireless/realtek/rtlwifi/rtl8192ce/phy.c  |  10 +-
 .../wireless/realtek/rtlwifi/rtl8192ce/phy.h  |   6 +-
 .../wireless/realtek/rtlwifi/rtl8192ce/reg.h  |  59 ++--
 .../wireless/realtek/rtlwifi/rtl8192ce/rf.c   | 112 +++----
 .../wireless/realtek/rtlwifi/rtl8192ce/trx.c  |   4 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/hw.c   | 278 +++++++++---------
 .../wireless/realtek/rtlwifi/rtl8192cu/hw.h   |   4 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/led.c  |   6 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/phy.c  |  16 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/rf.c   | 112 +++----
 .../realtek/rtlwifi/rtl8192cu/table.c         |   8 +-
 .../realtek/rtlwifi/rtl8192cu/table.h         |  16 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/trx.c  |  62 ++--
 .../wireless/realtek/rtlwifi/rtl8192cu/trx.h  |   4 +-
 .../wireless/realtek/rtlwifi/rtl8192de/dm.c   |  24 +-
 .../wireless/realtek/rtlwifi/rtl8192de/dm.h   |   2 +-
 .../wireless/realtek/rtlwifi/rtl8192de/fw.c   |  16 +-
 .../wireless/realtek/rtlwifi/rtl8192de/hw.c   |  66 ++---
 .../wireless/realtek/rtlwifi/rtl8192de/phy.c  |  68 ++---
 .../wireless/realtek/rtlwifi/rtl8192de/reg.h  |  28 +-
 .../wireless/realtek/rtlwifi/rtl8192de/trx.c  |   2 +-
 .../wireless/realtek/rtlwifi/rtl8192ee/trx.c  |   2 +-
 .../wireless/realtek/rtlwifi/rtl8192se/dm.h   |   2 +-
 .../wireless/realtek/rtlwifi/rtl8192se/fw.c   |   4 +-
 .../wireless/realtek/rtlwifi/rtl8192se/fw.h   |   6 +-
 .../wireless/realtek/rtlwifi/rtl8192se/hw.c   |  22 +-
 .../wireless/realtek/rtlwifi/rtl8192se/phy.c  |  44 +--
 .../wireless/realtek/rtlwifi/rtl8192se/reg.h  |  48 +--
 .../wireless/realtek/rtlwifi/rtl8192se/trx.c  |   4 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/def.h  |   2 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/hw.c   |   8 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/phy.c  |   2 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/phy.h  |   2 +-
 .../realtek/rtlwifi/rtl8723ae/pwrseq.h        |  18 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/sw.c   |   2 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/trx.c  |   4 +-
 .../wireless/realtek/rtlwifi/rtl8723be/hw.c   |  14 +-
 .../wireless/realtek/rtlwifi/rtl8723be/trx.c  |   4 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/dm.h   |  10 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/fw.c   | 102 +++----
 .../wireless/realtek/rtlwifi/rtl8821ae/hw.c   | 234 +++++++--------
 .../wireless/realtek/rtlwifi/rtl8821ae/phy.c  | 132 ++++-----
 .../wireless/realtek/rtlwifi/rtl8821ae/phy.h  |   4 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/reg.h  |  34 +--
 .../realtek/rtlwifi/rtl8821ae/table.c         | 184 ++++++------
 drivers/net/wireless/realtek/rtlwifi/usb.c    |   6 +-
 drivers/net/wireless/realtek/rtlwifi/usb.h    |   2 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h   |  26 +-
 61 files changed, 989 insertions(+), 995 deletions(-)

-- 
2.20.1

