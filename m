Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:26246 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751338AbdB0RQ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 12:16:26 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.neratec.com (Postfix) with ESMTP id 3F44ACE0374
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2017 15:49:40 +0100 (CET)
Received: from mail.neratec.com ([127.0.0.1])
        by localhost (mail.neratec.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id GlOIHHN7bcic for <linux-wireless@vger.kernel.org>;
        Mon, 27 Feb 2017 15:49:40 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mail.neratec.com (Postfix) with ESMTP id 1F301CE0397
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2017 15:49:40 +0100 (CET)
Received: from mail.neratec.com ([127.0.0.1])
        by localhost (mail.neratec.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ejy44u1O6ymK for <linux-wireless@vger.kernel.org>;
        Mon, 27 Feb 2017 15:49:40 +0100 (CET)
Received: from zefir.neratec.local (zefir.neratec.local [192.168.11.169])
        by mail.neratec.com (Postfix) with ESMTPSA id F12C9CE0374
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2017 15:49:39 +0100 (CET)
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: don't trigger spectral scan when not enabled
Date: Mon, 27 Feb 2017 15:49:36 +0100
Message-Id: <1488206976-7775-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20170227_181736_085678_C868038C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Doing so enables the FFT generation without prior
configuration, leading to an IRQ storm caused by
invalid (or at least unwanted) PHY errors.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 58f1ed1..51b618c 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -739,6 +739,9 @@ void ath9k_cmn_spectral_scan_trigger(struct ath_common *common,
 		return;
 	}
 
+	if (!spec_priv->spec_config.enabled)
+		return;
+
 	ath_ps_ops(common)->wakeup(common);
 	rxfilter = ath9k_hw_getrxfilter(ah);
 	ath9k_hw_setrxfilter(ah, rxfilter |
-- 
2.7.4
