Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA4DC4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 18:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4210206DD
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 18:29:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kpZDNiw/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbfDDS3j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 14:29:39 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42615 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbfDDS3j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 14:29:39 -0400
Received: by mail-ot1-f67.google.com with SMTP id 103so3249500otd.9
        for <linux-wireless@vger.kernel.org>; Thu, 04 Apr 2019 11:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bPYXZyjm1ESCOsIxBIRImYwZ3uA9PcDfTYX9r9YIpHc=;
        b=kpZDNiw/QkvkWtA+oGIH6GGeJLJG5NKdgNdoqeNNLc/Q6lCUOSoQ8InrKCF5uQTdua
         truLFfOkdCnmJdTo8rQeqOVGyh9IzHS8NEVWjal9ksaQD75943EqEkfrbdQFPj5wY6U4
         rtv/ohv/vEVBvQduV45tTee8luDLjAjQJxz5xPTdagAyLeNTQJA8+BazW21XDI8h2OcF
         Zk2n24Op54FgNhtFREFbtxwE1pUeHab3Bcc1PzRWtBOnzY5JlThiF676JrtWgEZiaiXQ
         GN2eDqgyv0MkyAYbkqFFwGBPvdPNonjJdIVgKnvE39OQEb92Glw2Yf+vstP01cz6nPe+
         UiyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=bPYXZyjm1ESCOsIxBIRImYwZ3uA9PcDfTYX9r9YIpHc=;
        b=nhV605HUDbrI9S58jzH1N4f64kuVszO9C2qGh0UyhHKOKNOE9OiH4OeTvJZn6Xd/fp
         k+CaAkxNeruyHsgjeqLyvZ9dvgI4zldUU+dICqSfTYdNinrtJSOmySOkXeT8lzZey6mm
         ZUtzVPS3gya8K+2UlD1SCBBKSiy4S08CT+U7ou7XhwuNo9N+p/bh5jyiHfsgC+ZSApk/
         tT5TmATe2ZlSEb65xpYHlaVPtI4Lp7z5cWVQbtwno81tqck1JIjqIBfkevAZhNX6KuXZ
         1ioGywVv3xJaGFYauidk1HvJttP+EWBpqC5Tn4PfJQE7/9sUe7t8LpkBDdJELU0BH5PM
         kswA==
X-Gm-Message-State: APjAAAV5k+uG13Nku8hz+sWrJl80hgK/rpPElfd7LXGPAmGJzkQZq3xO
        Wz7m3SuSj2KgyL4SkTR1hNc=
X-Google-Smtp-Source: APXvYqyouiT2FjADBPUaX+7WTK4y4IxeQ01DNlHPSYKSfwtzBqxaRXCVvuOvoTfYFiXGzDl07SFT0A==
X-Received: by 2002:a9d:5509:: with SMTP id l9mr5214719oth.195.1554402578069;
        Thu, 04 Apr 2019 11:29:38 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id a16sm7787996otl.4.2019.04.04.11.29.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Apr 2019 11:29:37 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v2 0/2] Modify the handling of the reason for a wakeup
Date:   Thu,  4 Apr 2019 13:29:29 -0500
Message-Id: <20190404182931.9477-1-Larry.Finger@lwfinger.net>
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
V2 - Fixed Merge problem

Larry Finger (2):
  rtlwifi: Fix duplicate tests of one of the RX descriptors
  rtlwifi: Convert the wake_match variable to local

 .../wireless/realtek/rtlwifi/rtl8188ee/trx.c    | 17 +++++++++--------
 .../realtek/rtlwifi/rtl8188ee/trx.c.rej         | 10 ++++++++++
 .../wireless/realtek/rtlwifi/rtl8192ee/trx.c    | 15 ++++++++-------
 .../wireless/realtek/rtlwifi/rtl8723be/trx.c    | 16 ++++++++--------
 .../wireless/realtek/rtlwifi/rtl8821ae/trx.c    | 14 +++++++-------
 drivers/net/wireless/realtek/rtlwifi/wifi.h     |  1 -
 6 files changed, 42 insertions(+), 31 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej

-- 
2.21.0

