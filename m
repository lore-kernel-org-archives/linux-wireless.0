Return-Path: <SRS0=2yIc=AD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B225C433E0
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Jun 2020 13:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2747320738
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Jun 2020 13:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgFVNjl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Jun 2020 09:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728212AbgFVNjl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jun 2020 09:39:41 -0400
Received: from mxout014.mail.hostpoint.ch (mxout014.mail.hostpoint.ch [IPv6:2a00:d70:0:e::314])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13ADC061573
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2020 06:39:40 -0700 (PDT)
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
        by mxout014.mail.hostpoint.ch with esmtp (Exim 4.92.3 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1jnMPP-000Hxu-Ke; Mon, 22 Jun 2020 15:22:47 +0200
Received: from [2a02:168:6182:1:4840:f038:bf12:aa10] (helo=ryzen2700.dss.husqvarnagroup.com)
        by asmtp013.mail.hostpoint.ch with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1jnMPP-0006GV-F3; Mon, 22 Jun 2020 15:22:47 +0200
X-Authenticated-Sender-Id: reto-schneider@reto-schneider.ch
From:   Reto Schneider <code@reto-schneider.ch>
To:     linux-wireless@vger.kernel.org
Cc:     Larry.Finger@lwfinger.net, Reto Schneider <code@reto-schneider.ch>
Subject: [PATCH 1/3] rtl8192cu: Fix deadlock
Date:   Mon, 22 Jun 2020 15:21:11 +0200
Message-Id: <20200622132113.14508-2-code@reto-schneider.ch>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200622132113.14508-1-code@reto-schneider.ch>
References: <20200622132113.14508-1-code@reto-schneider.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Prevent code from calling itself indirectly, causing the driver to hang
and consume 100% CPU.

Without this fix, the following script can bring down a single CPU
system:
```
while true; do
  rmmod rtl8192cu
  modprobe rtl8192cu
done
```

Signed-off-by: Reto Schneider <code@reto-schneider.ch>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index c66c6dc00378..d3bbfc0171f6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -680,8 +680,10 @@ static void _rtl_usb_cleanup_rx(struct ieee80211_hw *hw)
 	tasklet_kill(&rtlusb->rx_work_tasklet);
 	cancel_work_sync(&rtlpriv->works.lps_change_work);
 
-	flush_workqueue(rtlpriv->works.rtl_wq);
-	destroy_workqueue(rtlpriv->works.rtl_wq);
+	if (rtlpriv->works.rtl_wq) {
+		destroy_workqueue(rtlpriv->works.rtl_wq);
+		rtlpriv->works.rtl_wq = NULL;
+	}
 
 	skb_queue_purge(&rtlusb->rx_queue);
 
-- 
2.20.1

