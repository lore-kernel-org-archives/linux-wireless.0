Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE2DC433E9
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Dec 2020 16:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC020208D5
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Dec 2020 16:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633532AbgL1Q2Q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Dec 2020 11:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2633524AbgL1Q2Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Dec 2020 11:28:16 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D789C061799
        for <linux-wireless@vger.kernel.org>; Mon, 28 Dec 2020 08:27:35 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id r7so11757681wrc.5
        for <linux-wireless@vger.kernel.org>; Mon, 28 Dec 2020 08:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T3vbkvpnDfJt+kYGiWTgD3Sze4DdRUv6z46Vf171QE0=;
        b=HlLRqSVjKEqFUmImV6+YMe8wWB5FdGEKQ5bUlfpiH2xr/VO29pKZhEsb9GumPp18SQ
         vii9CEasaZOZxGUBMl5M2WnAuw5rIdIuAbiZvAv5ELfnqmLUqx/VSCTINRmdlmBTVVdU
         Qie9VcxQtU9Tsh+fr6Nljsef9QususTRx8qvdH04KuYbbu9KA+6ElJaP3WA0y3Owxa0s
         GBMCHIN5EbIxlP9eFgL5B2ilzCvVBIiovlS/Cl7f1ZUKDtarjXAaoRFtUau/3GkSFf08
         TE664YOJoYis+6Robyvm2l+n9TB8VCMuXP4tFnDLeK53yvxqYPImxhcMzgZitf4WXHqd
         Yw6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T3vbkvpnDfJt+kYGiWTgD3Sze4DdRUv6z46Vf171QE0=;
        b=iWQPjwpL1l4SY255VRVms/vlS3ITTkoWQf5P4bSNeWLkhsUGSL+GfybAws5xj37sz1
         D35nRiycif9Xds/zSPN+2HmCcCo30f3sqOc3eXOMXr1B4ZLCzF6J56hFxEFDCfNTWPXr
         m1tjAfJWdgxL17KspMlNNF0+bUuKMQtRF0pS5J13x4+c0YL1BZu0qvD6CAgypB5lciVb
         auREj6WJ8rSBa2F9dhq3f9BqOGQrViD54vlrNy429BBpiYJz6F28eS/awxA+nW2yEcea
         Uq4BK2+UrBOet6HdBu1m0zry5ErBYkcmU8sYY43QEwbIDrf+h21dO4hadgCrCqlXLznn
         Pejw==
X-Gm-Message-State: AOAM5327fIS2EvaWcwTFbBde3oXUwAqNewZFiNU899jTOcLPTcPiCxRn
        cpSd0GQETRJ8A2Z46uHYRBVySw==
X-Google-Smtp-Source: ABdhPJy2cINhgUKs664Q3NzFhhQX0qID9mrg8c25yPNVK/vanGcAp2Y0yGXs0i9Zv8B4N6i0Vt5GAw==
X-Received: by 2002:adf:fd05:: with SMTP id e5mr52106185wrr.225.1609172854451;
        Mon, 28 Dec 2020 08:27:34 -0800 (PST)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id w21sm19523379wmi.45.2020.12.28.08.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 08:27:33 -0800 (PST)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@codeaurora.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org
Cc:     bryan.odonoghue@linaro.org, shawn.guo@linaro.org,
        benl@squareup.com, loic.poulain@linaro.org
Subject: [PATCH 04/13] wcn36xx: Do not flush indication queue on suspend/resume
Date:   Mon, 28 Dec 2020 16:28:30 +0000
Message-Id: <20201228162839.369156-5-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228162839.369156-1-bryan.odonoghue@linaro.org>
References: <20201228162839.369156-1-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Testing on Android reveals that the flush on both suspend and resume of the
firmware indication work-queue can stall indefinitely.

Given this code path doesn't appear to have been exercised up until now,
removing this flush to unblock this situation.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index c463ec7c1568..745512a6ad83 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1110,7 +1110,6 @@ static int wcn36xx_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wow)
 
 	wcn36xx_dbg(WCN36XX_DBG_MAC, "mac suspend\n");
 
-	flush_workqueue(wcn->hal_ind_wq);
 	mutex_lock(&wcn->conf_mutex);
 	vif = wcn36xx_get_first_vif(wcn);
 	if (vif) {
@@ -1135,7 +1134,6 @@ static int wcn36xx_resume(struct ieee80211_hw *hw)
 
 	wcn36xx_dbg(WCN36XX_DBG_MAC, "mac resume\n");
 
-	flush_workqueue(wcn->hal_ind_wq);
 	mutex_lock(&wcn->conf_mutex);
 	vif = wcn36xx_get_first_vif(wcn);
 	if (vif) {
-- 
2.29.2

