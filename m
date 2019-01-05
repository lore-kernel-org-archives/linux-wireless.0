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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18DA2C43387
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 08:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBCDF2070B
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 08:32:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YiRBOpgE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfAEIcV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 03:32:21 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36700 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfAEIcV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 03:32:21 -0500
Received: by mail-wr1-f68.google.com with SMTP id u4so38458284wrp.3;
        Sat, 05 Jan 2019 00:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=+rLfGMG1douxX9tiNwu/aG4jUvk5DpaW4pxLJqerjfY=;
        b=YiRBOpgEAYGOVkJrBtcdGSckWMkEXHVD052b5Sp7V0bfQ5L2tRyErhnHIVwfYkl4bK
         otfM9qrc3FYoKv/H1cItFRkoHtkEk/Nh4c5RQti7n5Mx4C2r74OwkYX9gb8T3Iy/ngrC
         9RE8XaDK88Sx7yxv1uboaF3T7mnCBF9LAMiCailxGM5CCeGs8mz79IJoFAA9E5IMgs8H
         ebD5bPGpetsvhs2vgfrBH8NAnd2YVuX1TeTTCcY3X5w+KQRgRGarx4FrFJFfbCFamid9
         Z6GxFQGlJK6iDb0CItj2p31aiZPKmJITBGqpwUjovXZzHwxQ4AYYCd5gD98en03wJXrM
         1ZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=+rLfGMG1douxX9tiNwu/aG4jUvk5DpaW4pxLJqerjfY=;
        b=m0ZGyotCzTuOLGwjK3WOiPjeZCqGobovfKIXcjUbHQyxWuRBHLJx15rByF4D3dNjm0
         67zW1TMSStm6+pi0olLuomG9q44Zq9q9kKAcAXIwAvJtCHWl9/1wGwLs5JcP4fOgH38i
         7FxdTfftl+q2gee89IaFp/pnAjaWlEu0ru0tsAzHt0rlaJaEyUQlW5hSII46XguRpPx1
         r6p6p4x01a2Jdc2aiv1Lt+lpNqCno6n3k6GkoP61opG+dV12+rIjWl2OZvdjn72Hf7EQ
         4oIdcEQh7knHBNT1BtMucVI6tsl0n4812V2F/gOg/sWdsWbSa8rp1pV6y0TrxNT1rTTN
         HQ3g==
X-Gm-Message-State: AJcUukepl/G0q2ZcL+eTQXuSRdCv640KwSngHk8MsTQCbS7dALnpdkZ0
        rm5Y0Mcfq7J/wHMTa9dkFgPSvUs3CwU=
X-Google-Smtp-Source: ALg8bN5YCKimEOD2LwjwBL+8PG50bugb2cXke0e6cLKjlEFWdlI+ubxnnKp1mJEjy8b8GZWixTdCPA==
X-Received: by 2002:adf:f052:: with SMTP id t18mr49302938wro.112.1546677139207;
        Sat, 05 Jan 2019 00:32:19 -0800 (PST)
Received: from localhost.localdomain ([185.140.29.250])
        by smtp.gmail.com with ESMTPSA id q9sm66282701wrp.0.2019.01.05.00.32.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 05 Jan 2019 00:32:18 -0800 (PST)
Date:   Sat, 5 Jan 2019 09:32:16 +0100
From:   =?iso-8859-1?Q?J=FAlius?= Milan <jmilan.dev@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        gregkh@linuxfoundation.org, ajay.kathat@microchip.com,
        adham.abozaeid@microchip.com
Subject: [PATCH] staging: wilc1000: fix cast to restricted __le32
Message-ID: <20190105083216.GA28108@localhost.localdomain>
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

