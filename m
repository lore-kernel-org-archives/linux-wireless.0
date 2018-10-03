Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9302BC64EBC
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 14:08:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 573502082A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 14:08:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FII94jDg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 573502082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbeJCU4b (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 16:56:31 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45982 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbeJCU4a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 16:56:30 -0400
Received: by mail-pl1-f194.google.com with SMTP id y15-v6so3540743plr.12;
        Wed, 03 Oct 2018 07:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/Z+rc/V0/D/CPK7OCB5tr9qDXZNzXfoCHcN9lstMRH0=;
        b=FII94jDg+ir8FJ3Q5F+jSO/5mbwPmldlEpa87xVeENO8hiQMMI9iAWv5bTZw8IT/GD
         Xg2srs+lbcSUqTWVq+uco/xWicnWzv+kjcSnXnEF43PZDHsJEmgpUQ6LImZ3Y9SwcW+G
         CZFCRqoBCzySBXjQzPplRPrY20y7cqCPIWoNMavoJkcvPajXyjdfmp6joho8D0IyerS8
         V05fMvV4G7IJKMPcxa5wZem5dXaFqk0g5oJnIFXFFq0FvdhmqwjHMgG8QaIxG+BctjTr
         Bl1VM9opXqCKZdqiZn8UAj6DUOC/qemfaIgdBbwydzYAXM77Eo+V8X+EhMNq3JTev94M
         h+dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/Z+rc/V0/D/CPK7OCB5tr9qDXZNzXfoCHcN9lstMRH0=;
        b=cx57BcVzKNGQFnfW5zLdu5VlD0UwIjTM/qJW9K5oDTl3tLu/GnezrY8a8Vykzuzjug
         DQS04iimbQIpWBYxvSpbfsNFRxxpR1DZr9/vmGfz5ZItSiYavjqsCTaIJZShl8J+nZkv
         MU64TGtSR8NmMiOC17Y651EGVPvfCBcEB6bw2RhWwLxPo/m36plYsOC0hgjZ0j6a4glY
         UShmaZgKuVqu8M1LUWwM0pZb2IcdFT3IyO3uxyCBUtpntJo59wQDBfj1SB1Qb6KGr8HW
         Km9k42s4TiKkGiStinWzxXl+bsUtwt02WA2Ro1dlES/jlEL1qFlNkjXNAsCm3AeK4x6K
         bpuw==
X-Gm-Message-State: ABuFfog0TukZ7MCUFlqEDUSVvFhp147EwRQcisOeyaYLrNKqVIjU5oZj
        AgnByq21Ipw4hpsH6Tdyzms=
X-Google-Smtp-Source: ACcGV63e/owXLtSXeX9KfNGH9e0IcFFS25QZnM3kRwLrSEEEsQlBeernILgAd9qNTPJ6ogh7Sy219w==
X-Received: by 2002:a17:902:4d45:: with SMTP id o5-v6mr1818537plh.42.1538575677412;
        Wed, 03 Oct 2018 07:07:57 -0700 (PDT)
Received: from localhost.localdomain ([2402:f000:1:4414:4910:e0f1:49f2:a6db])
        by smtp.gmail.com with ESMTPSA id 76-v6sm4343684pfk.134.2018.10.03.07.07.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Oct 2018 07:07:56 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     sgruszka@redhat.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: wireless: iwlegacy: Fix possible data races in il4965_send_rxon_assoc()
Date:   Wed,  3 Oct 2018 22:07:45 +0800
Message-Id: <20181003140745.7650-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

CPU0:
il4965_configure_filter
	mutex_lock()
	line 6183: il->staging.filter_flags &= ... [WRITE]
	line 6184: il->staging.filter_flags |= ... [WRITE]

CPU1:
il4965_send_rxon_assoc
	line 1301: rxon1->filter_flags, rxon1->filter_flags [READ]
	line 1314: il->staging.filter_flags [READ]

The WRITE operations in CPU0 are performed with holding a mutex lock, 
but the READ operations in CPU1 are performed without holding this lock, 
so there may exist data races. 

These possible races are detected by a runtime testing. 
To fix these races, the mutex lock is used in il4965_send_rxon_assoc() 
to protect the data.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/intel/iwlegacy/4965.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965.c b/drivers/net/wireless/intel/iwlegacy/4965.c
index c3c638ed0ed7..45342777a5f1 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965.c
@@ -1297,6 +1297,7 @@ il4965_send_rxon_assoc(struct il_priv *il)
 	const struct il_rxon_cmd *rxon1 = &il->staging;
 	const struct il_rxon_cmd *rxon2 = &il->active;
 
+	mutex_lock(&il->mutex);
 	if (rxon1->flags == rxon2->flags &&
 	    rxon1->filter_flags == rxon2->filter_flags &&
 	    rxon1->cck_basic_rates == rxon2->cck_basic_rates &&
@@ -1307,6 +1308,7 @@ il4965_send_rxon_assoc(struct il_priv *il)
 	    rxon1->rx_chain == rxon2->rx_chain &&
 	    rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates) {
 		D_INFO("Using current RXON_ASSOC.  Not resending.\n");
+		mutex_unlock(&il->mutex);
 		return 0;
 	}
 
@@ -1321,6 +1323,8 @@ il4965_send_rxon_assoc(struct il_priv *il)
 	    il->staging.ofdm_ht_dual_stream_basic_rates;
 	rxon_assoc.rx_chain_select_flags = il->staging.rx_chain;
 
+	mutex_unlock(&il->mutex);
+
 	ret =
 	    il_send_cmd_pdu_async(il, C_RXON_ASSOC, sizeof(rxon_assoc),
 				  &rxon_assoc, NULL);
-- 
2.17.0

