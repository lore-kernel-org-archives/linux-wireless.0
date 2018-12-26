Return-Path: <SRS0=rEuJ=PD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD66C43444
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Dec 2018 06:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB74021720
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Dec 2018 06:44:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="Y+7EavdB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbeLZGoC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Dec 2018 01:44:02 -0500
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:58850 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbeLZGoC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Dec 2018 01:44:02 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 9A9F8956
        for <linux-wireless@vger.kernel.org>; Wed, 26 Dec 2018 06:44:00 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ss6vqT3hZw5M for <linux-wireless@vger.kernel.org>;
        Wed, 26 Dec 2018 00:44:00 -0600 (CST)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id DCE4169F
        for <linux-wireless@vger.kernel.org>; Wed, 26 Dec 2018 00:43:56 -0600 (CST)
Received: by mail-io1-f71.google.com with SMTP id s25so18589590ioc.14
        for <linux-wireless@vger.kernel.org>; Tue, 25 Dec 2018 22:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=LEca6Xts+zVHh0AgI4asPdaU8TuXEc059b4qJWAorB4=;
        b=Y+7EavdBCRELfYQN1c34errcdtuvEj7OXXdKe6cI7C9epiN94sbChz2W43sYLAmzEX
         Znt5TeBDsKPaWHWBjF2pz77wzo7Y4vwTrjSLjEr/7FDrOQjSzhr5AKIo5Czr7eNy/l+k
         7WQjItZ0ApUatcqCUbwt2TbGfVp8uxeRea8fKqsJDly0xEYZOGoYjZjc1tGSuloOkMoO
         BLd8yFHPFotPiOIljKBZGqClburbceSntq1icM9eoq7jYZ2z3FS8GhZlg/DJU+aSXtPo
         FSMWDmu1DlLTBJQCBba3+D6ZWz6GPzYw3NKFAFwklpYFod1y9nAi0mhhgLtHCm/M8Jh8
         Ob0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LEca6Xts+zVHh0AgI4asPdaU8TuXEc059b4qJWAorB4=;
        b=ATfbnW9YJ/GplV4G2ELJM955RQnvccvBXX3wVN285DNY+5p0i+isOwur1aeXlkAazB
         Vo+7zcyYam43atbK3iDGov9fnm4PAMHL9xe+rWJh2hbMX1A8BKjw6swhMgvTwohPDZ7k
         m3DLcRsr/V1Z3LiLpC4miG4LRyhYTChlHLFkt+Anpt/zGpqZvATzjTihtvZFMJqhBPu2
         x+cPytQ/G68fdPDtKwd2vRj4EJZDzEeDHCZvR6GZY5gBHbc2T8ZckS6xcm3mScg5ZXSN
         BU1V00x/McB2JyF7Sk4WNVriQ04fJYm9OKljeWEbo5jzAoNgfbaK7FciXJb05J37kBAs
         GDFA==
X-Gm-Message-State: AJcUukfW111lrBinvwZJO5NVAWH0QI4OU8sP/0l07WMtfwbEswESRdE2
        eG8+InecWTHrMW++uUTtPtKqsqTQIplxLvd6c+bBHSiyoN6fyp/NQ8pJXWKJ38UHn8WC6wJ1Jry
        oT4XYpEzeJPBqdqFn4GLYiN/2FcbSjpA=
X-Received: by 2002:a6b:ed05:: with SMTP id n5mr6538835iog.212.1545806636463;
        Tue, 25 Dec 2018 22:43:56 -0800 (PST)
X-Google-Smtp-Source: ALg8bN5S/eg+sG2rlpmZfjzmo0Wcv3S9JrKzU1Oj9d8l+u879YVJHVg1CoqHHqLmrDoYdH9u7oKRpA==
X-Received: by 2002:a6b:ed05:: with SMTP id n5mr6538829iog.212.1545806636226;
        Tue, 25 Dec 2018 22:43:56 -0800 (PST)
Received: from localhost.localdomain (host-173-230-104-22.mnmigsc.mn.minneapolis.us.clients.pavlovmedia.net. [173.230.104.22])
        by smtp.gmail.com with ESMTPSA id k18sm15704049ioa.39.2018.12.25.22.43.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 25 Dec 2018 22:43:55 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: ath: return error code upstream
Date:   Wed, 26 Dec 2018 00:43:28 -0600
Message-Id: <20181226064328.75897-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ath6kl_wmi_cmd_send could fail, so let's return its error code upstream.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 777acc564ac9..1f3cead3180b 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -776,10 +776,8 @@ int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi)
 	cmd->info.params.roam_rssi_floor = DEF_LRSSI_ROAM_FLOOR;
 	cmd->roam_ctrl = WMI_SET_LRSSI_SCAN_PARAMS;
 
-	ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_ROAM_CTRL_CMDID,
+	return ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_ROAM_CTRL_CMDID,
 			    NO_SYNC_WMIFLAG);
-
-	return 0;
 }
 
 int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid)
-- 
2.17.2 (Apple Git-113)

