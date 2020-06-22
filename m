Return-Path: <SRS0=2yIc=AD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D2BDC433E0
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Jun 2020 13:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6283020716
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Jun 2020 13:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbgFVNiI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Jun 2020 09:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729256AbgFVNiI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jun 2020 09:38:08 -0400
X-Greylist: delayed 941 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 22 Jun 2020 06:38:07 PDT
Received: from mxout017.mail.hostpoint.ch (mxout017.mail.hostpoint.ch [IPv6:2a00:d70:0:e::317])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FA2C061795
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2020 06:38:07 -0700 (PDT)
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
        by mxout017.mail.hostpoint.ch with esmtp (Exim 4.92.3 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1jnMPb-000LiO-KA; Mon, 22 Jun 2020 15:22:59 +0200
Received: from [2a02:168:6182:1:4840:f038:bf12:aa10] (helo=ryzen2700.dss.husqvarnagroup.com)
        by asmtp013.mail.hostpoint.ch with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1jnMPb-0006GV-27; Mon, 22 Jun 2020 15:22:59 +0200
X-Authenticated-Sender-Id: reto-schneider@reto-schneider.ch
From:   Reto Schneider <code@reto-schneider.ch>
To:     linux-wireless@vger.kernel.org
Cc:     Larry.Finger@lwfinger.net, Reto Schneider <code@reto-schneider.ch>
Subject: [PATCH 2/3] rtl8192cu: Prevent leaking urb
Date:   Mon, 22 Jun 2020 15:21:12 +0200
Message-Id: <20200622132113.14508-3-code@reto-schneider.ch>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200622132113.14508-1-code@reto-schneider.ch>
References: <20200622132113.14508-1-code@reto-schneider.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If usb_submit_urb fails the allocated urb should be unanchored and
released.

Signed-off-by: Reto Schneider <code@reto-schneider.ch>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index d3bbfc0171f6..1a9fcb2697bf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -720,8 +720,11 @@ static int _rtl_usb_receive(struct ieee80211_hw *hw)
 
 		usb_anchor_urb(urb, &rtlusb->rx_submitted);
 		err = usb_submit_urb(urb, GFP_KERNEL);
-		if (err)
+		if (err) {
+			usb_unanchor_urb(urb);
+			usb_free_urb(urb);
 			goto err_out;
+		}
 		usb_free_urb(urb);
 	}
 	return 0;
-- 
2.20.1

