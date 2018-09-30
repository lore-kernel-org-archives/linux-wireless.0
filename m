Return-Path: <SRS0=a98u=MM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F24C004D2
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 10:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6735120833
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 10:53:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ufIVTLyT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6735120833
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbeI3RZs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 30 Sep 2018 13:25:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33222 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbeI3RZs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Sep 2018 13:25:48 -0400
Received: by mail-wr1-f66.google.com with SMTP id f10-v6so10730187wrs.0;
        Sun, 30 Sep 2018 03:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mJIj+pT5+IKq1OG/ATUiq/2hs7M9ynVD6E1diIINKDA=;
        b=ufIVTLyTzqNmFfSQWaO5wvCXnGBFXen7wD+n7u93V63gdA+6Q1FwVBU7jZM7f6LARi
         PSeuVUmYElfX+0cxMydGAIMAKAfCDGp0VRhMWXyE6N8RVKTewOu/UUMNeYSwxADtDdkk
         TLUUS88trt2rY4C1aWVCnXn0929NQXccUzDDeLtIQ4/tSmEARk2jzCVqBlkpuQGhUujK
         B7O6uyjD4bY9gtLiOo5GC6kHetjGynw/jXeZ7nmt+kovYIk+ZwaNTXU3PvB1d5kJdpa8
         OrY7XfUpvTNR4RbtO3j/61TXcjsFJxYvW90aGOoeCY77pDg46QEpEAOR24mo2UHb9Cjp
         IAeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mJIj+pT5+IKq1OG/ATUiq/2hs7M9ynVD6E1diIINKDA=;
        b=DeOedN4HFOALz7bpJoItXe6TuLIWmQN3/VWCQJDScv1h3qWgP54av9H0APMVVuPTWJ
         U6GdoggvCly0noUZ4mYjfUiEa7J7K/zyYQnyiockS5/E+R1Im92hiGYVnvdBsadpqCcf
         u862fJUOOJ/QfeJcE6Jo5rjI/YGA5Avt5JIw7MPkZuJIlyyOeoUCLlkXj+gqRdfXgcVU
         CWeGi4edqrdmCMdrDL01B/ZpXwmzUA6GIV5axycQQgq367y2YJSXVNOo/m9fDeo4xgqp
         5fEwAMp1acmdO4cpYAEzn4xBTWmd+rJwOjJq+sgn8n2mUfRrVLu2ROzJ1cljUhe1ynyp
         /nwg==
X-Gm-Message-State: ABuFfohPXo/4yTNBza02OIjH0wc9zMnx8RENve4D/juWiGx3EjT4nehu
        ibUthoEfcm8YkfQI54a+JzcaWjDR
X-Google-Smtp-Source: ACcGV60TI8RzQVCOTFLST6d2U9CgTD/qlvzraEhp+XFYqNGQTCqlNSpR4+Z3gl42lXOeth+cmiU6rg==
X-Received: by 2002:adf:ade3:: with SMTP id w90-v6mr3969234wrc.73.1538304794160;
        Sun, 30 Sep 2018 03:53:14 -0700 (PDT)
Received: from strolchi.home.s3e.de (p57B63A04.dip0.t-ipconnect.de. [87.182.58.4])
        by smtp.gmail.com with ESMTPSA id j2-v6sm3256299wrw.29.2018.09.30.03.53.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Sep 2018 03:53:13 -0700 (PDT)
From:   stefan.seyfried@googlemail.com
To:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     Stefan Seyfried <seife+kernel@b1-systems.com>
Subject: [PATCH] cfg80211: fix wext-compat memory leak
Date:   Sun, 30 Sep 2018 12:53:00 +0200
Message-Id: <20180930105300.30797-1-stefan.seyfried@googlemail.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Stefan Seyfried <seife+kernel@b1-systems.com>

cfg80211_wext_giwrate and sinfo.pertid might allocate sinfo.pertid via
rdev_get_station(), but never release it

Signed-off-by: Stefan Seyfried <seife+kernel@b1-systems.com>
---
 net/wireless/wext-compat.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 167f7025ac98..f462336aac1c 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1277,12 +1277,16 @@ static int cfg80211_wext_giwrate(struct net_device *dev,
 	err = rdev_get_station(rdev, dev, addr, &sinfo);
 	if (err)
 		return err;
-
 	if (!(sinfo.filled & BIT_ULL(NL80211_STA_INFO_TX_BITRATE)))
 		return -EOPNOTSUPP;
 
 	rate->value = 100000 * cfg80211_calculate_bitrate(&sinfo.txrate);
 
+	/* sta_set_sinfo(), called from ieee80211_get_station(), called from
+	 * rdev_get_station via rdev->ops->get_station, allocates pertid struct
+	 * which we do not use here. */
+	kfree(sinfo.pertid);
+
 	return 0;
 }
 
@@ -1293,7 +1297,7 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	/* we are under RTNL - globally locked - so can use static structs */
 	static struct iw_statistics wstats;
-	static struct station_info sinfo;
+	static struct station_info sinfo = {};
 	u8 bssid[ETH_ALEN];
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION)
@@ -1352,6 +1356,9 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 	if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_TX_FAILED))
 		wstats.discard.retries = sinfo.tx_failed;
 
+	/* see cfg80211_wext_giwrate() above */
+	kfree(sinfo.pertid);
+
 	return &wstats;
 }
 
-- 
2.19.0

