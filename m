Return-Path: <SRS0=458R=PC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1318BC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Dec 2018 22:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF2802173B
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Dec 2018 22:35:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IIRLjBNN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbeLYWfl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Dec 2018 17:35:41 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37714 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbeLYWfk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Dec 2018 17:35:40 -0500
Received: by mail-wr1-f65.google.com with SMTP id s12so14385634wrt.4;
        Tue, 25 Dec 2018 14:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5fOGnKGi1KW1Jz4CcUtu1Z5DWuG3MIq7WLWqYoCdj+0=;
        b=IIRLjBNNM0VqVpetxcJmWtHSkd2jP84odMC5rZJaDvJau3JT1UzGVBp1ovNvE+rfFQ
         QClooqfZZTkfdbZDXSXFVPnHJ5Z3ge+174VIJJ89zPaPSlKjpZAU2KOMv3fpKB7DTLVZ
         cl3fkCF7mXmhlQ28o/oliNMHGcw6+K6huauV1ZhZHMbFpOQTXQh8OhIy9Skmh9g7OpmY
         kHpBhZjZKmHU7rUCbfwHtfI28m/MPIbdJGQDdw7DwqAQTtXveTdaiFKzw72tqA/KBM2m
         DZt4P7v7mS9GQca0Ck6YPdpPHpo4XGn/soV771L6qoMlqwwiYt/ffF2MFrfZIj0McO6P
         Z30Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5fOGnKGi1KW1Jz4CcUtu1Z5DWuG3MIq7WLWqYoCdj+0=;
        b=YN9SKbuuk0XFppVIen7v8XfXwi2Y3RMCQ/x8mdjmoV/bKZuBTyF1lB3WmnnVo3t+lm
         PHNe9bMRHhlDpwQ8deTe0k/ajsW2+05a7ABC0diIs+S26ZymY+JDUJtaeilG02HdSLRd
         grsmDblsf3UQFGAQCGlU8G+FU/dxdrzh9MUU2vRJK4kav8tvlud/qyAbRI9EZq6C6BYU
         dzwh1G/s0CvRz1m+Mu5MLMZZT4kqkwbEUD3fZISTWDF9X88SDHZXxYLWo5y1r2yJxqWW
         adHyc+Y76ME7dYggDEOb+Io5i3A3UDaR2F4m39ApGY1YRL1zHC9IBO5uAfCiBYV8F0Ik
         Irfw==
X-Gm-Message-State: AJcUukdD25Ynfxuu/E/9AndgnBigVPGAHZldlh42bhGWoEeZCbO1toZ7
        MicR5opWp0IMzXmz28G49xM=
X-Google-Smtp-Source: ALg8bN4b7BnzhCijb336+kQBXvdCIEyVVvSTQ3NX5ZUxJe+N1l9lbppa5SbuHry6d5/VoVEZt0DXwQ==
X-Received: by 2002:a5d:4b01:: with SMTP id v1mr15595534wrq.5.1545777337975;
        Tue, 25 Dec 2018 14:35:37 -0800 (PST)
Received: from norris-440-G3 ([5.134.110.166])
        by smtp.gmail.com with ESMTPSA id z14sm17261673wrm.48.2018.12.25.14.35.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Dec 2018 14:35:37 -0800 (PST)
From:   Marko Stankovic <dartnorris@gmail.com>
To:     adham.abozaeid@microchip.com, ajay.kathat@microchip.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marko Stankovic <dartnorris@gmail.com>
Subject: [PATCH] staging: wilc1000: make function wilc_get_stats_async static
Date:   Tue, 25 Dec 2018 23:35:31 +0100
Message-Id: <20181225223531.7659-1-dartnorris@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Makes local function wilc_get_stats_async() static

Cleans up sparse warning:
symbol 'wilc_get_stats_async' was not declared. Should it be static?

Signed-off-by: Marko Stankovic <dartnorris@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 70c854d939ce..5dae6e7155d3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1992,7 +1992,7 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 	return result;
 }
 
-int wilc_get_stats_async(struct wilc_vif *vif, struct rf_info *stats)
+static int wilc_get_stats_async(struct wilc_vif *vif, struct rf_info *stats)
 {
 	int result;
 	struct host_if_msg *msg;
-- 
2.17.1

