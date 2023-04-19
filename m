Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22023C77B75
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Apr 2023 10:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbjDSKCc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Apr 2023 06:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbjDSKCR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Apr 2023 06:02:17 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD245276
        for <linux-wireless@vger.kernel.org>; Wed, 19 Apr 2023 03:02:16 -0700 (PDT)
From:   Martin Kaistra <martin.kaistra@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1681898532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A0gIrPs+ijZkyXP1O1tJbboOu7bibc0lzRsbRMQ+rtY=;
        b=rcCYNsnVbqSjq7MNfTint8zGhjLOwk4qLZiP+Af6vl2YdNnN+LdWhTF7hMVEVGCpgzNq5Z
        p09GGoS9F3zs3e7x9/5Pu4OySNfmMu+xPMmUwmD0sHn2dk6AZdE/N/TyHFP8wQl/C05Gkl
        SmPExEKegDmHH0PR/jlyKNjeUXqjrFc7guF15/M8kOzG+9Mbh75x+qqvRfvoyWP9yx7cTg
        REvnZMhZywa6XXXeocCQ0uXNRTMRvqlByh/EWfKBOypphBFtwCPe6QozNKrYSpWWknaftU
        5KgJxH52Nr7g03ElRQXf3mNU4C5pf62whb5LySLYdz3lYQ4AiQk9njLXx8Dz0w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1681898532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A0gIrPs+ijZkyXP1O1tJbboOu7bibc0lzRsbRMQ+rtY=;
        b=X2zRB0wDbdkL36aUICixOnIxL0ETSl8ZAthKP5OvMKDfDsmC+NT4B5LGkkiLQ7XG2TpSZD
        paIiUugDSEoiZoBA==
To:     linux-wireless@vger.kernel.org
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v2 07/18] wifi: rtl8xxxu: Actually use macid in rtl8xxxu_gen2_report_connect
Date:   Wed, 19 Apr 2023 12:01:34 +0200
Message-Id: <20230419100145.159191-8-martin.kaistra@linutronix.de>
In-Reply-To: <20230419100145.159191-1-martin.kaistra@linutronix.de>
References: <20230419100145.159191-1-martin.kaistra@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The report_connect function has had a macid parameter from the
beginning, but it has not been used, because in STA mode, the value was
always zero.
As it can now have different values in AP mode, actually wire it up to
the H2C command.

Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index de44e79dd186a..ede9f7e1c446c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4544,6 +4544,8 @@ void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 	else
 		h2c.media_status_rpt.parm &= ~BIT(0);
 
+	h2c.media_status_rpt.macid = macid;
+
 	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.media_status_rpt));
 }
 
-- 
2.30.2

