Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A0CC282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 06:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 292B12177E
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 06:34:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sZ2WYW0Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfBDGeG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 01:34:06 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46942 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfBDGeG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 01:34:06 -0500
Received: by mail-pf1-f194.google.com with SMTP id c73so6279356pfe.13
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2019 22:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9c5Qv3xKOnSbwK7hxSyqCi1So4hNP+y66JHHTtRgqGg=;
        b=sZ2WYW0Qub0ZWOMCSGxSE1YW1VkNUH+cqe7TTBhWfFXYrjogJjUCg8dyX6ImR7yj6P
         rnnLdx0HfZYLBtqsmGO+uStFt1zBhDlw13rPkjztH469GS4v2+Qwd3YK1+PjBf9TWTUU
         q8SnU738lDeAO2Thi3xQOMNWX8z9z9VywoXO3eOFK/tj1CLI/378TtO+qpNX/6zF3LWV
         oBnOtJSbMoDfgnQgyi1v/4g9xaZ5LaaMDwyUKuDBc23YESQF+Nj0MLnby0m83rGuw5e3
         Vsrh88wIw/ITtydMN+Kad3PhZ3F9iWa/c5quK5tqYslaT1cwRODg3v93bmthMND008DK
         wxsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9c5Qv3xKOnSbwK7hxSyqCi1So4hNP+y66JHHTtRgqGg=;
        b=RDKxdb8RZV1rVjLhn8LfLv3xtfcrRx1kZB352L7UzPFj0KQw5Lmn4eRsrtvpsM9WUU
         Dn8O+Jk3juwiEOb4M1pkSNwG4t7xLUGU25lApC8i38uRkKxj0iHLdV5ZxWiTDm8wIx0a
         pD6Cw80ae7PDg8z9SyelZe2BrI9alwtl/nlOBMkurPx/wLFYbcCZ8x4JGgNFr49bDFA1
         yUL0K2TfjWyGt3Zd1yFB+YwiK9GsxHeavOCuYr7GlNBjSRprZF9RIMvkg4bWiwBstRga
         6iyMJhzHx7URQUP49rqVL/SC/iovKURpUrevuJs5VKwtbx4gYPjiHyRQJOxyfT2xqrqJ
         DPsA==
X-Gm-Message-State: AHQUAuZ2omw1sfxbBD+QtvNxv4/urNokcJKimyp6g7nWy48+YOuW9zdO
        T6hvd8X7fHqY3alVCtj2+wg=
X-Google-Smtp-Source: AHgI3IaRlFYBvH/iv9xRsXUx7HwdzJ0zgffCaoA3MkwD2YvbPeA0B71bNHI+nph06MZUve2MJ6WQHg==
X-Received: by 2002:a63:2ccd:: with SMTP id s196mr11798433pgs.194.1549262045405;
        Sun, 03 Feb 2019 22:34:05 -0800 (PST)
Received: from cpu459.localdomain ([27.59.252.63])
        by smtp.gmail.com with ESMTPSA id t21sm20240438pgg.24.2019.02.03.22.34.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 22:34:04 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, rishikesh.basu@redpinesignals.com,
        siva.rebbagondla@redpinesignals.com,
        krishna.pedda@redpinesignals.com, amitkarwar@gmail.com
Subject: [v3 5/5] rsi: fix for wowlan wakeup failure
Date:   Mon,  4 Feb 2019 12:03:29 +0530
Message-Id: <1549262009-8766-6-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1549262009-8766-1-git-send-email-siva8118@gmail.com>
References: <1549262009-8766-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

During wowlan regression tests, sometimes radio is not waking up for wowlan
packet in coex mode. This is because of power save is enabled by default
in case of coex mode greater than one. Hence, disable power save in coex
mode to avoid radio loss.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 7bc8da6..3fd2571 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1901,6 +1901,10 @@ int rsi_config_wowlan(struct rsi_hw *adapter, struct cfg80211_wowlan *wowlan)
 		return 0;
 	}
 	rsi_dbg(INFO_ZONE, "TRIGGERS %x\n", triggers);
+
+	if (common->coex_mode > 1)
+		rsi_disable_ps(adapter, adapter->vifs[0]);
+
 	rsi_send_wowlan_request(common, triggers, 1);
 
 	/**
-- 
2.5.5

