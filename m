Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7EBEC282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADCF520880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:43:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=agner.ch header.i=@agner.ch header.b="nDez2YDb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfA1PnV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:43:21 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:43694 "EHLO
        mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfA1PnV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:43:21 -0500
Received: from trochilidae.toradex.int (unknown [46.140.72.82])
        by mail.kmu-office.ch (Postfix) with ESMTPSA id A0F5A5C02F4;
        Mon, 28 Jan 2019 16:43:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=agner.ch; s=dkim;
        t=1548690199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:
         content-transfer-encoding:content-transfer-encoding:in-reply-to:
         references; bh=W7FgzYYgQ8xCMx21nXE4SnvSHuxx2lQO9JW+fKaNZyI=;
        b=nDez2YDbvjptvcv/UvH9Z04uh4swUo7etQTiMLLXlcjJpviN6oaVCoFDlQ4/f4TitTOA/s
        P0MzUyo9+XO35+vgs8k16T5rz8nPPD9gxNHMSXvECGqQbWzj54Bc+ryI0OqulR2rdbWM8Y
        qgab+/En7BNRk50EKlkGqBFGiv9Jga0=
From:   Stefan Agner <stefan@agner.ch>
To:     amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxinming820@gmail.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH] mwifiex: don't print error message on coex event
Date:   Mon, 28 Jan 2019 16:43:10 +0100
Message-Id: <20190128154310.17322-1-stefan@agner.ch>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The BT coex event is not an error condition. Don't print an error
message in this case. The same even in sta_event.c prints a
message using the debug level already.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/net/wireless/marvell/mwifiex/uap_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/uap_event.c b/drivers/net/wireless/marvell/mwifiex/uap_event.c
index e86217a6b9ca..ca759d9c0253 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_event.c
@@ -300,7 +300,7 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		mwifiex_11h_handle_radar_detected(priv, adapter->event_skb);
 		break;
 	case EVENT_BT_COEX_WLAN_PARA_CHANGE:
-		dev_err(adapter->dev, "EVENT: BT coex wlan param update\n");
+		mwifiex_dbg(adapter, EVENT, "event: BT coex wlan param update\n");
 		mwifiex_bt_coex_wlan_param_update_event(priv,
 							adapter->event_skb);
 		break;
-- 
2.20.1

