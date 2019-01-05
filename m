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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF702C43612
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 09:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EB40208E3
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 09:10:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VaVBSqn4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfAEJKb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 04:10:31 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36508 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfAEJKa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 04:10:30 -0500
Received: by mail-wr1-f65.google.com with SMTP id u4so38505489wrp.3;
        Sat, 05 Jan 2019 01:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=+rLfGMG1douxX9tiNwu/aG4jUvk5DpaW4pxLJqerjfY=;
        b=VaVBSqn4Id2RUaOZKJ7EwtHA7s2ANA5XXdgm+tJtEPdVyy0ZrMEGREWV84oIaOjyvO
         LbcqRunbKZCppr2fElC+7thMTQlpSPcxdIJ93ffd+L0bkWiRKijfNOwK59NzyQa6NCGN
         a8eLjBWT4yZeJLs0N6bU8SNSlfW6r0yu9wOObYK5s8gB7sp8oRnv8PS208dcLpBl9q7r
         Wy8npJxhn6PlKegnNWTWWLg0cHxWJFi1sW5jTPLVKXVPYxMUSu1JsvtLYa2BVmXO9u8Q
         G+bNLnHXSJYG7PrGSYFEKtp84Gm/na8Gko3/vsenplxkglrBIQjN88Ho45xUXQK6RQi4
         aShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=+rLfGMG1douxX9tiNwu/aG4jUvk5DpaW4pxLJqerjfY=;
        b=W/O+iTp2JvDab7eV3asfyQapE4T3kpWsOIgWdzXMn8MSzpAK+VbgguMgV+yWuaJJGg
         mQR5DzzWRek+3lPZcQnf2Q2ncJfl8jdZMld5y/K73mvyldH26o7PExhhFUyMj4HUXnkE
         9oywmW0jo8ktP+oZUBLZXo7b71UWR6xrdKopO2jcFcBPvSWu6AE9BhWgjPmrp79QgYci
         WUBDDZEOJRg0YiDX8cWEjPX7CxsI/3BgvymmIzndS1DhWTFa9PvhGQjxGegE8pom3+bg
         AWE8VtstKmGBxqgD2V4Zx18l8Fxg5DCJ+bLr2t3PcCZFON+nyPbYkCAwwdW/Rdicz/4g
         XmJQ==
X-Gm-Message-State: AJcUukeJ6XHlrSNer0oPNlWnQmPNmS5c8yfTmV+piLi5ZfnHKkYdYIUs
        ZZJngWw9aFjJAMa6Jm7Km8Tcv8y6UcI=
X-Google-Smtp-Source: ALg8bN7r5Fg639HQnL2/CBo2Pibz+gZIsPMHr79lM+SaPxAW7znr6PtwO8bU6FzX5SiB/6La+tmK7g==
X-Received: by 2002:a5d:660e:: with SMTP id n14mr45732739wru.19.1546679428480;
        Sat, 05 Jan 2019 01:10:28 -0800 (PST)
Received: from localhost.localdomain ([185.140.29.250])
        by smtp.gmail.com with ESMTPSA id m6sm38583842wrv.24.2019.01.05.01.10.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 05 Jan 2019 01:10:27 -0800 (PST)
Date:   Sat, 5 Jan 2019 10:10:25 +0100
From:   =?iso-8859-1?Q?J=FAlius?= Milan <jmilan.dev@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        gregkh@linuxfoundation.org, ajay.kathat@microchip.com,
        adham.abozaeid@microchip.com
Subject: [PATCH v2] staging: wilc1000: fix cast to restricted __le32
Message-ID: <20190105091025.GA28917@localhost.localdomain>
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

