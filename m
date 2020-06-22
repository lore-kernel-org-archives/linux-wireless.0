Return-Path: <SRS0=2yIc=AD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E09C433DF
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Jun 2020 13:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B091020716
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Jun 2020 13:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgFVNsI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Jun 2020 09:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728212AbgFVNsH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jun 2020 09:48:07 -0400
Received: from mxout012.mail.hostpoint.ch (mxout012.mail.hostpoint.ch [IPv6:2a00:d70:0:e::312])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33694C061573
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2020 06:48:07 -0700 (PDT)
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
        by mxout012.mail.hostpoint.ch with esmtp (Exim 4.92.3 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1jnMPq-000B1F-4A; Mon, 22 Jun 2020 15:23:14 +0200
Received: from [2a02:168:6182:1:4840:f038:bf12:aa10] (helo=ryzen2700.dss.husqvarnagroup.com)
        by asmtp013.mail.hostpoint.ch with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1jnMPk-0006GV-2c; Mon, 22 Jun 2020 15:23:14 +0200
X-Authenticated-Sender-Id: reto-schneider@reto-schneider.ch
From:   Reto Schneider <code@reto-schneider.ch>
To:     linux-wireless@vger.kernel.org
Cc:     Larry.Finger@lwfinger.net, Reto Schneider <code@reto-schneider.ch>
Subject: [PATCH 3/3] rtl8192cu: Free ieee80211_hw if probing fails
Date:   Mon, 22 Jun 2020 15:21:13 +0200
Message-Id: <20200622132113.14508-4-code@reto-schneider.ch>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200622132113.14508-1-code@reto-schneider.ch>
References: <20200622132113.14508-1-code@reto-schneider.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In case of an error, no one will use the allocated structure. Call
ieee80211_free_hw, same as in rtl_usb_disconnect.

Signed-off-by: Reto Schneider <code@reto-schneider.ch>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 1a9fcb2697bf..d05e709536ea 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1087,6 +1087,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 	usb_put_dev(udev);
 	complete(&rtlpriv->firmware_loading_complete);
 	kfree(rtlpriv->usb_data);
+	ieee80211_free_hw(hw);
 	return -ENODEV;
 }
 EXPORT_SYMBOL(rtl_usb_probe);
-- 
2.20.1

