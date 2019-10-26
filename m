Return-Path: <SRS0=0b32=YT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8805CA9EBC
	for <linux-wireless@archiver.kernel.org>; Sat, 26 Oct 2019 13:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DC99214DA
	for <linux-wireless@archiver.kernel.org>; Sat, 26 Oct 2019 13:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572096985;
	bh=vfpMNsQ26lH8aPbGdDkogyhbz2vogD1NVqU5cgg7OOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RLPHvZwW70eHwPIM/B0OvAuIcDUn6yU+8RA9ejlZ98uBDNw0z8usiAAORjI/RHN7l
	 J8AvpaVFgMq5DWq9iMb3ATNbv18VnsR5/300dfq5fC76XO+u2KU0CQ7b52Xg+xb0rw
	 E+khME+2Rs+ycMhBhOdB+oHPiYfBsPMBGE6+nnCw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfJZNgY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 26 Oct 2019 09:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbfJZNQh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 26 Oct 2019 09:16:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D72ED222C3;
        Sat, 26 Oct 2019 13:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095796;
        bh=vfpMNsQ26lH8aPbGdDkogyhbz2vogD1NVqU5cgg7OOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2hhklzwffOQ/JqLFHgs+kXU6UkAXWgX9Jyqy7uKkISUOcGMZHPdcxFPi7rPZPLJK
         Ju+jGY3Y6P/1jsc/p0KtvpYVVce0na7j91O+mL2ZR9cjP+nN6MTvw3a0gBd6rSW3R7
         vXO2j+VEt3SdU8N9LqkH/Ly1wvWAHZhjTqWgPWyo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 23/99] mac80211: accept deauth frames in IBSS mode
Date:   Sat, 26 Oct 2019 09:14:44 -0400
Message-Id: <20191026131600.2507-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 95697f9907bfe3eab0ef20265a766b22e27dde64 ]

We can process deauth frames and all, but we drop them very
early in the RX path today - this could never have worked.

Fixes: 2cc59e784b54 ("mac80211: reply to AUTH with DEAUTH if sta allocation fails in IBSS")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/20191004123706.15768-2-luca@coelho.fi
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 768d14c9a7161..0e05ff0376726 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3467,9 +3467,18 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 	case cpu_to_le16(IEEE80211_STYPE_PROBE_RESP):
 		/* process for all: mesh, mlme, ibss */
 		break;
+	case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
+		if (is_multicast_ether_addr(mgmt->da) &&
+		    !is_broadcast_ether_addr(mgmt->da))
+			return RX_DROP_MONITOR;
+
+		/* process only for station/IBSS */
+		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+		    sdata->vif.type != NL80211_IFTYPE_ADHOC)
+			return RX_DROP_MONITOR;
+		break;
 	case cpu_to_le16(IEEE80211_STYPE_ASSOC_RESP):
 	case cpu_to_le16(IEEE80211_STYPE_REASSOC_RESP):
-	case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
 	case cpu_to_le16(IEEE80211_STYPE_DISASSOC):
 		if (is_multicast_ether_addr(mgmt->da) &&
 		    !is_broadcast_ether_addr(mgmt->da))
-- 
2.20.1

