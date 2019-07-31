Return-Path: <SRS0=Y9Fe=V4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3738C433FF
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Jul 2019 00:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7102720644
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Jul 2019 00:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g8mu937N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfGaAdO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Jul 2019 20:33:14 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33010 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfGaAdO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jul 2019 20:33:14 -0400
Received: by mail-oi1-f195.google.com with SMTP id u15so49397442oiv.0
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jul 2019 17:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UsJ5mAr/RC3iU+xZHmxNrQOOFxp57Xf1yINmm/KfYnE=;
        b=g8mu937NzZxCQPOFFTSZRDH8H3COdpu77G7+ck55atfn/VrqJnga0do+/enrJxMjKe
         Qu4RcCPy2Sx4efvHBGeUTQbn6z3HF/wOt9py4bBeR6xr6JyhUtG3VSASz6WLp7H31FVh
         ZfV4p41fchoOjRbGTXSGKvAouSasSQeq9B0at3HJH90Wm5+8jsUmENu6lLpYl0QJBywS
         UCjne5lZecggug3QGx0lPvTJMoSTvnLsazBN+mkgHK8EGCvhsDSBdZwg8CJDD1k1g68v
         T+m1d/NeuMRWhTkenml5JVpJCC0kBXouvsTKR4O1MlP42nRHy96Bo0QDUHXfHoiT5MQ3
         pEGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=UsJ5mAr/RC3iU+xZHmxNrQOOFxp57Xf1yINmm/KfYnE=;
        b=dJaHA5qt/rttkhUndd7j973gwdIDVtuDSBJt8mmo93VMswZ7fNP3gbRvY4J8kaRxTc
         eVfkJashSfMf53ifO2ibc0WqaLf/RXIvE+HWZv4uiLJf0zgh9gjVLq3vVfaZun+p6Nwj
         nq0nHIfOwU0H+tokmiw5R6Ft4C+lahL9ODdbuZboiT2crV29ceSVfpqo8qioK+fAZymh
         qJ/xeoZgMJZH/Hs4nYjVsF8L+VPxpcWNysL4/bv0NIaS9wQIBhiZphz9Sl3JdlOYOSiq
         HknaSahb2hohnuGPsFswYl7mb00yslzhev8x8CHaPSglx/LhfDxHrbxJ/9ufFQhQQpCZ
         pV8A==
X-Gm-Message-State: APjAAAXlbLDWj0pixbhcjrLr2Z5VOvsOILH1VuYbfmuYs3WHD1ULPX1Z
        qRVHA/fozrp8wYaM+fbf9zo=
X-Google-Smtp-Source: APXvYqwv/YzJZ4Auz1J8Ax+wcET8KdkKdmuxWbBCLkOYCN5tPnfB9vwY7RhzDHmVvhBT34rUpnQfVQ==
X-Received: by 2002:aca:b208:: with SMTP id b8mr37182935oif.98.1564533193774;
        Tue, 30 Jul 2019 17:33:13 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id t11sm22156016otq.13.2019.07.30.17.33.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 17:33:12 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/5] rtlwifi: rtl8188ee: Replace local TX and RX bit manipulation macros
Date:   Tue, 30 Jul 2019 19:32:59 -0500
Message-Id: <20190731003304.14377-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

These patches are part of a series intended to replace the bit-manipulation
macros used to set and read the various descriptors with a set of inline
routines.

The final patch removes a local configuration variable.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>


Larry Finger (5):
  rtlwifi: rtl8i188ee: Remove unused GET_XXX and SET_XXX descriptor
    macros
  rtlwifi: rtl88188ee: Replace local bit manipulation macros
  rtlwifi: rtl8188ee: Convert macros that set descriptor
  rtlwifi: rtl8188ee: Convert inline routines to little-endian words
  rtlwifi: rtl8188ee: Remove local configuration variable

 .../wireless/realtek/rtlwifi/rtl8188ee/dm.c   |    7 +-
 .../wireless/realtek/rtlwifi/rtl8188ee/trx.c  |  257 ++--
 .../wireless/realtek/rtlwifi/rtl8188ee/trx.h  | 1046 +++++++++--------
 3 files changed, 673 insertions(+), 637 deletions(-)

-- 
2.22.0

