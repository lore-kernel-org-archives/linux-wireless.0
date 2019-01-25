Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06BCC282C2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 06:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80493218D2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 06:30:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EDTJrFoN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfAYGaa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 01:30:30 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41975 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbfAYGaa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 01:30:30 -0500
Received: by mail-pl1-f196.google.com with SMTP id u6so4089417plm.8
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2019 22:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9c5Qv3xKOnSbwK7hxSyqCi1So4hNP+y66JHHTtRgqGg=;
        b=EDTJrFoN0TQ7y0URn+ovhKr/gDoqaXiE0bkjCYOTsKhPuF2DyMhG+/x0SaWEiiqdmq
         h8RdHoj3NHJglWjWXn5o77D0vvdPkRIATsL2UOMX2OLQdRAcDhPiW4tBQkUKknrAT+7p
         vJJhyxvRohvSS/6595Wgq2rofXsNPtc+SoaCHHF8DKqLhAoNRv4KT++HPQJWLH1lNyJi
         D6Lret2d9qb6hRHg+7qV/AbBjpABhgNzqA1cvShGM8+8wHwOPbwqArMzvmv5fhUogyYB
         kJGs4fHbTjLWLQKEoTViG+PYuwt3YumMNg6JXF8Q+OJ87jhjeDO4Hs7AG6FHCsq6/Esg
         vlIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9c5Qv3xKOnSbwK7hxSyqCi1So4hNP+y66JHHTtRgqGg=;
        b=aj1HPK2zFtmIkHh0mZhlASR21U/m0w/MTpUzH+Nrwhcz+7aM+J2agiQn9+dK7M4Aop
         OOYoYKAf+0gVQsLbKrLeBFTMt+Rkbg9bQnk3+UyiyV7F0KQpWHrZxn/1MVoNi8hsje5t
         iCD67HyVqTg7Lzvo51H7XYslTE+renhbqk7tQ07G5FUsihovgY/Pq19l7J90s4DBTHIJ
         TfI/LuwYCIPwAMjXfw5gurh2+/IjJTCCeYFZbjQqKcf++Tt5TVWThilHAnqnWzDyWlR4
         A0rHUDYAH56OWjQkDqj0Keo6MQv0jVdJ5Hm2Rvq6rJOdR3PQyHvjppwz6yeq1QuIe/YT
         4+KA==
X-Gm-Message-State: AJcUukeDgdgB/t0Q6t3oG1VSwq84F3bWic0VpDKDqP2MzT48auTRTqFH
        19ewlpe8BQmQZ3C6/3cYA4I=
X-Google-Smtp-Source: ALg8bN5Bmj8wNXWk3QY/xJcxXypspPXpMI7kZakIV4un0IXwR/lQ/ZZkdVgW7oGyLRXXn99Ea7M2iw==
X-Received: by 2002:a17:902:e18c:: with SMTP id cd12mr9162761plb.279.1548397829963;
        Thu, 24 Jan 2019 22:30:29 -0800 (PST)
Received: from cpu459.localdomain ([203.196.161.90])
        by smtp.gmail.com with ESMTPSA id x19sm37384793pfk.14.2019.01.24.22.30.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 22:30:29 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Rishikesh Basu <rishikesh.basu@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        krishna.pedda@redpinesignals.com
Subject: [PATCH 5/5] rsi: fix for wowlan wakeup failure
Date:   Fri, 25 Jan 2019 12:00:02 +0530
Message-Id: <1548397802-12180-6-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1548397802-12180-1-git-send-email-siva8118@gmail.com>
References: <1548397802-12180-1-git-send-email-siva8118@gmail.com>
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

