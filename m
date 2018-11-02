Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86337C6786F
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 20:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B7FA2082D
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 20:50:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B7FA2082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbeKCF6y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 3 Nov 2018 01:58:54 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37015 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbeKCF6x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Nov 2018 01:58:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id z3-v6so3261280wru.4
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2018 13:50:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oWHr0wwXRasiyzF8nzJYbCrk6mWK3KDKMBJNra/6ZZs=;
        b=gi+6yDycuP3C+6Kl2cx5vfj65igbOrVxQkr3cGYi+WccvgeXJw6LATh5la1R97FkE7
         D7/TBqlZxM/2jnZABNUQwPSc6cjWkUm0zBBqDObbUMceTOSpfCNyU6XOodYyDPPp31Yb
         UKB+00ZFTj2jUQX9cNfiaRhCptXZcDv5PrJdNzpVBMpXyqxTkm+c8IK5afYKTsWUnHG9
         1YBaFbOzX8yDy/b7ccagfgLWoL5GhkIGKGAQSglnkxBlUK969vTifqDNottVEUtjGhmL
         ZV5Gvt+4uVTkdrDM8qhg88WFxV49QLQeTCJdqvVwqgRFXh3bNa3gf+hBe5zOh+5T03TM
         7EPw==
X-Gm-Message-State: AGRZ1gJDy/QZkGVvYiGMHdJ//ivSz3Q0y1or3UoOXwjFh7u4iJK4s5KI
        pIToFy6+gbkm1cU7v26yOz9OLzExTJU=
X-Google-Smtp-Source: AJdET5cyspBvYJxOj4o8kw2ufvgMZr7WOm8veMA9Ij/hJc2HRHvfUWBUDYtQUU+0e4DVYFzR3s9LRw==
X-Received: by 2002:adf:f941:: with SMTP id q1-v6mr11072286wrr.151.1541191814062;
        Fri, 02 Nov 2018 13:50:14 -0700 (PDT)
Received: from localhost.localdomain ([151.66.16.197])
        by smtp.gmail.com with ESMTPSA id c14-v6sm28349450wmh.44.2018.11.02.13.50.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 13:50:13 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     koen.vandeputte@ncentric.com
Subject: [PATCH 5/5] ath9k: dynack: remove 'experimental' tag
Date:   Fri,  2 Nov 2018 21:49:59 +0100
Message-Id: <c3a0b7cd47466f00ee5449c4ce26da328aff5232.1541190974.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1541190974.git.lorenzo.bianconi@redhat.com>
References: <cover.1541190974.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove experimental tag from dynack Kconfig entry since it has
been tested on outdoor 25Km links

Tested-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 1f3523019509..ceca23a851d5 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -116,7 +116,7 @@ config ATH9K_DFS_CERTIFIED
 	  except increase code size.
 
 config ATH9K_DYNACK
-	bool "Atheros ath9k ACK timeout estimation algorithm (EXPERIMENTAL)"
+	bool "Atheros ath9k ACK timeout estimation algorithm"
 	depends on ATH9K
 	default n
 	---help---
-- 
2.19.1

