Return-Path: <SRS0=1g4v=XS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97AA6C4CEC4
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 19:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D11720665
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 19:49:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JsvvtVAx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502403AbfIWTtf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Sep 2019 15:49:35 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:43735 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728561AbfIWTtf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Sep 2019 15:49:35 -0400
Received: by mail-wr1-f54.google.com with SMTP id q17so15314194wrx.10
        for <linux-wireless@vger.kernel.org>; Mon, 23 Sep 2019 12:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aKtmtSedZmqwNRKQvTjw2tVLyZk03BE91Oh9l3casmw=;
        b=JsvvtVAxCOZoelDBfv0L7dpTIp+6bhECrNPMlbkJBaReoPqBMYFAsQQF6DWn+iKuoV
         AXsMK8uu/ZpJmKRa1Hoe/Jp1kF7U+nKFMSFA7cOBi4AuYf+IDVeQhl395hPLX1bunZPX
         +KwUHbiEUX2sI8DnvXOrf8hJ5Ff4sLiyAn2YkEPXay2myhY3/pB3CxN8kH6Yhxgu3BWn
         WQluni2SyyXpjmdQEexEfZLb5a4Owu9ImsJpEipmIULkyzlMMUn5CyO9VeqXh6AA/J2Z
         vzNI+C0jD6XaAyvgbTAjxxZ9LeeKoeY/RG2U5LGlL/bdfQXXkajTEZzj8p5P4olaZoqq
         8LKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aKtmtSedZmqwNRKQvTjw2tVLyZk03BE91Oh9l3casmw=;
        b=Ck3WvrA0A31xFhB5ZRYJl3fPUdurP1/SNXsdci0MQ2lzyX23QZW+ztBE3EsMiqDsUM
         TTBZcPMf+ZTJe7VTMJWjTP4MVTu093x9mRLNcggpmPtP7P/8ASFVDBifoxEKYHbzM/KC
         ivYj5AX1XzioQfLK81SPewtWZhf55kuaTKsHydC6ZGfnGVm6CUf/Z9zvY5xt2OvrW+qw
         JFuEfpcBp+DcUiy9Ja3OKzBCx4Hc2v1754k5R5iGgH9cwdnAnXbJdQAPRzW191Mh+2lF
         mIN5e6qVAW5LktF7kd0nJhlyCfnrtix+fsa5G4JmeNWyjY/Hqt41NQ7IR/cVGHllPdc/
         oTOA==
X-Gm-Message-State: APjAAAW8285aSlfw8jjzqmW3g5g2kmnsHsdFnDolg/N8NZysIZP1pIuW
        Y/gtQjukQHz9JJxlcQDqWx1tS7+a
X-Google-Smtp-Source: APXvYqzRZfNdTml48n2fpSD+PnGFA8XeER/BMeskg+CehdxikXvvDyocfgel1T0zP/CQteTzEEuTAA==
X-Received: by 2002:a05:6000:a:: with SMTP id h10mr802484wrx.226.1569268171849;
        Mon, 23 Sep 2019 12:49:31 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id o188sm25108013wma.14.2019.09.23.12.49.31
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 23 Sep 2019 12:49:31 -0700 (PDT)
From:   =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, ath10k@lists.infradead.org
Subject: [PATCH 4/5] ath10k: change sw version print format to hex
Date:   Mon, 23 Sep 2019 21:49:24 +0200
Message-Id: <1569268165-1639-4-git-send-email-pozega.tomislav@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1569268165-1639-1-git-send-email-pozega.tomislav@gmail.com>
References: <1569268165-1639-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Software version within WMI event ready message was displayed
in a not very useful decimal format. Change this info to be shown
in a hexadecimal format instead.

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 2d43adf..59d2d2a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5650,7 +5650,7 @@ int ath10k_wmi_event_ready(struct ath10k *ar, struct sk_buff *skb)
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
-		   "wmi event ready sw_version %u abi_version %u mac_addr %pM status %d\n",
+		   "wmi event ready sw_version 0x%08x abi_version %u mac_addr %pM status %d\n",
 		   __le32_to_cpu(arg.sw_version),
 		   __le32_to_cpu(arg.abi_version),
 		   arg.mac_addr,
-- 
1.7.0.4

