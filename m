Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0C0C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 03:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD6D320854
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 03:19:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="nnVtm/8M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfCSDTu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Mar 2019 23:19:50 -0400
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:46734 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbfCSDTu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Mar 2019 23:19:50 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id D6FE7B45
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2019 03:19:48 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NTfpJi6O0JwS for <linux-wireless@vger.kernel.org>;
        Mon, 18 Mar 2019 22:19:48 -0500 (CDT)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id A7631994
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2019 22:19:48 -0500 (CDT)
Received: by mail-io1-f69.google.com with SMTP id k24so14996678ioa.18
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2019 20:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=fHMSauccrIJ9HihNDOavw9LAVGK09QKXxKSO/H0MbjE=;
        b=nnVtm/8MN7bK1K66rhuZ624aJBIK8T50Z2c/ARXOugIpTiH6hl+Z87hhFe5Ak0l0DI
         fbBhh7o18k3HQ80Rv87c+OIxwHB1I+yL6sJ/khrCB302jQREZBN/gSibY8vMUtsN4U7w
         FfMSo9m28zmzzyGl2CSSLX5SitSDbRQLxruAsuO3Ro44HlXUhoZ/zuzrf3Nc+vsjxlFy
         x8YZXCjb2cSyaMOoGV8t1WjNKJsAwfnSaLFITDwhMkCNC08b03doZXoUyve1Wx7qmB1h
         P3+wKpzDDwO11QbkrRSzHjUIWfxiZ2d+JxlG94mI7kavc09LHeSUei7Osh3wCT7mZ42u
         gqpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fHMSauccrIJ9HihNDOavw9LAVGK09QKXxKSO/H0MbjE=;
        b=IvUmI4gun8GmY4/qtBcHz3+lgNzmjiI3sxZX9gq7cwUxqscjIHruuqkd+DsH27O435
         QqyfwznqJEh7TkpIdxcXcGUae91LvYNFPdzautI7SV8DFNxq3V0+vtprovKVg/m3OwaO
         2SmfV6QKXsCsfeoxW3ghRYGNHjaI5Tp3DfEwMZPEs8JsOXLvIgLYP3rC+46GOQpYy6gL
         5rWodZjfZNhAauCuY6IxaYv5KqxhA78kUWq8hKk/EjCvalYdHUkC/mL2+Qs68lc3jV1/
         7ZTVTS0wgueaC6+z3lF1tCMK9cdnoSSxghTgMx8KiyUP3Qji6mj3ur9DAi17RTwMq3gU
         R2rg==
X-Gm-Message-State: APjAAAUB726e51g/UDHWae1TfZ7vSn2O2iotsAN3tgPXFBY2aBCX59Xe
        xfe3HPEvz7er1buO1HC1dzcZh0ROIXYojLhvWODwyvIPzTjOy01Aj9iSLVE3dzZtR6KFP9yrleK
        QZ2Lx1qb+Kl5FPwH/qwzHGXXM0dUmWmg=
X-Received: by 2002:a02:b703:: with SMTP id g3mr137942jam.106.1552965588332;
        Mon, 18 Mar 2019 20:19:48 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwzeoP/kvrNPPv201hX0xDPECjhwxZLnNlLFv8wbsnFiAV5IMiJ8QiU35yw/YyQCLM2CyVLyA==
X-Received: by 2002:a02:b703:: with SMTP id g3mr137934jam.106.1552965588156;
        Mon, 18 Mar 2019 20:19:48 -0700 (PDT)
Received: from lenovo-1.hsd1.mn.comcast.net (c-73-242-25-233.hsd1.mn.comcast.net. [73.242.25.233])
        by smtp.googlemail.com with ESMTPSA id 202sm940459itl.1.2019.03.18.20.19.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Mar 2019 20:19:47 -0700 (PDT)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: Fix to check for kmemdup failure
Date:   Mon, 18 Mar 2019 22:19:44 -0500
Message-Id: <20190319031944.18984-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In case of kmemdup failure while setting the service name the patch
returns -ENOMEM upstream for processing.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 net/nfc/llcp_sock.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index ae296273ce3d..17dcd0b5eb32 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -726,6 +726,10 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 	llcp_sock->service_name = kmemdup(addr->service_name,
 					  llcp_sock->service_name_len,
 					  GFP_KERNEL);
+	if (!llcp_sock->service_name) {
+		ret = -ENOMEM;
+		goto sock_llcp_release;
+	}
 
 	nfc_llcp_sock_link(&local->connecting_sockets, sk);
 
@@ -745,10 +749,11 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 	return ret;
 
 sock_unlink:
-	nfc_llcp_put_ssap(local, llcp_sock->ssap);
-
 	nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
 
+sock_llcp_release:
+	nfc_llcp_put_ssap(local, llcp_sock->ssap);
+
 put_dev:
 	nfc_put_device(dev);
 
-- 
2.17.1

