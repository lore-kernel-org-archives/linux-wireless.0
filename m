Return-Path: <SRS0=Ljpw=BN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED07DC433DF
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Aug 2020 03:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA1FA20738
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Aug 2020 03:11:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KCazHJ0K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgHCDLW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Aug 2020 23:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbgHCDLV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Aug 2020 23:11:21 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D42C061756
        for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2020 20:11:20 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id d190so13001733wmd.4
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2020 20:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=azNHQsdJAoWWLTflM7Ey2S4srlS3jrEo8Q6zu9bfi9A=;
        b=KCazHJ0KESxu5Qe7sbtrF/XremK3VUToyVi0LwfpMO8oDZxM7fGX07Bcm4cSryBKdB
         slWxCeM99yTSQeq6/IBelaCC6JwQqBorw/13GflONbMLhKkOi98jlSXgHyE+nmG7N/xd
         kXuY3c39iP2nTHVCjRDcQTK/4OHWlI6ZhK3dLVNRboI7VGN2hoFro2hy27PuogjFPDbp
         96lDOzlO0FfmERbTJI/b21FcZjoJUfhcMthqSH9vcc28L7rGd07We6WA3B5SOCbQWNwQ
         MpyQO81SH1uLA/9o0JKPxVgzlauxid9nZN2rP4OEJBsbON2ZXFKSIRndQqfoonYcclfb
         X8wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=azNHQsdJAoWWLTflM7Ey2S4srlS3jrEo8Q6zu9bfi9A=;
        b=GJiZET+bPsamjqwY4ZMZCU6YiGk5mtj95JiGsqAEsZSaRvk44aeb0BPdK1u33vZRw7
         sgUlZKDSlPCS+aQBiqU+zpZ5rm5lX8fVf6MbYTjqoIDXjQR/xWYKSZohX0Nilz0TGeRb
         Cr7oOOnysikaL59v6OHkM7koJ3PfPa6xcUEUQeBJDVQ/BsWE96FWeBwsXQMwZie75qjH
         0Yehfu2TYURy9/bMKZiSgyJ4Y9pS4CONrbqPF/tYcAEMkx5khx66cujd+VNmHCn3vDE3
         rt0SUnkvVkTh+wrfwXjNA3kq3FdKvWmOeKAQxS9uCtX0E+NkWqAnBGRNlMCglyBjc6gV
         hGPQ==
X-Gm-Message-State: AOAM532n9cWktaqMc5JZ37GslrdOK0zkYeGStwRTznyC6/voEQBJ8R4g
        UfAdGW7PdkAgK7X9HTCJDXTUVVyNzgw=
X-Google-Smtp-Source: ABdhPJzKvBmndB3oioXUfDIjkMS7361zuGvsMouEm1hJd/sl0eMIscXkgbd7tzDzibuAe+4Xur0BdQ==
X-Received: by 2002:a1c:9d53:: with SMTP id g80mr13692876wme.70.1596424279680;
        Sun, 02 Aug 2020 20:11:19 -0700 (PDT)
Received: from localhost.localdomain ([176.61.57.127])
        by smtp.gmail.com with ESMTPSA id q2sm21956857wro.8.2020.08.02.20.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2020 20:11:19 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@codeaurora.org
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        bryan.odonoghue@linaro.org, shawn.guo@linaro.org
Subject: [PATCH 31/36] wcn36xx: Add accessor macro HW_VALUE_PHY for PHY settings
Date:   Mon,  3 Aug 2020 04:11:27 +0100
Message-Id: <20200803031132.1427063-32-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200803031132.1427063-1-bryan.odonoghue@linaro.org>
References: <20200803031132.1427063-1-bryan.odonoghue@linaro.org>
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
index ae8bda76d573..38d68161d9fd 100644
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

