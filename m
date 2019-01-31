Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B307DC169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 05:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AFC72087F
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 05:53:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wx4vJTe5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfAaFxj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 00:53:39 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33445 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfAaFxj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 00:53:39 -0500
Received: by mail-pf1-f195.google.com with SMTP id c123so1008662pfb.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2019 21:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bE161hYCDVB1Ui5bpyCuPHmtXVi+qYjmnQvupFiQdGs=;
        b=Wx4vJTe5uKAEbSP0GUUj4qE9UWDWB+m+aKGrkijvGbwkgeEQefllHGnESS0r0/Abq9
         t/cjjDvZDwYWYFvwGSPm0zl6B85tErga9tOl0eTrhe69uKtohyfAdFJkGoaAe/0R21CC
         81ykQJbwnUvQWbovIExl+1l7oPLVUXrVJatF60w1NmFPU4OOPVMXvGV2ZRH6UIG4ygKG
         kjnN7x/umM3f4DkB9ooUJfKjq6ScFL6iNW0C3OktmOekidmd+ktovwAnb/c3u7oEp9RL
         EWSXhG5Pk3w7gvzfSo1sGCz3Uidzl5arHR2OHm+ERb4SrFdPH30Ig7AG5V4l9ePyUqTe
         SqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bE161hYCDVB1Ui5bpyCuPHmtXVi+qYjmnQvupFiQdGs=;
        b=o0HwBBlIDd/yC5qBCPIc70sk3Y8/a/eLYzrYcz4qE1+mQ7fz2JmBRZjd9trkONc6f8
         TT5CDKDYtxQhFTSZXusGI34u3AO5lKzSaa3vBvzigzMVgLD/y6TZem3C0IWFv/Gj36Yd
         daUcu9YZrGk10sXyJcPAKNMjkBfNmq+9EpjI5Z8mB+Xf2gXr/7q5xeZXIedfCfTroxeM
         nhqTyu4YKju6rkq7d3/jCzODd+LBhNAtbPOlqCWpnIn9f2z6pY1PRyB7oxg8z2AgMeMl
         GWKRxcFZhZmnOmMKhlxJlx400+leVpG81+7aOZuIaS9c7LaseaGxx0awNGq0etshibCr
         Y9Ow==
X-Gm-Message-State: AJcUukcoaruQgd28AgyRSGcnBMs6THYVFu/vAp7+G82n1ibMqZOKNKQ1
        TZ4QLfnj/7fqimHazQmXHq0=
X-Google-Smtp-Source: ALg8bN4YZJptqghIDkFTJk7Q5rih6A7USyKOb39LAejv6L4cWlo0eRgncCO4IvUAqFejwKkBecDLAg==
X-Received: by 2002:a62:4641:: with SMTP id t62mr33159804pfa.141.1548914018459;
        Wed, 30 Jan 2019 21:53:38 -0800 (PST)
Received: from cpu459.localdomain ([203.196.161.90])
        by smtp.gmail.com with ESMTPSA id h19sm4314493pfn.114.2019.01.30.21.53.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 21:53:37 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, rishikesh.basu@redpinesignals.com,
        siva.rebbagondla@redpinesignals.com,
        krishna.pedda@redpinesignals.com,
        ganapathi.kondraju@redpinesignals.com
Subject: [v2 3/5] rsi: fix wowlan wakeup issue for hibernate(S4)
Date:   Thu, 31 Jan 2019 11:23:03 +0530
Message-Id: <1548913985-7180-4-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1548913985-7180-1-git-send-email-siva8118@gmail.com>
References: <1548913985-7180-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

At SDIO restore ieee80211_restart_hw() is getting called to restart all
MAC operations. This step is not required.
Returning 1 from mac80211_resume() will serve this purpose.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 8 ++++++--
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 1 -
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index aded1ae..8d1282f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1938,8 +1938,12 @@ static int rsi_mac80211_resume(struct ieee80211_hw *hw)
 
 	rsi_dbg(INFO_ZONE, "%s: mac80211 resume\n", __func__);
 
-	if (common->hibernate_resume)
-		return 0;
+	if (common->hibernate_resume) {
+		/* Device need a complete restart of all MAC operations.
+		 * returning 1 will serve this purpose.
+		 */
+		return 1;
+	}
 
 	mutex_lock(&common->mutex);
 	rsi_send_wowlan_request(common, 0, 0);
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 4005c1d..43e8a0d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1393,7 +1393,6 @@ static int rsi_restore(struct device *dev)
 	common->iface_down = true;
 
 	adapter->sc_nvifs = 0;
-	ieee80211_restart_hw(adapter->hw);
 
 	common->wow_flags = 0;
 	common->iface_down = false;
-- 
2.5.5

