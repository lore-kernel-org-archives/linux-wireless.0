Return-Path: <SRS0=GVYC=2A=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E691C43603
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Dec 2019 11:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10BBE206D5
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Dec 2019 11:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575978338;
	bh=rbUycGx9gUlIfbdz81Q/uowA7hYIYjXqn/v/eFl7Jvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=eWA7TYCU18HM+iQs0A8S3lJC4ckBt61jHDCyAqZZfcehmYjLB/Bte91Eb1JSR+0XG
	 YgJ9AUOlLEq5T3j5bTrfHyem91HYCJb9YQp8vn59Zc/eZ5nn20J1AfdiXg3KuKClIM
	 ExBh+CbACOJ96vB5gjmeco0Hqt8MZJitChdo4imU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfLJLor (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 Dec 2019 06:44:47 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43490 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbfLJLoq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Dec 2019 06:44:46 -0500
Received: by mail-lj1-f196.google.com with SMTP id a13so19498747ljm.10;
        Tue, 10 Dec 2019 03:44:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P3dSQCHRI36SjPWYo0brD43NEdcMsLd/xYS8Df+31B4=;
        b=WlI/+IAY2YpfyFWJfmsfGOhePWAYppvUGULiDGAnStzwa455XbZ2t6gJMLPcCbaPwG
         m4Bnm4rlGeRS9Xb2EQFGp87dMQ4/KpWY+LWg0piNiBaqd5eMVLSzfpiiUPA7TeLQWT8b
         LLZNjoDtz1bS/weBFHu62kuaj22U4KERbVb2q7fuQ1n5XC6BTr5/gnZAy1UE1+P2WdaT
         3FeTK7HAV8yh4sC+iJsh5MHv+eBWGgRg1tg0D7Pq5tm6NK+lj4MC1XKPROZyBNO9Hqoh
         l8zeuUmPpvvXpmtsG6PIX8ss+Ig1dxS5lmLTdb7V0666bZGPtdWKH8FuQ/o45b9wNBEc
         Jr5w==
X-Gm-Message-State: APjAAAWFl2e9vXxKpWUITq0+9EU/eSt+WPVrOP/TtIShUxij5h+aMYGt
        lWU5fSghRi65lASh6b/r8po=
X-Google-Smtp-Source: APXvYqxLiCnWQg2+yXPqCdb9teaUE2XcyjKhLXsnKd7FWH2vE9SYKCnmXjufUvjYd9E8cLy+G53n5g==
X-Received: by 2002:a2e:585e:: with SMTP id x30mr20943600ljd.141.1575978283741;
        Tue, 10 Dec 2019 03:44:43 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id n14sm1419005lfe.5.2019.12.10.03.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:44:42 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedwa-0001Hs-Eq; Tue, 10 Dec 2019 12:44:44 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Arend van Spriel <arend@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 2/7] at76c50x-usb: fix endpoint debug message
Date:   Tue, 10 Dec 2019 12:44:21 +0100
Message-Id: <20191210114426.4713-3-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191210114426.4713-1-johan@kernel.org>
References: <20191210114426.4713-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Make sure to use the current alternate setting, which may not be the
same as the first alternate setting, also when printing the number of
endpoints at probe.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/atmel/at76c50x-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index db2c3b8d491e..3b2680772f03 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -2236,7 +2236,7 @@ static int at76_alloc_urbs(struct at76_priv *priv,
 	at76_dbg(DBG_PROC_ENTRY, "%s: ENTER", __func__);
 
 	at76_dbg(DBG_URB, "%s: NumEndpoints %d ", __func__,
-		 interface->altsetting[0].desc.bNumEndpoints);
+		 interface->cur_altsetting->desc.bNumEndpoints);
 
 	ep_in = NULL;
 	ep_out = NULL;
-- 
2.24.0

