Return-Path: <SRS0=cxAL=VX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D837C76190
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jul 2019 22:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1021E20657
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jul 2019 22:48:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="diEvRYIg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfGZWsJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Jul 2019 18:48:09 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41218 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfGZWsJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jul 2019 18:48:09 -0400
Received: by mail-pg1-f195.google.com with SMTP id x15so15066987pgg.8
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jul 2019 15:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LE5HXl9c8iNYntyEAQHtNDVhGoM2MPcEXBamaCdK6L0=;
        b=diEvRYIgZeMYd6HRX8fxDannmRaRIM6VWY649ysOKDXKFfJCTyOTRa9R1AGwNU1M0e
         +kFonAz6/+fVMIQtrSTeNuuRJNCbQXlNKC+tsQsmzVZ8Euz7gXv22SZVwHnrgQr8TX9b
         R70OyhH8qdaM4HM0xfRUjT/3/xCoyY3AdN/HQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LE5HXl9c8iNYntyEAQHtNDVhGoM2MPcEXBamaCdK6L0=;
        b=PN2McVXm4oVXKDV3SHr4k5rrE8h8oCwWnBF5dDH/B9Nk+IehE7tkP12AteDVfTbhP9
         +m5jhd5vJ6nVfcI5bXipMFBS0r6Y7yilxgNj3BhshxUux9T4HGUFWhs6rvYOWWhnNWbY
         Gh9I162DL1LDaK/o4uqvutgObzmpxdKkrUfOQt8XGwgXZG3YnDF8a7mk70qOaxTbyMNV
         IhNcKAkre0AO2RYWmgEvHq1w8AGfpmPVfTewqM+jbNhjbHHaO7SgYYkXS5eZiB29yNWY
         lGL4CMf4I/cyDgP67Lz9lKmZX3QhYPJHkw0++sJXSXXdHto5fQ1gJlMGXNjbrpWaPR/Y
         oCjg==
X-Gm-Message-State: APjAAAVqcqb6PUZxtpVLCrU36+MEXF9zAJb61h98DZ531XtNGfwRx7x0
        RljLZ/jdq4fTSf9d40E161Wa0g==
X-Google-Smtp-Source: APXvYqw3eOEMITENtNwhowd3u7jd/LV05yb6g4NtCYbrvpUTO06IaoHwBwfygMqwhqr2edi/GazD0A==
X-Received: by 2002:a17:90a:2305:: with SMTP id f5mr105461085pje.128.1564181288411;
        Fri, 26 Jul 2019 15:48:08 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id s24sm54634766pfh.133.2019.07.26.15.48.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 15:48:07 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] mac80211: don't WARN on short WMM parameters from AP
Date:   Fri, 26 Jul 2019 15:47:58 -0700
Message-Id: <20190726224758.210953-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In a very similar spirit to commit c470bdc1aaf3 ("mac80211: don't WARN
on bad WMM parameters from buggy APs"), an AP may not transmit a
fully-formed WMM IE. For example, it may miss or repeat an Access
Category. The above loop won't catch that and will instead leave one of
the four ACs zeroed out. This triggers the following warning in
drv_conf_tx()

  wlan0: invalid CW_min/CW_max: 0/0

and it may leave one of the hardware queues unconfigured. If we detect
such a case, let's just print a warning and fall back to the defaults.

Tested with a hacked version of hostapd, intentionally corrupting the
IEs in hostapd_eid_wmm().

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 net/mac80211/mlme.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a99ad0325309..4c888dc9bd81 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2042,6 +2042,16 @@ ieee80211_sta_wmm_params(struct ieee80211_local *local,
 		ieee80211_regulatory_limit_wmm_params(sdata, &params[ac], ac);
 	}
 
+	/* WMM specification requires all 4 ACIs. */
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		if (params[ac].cw_min == 0) {
+			sdata_info(sdata,
+				   "AP has invalid WMM params (missing AC %d), using defaults\n",
+				   ac);
+			return false;
+		}
+	}
+
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		mlme_dbg(sdata,
 			 "WMM AC=%d acm=%d aifs=%d cWmin=%d cWmax=%d txop=%d uapsd=%d, downgraded=%d\n",
-- 
2.22.0.709.g102302147b-goog

