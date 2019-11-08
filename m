Return-Path: <SRS0=s5sB=ZA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9654BFC6196
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Nov 2019 12:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6295B222C6
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Nov 2019 12:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573214935;
	bh=NgTsZq5LbL3QYqBe2oz5+VeHyhCREUqx2iZfVrpgkDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ce4QFQTawT0ubQjqy464e8k9LluxGA9O1h4gL8s1lGM9M5NzQmLeu9oVtXxu4OC4Z
	 oheh2AOSsM9TiQMvC8JfiQTKR0X0swkI8PooeEUvHPXJc2w2quxhyM8KfmDqkXZwJd
	 f4CjORrEkudFcFdVUlJk3Xr14QK8UseP+GxYI4aU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732106AbfKHLkT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Nov 2019 06:40:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388543AbfKHLkO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E323222C4;
        Fri,  8 Nov 2019 11:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213214;
        bh=NgTsZq5LbL3QYqBe2oz5+VeHyhCREUqx2iZfVrpgkDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1hfXleEa+6NK8RWbGz5dQKUrDSH/xQyt5ivXCSo1bjxZ14XHllOr/K+V3YcsAXNMM
         mmBQ1Zyfe4lL6m/M9vWC7jEgchNWPO+YW9EEIWTuP0V5EUPi4KxfRIWRjJXgp9nZy7
         aivUhF8B2zV3CESAmb2tEP0VKUB/dXfIMsw2wkHw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erik Stromdahl <erik.stromdahl@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 094/205] ath10k: wmi: disable softirq's while calling ieee80211_rx
Date:   Fri,  8 Nov 2019 06:36:01 -0500
Message-Id: <20191108113752.12502-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Erik Stromdahl <erik.stromdahl@gmail.com>

[ Upstream commit 37f62c0d5822f631b786b29a1b1069ab714d1a28 ]

This is done in order not to trig the below warning in
ieee80211_rx_napi:

WARN_ON_ONCE(softirq_count() == 0);

ieee80211_rx_napi requires that softirq's are disabled during
execution.

The High latency bus drivers (SDIO and USB) sometimes call the wmi
ep_rx_complete callback from non softirq context, resulting in a trigger
of the above warning.

Calling ieee80211_rx_ni with softirq's already disabled (e.g., from
softirq context) should be safe as the local_bh_disable and
local_bh_enable functions (called from ieee80211_rx_ni) are fully
reentrant.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 583147f00fa4e..40b36e73bb48c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2487,7 +2487,8 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 		   status->freq, status->band, status->signal,
 		   status->rate_idx);
 
-	ieee80211_rx(ar->hw, skb);
+	ieee80211_rx_ni(ar->hw, skb);
+
 	return 0;
 }
 
-- 
2.20.1

