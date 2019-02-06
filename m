Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C32C5C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 23:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91F802084D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 23:56:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R/JZaxxX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfBFX4A (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 18:56:00 -0500
Received: from mail-yb1-f201.google.com ([209.85.219.201]:36367 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbfBFXz7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 18:55:59 -0500
Received: by mail-yb1-f201.google.com with SMTP id 63so4589332ybf.3
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2019 15:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=aO0K/0tKy8AOp6h35fENa/NV5JSrDiAT7U9CyNpTqow=;
        b=R/JZaxxX15aqoj9AUJmLk1xwSMuiNELhse4z3SzsoY8j7tVj9qsrVFTiDzideqAwh/
         T+8bNMBY9Y/NZ3BWtcQlLAgz9m6nZ6ZauK+jzk9TXVD2iO1aSRHyqFEGdPF53LzCNcjj
         2RPRvLszljEHMvvDIcpzWLUmPOU/h/DKZPOXZu27Zee0lYPihWDtiJxC5D5uHH4E6xob
         3VOlFJGfemfPfBv5yp7rZqEw20flmRpBCvKcwzzRYfaqysTs89ipd5FVyLTfoMACn57/
         HpSI1gWR8OZ9lxbcedvAVkKFlVap1vgjRoud0l4CgY66qrzB2QHKtd56jB0Zu2kihvim
         wOsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=aO0K/0tKy8AOp6h35fENa/NV5JSrDiAT7U9CyNpTqow=;
        b=dkl6L2qjNBu6Y9zrJKZiGQ1JP9P+9grLcHj/uqwSgpkNyRGDZaHAZpYJc4TK9eGacG
         M3GnEFchD8F4YZPGoiT9cnSjAURKJNHAP9pSfFp5/3OE70GNPIDfPXc1uKZ758MuL9WN
         eyKIwQSRIFSrNPCAHIWEYuzEU0nNq6nzycQFykZIe4zQoYMKWwUolP5fR4CATVd7jDvY
         WvHeJ8tb0n8RIuO60pzIauu1pKJeUfIoTNpj7U5VYDCR0eqrjHmm7An+TDskHUFAw8Jy
         41R4cSCoDAn8F7ieUEozymBaiF5a9/Isw0h8lUCzd+n0uNyw/heWF4YbQ3ymUC/SmowR
         tO9w==
X-Gm-Message-State: AHQUAuYIqPKvQcu7eDJc1Skvp3wf0wvXcHxmphANBXY1vfJplLEAsT0U
        dsAbmBYNGQd291qmUKQFBy5oUT1IJV+jZOar
X-Google-Smtp-Source: AHgI3IaCHk4/+QK/h+OTMA2mhoHo1NbWQRVF8mAMhttaVWpDFghmIPOkE+BC72aiyz2ZLqGMFloWS2eURLCI+bnw
X-Received: by 2002:a25:6643:: with SMTP id z3mr5565779ybm.16.1549497358866;
 Wed, 06 Feb 2019 15:55:58 -0800 (PST)
Date:   Wed,  6 Feb 2019 15:54:15 -0800
Message-Id: <20190206235415.10394-1-schuffelen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.20.1.611.gfbb209baf1-goog
Subject: [PATCH mac80211-next] virt_wifi: Remove REGULATORY_WIPHY_SELF_MANAGED
From:   Cody Schuffelen <schuffelen@google.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com,
        Cody Schuffelen <schuffelen@google.com>,
        Alistair Strachan <astrachan@google.com>,
        Greg Hartman <ghartman@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

REGULATORY_WIPHY_SELF_MANAGED as set here breaks NL80211_CMD_GET_REG,
because it expects the wiphy to do regulatory management. Since
virt_wifi does not do regulatory management, this triggers a WARN_ON in
NL80211_CMD_GET_REG and fails the netlink command.

Removing REGULATORY_WIPHY_SELF_MANAGED fixes the problem and the virtual
wireless network continues to work.

Signed-off-by: Cody Schuffelen <schuffelen@google.com>
Acked-by: Alistair Strachan <astrachan@google.com>
Acked-by: Greg Hartman <ghartman@google.com>
---
 drivers/net/wireless/virt_wifi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/virt_wifi.c b/drivers/net/wireless/virt_wifi.c
index 71044c6cfd8c..606999f102eb 100644
--- a/drivers/net/wireless/virt_wifi.c
+++ b/drivers/net/wireless/virt_wifi.c
@@ -360,7 +360,6 @@ static struct wiphy *virt_wifi_make_wiphy(void)
 	wiphy->bands[NL80211_BAND_5GHZ] = &band_5ghz;
 	wiphy->bands[NL80211_BAND_60GHZ] = NULL;
 
-	wiphy->regulatory_flags = REGULATORY_WIPHY_SELF_MANAGED;
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
 	priv = wiphy_priv(wiphy);
-- 
2.20.1.611.gfbb209baf1-goog

