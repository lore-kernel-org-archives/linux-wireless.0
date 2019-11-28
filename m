Return-Path: <SRS0=WqAe=ZU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 029CAC43215
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Nov 2019 17:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE8E121826
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Nov 2019 17:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574961886;
	bh=RAYe5u89j0gevqYuxVl//afQVDlQK+7EMpuQardxMTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Sr6JUzD6L8mDIuLyldcR9zgCL33O+ns/AVZYr3rbUFr2BEcSmrtee38V9oSmux+1i
	 6sChgdJr1cGusqFsgdSsKmhF33o/7hMk6HPLGb06jiKOQatgE9ZISKGrj63ZccY+PX
	 Bfn5oXDOgf4NC40DvJ2fap+/QGjMVPsHvcMragMA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfK1RYq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Nov 2019 12:24:46 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38285 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfK1RYp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Nov 2019 12:24:45 -0500
Received: by mail-lj1-f196.google.com with SMTP id k8so18720909ljh.5;
        Thu, 28 Nov 2019 09:24:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pNXr26dRu/aWo/ZNTMnDAua6PjrBe7AfSoIfHjNsLPE=;
        b=DijGBPHU15acrYKJtI3L20TQdWuWDnCZSor5ygvTiyRAiiGAEmDvxn0Z5qRNVXt45G
         zDpfMzKD0N4lgGPT44ht37yOK2PgZPIMx8ry5ygfW836puozD/o4hcVZch/CnuEk66wP
         Qm4vAZP2bA+TTL5hGlX6uF3JT3PX9L4Iiv1NxuB9k09UuYVTaFFt10KeVQUcndPPFMpb
         6DLtmkYgydOiI8vkeKWTwFZs3FD3JKKN3CUhqjyaDzP2VXcABZnUAElpRQvqsYHkDeu/
         KheLYEroZGi4527HwJXR7Xe1YyExRRBy61FO6dxNFnKltJLejcK1RKYBVFm+04/el6OL
         UFFA==
X-Gm-Message-State: APjAAAWn437P/sM2CLJ8Fc2Nx8dVMGVbk7YQdWFdooxdvPS2z6Tekjv+
        vfzWsUvKDFbJIxGweaRlm9c=
X-Google-Smtp-Source: APXvYqwTGHlPMSUQNTb3ZUCf6aq5gzdY12/WN1GGQebXicNweZ5WxFIrPWT9g4iavEJoZJ+5Nmt4vw==
X-Received: by 2002:a05:651c:305:: with SMTP id a5mr35814469ljp.144.1574961883728;
        Thu, 28 Nov 2019 09:24:43 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id f11sm4733771lfa.9.2019.11.28.09.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 09:24:41 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iaNWz-0006wb-N6; Thu, 28 Nov 2019 18:24:41 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 3/5] rsi: fix memory leak on failed URB submission
Date:   Thu, 28 Nov 2019 18:22:02 +0100
Message-Id: <20191128172204.26600-4-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191128172204.26600-1-johan@kernel.org>
References: <20191128172204.26600-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Make sure to free the skb on failed receive-URB submission (e.g. on
disconnect or currently also due to a missing endpoint).

Fixes: a1854fae1414 ("rsi: improve RX packet handling in USB interface")
Cc: stable <stable@vger.kernel.org>     # 4.17
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 30bed719486e..2c869df1c62e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -338,8 +338,10 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter, u8 ep_num)
 			  rx_cb);
 
 	status = usb_submit_urb(urb, GFP_KERNEL);
-	if (status)
+	if (status) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in urb submission\n", __func__);
+		dev_kfree_skb(skb);
+	}
 
 	return status;
 }
-- 
2.24.0

