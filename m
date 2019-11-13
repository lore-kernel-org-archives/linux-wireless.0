Return-Path: <SRS0=dvfj=ZF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73935C43141
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 23:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAA39206D8
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 23:36:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UYHYWaYY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfKMXgD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Nov 2019 18:36:03 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45738 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbfKMXgD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Nov 2019 18:36:03 -0500
Received: by mail-pf1-f196.google.com with SMTP id z4so2727438pfn.12
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2019 15:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SjmhxW54SXkSEjAKtCETMQbt3jTR5yZxCqORBZRYl58=;
        b=UYHYWaYYM781SsQdehbJpzWjlTZmQAIGfEsd5+W03I1MfDcbb+sfyDvqsXdbEIJnD/
         VeX0GVTgrjC/zFLMI9MKbhZmJFhBTj5owbuGxRzMRJGL+EDTPcud/hGhzCG0fQXR9z0y
         ZVZBuaYIAnn4lTJYx4KcQ0mPRfIOjmYRvElsfqVJQol+GC5yiyGfGn9j9dGdVRISKxmD
         dLOuZuTrtwISDD3egQH3LrKeKD3mJndVfjhSunIcGroSQDvVOVL1pxfV+3CboksyLw6v
         MOxNXnaoEsbIdnFE3y8/gqEZRfS+pr6IL2n9uxDjuGsY0e0cPXyA79uQk0BEXoIsDlaK
         fxKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SjmhxW54SXkSEjAKtCETMQbt3jTR5yZxCqORBZRYl58=;
        b=Ix86AIooc5ZNvRAu8jKcs4mfUw1o7H2plLQDvDNBsm898S9VSpJuvES2sUbagreekb
         KVbSFA8/7hByQ0I2pJb6aIv3yO6KMnsZGJ7/T3caZYYis3QpYvD2hW626+i3WvXHrl9U
         ZIlyb7H2gJRdsvDfmnM5HJntIupYyS7O3IsznlhICWuIL9QlYGHXEtDTkcOfo2mlGhef
         FF4K0Calx0MWYQsX6NLrEgoY2y8gYWh0Hdm7hx6KltooTPwIiarLgnCa9W77uUyWUaV/
         Nnkw2XXWfBIr9CK5lBXw5FCRzduJoKjW9F4ttcYUTxwfkvx49ZCtZSuErAvcSogOrRVy
         lMNw==
X-Gm-Message-State: APjAAAWJ09HSIR8yBC+TLPmJP3QThEH5Rg1Iy+zomcsm4FGV82bes47K
        i/hvmHd38+2w87F7sUwjR+DjxA==
X-Google-Smtp-Source: APXvYqzevviBfAs8NwUJeoBiiRsJnoiWpZyqm4FO+fpamuqtnkn0q+9YBFL5LiaKBLj/jtOre/3uvA==
X-Received: by 2002:a63:731a:: with SMTP id o26mr6696115pgc.108.1573688162549;
        Wed, 13 Nov 2019 15:36:02 -0800 (PST)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id v10sm3526345pgr.37.2019.11.13.15.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 15:36:01 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, govinds@codeaurora.org
Subject: [PATCH] ath10k: qmi: Sleep for a while before assigning MSA memory
Date:   Wed, 13 Nov 2019 15:35:58 -0800
Message-Id: <20191113233558.4040259-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Unless we sleep for a while before transitioning the MSA memory to WLAN
the MPSS.AT.4.0.c2-01184-SDM845_GEN_PACK-1 firmware triggers a security
violation fairly reliably. Unforutnately recovering from this failure
always results in the entire system freezing.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 637f83ef65f8..a0ba07b85362 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -773,6 +773,13 @@ static void ath10k_qmi_event_server_arrive(struct ath10k_qmi *qmi)
 	if (ret)
 		return;
 
+	/*
+	 * HACK: sleep for a while inbetween receiving the msa info response
+	 * and the XPU update to prevent SDM845 from crashing due to a security
+	 * violation, when running MPSS.AT.4.0.c2-01184-SDM845_GEN_PACK-1.
+	 */
+	msleep(20);
+
 	ret = ath10k_qmi_setup_msa_permissions(qmi);
 	if (ret)
 		return;
-- 
2.23.0

