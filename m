Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CE4C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 17:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2EBF20855
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 17:22:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cva/WBbm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfBHRWg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 12:22:36 -0500
Received: from mail-ot1-f45.google.com ([209.85.210.45]:39054 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfBHRWg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 12:22:36 -0500
Received: by mail-ot1-f45.google.com with SMTP id n8so7064667otl.6
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2019 09:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PN9493HKSlTnnHz8/LQdCuDZ9Y/Qat94mMkRl31jEvc=;
        b=Cva/WBbmI1qbUz7otUM1vj+QsEgwHOUmhBMkmB0SLPMTTDjq/WwY48c/Uhs3sy65Yf
         RJC9UBmYuwv/2Yso0oo0+PSs6oKw9oPyOBcZkoNi0LoFQ8v2uEQorubipbIcXONmCSz3
         WuQrLh+FIxALPwJ6E17jWRgU5+jXWcEigOKTZVQV+4lsbXZJyLd/LBG16f4FF6O3AypV
         R7u6LqCHLhEjQa+Tr9ImRAnOMCsYbPLVOxQURt8LVdLibY8Sc/HwY/JJkoZr/ByWOc9N
         1AP1nL9FxznSv1C3p9wBJcQxIWwStxJu9p28Xg5W0aJdM6BSXCBh3X27PKYI+xKDf09U
         +3fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=PN9493HKSlTnnHz8/LQdCuDZ9Y/Qat94mMkRl31jEvc=;
        b=cbLUeEnPYmXkM2r1MN7aCsY0TDbiWJv7CT2ovR3MzGVlTJKFdYi8iNSMGFE/B40zon
         HRMAo5B2ejhTnfhzDOBr5D8m6Cj5t23xI+6v8HOKyAzpfHp+tTDXxZRIsDnQ7XoucrD6
         zdaLuy3WX+PamFzN5Obz+gwS5aS5VJMqR1vRNTPulkXBdnHCTtWur0vUMALSGuW56NSC
         aqNF+4iQJjb7jpeWSmyOIcmGTLI9Rr7c6YQGhA09GBkuLXtkhJ0ni8POUA3nLYjiDt3d
         BF4+mLlesS7CAGeFLQm5ZdyM3pmwTQTZ90Gl2JF2GCyxP67dO8fEEHzDvlOeHXYHH26V
         kLCA==
X-Gm-Message-State: AHQUAuaaVy0n/qrQng5W1oJUYtJSiHyfRG/Jllu1uG68/CfQdqTAWh2x
        saQaJXGUxer4xMpmUTOzHpE=
X-Google-Smtp-Source: AHgI3IbSQVYHJ/Pw+UjZixKHpl578u5KopX3lUbRtGPX9u1Bq0Nctr/ENRMhhr5Jvk8m4SSjWHX44w==
X-Received: by 2002:a9d:7a8c:: with SMTP id l12mr14323670otn.335.1549646554909;
        Fri, 08 Feb 2019 09:22:34 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o2sm1107262otj.2.2019.02.08.09.22.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 09:22:34 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 00/13] rtlwifi: Replace old-style license info with SPDX form
Date:   Fri,  8 Feb 2019 11:21:56 -0600
Message-Id: <20190208172209.28530-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

These patches change all the license information from the old-stype format
to the newer SPDX format. There are no code changes.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
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

