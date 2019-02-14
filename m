Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B391C10F04
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 17:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 061D7222DA
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 17:00:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ICKxqifY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391717AbfBNRA4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 12:00:56 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40285 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbfBNRAz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 12:00:55 -0500
Received: by mail-ot1-f65.google.com with SMTP id s5so11665596oth.7
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 09:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=lTZsMVZrASi8dqIK4rzvSQMqhS2jhLPfWaOJIwLaAZA=;
        b=ICKxqifYzWcokNchnqynovMwOLLvORZJP5gKCMxnu2VdZpX7Naz3N7wP9IiTgLeAly
         jJcoQxY3J0VjmpHfU7AP+7I40BXbLpAQNP/W4Ob+bKVk7A8AGO8AUAKRedpixdCWGSZ2
         pbtjM2Yvo8cxVc0SAH0H/Oj7n/Ma5OMFb1Wb3T1yXefOhBifscFBtY0LsJn+qWK9WrCc
         r7DpfBC5HYUg0gSS1JYBJcyqSr5daj17v/Olw98pg2LfZc4trXHO9ZugGLp9AMT9mxt1
         rzC0/6jcqqXtudhcZ83Dz0RCFlm6c7FOthZWY43+LB3oyyJqBwEweTA+B9yMtjqqEG/b
         DWWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=lTZsMVZrASi8dqIK4rzvSQMqhS2jhLPfWaOJIwLaAZA=;
        b=WKY4/0kZjGHP3NLAhu4vF0BHyIcKRRvBU3WEcqoQVAhwj8OQcgvzr6QUOBl/gxP45Z
         JPwZobM6jXLA3SEO+jaQUvMs/0oRjywKBddH1N/yWIQzkCFFDu30FndEPGyHaeDDIwUh
         P5gaZqZnrAxqz8nlzN851lh8FqS10b8qXzEHuy34pKwrA6O54iczrAHxXUYWQ5qOmagv
         2CN8UELuDQ727pU3QwM2eYP3ggz4a581X0fbP17tepi0aWTIucSTtO0XagulAAMD+1a/
         +pwkiY++j+huqzEv8x0juhtXzVIhZeXuD+BPrJJwwa4v021c60Dr0mxhpBLlVnUpG4KF
         DP6w==
X-Gm-Message-State: AHQUAuY4MZZWlVhnPpdsT/RCZBPFP+igCW92UPOzCdQeCZpfFH2KLXSj
        jcfY9FuBgLNig1VlIDYa3H90zGo6
X-Google-Smtp-Source: AHgI3IYjM2wWbhfEtK9Dl/lsi0/pn/bomnex5DAvGRyjoJ/P87qotZfJUEu1iIs6OQ1+Y7zJRKsvpg==
X-Received: by 2002:aca:644:: with SMTP id 65mr2993203oig.21.1550163654002;
        Thu, 14 Feb 2019 09:00:54 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id l5sm1158327oil.15.2019.02.14.09.00.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 09:00:53 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v2 00/13] rtlwifi: Replace old-style license info with SPDX form
Date:   Thu, 14 Feb 2019 11:00:30 -0600
Message-Id: <20190214170043.3705-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.16.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

These patches change all the license information from the old-stype format
to the newer SPDX format. There are no code changes.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
v2 - C++ comment style used for SPDX line in .c files, and GPL 2.0+ changed to 2.0.
---

