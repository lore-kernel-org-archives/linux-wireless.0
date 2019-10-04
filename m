Return-Path: <SRS0=IBNP=X5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0D61C4CED1
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Oct 2019 14:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9E57222CA
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Oct 2019 14:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570200361;
	bh=Kp7VuvFTRPVIoBYiwjPrQ0tTuFh0qAbFY/3e2efh+gA=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Un1w7zcnNoUUkXyCGo1YJQzp5zmLy7N4YmB/Xuj/LrclmyUVGfw0GwYCT1USjtTuE
	 6xJXhg8cgvyBq4i5fi5OwSeNiNy8VBsGrWUTV0bXbEXjX3nZ7l1348/4vkt50eaXfR
	 aX3RVhmm8QXvlezcwsI5Of2j/90Rezkc20epdB+c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389372AbfJDOpx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:45:53 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37077 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389136AbfJDOpw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Oct 2019 10:45:52 -0400
Received: by mail-lf1-f65.google.com with SMTP id w67so4681330lff.4;
        Fri, 04 Oct 2019 07:45:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=41QFKhTKVw0r48ZhA+a3ExQuzLOYbcSClKQP6ZHYplY=;
        b=NaCJdxmirxyJP/KpxD50qItbwZDFQIlUdsA5gju1LjFOBei/0mpmX24PiLKH4+jHZt
         Jr5lZ/2/B+mafNMIzNw1eTNGV/Bk2E5AcohEw9J0ViJ93Lzy42uOL13G54n4+YCrdbxz
         NsRCslGUZGhT+Ccf6F0kQK27WHVbkj8n9MrFJuXxNof5kJdD8n09sTt46FPd9ekwRSf/
         VjpZxorAFTi9PVu5cBB9VfdwirMAJGd6xoQjbUkrwUTnYYLXdSsWGGgpPODj3WT7q6Ka
         GQ0mlV4T4rqCagbvyP6yUA+S2S6d9WhONmvvsLMp5JFtdTf30qsnmT6/yjy0w5S9Blh0
         CiUA==
X-Gm-Message-State: APjAAAWCL63Z3nM7htbpoz59iyIpn96mK9tl7gnic6pKO6mPgJsogP8w
        H6/P0rhkxHSAfF9Y/76WIEEsx3k5
X-Google-Smtp-Source: APXvYqwoyp2pDz11DUVf5PxE3ytN1hgT396kAmXEEpx4FfU2SPT2GaaBEfvO/egu9MZI9T25qQkHRA==
X-Received: by 2002:a19:710c:: with SMTP id m12mr9438052lfc.41.1570200349750;
        Fri, 04 Oct 2019 07:45:49 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id g3sm1326422ljj.59.2019.10.04.07.45.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 07:45:48 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iGOqG-0005V1-1n; Fri, 04 Oct 2019 16:46:00 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 1/2] Revert "rsi: fix potential null dereference in rsi_probe()"
Date:   Fri,  4 Oct 2019 16:44:21 +0200
Message-Id: <20191004144422.13003-1-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This reverts commit f170d44bc4ec2feae5f6206980e7ae7fbf0432a0.

USB core will never call a USB-driver probe function with a NULL
device-id pointer.

Reverting before removing the existing checks in order to document this
and prevent the offending commit from being "autoselected" for stable.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 23a1d00b5f38..760eaffeebd6 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -793,7 +793,7 @@ static int rsi_probe(struct usb_interface *pfunction,
 		adapter->device_model = RSI_DEV_9116;
 	} else {
 		rsi_dbg(ERR_ZONE, "%s: Unsupported RSI device id 0x%x\n",
-			__func__, id ? id->idProduct : 0x0);
+			__func__, id->idProduct);
 		goto err1;
 	}
 
-- 
2.23.0

