Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC59C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 14:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA3472087F
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 14:43:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BxWxNzpz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbfAGOnL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 09:43:11 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46013 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727643AbfAGOnK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 09:43:10 -0500
Received: by mail-wr1-f66.google.com with SMTP id t6so630274wrr.12;
        Mon, 07 Jan 2019 06:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=zVDROSnfZqLIC6uZXDp4ZJBmcMkYcpBLNcGKIHLNFsY=;
        b=BxWxNzpzDYiwDufPtwATgV6wzZ+wgzBpaE3R+Aly2caZ3NmD8/9ayJJwdQZT42bUFi
         Vl/9LhYT5tG/aF6K9SaU08+yc5yggY5IzJZPb685SXu4Q1aLUYCePCwL5CexJp1dnQco
         oyXRS3mIMafyWxicm2uXNyiVcWnoFRBe1gQVrMueZAafssD37moPkEigQydgxnYX/Q8k
         3w5Hf4BZqNgqv1oErNDRgKNanzDjuMOBYIdW+aDUFdI/vkn0f5hGgNOkJGos1FfjLLXu
         u7OsKMVpOI+SOgY20Nevu1lRDgiGoS4o/8JNBIbuus3PNy8qVEYqPC32wCeTjV9mQln6
         ODcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=zVDROSnfZqLIC6uZXDp4ZJBmcMkYcpBLNcGKIHLNFsY=;
        b=rp9jUdFRp/KGAuOg09HxKpxiJiovtdJD1JQ2eoax7ZQmndbDs0u11/bZstxBlXMCHh
         Ibv3NnINlxkJyyaf9tbJ1VOAqz6Q2wfAIIdyJFsRQnIidSOzsDIu+LmnMSzKq7gqF8sg
         AcxPvDryJFkJcQsf0b4o4VDgoWWLhgbBDuMZzy65EGR7WaxZpXD7KW6jvvvrMgMRr+5T
         BBTxnYSS61x0SVOVGr2InXps/6wrl0B9giVx1lGPFMRnzsODV0weT/nO+9l4W0n5G/0G
         puAmkGNk+yyytVP+L9wQ91ZqGkV6r4nt2RXwpnpuRW/RBxh1BNfMVapLlX2FIAlQQ3k+
         U+Zw==
X-Gm-Message-State: AJcUukfKfvYAPlQNmRqtfNommiC5f0Zi8sZF8UeqJlmlSi9NZpfucpy/
        dSeu2Zt4h1moKpyYu+hA2W9BgXF7
X-Google-Smtp-Source: ALg8bN65+B1HZkZASV8Ox/+o+od/RCs/nT5U4WD8pOnpMlF7au7liKPdWeOvbLVv/IINKs7jMmtQlQ==
X-Received: by 2002:adf:8b83:: with SMTP id o3mr54903739wra.81.1546872187970;
        Mon, 07 Jan 2019 06:43:07 -0800 (PST)
Received: from localhost.localdomain ([185.140.29.250])
        by smtp.gmail.com with ESMTPSA id o17sm16359259wmg.35.2019.01.07.06.43.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Jan 2019 06:43:07 -0800 (PST)
Date:   Mon, 7 Jan 2019 15:43:05 +0100
From:   =?iso-8859-1?Q?J=FAlius?= Milan <jmilan.dev@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        gregkh@linuxfoundation.org, Adham.Abozaeid@microchip.com,
        Ajay.Kathat@microchip.com
Subject: [PATCH v4] staging: wilc1000: fix registration frame size
Message-ID: <20190107144305.GA14627@localhost.localdomain>
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

v4:
- changed struct wilc_reg_frame member frame_type type to le16
- reverted cast of frame_type to le32 in wilc_frame_register
- changed subject line, previous version has subject:
  "[PATCH v3] staging: wilc1000: fix cast to restricted __le32"
  https://www.spinics.net/lists/linux-wireless/msg181166.html

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 70c854d939ce..7acb790d850b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -36,7 +36,7 @@ struct wilc_op_mode {
 struct wilc_reg_frame {
 	bool reg;
 	u8 reg_id;
-	__le32 frame_type;
+	__le16 frame_type;
 } __packed;
 
 struct wilc_drv_handler {
-- 
2.14.5

