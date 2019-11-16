Return-Path: <SRS0=oU4Q=ZI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2ACDC43141
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Nov 2019 16:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9ABEF214DE
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Nov 2019 16:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573921097;
	bh=1EzmoxlhEX6IlHcaaJRCa8HqlvFEPSAV4f3se9ynVhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=c0/rMz6JwPnrEsRja/OsDrvV91CEBKvPs7AdIaqIrBR9M/JOlbF32lW5vAZcQYUT8
	 XQ+hpHg72FQQ6bNi3cLAdRXNHRNXLjl7TaLnaCw2LMqovfFYphmN0zpM1TeVdvKGyf
	 ITRpIJNyZtvTS4ZXUDbSsyMb/l0eMa4L/9D2BArk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731842AbfKPQSN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Nov 2019 11:18:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729415AbfKPPqb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:31 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB9022084D;
        Sat, 16 Nov 2019 15:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919190;
        bh=1EzmoxlhEX6IlHcaaJRCa8HqlvFEPSAV4f3se9ynVhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NaVDqJaakFW+afZbvoAh7cAArTzNxlBY3YGjjY4uPIPGj+Ct4IgvOTR277sjbIK8G
         a/AGcalzGPgeRZGGjWvUQAMk+e2YXYzkXy55n+dwunlLVsKd8o0KikZOSTVH/dvR6K
         zw2Bn8q6czlhqsonqTruEd/9rpe1HCBuadHbgprA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lior David <liord@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 199/237] wil6210: fix locking in wmi_call
Date:   Sat, 16 Nov 2019 10:40:34 -0500
Message-Id: <20191116154113.7417-199-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lior David <liord@codeaurora.org>

[ Upstream commit dc57731dbd535880fe6ced31c229262c34df7d64 ]

Switch from spin_lock to spin_lock_irqsave, because
wmi_ev_lock is used inside interrupt handler.

Signed-off-by: Lior David <liord@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 2010f771478df..8a603432f5317 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1639,16 +1639,17 @@ int wmi_call(struct wil6210_priv *wil, u16 cmdid, u8 mid, void *buf, u16 len,
 {
 	int rc;
 	unsigned long remain;
+	ulong flags;
 
 	mutex_lock(&wil->wmi_mutex);
 
-	spin_lock(&wil->wmi_ev_lock);
+	spin_lock_irqsave(&wil->wmi_ev_lock, flags);
 	wil->reply_id = reply_id;
 	wil->reply_mid = mid;
 	wil->reply_buf = reply;
 	wil->reply_size = reply_size;
 	reinit_completion(&wil->wmi_call);
-	spin_unlock(&wil->wmi_ev_lock);
+	spin_unlock_irqrestore(&wil->wmi_ev_lock, flags);
 
 	rc = __wmi_send(wil, cmdid, mid, buf, len);
 	if (rc)
@@ -1668,12 +1669,12 @@ int wmi_call(struct wil6210_priv *wil, u16 cmdid, u8 mid, void *buf, u16 len,
 	}
 
 out:
-	spin_lock(&wil->wmi_ev_lock);
+	spin_lock_irqsave(&wil->wmi_ev_lock, flags);
 	wil->reply_id = 0;
 	wil->reply_mid = U8_MAX;
 	wil->reply_buf = NULL;
 	wil->reply_size = 0;
-	spin_unlock(&wil->wmi_ev_lock);
+	spin_unlock_irqrestore(&wil->wmi_ev_lock, flags);
 
 	mutex_unlock(&wil->wmi_mutex);
 
-- 
2.20.1