Larry Finger (13):
  rtlwifi: Replace old-style license information
  rtlwifi: btcoex: Replace old-style license information
  rtlwifi: rtl8188ee: Replace old-style license information
  rtlwifi: rtl8192com: Replace old-style license information
  rtlwifi: rtl8192ce: Replace old-style license information
  rtlwifi: rtl8192cu: Replace old-style license information
  rtlwifi: rtl8192de: Replace old-style license information
  rtlwifi: rtl8192ee: Replace old-style license information
  rtlwifi: rtl8192se: Replace old-style license information
  rtlwifi: rtl8723ae: Replace old-style license information
  rtlwifi: rtl8723be: Replace old-style license information
  rtlwifi: rtl8723_common: Replace old-style license information
  rtlwifi: rtl8821ae: Replace old-style license information

 drivers/net/wireless/realtek/rtlwifi/base.c   | 26 ++------------
 drivers/net/wireless/realtek/rtlwifi/base.h   | 26 ++------------
 .../realtek/rtlwifi/btcoexist/halbt_precomp.h | 25 ++-----------
 .../rtlwifi/btcoexist/halbtc8192e2ant.c       | 35 ++-----------------
 .../rtlwifi/btcoexist/halbtc8192e2ant.h       | 27 ++------------
 .../rtlwifi/btcoexist/halbtc8723b1ant.c       | 26 ++------------
 .../rtlwifi/btcoexist/halbtc8723b1ant.h       | 27 ++------------
 .../rtlwifi/btcoexist/halbtc8723b2ant.c       | 27 ++------------
 .../rtlwifi/btcoexist/halbtc8723b2ant.h       | 27 ++------------
 .../rtlwifi/btcoexist/halbtc8821a1ant.c       | 26 ++------------
 .../rtlwifi/btcoexist/halbtc8821a1ant.h       | 26 ++------------
 .../rtlwifi/btcoexist/halbtc8821a2ant.c       | 26 ++------------
 .../rtlwifi/btcoexist/halbtc8821a2ant.h       | 26 ++------------
 .../rtlwifi/btcoexist/halbtc8822bwifionly.c   | 17 ++-------
 .../rtlwifi/btcoexist/halbtc8822bwifionly.h   |  3 ++
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c  | 26 ++------------
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h  | 27 ++------------
 .../realtek/rtlwifi/btcoexist/rtl_btc.c       | 27 ++------------
 .../realtek/rtlwifi/btcoexist/rtl_btc.h       | 25 ++-----------
 drivers/net/wireless/realtek/rtlwifi/cam.c    | 27 ++------------
 drivers/net/wireless/realtek/rtlwifi/cam.h    | 26 ++------------
 drivers/net/wireless/realtek/rtlwifi/core.c   | 26 ++------------
 drivers/net/wireless/realtek/rtlwifi/core.h   | 26 ++------------
 drivers/net/wireless/realtek/rtlwifi/debug.c  | 25 ++-----------
 drivers/net/wireless/realtek/rtlwifi/debug.h  | 25 ++-----------
 drivers/net/wireless/realtek/rtlwifi/efuse.c  | 27 ++------------
 drivers/net/wireless/realtek/rtlwifi/efuse.h  | 26 ++------------
 drivers/net/wireless/realtek/rtlwifi/pci.c    | 26 ++------------
 drivers/net/wireless/realtek/rtlwifi/pci.h    | 26 ++------------
 drivers/net/wireless/realtek/rtlwifi/ps.c     | 26 ++------------
 drivers/net/wireless/realtek/rtlwifi/ps.h     | 26 ++------------
 .../net/wireless/realtek/rtlwifi/pwrseqcmd.h  | 26 ++------------
 drivers/net/wireless/realtek/rtlwifi/rc.c     | 26 ++------------
 drivers/net/wireless/realtek/rtlwifi/rc.h     | 26 ++------------
 drivers/net/wireless/realtek/rtlwifi/regd.c   | 26 ++------------
 drivers/net/wireless/realtek/rtlwifi/regd.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8188ee/def.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8188ee/dm.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8188ee/dm.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8188ee/fw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8188ee/fw.h   | 25 ++-----------
 .../wireless/realtek/rtlwifi/rtl8188ee/hw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8188ee/hw.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8188ee/led.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8188ee/led.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8188ee/phy.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8188ee/phy.h  | 26 ++------------
 .../realtek/rtlwifi/rtl8188ee/pwrseq.c        | 26 ++------------
 .../realtek/rtlwifi/rtl8188ee/pwrseq.h        | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8188ee/reg.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8188ee/rf.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8188ee/rf.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8188ee/sw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8188ee/sw.h   | 26 ++------------
 .../realtek/rtlwifi/rtl8188ee/table.c         | 28 ++-------------
 .../realtek/rtlwifi/rtl8188ee/table.h         | 28 ++-------------
 .../wireless/realtek/rtlwifi/rtl8188ee/trx.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8188ee/trx.h  | 26 ++------------
 .../realtek/rtlwifi/rtl8192c/dm_common.c      | 26 ++------------
 .../realtek/rtlwifi/rtl8192c/dm_common.h      | 26 ++------------
 .../realtek/rtlwifi/rtl8192c/fw_common.c      | 26 ++------------
 .../realtek/rtlwifi/rtl8192c/fw_common.h      | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192c/main.c  | 26 ++------------
 .../realtek/rtlwifi/rtl8192c/phy_common.c     | 26 ++------------
 .../realtek/rtlwifi/rtl8192c/phy_common.h     | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ce/def.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ce/dm.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ce/dm.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ce/hw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ce/hw.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ce/led.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ce/led.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ce/phy.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ce/phy.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ce/reg.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ce/rf.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ce/rf.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ce/sw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ce/sw.h   | 26 ++------------
 .../realtek/rtlwifi/rtl8192ce/table.c         | 28 ++-------------
 .../realtek/rtlwifi/rtl8192ce/table.h         | 28 ++-------------
 .../wireless/realtek/rtlwifi/rtl8192ce/trx.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ce/trx.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192cu/def.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192cu/dm.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192cu/dm.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192cu/hw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192cu/hw.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192cu/led.c  | 24 ++-----------
 .../wireless/realtek/rtlwifi/rtl8192cu/led.h  | 24 ++-----------
 .../wireless/realtek/rtlwifi/rtl8192cu/mac.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192cu/mac.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192cu/phy.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192cu/phy.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192cu/reg.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192cu/rf.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192cu/rf.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192cu/sw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192cu/sw.h   | 26 ++------------
 .../realtek/rtlwifi/rtl8192cu/table.c         | 26 ++------------
 .../realtek/rtlwifi/rtl8192cu/table.h         | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192cu/trx.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192cu/trx.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/def.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/dm.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/dm.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/fw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/fw.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/hw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/hw.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/led.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/led.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/phy.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/phy.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/reg.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/rf.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/rf.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/sw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/sw.h   | 26 ++------------
 .../realtek/rtlwifi/rtl8192de/table.c         | 27 ++------------
 .../realtek/rtlwifi/rtl8192de/table.h         | 27 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/trx.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192de/trx.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ee/def.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ee/dm.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ee/dm.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ee/fw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ee/fw.h   | 25 ++-----------
 .../wireless/realtek/rtlwifi/rtl8192ee/hw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ee/hw.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ee/led.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ee/led.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ee/phy.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ee/phy.h  | 26 ++------------
 .../realtek/rtlwifi/rtl8192ee/pwrseq.c        | 26 ++------------
 .../realtek/rtlwifi/rtl8192ee/pwrseq.h        | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ee/reg.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ee/rf.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ee/rf.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ee/sw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ee/sw.h   | 26 ++------------
 .../realtek/rtlwifi/rtl8192ee/table.c         | 28 ++-------------
 .../realtek/rtlwifi/rtl8192ee/table.h         | 28 ++-------------
 .../wireless/realtek/rtlwifi/rtl8192ee/trx.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192ee/trx.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192se/def.h  | 27 ++------------
 .../wireless/realtek/rtlwifi/rtl8192se/dm.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192se/dm.h   | 27 ++------------
 .../wireless/realtek/rtlwifi/rtl8192se/fw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192se/fw.h   | 27 ++------------
 .../wireless/realtek/rtlwifi/rtl8192se/hw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192se/hw.h   | 27 ++------------
 .../wireless/realtek/rtlwifi/rtl8192se/led.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192se/led.h  | 27 ++------------
 .../wireless/realtek/rtlwifi/rtl8192se/phy.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192se/phy.h  | 27 ++------------
 .../wireless/realtek/rtlwifi/rtl8192se/reg.h  | 27 ++------------
 .../wireless/realtek/rtlwifi/rtl8192se/rf.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192se/rf.h   | 27 ++------------
 .../wireless/realtek/rtlwifi/rtl8192se/sw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192se/sw.h   | 25 ++-----------
 .../realtek/rtlwifi/rtl8192se/table.c         | 27 ++------------
 .../realtek/rtlwifi/rtl8192se/table.h         | 20 ++---------
 .../wireless/realtek/rtlwifi/rtl8192se/trx.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8192se/trx.h  | 27 ++------------
 .../wireless/realtek/rtlwifi/rtl8723ae/btc.h  | 25 ++-----------
 .../wireless/realtek/rtlwifi/rtl8723ae/def.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723ae/dm.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723ae/dm.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723ae/fw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723ae/fw.h   | 25 ++-----------
 .../rtlwifi/rtl8723ae/hal_bt_coexist.c        | 26 ++------------
 .../rtlwifi/rtl8723ae/hal_bt_coexist.h        | 25 ++-----------
 .../realtek/rtlwifi/rtl8723ae/hal_btc.c       | 27 ++------------
 .../realtek/rtlwifi/rtl8723ae/hal_btc.h       | 25 ++-----------
 .../wireless/realtek/rtlwifi/rtl8723ae/hw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723ae/hw.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723ae/led.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723ae/led.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723ae/phy.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723ae/phy.h  | 26 ++------------
 .../realtek/rtlwifi/rtl8723ae/pwrseq.c        | 26 ++------------
 .../realtek/rtlwifi/rtl8723ae/pwrseq.h        | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723ae/reg.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723ae/rf.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723ae/rf.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723ae/sw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723ae/sw.h   | 26 ++------------
 .../realtek/rtlwifi/rtl8723ae/table.c         | 28 ++-------------
 .../realtek/rtlwifi/rtl8723ae/table.h         | 28 ++-------------
 .../wireless/realtek/rtlwifi/rtl8723ae/trx.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723ae/trx.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723be/def.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723be/dm.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723be/dm.h   | 23 ++----------
 .../wireless/realtek/rtlwifi/rtl8723be/fw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723be/fw.h   | 25 ++-----------
 .../wireless/realtek/rtlwifi/rtl8723be/hw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723be/hw.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723be/led.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723be/led.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723be/phy.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723be/phy.h  | 26 ++------------
 .../realtek/rtlwifi/rtl8723be/pwrseq.c        | 26 ++------------
 .../realtek/rtlwifi/rtl8723be/pwrseq.h        | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723be/reg.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723be/rf.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723be/rf.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723be/sw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723be/sw.h   | 26 ++------------
 .../realtek/rtlwifi/rtl8723be/table.c         | 28 ++-------------
 .../realtek/rtlwifi/rtl8723be/table.h         | 28 ++-------------
 .../wireless/realtek/rtlwifi/rtl8723be/trx.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8723be/trx.h  | 26 ++------------
 .../realtek/rtlwifi/rtl8723com/dm_common.c    | 26 ++------------
 .../realtek/rtlwifi/rtl8723com/dm_common.h    | 26 ++------------
 .../realtek/rtlwifi/rtl8723com/fw_common.c    | 26 ++------------
 .../realtek/rtlwifi/rtl8723com/fw_common.h    | 26 ++------------
 .../realtek/rtlwifi/rtl8723com/main.c         | 26 ++------------
 .../realtek/rtlwifi/rtl8723com/phy_common.c   | 26 ++------------
 .../realtek/rtlwifi/rtl8723com/phy_common.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8821ae/def.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8821ae/dm.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8821ae/dm.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8821ae/fw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8821ae/fw.h   | 25 ++-----------
 .../wireless/realtek/rtlwifi/rtl8821ae/hw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8821ae/hw.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8821ae/led.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8821ae/led.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8821ae/phy.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8821ae/phy.h  | 26 ++------------
 .../realtek/rtlwifi/rtl8821ae/pwrseq.c        | 26 ++------------
 .../realtek/rtlwifi/rtl8821ae/pwrseq.h        | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8821ae/reg.h  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8821ae/rf.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8821ae/rf.h   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8821ae/sw.c   | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8821ae/sw.h   | 26 ++------------
 .../realtek/rtlwifi/rtl8821ae/table.c         | 29 ++-------------
 .../realtek/rtlwifi/rtl8821ae/table.h         | 28 ++-------------
 .../wireless/realtek/rtlwifi/rtl8821ae/trx.c  | 26 ++------------
 .../wireless/realtek/rtlwifi/rtl8821ae/trx.h  | 26 ++------------
 drivers/net/wireless/realtek/rtlwifi/stats.c  | 27 ++------------
 drivers/net/wireless/realtek/rtlwifi/stats.h  | 26 ++------------
 drivers/net/wireless/realtek/rtlwifi/usb.c    | 24 ++-----------
 drivers/net/wireless/realtek/rtlwifi/usb.h    | 24 ++-----------
 drivers/net/wireless/realtek/rtlwifi/wifi.h   | 26 ++------------
 248 files changed, 520 insertions(+), 5922 deletions(-)

-- 
2.20.1

