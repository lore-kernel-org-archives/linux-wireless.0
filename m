Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B5AC43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 20:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 665E220827
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 20:31:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tGA7volR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbfAHUbq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 15:31:46 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33811 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbfAHUbq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 15:31:46 -0500
Received: by mail-lj1-f193.google.com with SMTP id u89-v6so4580016lje.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2019 12:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=62c/abkv8pQsWmXqEQIZxagDNLv4EUWrDeEM66FCP3I=;
        b=tGA7volRNOP4jkRLdnqgwdZtl5mNbPLsmY32mSMNvDWPws9v3kMfoJ0ALqrqv/QhhP
         2cvj50Z5Xj3IJcyRG0AP5FLwJ/JRt+LJv9c32ia2V5ecrgRINn3WLVZ+Ony57u/tnkxD
         vFF2gpjOp/tDLxM9Dp9FOGY1M+ahlBeuopxDARCewTVRf0UiEpYjKp4NvuJEkZDk5BQn
         W3xE6ItFUUNBnlj970EcyvP5VWLCVpSy/dYlm4aklsEKiPkclw+la8hGO/RwOgO5tWN7
         59J7w6ysdeb36Sj6WTM6PGE/WN62k5rOgIqLgSNjGk7t1g+LILBL3mFtJL7AKJnyy+x6
         E/JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=62c/abkv8pQsWmXqEQIZxagDNLv4EUWrDeEM66FCP3I=;
        b=Gukqy+c13213utatZcPCeTR6fsyxLxnxh+UhRs7kqBNVV1SmCR2zoN22TgHqz+vR14
         9G3eCRDnlDSZlZYDnJicAd1cq9HQD9QI+yDCdrxonuW/4rU0rK9sdpgauaz+Vmyf1Qvh
         d8T4JMN8JFuMM1OugQW+ub4RwGDPh2HS7MFIkdaV028+hZYsXRR/l9oFlrqdpNJdQx7B
         q/ZRcjoPe5wMuObpuXKQD8c7XhrNujTsb8Nq/kcSuAm5uV0OxLU/aN2bmWh6YbBOHB/9
         edAaienE8AExJH4Uq5b3cfKiO9vaMeOZZD7syJ+uZ9qJYnX0I/5E6bUxsixtejd+ICzf
         C/2Q==
X-Gm-Message-State: AJcUukfuMPSBXZlFwp6Np3lRyUfZ0NVYeTidxlzpaB9+/Rsmsnkslm6l
        0n62jkh75pbaJq5SSB7fK7ZjVAdb
X-Google-Smtp-Source: ALg8bN6HHZPO+B5h2dkpCKIiWrLgDC/SwMOzyBlwd4VkGq2RbZpeG2crHpunaIfW5z0LlZr0kRHApQ==
X-Received: by 2002:a2e:7615:: with SMTP id r21-v6mr1812644ljc.131.1546979503084;
        Tue, 08 Jan 2019 12:31:43 -0800 (PST)
Received: from localhost.localdomain (ppp92-100-66-191.pppoe.avangarddsl.ru. [92.100.66.191])
        by smtp.googlemail.com with ESMTPSA id s3-v6sm14627164lje.73.2019.01.08.12.31.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 12:31:42 -0800 (PST)
From:   Sergey Matyukevich <geomatsi@gmail.com>
To:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     Jouni Malinen <jouni@codeaurora.org>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH] mac80211: allow overriding HT STBC capabilities
Date:   Tue,  8 Jan 2019 23:31:49 +0300
Message-Id: <20190108203149.9017-1-geomatsi@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Allow user to override STBC configuration for Rx and Tx spatial streams.
In practice RX/TX STBC settings can be modified using appropriate
options in wpa_supplicant configuration file:
  tx_stbc=-1..1
  rx_stbc=-1..3

This functionality has been added to wpa_supplicant in commit cdeea70f59d0.

In FullMAC case these STBC options are passed to drivers by cfg80211
connect callback in fields of cfg80211_connect_params structure.
However for mac80211 drivers, e.g. for mac80211_hwsim,
overrides for STBC settings are ignored.

The reason why RX/TX STBC capabilities are not modified for mac80211
drivers is as follows. All drivers need to specify supported HT/VHT
overrides explicitly: see ht_capa_mod_mask and vht_capa_mod_mask fields
of wiphy structure. Only supported overrides will be passed to drivers by
cfg80211_connect and cfg80211_mlme_assoc operations: see bitwise 'AND'
performed by cfg80211_oper_and_ht_capa and cfg80211_oper_and_vht_capa.

This commit adds RX/TX STBC HT capabilities to mac80211_ht_capa_mod_mask,
allowing their modifications, as well as applies requested STBC
modifications in function ieee80211_apply_htcap_overrides.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 net/mac80211/ht.c   | 8 ++++++++
 net/mac80211/main.c | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index f849ea814993..e03c46ac8e4d 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -107,6 +107,14 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 	__check_htcap_enable(ht_capa, ht_capa_mask, ht_cap,
 			     IEEE80211_HT_CAP_40MHZ_INTOLERANT);
 
+	/* Allow user to enable TX STBC bit  */
+	__check_htcap_enable(ht_capa, ht_capa_mask, ht_cap,
+			     IEEE80211_HT_CAP_TX_STBC);
+
+	/* Allow user to configure RX STBC bits */
+	if (ht_capa_mask->cap_info & IEEE80211_HT_CAP_RX_STBC)
+		ht_cap->cap |= ht_capa->cap_info & IEEE80211_HT_CAP_RX_STBC;
+
 	/* Allow user to decrease AMPDU factor */
 	if (ht_capa_mask->ampdu_params_info &
 	    IEEE80211_HT_AMPDU_PARM_FACTOR) {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 87a729926734..1114ee217bd6 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -478,6 +478,8 @@ static const struct ieee80211_ht_cap mac80211_ht_capa_mod_mask = {
 				IEEE80211_HT_CAP_MAX_AMSDU |
 				IEEE80211_HT_CAP_SGI_20 |
 				IEEE80211_HT_CAP_SGI_40 |
+				IEEE80211_HT_CAP_TX_STBC |
+				IEEE80211_HT_CAP_RX_STBC |
 				IEEE80211_HT_CAP_LDPC_CODING |
 				IEEE80211_HT_CAP_40MHZ_INTOLERANT),
 	.mcs = {
-- 
2.20.1

