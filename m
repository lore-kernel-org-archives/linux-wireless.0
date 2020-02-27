Return-Path: <SRS0=Gmm1=4P=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A753BC4BA2D
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Feb 2020 00:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73FE924679
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Feb 2020 00:05:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BtaDxmvB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgB0AF1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Feb 2020 19:05:27 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44859 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgB0AF1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Feb 2020 19:05:27 -0500
Received: by mail-pl1-f193.google.com with SMTP id d9so345384plo.11
        for <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2020 16:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RhYHdaC+npN1RSDyAo/2yjjolxZ1CEpp4Vwu9UTJs58=;
        b=BtaDxmvBZDIW4bF1ZefkJXPPUhBWJEqoWrekfB0e8eQNOLLixbuZF3y7pT8Xq/7jj+
         E/yJ1YqIHk5zKX4HCFBcbR5ppwvqHF9p6pEecQatHy6v7xA8lhungE9d2UcOHy+Ov38p
         RW+zoFuXALkXALlIDPG9w1gce5K2b47ku18YI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RhYHdaC+npN1RSDyAo/2yjjolxZ1CEpp4Vwu9UTJs58=;
        b=PxVZ+3GSqW2aaoicSZA6VrrVd8z1rrt2n02G1D0Q63WMTJ/G9T1SYwneqHLDX19AkP
         k1b4xI82YTbtvEuWa0W/hhpfSUaa35VMJ/lIAEMr/BWNyMDtfw10TPKXDQtwRjiNBV4m
         j+rmDhxBRsmOWf0//+KS8UD+WT+17SFiNhZwthHXcLYQ3fkCefGmdTzHkv65kRdu4G4w
         vlo/2tu2vVhafYK/sVf9VEJHhTh0no1XcPX3iUYEOsqj8DSSBSFUBcK0tTLpLA7y9zNX
         hrBN/Z5zR5si16sBOIcKtfsgeBWEVEbd0dLleRgZm1huPbmc41WlJRAmrY2gKwLRNH5v
         X4TA==
X-Gm-Message-State: APjAAAXmxL3RsnVBanRK8TLUL0vuuG+fsSDHlSmkRykPkYlwxfDTZdUn
        C3gV/E83GfqnzHqVd45XSIsfaC19Cag=
X-Google-Smtp-Source: APXvYqxdXAggPnSsxeYaGs+h1PAi2Zz+wyxxWNmf1O/8MMGfcnT/SLcQmq0Hs/QrK99fQEbOujjCMw==
X-Received: by 2002:a17:902:7c8f:: with SMTP id y15mr910432pll.55.1582761926183;
        Wed, 26 Feb 2020 16:05:26 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id 196sm4307849pfy.86.2020.02.26.16.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 16:05:25 -0800 (PST)
From:   Brian Norris <briannorris@chromium.org>
To:     linux-wireless@vger.kernel.org
Cc:     <linux-kernel@vger.kernel.org>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Arend Van Spriel <arend@broadcom.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] mwifiex: set needed_headroom, not hard_header_len
Date:   Wed, 26 Feb 2020 16:05:11 -0800
Message-Id: <20200227000511.256055-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

hard_header_len provides limitations for things like AF_PACKET, such
that we don't allow transmitting packets smaller than this.

needed_headroom provides a suggested minimum headroom for SKBs, so that
we can trivally add our headers to the front.

The latter is the correct field to use in this case, while the former
mostly just prevents sending small AF_PACKET frames.

In any case, mwifiex already does its own bounce buffering [1] if we
don't have enough headroom, so hints (not hard limits) are all that are
needed.

This is the essentially the same bug (and fix) that brcmfmac had, fixed
in commit cb39288fd6bb ("brcmfmac: use ndev->needed_headroom to reserve
additional header space").

[1] mwifiex_hard_start_xmit():
	if (skb_headroom(skb) < MWIFIEX_MIN_DATA_HEADER_LEN) {
	[...]
		/* Insufficient skb headroom - allocate a new skb */

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 0a6da6fe2f89..1566d2197906 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3052,7 +3052,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
 	dev->watchdog_timeo = MWIFIEX_DEFAULT_WATCHDOG_TIMEOUT;
-	dev->hard_header_len += MWIFIEX_MIN_DATA_HEADER_LEN;
+	dev->needed_headroom = MWIFIEX_MIN_DATA_HEADER_LEN;
 	dev->ethtool_ops = &mwifiex_ethtool_ops;
 
 	mdev_priv = netdev_priv(dev);
-- 
2.25.0.265.gbab2e86ba0-goog

