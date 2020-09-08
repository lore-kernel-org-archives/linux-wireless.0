Return-Path: <SRS0=ylPz=CR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5056AC43461
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Sep 2020 18:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16A332080A
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Sep 2020 18:35:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sJ3q/QCw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731449AbgIHSfU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Sep 2020 14:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731661AbgIHSc3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Sep 2020 14:32:29 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADA6C0617BD
        for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2020 11:24:34 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id b79so298726wmb.4
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2020 11:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gyyyc+eVVPBc5oNmWeDufnX8Vdj7EzlctFSImbJVqV4=;
        b=sJ3q/QCwIc5SBl90sX76a7rYUxHXmw/hI2OdDgqa5uMO6+nU0PVtWNBiGXjLUpnJRs
         4DKButEsv7yhTfdhYOLclK/k1Z7zaFL+0dapLwIL36vAU9naeeQtEWstLCA6uHtJ8ADD
         Sm9csVq9dWl0ddjzV6ykuPGWVoSBHZFjHwStRBeAsZMjbwJQmO4w9hHS2qWTJgjnw3ka
         la6A6F010eJ6r+IWIk7vl1BUtg3+Wl1061az25RqR51HQdEQxRCgDaHex4CtgwkhTh76
         Ba2W0NoiDL4Hyn22esZN7ZvoK2VuEYzUsgAOaiyE1bPJ1T3+3hCk+fwcVBQ2hJRAv0pi
         OVOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gyyyc+eVVPBc5oNmWeDufnX8Vdj7EzlctFSImbJVqV4=;
        b=A3gEJNdGyORDx+Rur7kMuZeGl+2JC7IKxkIAXOVBETQcjJ/qKRHb/xPXHTI0rds1nh
         oYy27b6MpoAiczXmpcgW5FgqmqKm3HEgqlztfGKrxJqbvTcumdA1CG7gGxIlg8jYQB1o
         1AlyME9NWsqo1F+lUe/Ug5OQ5QvwnFlwqozXsJjAChmWC14mT5PNxjKqVdmJVlrqqNJW
         ShvmYJ4ImqNY3Gc20KgUIHyqP1i8rhkODyWTN+gZ/CmsVY+z6v/QAGlD5/hGa2S46j08
         zfXU9QrXenlwiaHQweBINxR/NO6RF7AGn1jWnUobznwTpMyYjm+1QOPJIyJHVBUD2idm
         Dk9Q==
X-Gm-Message-State: AOAM533VB9VeivbC8VSIvsu5zRUhuW6wmmfOz/a2XEgcdIAj5bw6zu8i
        6+rJPVJ4XN66F9gjNqpzdoqFALCLQ2LoOg==
X-Google-Smtp-Source: ABdhPJzmyt/uV51YIHc0zyS98DTSsNe1JlzEbnvA3bA2DY5BMM8DqrD5sybmxvT3ffyyTuEXTgiItA==
X-Received: by 2002:a1c:9ed8:: with SMTP id h207mr409361wme.116.1599589471144;
        Tue, 08 Sep 2020 11:24:31 -0700 (PDT)
Received: from localhost.localdomain ([176.61.57.127])
        by smtp.gmail.com with ESMTPSA id f14sm352447wrv.72.2020.09.08.11.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 11:24:30 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@codeaurora.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org
Cc:     bryan.odonoghue@linaro.org, shawn.guo@linaro.org,
        loic.poulain@linaro.org
Subject: [PATCH v3 3/5] wcn36xx: Add accessor macro HW_VALUE_PHY for PHY settings
Date:   Tue,  8 Sep 2020 19:25:12 +0100
Message-Id: <20200908182514.2870410-4-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200908182514.2870410-1-bryan.odonoghue@linaro.org>
References: <20200908182514.2870410-1-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Adds HW_VALUE_PHY(hw_value) an access macro that will be used to
extract a hardware specific PHY setting for a given channel.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index ebce1ed7adf7..71fa9992b118 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -83,6 +83,8 @@ enum wcn36xx_ampdu_state {
 	WCN36XX_AMPDU_OPERATIONAL,
 };
 
+#define HW_VALUE_PHY_SHIFT 8
+#define HW_VALUE_PHY(hw_value) ((hw_value) >> HW_VALUE_PHY_SHIFT)
 #define HW_VALUE_CHANNEL(hw_value) ((hw_value) & 0xFF)
 #define WCN36XX_HW_CHANNEL(__wcn)\
 	HW_VALUE_CHANNEL(__wcn->hw->conf.chandef.chan->hw_value)
-- 
2.27.0

