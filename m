Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3658C37121
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 23:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ACFF2089F
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 23:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548113475;
	bh=GPRUJnIB0OyzBbUFz04hJUGu7UnzF9PTVC/GUpLYalo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=RHToRBKp7QXsHNbU8bzRYQBD8royH8dR70JhNd49C7uuq+43uQ2kokhR10MQtEma6
	 5p9DqgOsVNjRIJBEsm90YpmlY5eyfYwXRJo3jX1ft2RxpRTiy57kOibXfTosxQeRMr
	 cdyj9qPj1PRDGi5wKCvMGTNjOkvAU0/lC1aqKoM0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfAUXbJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 18:31:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:38952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbfAUXbJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 18:31:09 -0500
Received: from sinanubuntu1604.mkjiurmyylmellclgttazegk5f.bx.internal.cloudapp.net (unknown [40.117.83.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94B822089F;
        Mon, 21 Jan 2019 23:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548113468;
        bh=GPRUJnIB0OyzBbUFz04hJUGu7UnzF9PTVC/GUpLYalo=;
        h=From:To:Cc:Subject:Date:From;
        b=kH6gkEjOx5XHSJAFKsUCqv/+utj3yIBDtj7Hqv0VaoeTJ7nDZYgZDbFTR3gtAJRfr
         tMqvCg0ZmRRhZKqEGOx+XeM+fyvZ2IXsz6PEbvmer9lOdN9ah23+9y0wt72rNoouii
         Gzm5mkynCeekxRsggGNog1cj5rFGY7YGH+AMiE6E=
From:   Sinan Kaya <okaya@kernel.org>
To:     linux-next@vger.kernel.org
Cc:     Sinan Kaya <okaya@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org (open list:INTEL WIRELESS WIFI LINK
        (iwlwifi)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [for next][PATCH] iwlwifi: Fix unmet dependency error for IWLWIFI_LEDS
Date:   Mon, 21 Jan 2019 23:31:02 +0000
Message-Id: <20190121233102.13705-1-okaya@kernel.org>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There is an unresolved dependency as follows:

IWLWIFI_LEDS selects MAC80211_LEDS.
MAC80211_LEDS depends on MAC80211.

It is possible to choose MAC80211_LEDS (y) but not choose MAC80211 (n)

WARNING: unmet direct dependencies detected for MAC80211_LEDS
  Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=n] && LEDS_CLASS [=y]
  Selected by [y]:
  - IWLWIFI_LEDS [=y] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_INTEL [=y] && IWLWIFI [=y] && (LEDS_CLASS [=y]=y || LEDS_CLASS [=y]=IWLWIFI [=y])

Move the MAC80211 dependency into IWLWIFI_LEDS so that we avoid this
configuration.

Signed-off-by: Sinan Kaya <okaya@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index 491ca3c8b43c..74f0d0bbed34 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -46,7 +46,7 @@ if IWLWIFI
 
 config IWLWIFI_LEDS
 	bool
-	depends on LEDS_CLASS=y || LEDS_CLASS=IWLWIFI
+	depends on MAC80211 && (LEDS_CLASS=y || LEDS_CLASS=IWLWIFI)
 	select LEDS_TRIGGERS
 	select MAC80211_LEDS
 	default y
-- 
2.19.0

