Return-Path: <SRS0=EpEU=EI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F31C00A89
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Nov 2020 11:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3832E223AB
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Nov 2020 11:26:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hqE+y6Ph"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbgKBL0H (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 2 Nov 2020 06:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728483AbgKBLZG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Nov 2020 06:25:06 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEBAC061A47
        for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2020 03:25:04 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id 33so3352429wrl.7
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2020 03:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zIn8muh7VBL1fkT+XkKMlktVpytHKFk/n3s4ZGv33nQ=;
        b=hqE+y6PheG1yrEeNLsS1M6iQUy/d4MhXF8Pr9nPQy+l66qcxrZTOeXOhqwtg8yEvJy
         Zo9d9j4r8X2Rc5+FzFljtSk9WCnBIu8mfs7jh37qudUIrqBLqrNwIJUQVx7UtEB7oyBB
         HKRzq7NE1teT5dJIUXsMusD5m2DlCXg5x1GpvwzhW8zI+TnMhj7K/sW6FVu1a4E48+mu
         wNsPIu5ZEGwtflVsCs2YPQ6Isjgr47+fdYo9+8JV5p9S3kPsf2fIVEyrM+U0gK8jOGSU
         oRjGMXhpL4sEdTVb+e+uJ9w2x6v9ZJ9e1fEENpJ+N421lhX4UYGVVao8rJgnofhnXxCI
         bBLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zIn8muh7VBL1fkT+XkKMlktVpytHKFk/n3s4ZGv33nQ=;
        b=m5HXWlc4Ae54dT+tL4/lXOLxYZPA1g2jer18u6ESVs3SDBTXDmudQAgWLL8rW6G6oD
         D83TIY2HLhQP5JC73ekX69nwf2J4GIDqwcfgRAB+AwYC1xodGX6WT77Zto7eJb5yw3dt
         Ch60lMzWIgSRUMv+COkcArEiz4yNWAhxxkAjwkf8ztmlQr7I1s4J9e5ieFdALerDeUjs
         I8J4pw+LK1DPkuYNVHuCRxQYwMv/1V2Qgqwo8TBlqaav0pQDJ07zlcLb8GgLIPKZ0Nly
         tcZi+ElGsppf6j3u7yFzMUJK21CdgYDNfeZp3DMzJufcA55Ex59PnMJM3IdJQdXbQ//v
         Lyow==
X-Gm-Message-State: AOAM532h5CvOHpvj/HpubZITnMgLO1kD8TatcWIx1cfB4xYq7kVG+6L2
        mnYVo0rYAAgM5UrW1Jd5zqvFBg==
X-Google-Smtp-Source: ABdhPJx/S5Q2OlmIsIYNzqdzdRxI/T1Zy8Ub1LoErrxHc/2spcetNSSjcmi3GMMHTmpmyVrGguPw4g==
X-Received: by 2002:adf:fc07:: with SMTP id i7mr14508376wrr.223.1604316303415;
        Mon, 02 Nov 2020 03:25:03 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:25:02 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 34/41] rtl8821ae: phy: Place braces around empty if() body
Date:   Mon,  2 Nov 2020 11:24:03 +0000
Message-Id: <20201102112410.1049272-35-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c: In function ‘_rtl8812ae_phy_get_txpower_limit’:
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:2453:3: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]

Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 72ee0700a5497..8a1a2277e137b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -2448,8 +2448,9 @@ static s8 _rtl8812ae_phy_get_txpower_limit(struct ieee80211_hw *hw,
 	else if (band == BAND_ON_5G)
 		channel_temp = _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(hw,
 		BAND_ON_5G, channel);
-	else if (band == BAND_ON_BOTH)
+	else if (band == BAND_ON_BOTH) {
 		;/* BAND_ON_BOTH don't care temporarily */
+	}
 
 	if (band_temp == -1 || regulation == -1 || bandwidth_temp == -1 ||
 		rate_section == -1 || channel_temp == -1) {
-- 
2.25.1

