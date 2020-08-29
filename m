Return-Path: <SRS0=lHvG=CH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C8F5C433E6
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Aug 2020 00:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBA8F207DA
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Aug 2020 00:55:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U8dmBqQJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgH2AzB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Aug 2020 20:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbgH2Ay4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Aug 2020 20:54:56 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57200C061264
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2020 17:54:56 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 5so751385otp.12
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2020 17:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eHcR5PhbYH26I6HoLHCkhZHx8aDJz0yZDT0dInE71+g=;
        b=U8dmBqQJFdHCjKB+ihXIaZKgdBRWlpo2KcoB1eSPvnI0AL70AoTTdPPbqXFIeq8feh
         HflWjg/EiJ6QvQk91tSa+ME/gP2vp0/7MFGuETnM5z/V7vzDqXN4fGiZOeoN5tPzkOcr
         J4vdLlbikrjg+6D3c/ouM5EBLTEnfNPGn1ijlOvdmy7D0yIzE0+bhS1aezn4eHwScmSb
         BM4KuOfMHnNFAO2R0MkwQUrG98Nc9OOFTQE+jYnMrzehATW82FtpIVs5R5K+uTrZ41Yx
         eBCJFpPF/R4wnd2opQJe5J4UeEY11Vc3IoyvxsuVbpER1BP0iIzP93Q5veKd13olRPsE
         SsSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=eHcR5PhbYH26I6HoLHCkhZHx8aDJz0yZDT0dInE71+g=;
        b=qPrrK46p7yRF1rbKcxkP5MZjRndXlelnswk48/GSt7beJXc5kT/MIBzgtfTt87vA5c
         xFd/tf82b39IuXy7aw1IE1qh4fRg1gQPUzjz6hUC47wn6s1POoOlFE1K+LAdIU9aGhPf
         TIF1boIuYMCs3JPgfNx74ur7Jpqpj6lKJN4SIgZ9E0dXiYOTYXjKitED8WX858HupGr7
         ZI0kDkkMV5eDt7hCwNpeaekKPxzzxg998crLHPsvDVYYdd1uobO6I8ujJG6rpI8CHN6K
         3+2lg4Ty1BfHNEYh6sWzDZFkso0lUZ/e/0xEbhqVXuRwdL6fx2DCK/xgO7urP0J1G7PA
         LG1A==
X-Gm-Message-State: AOAM530lUzLvjsToH2qhUexFcsqb4Y/TV2N7YOXrQULgBPfAZkzb1yCL
        cb7+Gq05XMTOTooTufyZWy608IkOzUU=
X-Google-Smtp-Source: ABdhPJybdDn9aget+t9dWTAQhTIqLNy+yl3TXXVw/URei8/BrQN2nLwjCojzwQNdly8jXSx+gppIyA==
X-Received: by 2002:a9d:ae8:: with SMTP id 95mr114856otq.260.1598662495712;
        Fri, 28 Aug 2020 17:54:55 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id w136sm202253oif.14.2020.08.28.17.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 17:54:54 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v3 00/15 rtlwifi: Change RT_TRACE into rtl_dbg for all drivers
Date:   Fri, 28 Aug 2020 19:54:40 -0500
Message-Id: <20200829005442.32318-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This submission consists of the two patches that failed in the v2 case.

Larry Finger (2):
  rtlwifi: rtl8821ae: Rename RT_TRACE to rtl_dbg
  rtlwifi: Remove temporary definition of RT_TRACE

 drivers/net/wireless/realtek/rtlwifi/debug.h  |  17 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/dm.c   | 821 +++++++++---------
 .../wireless/realtek/rtlwifi/rtl8821ae/fw.c   | 134 +--
 .../wireless/realtek/rtlwifi/rtl8821ae/hw.c   | 456 +++++-----
 .../wireless/realtek/rtlwifi/rtl8821ae/led.c  |  32 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/phy.c  | 527 +++++------
 .../wireless/realtek/rtlwifi/rtl8821ae/rf.c   |   6 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/trx.c  |  59 +-
 8 files changed, 1023 insertions(+), 1029 deletions(-)

-- 
2.28.0

