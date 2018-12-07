Return-Path: <SRS0=Y8Bh=OQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E14FC64EB1
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 00:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4830620868
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 00:13:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="PZ9MFiqz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4830620868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbeLGANp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Dec 2018 19:13:45 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42158 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbeLGANk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Dec 2018 19:13:40 -0500
Received: by mail-pf1-f195.google.com with SMTP id 64so981470pfr.9
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2018 16:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t0y6HX6J+lHDD23/0YpeJqj2ohhaa87LchmrhAZziw4=;
        b=PZ9MFiqz8iRa8RqqQx0fWSwRKbwKMTke0UKoX2RUtOf7grTuejFs2s0yF2GnYyvRmA
         T9nqEeHW+kNw5mbPhMWzC5Waov3Jg88MvBU/SNTBZJPuN9r0cNPZa+qtD0f0IB78WAcL
         fIcVN2nOhFUhASueVXCH1Vo4WvhK5zVEL7cBY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t0y6HX6J+lHDD23/0YpeJqj2ohhaa87LchmrhAZziw4=;
        b=EHkN6qIbnZBD9Y8Qe7GiRmHN47YRdUbHIfKOWaNQt023pDsodKHNtl3jbB7kLDFjfH
         bCdzYiaos/wxLXvqkEnOyYpt+ld6dLkWsM++alytD2l9S8goeTQlqbThgwoGZF8YXRdm
         cPv5fAksJ+mkPCN0MDOwh6cptF7HTwKiQkYK4DfI8/yzqzuMwWq5j9CmfPGSl1wZ5+Cb
         an1kMlz3VN4Dx7k8pI9JyH6UIUbkVgvJm2l5tEmP2AzNcDhS6vdyq6SbPNe/rokV2Tf/
         1tJjskgjLiIDatYseSJX2crZ164CHG5dFB+60u4BxpD4iBEBtgf7sAnXlSyQNibP2rrg
         Ynwg==
X-Gm-Message-State: AA+aEWbbXt013KfR8FQL7aSI0qlUN59N1xzDy/I2mR1YEViXBRu8dNAp
        0e1WaYs5ioKaP6Zi+s5rXM7PDJF9p5k=
X-Google-Smtp-Source: AFSGD/WdM3TiiOh82V1bzS/Lfj1DTjFNWNi+H99oAr0mLZHglK3MvxM0uNU6p/CKGhtzdGQtbbHzRQ==
X-Received: by 2002:a63:6645:: with SMTP id a66mr45723pgc.390.1544141619817;
        Thu, 06 Dec 2018 16:13:39 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id o66sm1654437pgo.75.2018.12.06.16.13.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Dec 2018 16:13:30 -0800 (PST)
From:   Brian Norris <briannorris@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     <linux-kernel@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [RFC PATCH v2 2/2] mwifiex: add NL80211_STA_INFO_RX_BITRATE support
Date:   Thu,  6 Dec 2018 16:12:49 -0800
Message-Id: <20181207001249.165477-2-briannorris@chromium.org>
X-Mailer: git-send-email 2.20.0.rc2.403.gdbc3b29805-goog
In-Reply-To: <20181207001249.165477-1-briannorris@chromium.org>
References: <20181207001249.165477-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Comparing the existing TX_BITRATE parsing code (in
mwifiex_parse_htinfo()) with the RX bitrate histograms in debugfs.c, it
appears that the rxpd_rate and rxpd_htinfo fields have the same format.
At least, they give reasonable results when I parse them this way.

So this patch adds support for RX_BITRATE to our station info dump.

Along the way, I add legacy bitrate parsing into the same function,
using the debugfs code (mwifiex_histogram_read() and
mwifiex_adjust_data_rate()) as reference.

Additionally, to satisfy the requirements of
NL80211_STA_INFO_RX_BITRATE, I skip logging the bitrate of multicast
packets. This shouldn't add a lot of overhead to the RX path, as there
are already several similar 802.3 header checks in this same codepath.
We can also bias the branch behavior to favor unicast, as that's the
common performance-sensitive case.

I'd consider this support somewhat experimental, as I have zero
documentation from Marvell. But the existing driver code gives me good
reason to think this is correct.

I've tested this on a few different 802.11{a,b,g,n,ac} networks, and the
reported bitrates look good to me.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
RFC: I'd appreciate it if someone from Marvell could double check my work
here.

v2:
 * no change - just split unrelated (debugfs) patch to its own series
---
 .../net/wireless/marvell/mwifiex/cfg80211.c   | 26 +++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/sta_rx.c | 13 ++++++----
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 02b80ea232a7..1467af22e394 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1333,6 +1333,28 @@ mwifiex_parse_htinfo(struct mwifiex_private *priv, u8 rateinfo, u8 htinfo,
 				rate->flags |= RATE_INFO_FLAGS_SHORT_GI;
 		}
 	}
+
+	/* Decode legacy rates for non-HT. */
+	if (!(htinfo & (BIT(0) | BIT(1)))) {
+		/* Bitrates in multiples of 100kb/s. */
+		static const int legacy_rates[] = {
+			[0] = 10,
+			[1] = 20,
+			[2] = 55,
+			[3] = 110,
+			[4] = 60, /* MWIFIEX_RATE_INDEX_OFDM0 */
+			[5] = 60,
+			[6] = 90,
+			[7] = 120,
+			[8] = 180,
+			[9] = 240,
+			[10] = 360,
+			[11] = 480,
+			[12] = 540,
+		};
+		if (rateinfo < ARRAY_SIZE(legacy_rates))
+			rate->legacy = legacy_rates[rateinfo];
+	}
 }
 
 /*
@@ -1414,6 +1436,10 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 	/* bit rate is in 500 kb/s units. Convert it to 100kb/s units */
 	sinfo->txrate.legacy = rate * 5;
 
+	sinfo->filled |= BIT(NL80211_STA_INFO_RX_BITRATE);
+	mwifiex_parse_htinfo(priv, priv->rxpd_rate, priv->rxpd_htinfo,
+			     &sinfo->rxrate);
+
 	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_BSS_PARAM);
 		sinfo->bss_param.flags = 0;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_rx.c b/drivers/net/wireless/marvell/mwifiex/sta_rx.c
index 00fcbda09349..fb28a5c7f441 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_rx.c
@@ -152,14 +152,17 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 		mwifiex_process_tdls_action_frame(priv, offset, rx_pkt_len);
 	}
 
-	priv->rxpd_rate = local_rx_pd->rx_rate;
-
-	priv->rxpd_htinfo = local_rx_pd->ht_info;
+	/* Only stash RX bitrate for unicast packets. */
+	if (likely(!is_multicast_ether_addr(rx_pkt_hdr->eth803_hdr.h_dest))) {
+		priv->rxpd_rate = local_rx_pd->rx_rate;
+		priv->rxpd_htinfo = local_rx_pd->ht_info;
+	}
 
 	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA ||
 	    GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
-		adj_rx_rate = mwifiex_adjust_data_rate(priv, priv->rxpd_rate,
-						       priv->rxpd_htinfo);
+		adj_rx_rate = mwifiex_adjust_data_rate(priv,
+						       local_rx_pd->rx_rate,
+						       local_rx_pd->ht_info);
 		mwifiex_hist_data_add(priv, adj_rx_rate, local_rx_pd->snr,
 				      local_rx_pd->nf);
 	}
-- 
2.20.0.rc2.403.gdbc3b29805-goog

