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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AC2C43387
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 08:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 265A5208E3
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 08:23:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KchppJ9P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfAEIX3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 03:23:29 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39737 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfAEIX3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 03:23:29 -0500
Received: by mail-wm1-f68.google.com with SMTP id f81so3156380wmd.4;
        Sat, 05 Jan 2019 00:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=+rLfGMG1douxX9tiNwu/aG4jUvk5DpaW4pxLJqerjfY=;
        b=KchppJ9PHg04635SV9GZ8yG9tU9cI4wjzQ29C6nfa3gGnSFrGg9fETxASeFEUGZOBh
         QFz9EHsZKVt5aSV/l6oXy5R7ZpwgAewaXlZZvpJcrBscIFGIaiPz7oTOPJMtFCR8Hy5J
         8WU73gpoMQkid9Oz0EdNOHWHX0V4RLsegrgtOhoAsmbuX4lAk+isskcx7YJAPLuBUBh1
         4lcbTxbIRE/Y7E4q86wZNUIP/NRF/rIfRXJWCSzPh8Cavy7tAvOSZz5w5D8L3MJmwv0P
         hKmsn0d76if6wfdATqyu+U/ohP65OGJrxouISWrpw//+fCNVAvzwGuKGiAAeYxmy82e2
         1tXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=+rLfGMG1douxX9tiNwu/aG4jUvk5DpaW4pxLJqerjfY=;
        b=b4pXFeHb8rJwucn4Y0WoMwtBFj5Y/Y1VGHBKB/EriRkhGSERyqDsjpcguoyawCvDwj
         mcMqj4VvxMWKkPviE1fArVutKPfqp1dLFij4QR2RAYjJ7HsxE1iNTYbdvH+VwxKYyAg/
         GR981CWI5L1mJeJEcFtykDbDf+J/sIdzritpZW8ueKYXM+8hJd6dSlWoopCYTKtORE8W
         3bdNIWHgF8JI7kBZLprn7ivZRUE3UoVvKkhEd37Fciv5M+agylw0I+jr3BlBby2kdAKR
         rYu8R9aKg0Jw3wyYoHsyRMBf0+ei8F/kJNv1H/7mlVPrwtXaYYl3IIcxJkJyeHIudZ+o
         V/RA==
X-Gm-Message-State: AJcUukeBzx2NkBbiTL7VhSli0/FyOg6L40G72B21aQ8q17zYUe4JfOzI
        ZiE4tREjCVn16BtcuwvL2JUuRTg/yzdhzw==
X-Google-Smtp-Source: ALg8bN4Zn1XzsvgGPjCL/x7Z64kbFLkjr5v1xwOwSVL2nK+yOmhODPIjGjuKcu1mPKxwMGyC9kXQgQ==
X-Received: by 2002:a1c:410b:: with SMTP id o11mr3525130wma.109.1546676606844;
        Sat, 05 Jan 2019 00:23:26 -0800 (PST)
Received: from localhost.localdomain ([185.140.29.250])
        by smtp.gmail.com with ESMTPSA id b129sm2326732wmd.24.2019.01.05.00.23.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 05 Jan 2019 00:23:26 -0800 (PST)
From:   "=?iso-8859-1?Q?J=FAlius?= Milan" <julikmilan@gmail.com>
X-Google-Original-From: =?iso-8859-1?Q?J=FAlius?= Milan <jmilan.dev@gmail.com>
Date:   Sat, 5 Jan 2019 09:23:23 +0100
To:     linux-kernel@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        gregkh@linuxfoundation.org, ajay.kathat@microchip.com,
        adham.abozaeid@microchip.com
Subject: [PATCH] staging: wilc1000: fix cast to restricted __le32
Message-ID: <20190105082323.GA27838@localhost.localdomain>
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

