Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42232C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 05:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 000F620855
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 05:30:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VOCgF7ub"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 000F620855
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbeKIPJK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 10:09:10 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:45403 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727087AbeKIPJJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 10:09:09 -0500
Received: by mail-oi1-f196.google.com with SMTP id p144-v6so529147oic.12;
        Thu, 08 Nov 2018 21:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xrcsgjlNOYa+gpPGnMn9FJzPuleKov99jbnVt5Nn8rk=;
        b=VOCgF7ubBnuDtjRfD0PwT9jqP0BSO+3I2IJI3GSgUoi2Aw7yMJXtnHSwb2ngGRWw70
         KjnuWiWAkHX0GTYJ+NRx5lU09KfT8ZE+Sd4v5ANhJJRdEyvCSEN2qdD+9DQY8seHxWI9
         Mq0wgSSd53GysKEdss5wm0CeFCHJdVoQ6oB/tcxOFsTxxqSK4vCGvBOWm7jCRejVDjEf
         G5dIKfBPLtSgCqB8GzYaZhMJvdgDfPeynwI1Bg3H0+E3rHb4ApjPph5nHU2Y4y6WG9iM
         fvDALGdgSnoOoEuKQAnG45bEAzCtP7nPtu/aPMC78vcNiKIhWV79oDJkPnvRPiwmk91C
         EVjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=xrcsgjlNOYa+gpPGnMn9FJzPuleKov99jbnVt5Nn8rk=;
        b=aspQ6I+hcA4mxFaY0BZaSy5cUlIXASLjqU/2CXzWOjKA/MtZww2NNHvhMTNnWX0grk
         LUIWGx4GJHooFVw5bJTHnk2AlqaVRfpWa8OMUDc01cTzYzOX/M4xuCqkdSqFjjT6/Cud
         8aPJItl4J3Jmc1zjZ3ZLE1nCByKrC+DDwG1v5kU+Kh+sT49PsPXWheP1rP2hHW17txe9
         FGy+MRdklVAJj4ETXcodCJTUlHhGJz055CRhrE+yd3Izhb1fliKWfK0xt1lPqlLZPP8W
         BnQNt/83kUiiTDyC8QcjEvvSZv3rj4eAIR7G5kteWyoICHCSIHmbOV6vZZ8sy0RZGI8k
         AzmA==
X-Gm-Message-State: AGRZ1gJHgWit7jr9FJIW9AZg0aVc2a9L+Y7TqYLImgjcaCzg7SeIdkGS
        oNEAZz+5O7fUilDZ9SN4mDw=
X-Google-Smtp-Source: AJdET5cJ5rR7+0jR4apyuh1n5xU+Q/YyUcdpcfRX+/9faHGWDMkVvXNOlUj4fUctjcjo2l4ZOEhQZg==
X-Received: by 2002:aca:4d95:: with SMTP id a143-v6mr4436797oib.343.1541741414095;
        Thu, 08 Nov 2018 21:30:14 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id p204-v6sm2751373oib.25.2018.11.08.21.30.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 21:30:13 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, youling257 <youling257@gmail.com>
Subject: [PATCH] staging: rtl8723bs: Add missing return for cfg80211_rtw_get_station
Date:   Thu,  8 Nov 2018 23:30:09 -0600
Message-Id: <20181109053009.26055-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

With Androidx86 8.1, wificond returns "failed to get
nl80211_sta_info_tx_failed" and wificondControl returns "Invalid signal
poll result from wificond". The fix is to OR sinfo->filled with
BIT_ULL(NL80211_STA_INFO_TX_FAILED).

This missing bit is apparently not needed with NetworkManager, but it
does no harm in that case.

Reported-and-Tested-by: youling257 <youling257@gmail.com>
Cc: linux-wireless@vger.kernel.org
Cc: youling257 <youling257@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index af2234798fa8..db553f2e4c0b 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -1277,7 +1277,7 @@ static int cfg80211_rtw_get_station(struct wiphy *wiphy,
 
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_PACKETS);
 		sinfo->tx_packets = psta->sta_stats.tx_pkts;
-
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_FAILED);
 	}
 
 	/* for Ad-Hoc/AP mode */
-- 
2.19.1

