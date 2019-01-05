Return-Path: <SRS0=nI2m=PN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B3FC43387
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 11:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0539820645
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 11:39:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z8h5nhLd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbfAELj0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 06:39:26 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37672 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfAELjZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 06:39:25 -0500
Received: by mail-wm1-f67.google.com with SMTP id g67so3388607wmd.2;
        Sat, 05 Jan 2019 03:39:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=AzSmhYUNSNe5vSYv5BojS9K6e2rjC7kEkfqO4kLJ3Hg=;
        b=Z8h5nhLdRomHqOuBqYvaqDIHnSF62hzTWRdgJ+6zI5Ub0UfD/YNMkeOlwwe11GNR+p
         iAXhiimw7A+sdvwFerOzNHbs5xoQqGdOPiKCxl2jkHl8KM2ZRzXUdZySOT66iOIq99uc
         VjD58awww+cNyCOEfLNwU9DNJBAWI0vaToxUS+c/aHY0T9CEr3T7/IueAWeqzG+3+Iaw
         Poh438Uk0+IjQbyBTOAAanNz6l6rmcYsCEXPa+k+7oUkVStuVVKJ++sD1S9KirrazqQc
         El3Apt3wV03fiG7GE121tqGD2KoOlGee12gmKbVTEoDJrJt8NhqEfXGjyN4flWwdDv0j
         Y+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=AzSmhYUNSNe5vSYv5BojS9K6e2rjC7kEkfqO4kLJ3Hg=;
        b=sFAW2Dxnlc+Eg/ZY9/Hg5ualf4mi2JkWkJ8ZZcSpo+y9CgLSNmTiUb6asKLSMxmUcQ
         9ZWhHWsY1yB01w1nIxUl6YjCuAPorNEJ7ekQtVaGIW7XEhKmbfkNnZk7ce7Szz+o6y6u
         WqiZfDekOQAQ8nIf6dtLj6Z8+a3YQrqUorpjS+DcSTY0nLgz9reriyShdftf8meYqB+S
         RzWSMDsdbkIi4lXhjKtX2SWXCC9qr93q66rM80BjWrAqnhXmQhu6Jj7TMALAeS7YHwog
         W+HWyZqkVbwPkOprYdnCdT2tvHS6zksxAb3dAjhruYxewutbaWoqpnGNKMwS/a9NSbj/
         WaxA==
X-Gm-Message-State: AJcUukeTT4ERifnvfIyMjJmRScAVNqb6Lw0e4V2Frenn8G6ycRcEUdMu
        URP4JGWaB9j/F1TL1M/9ecuzJAf0
X-Google-Smtp-Source: ALg8bN5KACqfFY270YTH+di+vInq/ZEMjWL3YW8XItO1lm9FoxWTCYzYKwPKQzSc9VIs24I9VbN+Ww==
X-Received: by 2002:a1c:d74a:: with SMTP id o71mr3885216wmg.73.1546688362815;
        Sat, 05 Jan 2019 03:39:22 -0800 (PST)
Received: from localhost.localdomain (178-143-129-241.dynamic.orange.sk. [178.143.129.241])
        by smtp.gmail.com with ESMTPSA id g67sm5145933wmd.38.2019.01.05.03.39.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 05 Jan 2019 03:39:22 -0800 (PST)
Date:   Sat, 5 Jan 2019 12:39:20 +0100
From:   =?iso-8859-1?Q?J=FAlius?= Milan <jmilan.dev@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        gregkh@linuxfoundation.org, ajay.kathat@microchip.com,
        adham.abozaeid@microchip.com
Subject: [PATCH v3] staging: wilc1000: fix cast to restricted __le32
Message-ID: <20190105113920.GA30908@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes the following sparse warnings:

drivers/staging/wilc1000/host_interface.c:2360:30: warning:
 incorrect type in assignment (different base types)
    expected restricted __le32 [addressable] [assigned] [usertype] frame_type
    got restricted __le16 [usertype] <noident>

Fixes: 147ccfd451024 ("staging: wilc1000: handle mgmt_frame_register ops from cfg82011 context")
Signed-off-by: Július Milan <jmilan.dev@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

v3:
- nothing really changed since v1, v2, I just messed emails and then patch
  format, sorry for that, it's my first patch :)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5dae6e7155d3..07c3d6293573 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2357,7 +2357,7 @@ void wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 	default:
 		break;
 	}
-	reg_frame.frame_type = cpu_to_le16(frame_type);
+	reg_frame.frame_type = cpu_to_le32(frame_type);
 	result = wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
-- 
2.14.5

