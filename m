Return-Path: <SRS0=gp58=4L=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4B0C35669
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Feb 2020 02:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2841D20659
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Feb 2020 02:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582424821;
	bh=cy7SP9sbTFkiqIp2R+EgdcYVzesuD6fYlrZu3pfgR18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=kuatJUW6HThzttmrGiVwbpFpYWsjPC7eozYDqKxekDTsnU5lCf+Z4dzHzkjtdhR/g
	 1kfk1ue0VXGvAmA69NZiy2dHU+RbhqbhVDvoCwAlvFusrpCATwps4ifK+21LWa4l91
	 jjBf9WMBFg4hZgqhTvI7kdjsO5ajmxLAz80ebXvU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgBWC0z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 22 Feb 2020 21:26:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:54984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729410AbgBWCYp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Feb 2020 21:24:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB483208C4;
        Sun, 23 Feb 2020 02:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424684;
        bh=cy7SP9sbTFkiqIp2R+EgdcYVzesuD6fYlrZu3pfgR18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfxtyjXkqC0/kRuC3wxT9a9yBZslr+gQKTXH0L7VBcS9hg3qS+McYBg8v3bhnQvFp
         vMHS7EbL1JivjdYX5KjmuGoRLupGJ0tEkoeg3fseaXDEDPj/wNaHeTgowH9QTO+p1h
         Yh+YcptYJl/wvk4vSWljSGMSjmC07f8xBjoLeNQ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/16] cfg80211: check wiphy driver existence for drvinfo report
Date:   Sat, 22 Feb 2020 21:24:26 -0500
Message-Id: <20200223022438.2398-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022438.2398-1-sashal@kernel.org>
References: <20200223022438.2398-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[ Upstream commit bfb7bac3a8f47100ebe7961bd14e924c96e21ca7 ]

When preparing ethtool drvinfo, check if wiphy driver is defined
before dereferencing it. Driver may not exist, e.g. if wiphy is
attached to a virtual platform device.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Link: https://lore.kernel.org/r/20200203105644.28875-1-sergey.matyukevich.os@quantenna.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/ethtool.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/wireless/ethtool.c b/net/wireless/ethtool.c
index e9e91298c70de..3cedf2c2b60bd 100644
--- a/net/wireless/ethtool.c
+++ b/net/wireless/ethtool.c
@@ -6,9 +6,13 @@
 void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct device *pdev = wiphy_dev(wdev->wiphy);
 
-	strlcpy(info->driver, wiphy_dev(wdev->wiphy)->driver->name,
-		sizeof(info->driver));
+	if (pdev->driver)
+		strlcpy(info->driver, pdev->driver->name,
+			sizeof(info->driver));
+	else
+		strlcpy(info->driver, "N/A", sizeof(info->driver));
 
 	strlcpy(info->version, init_utsname()->release, sizeof(info->version));
 
-- 
2.20.1

