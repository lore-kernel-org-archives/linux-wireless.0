Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D9BC678D4
	for <linux-wireless@archiver.kernel.org>; Mon,  6 Mar 2023 12:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjCFMvC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 6 Mar 2023 07:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbjCFMu7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2023 07:50:59 -0500
Received: from stravinsky.debian.org (stravinsky.debian.org [IPv6:2001:41b8:202:deb::311:108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AC12C649;
        Mon,  6 Mar 2023 04:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
        :References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=8zNKlKhM0O0aNAjf3D7gkhepjgOa5hI05EN7HEbUygc=; b=eTt2M75dmxCrhg6u5BKL+NFGYA
        lFkRTRd1l6Nwwi8O75vpCRI0v9H0ci8gyDvI1cArSY91fnZI+Umcj+SU1XPA7DVTeGGl2RTGsczrW
        tHxQrPehORBiCqWapJflj0Wa8G3jVXHeWtPA9rkvNvgANWtru0XdqvMwpoP7tKVBnFOIgKTuIt5br
        m3EoUS1/c9nhvdUkCAgxRJSU9mx0gtjBbWcgKre2yVPQwumehIM3DOlEh+pcUkJWriuu1KvAN7eeh
        RdPrp3fAQpbUxVIN7zowfVvkFmUwssIQ8sy6TzZXWP/OO/PFfpbLFVGHB0BArNmL9G6tvi4Iq3vEd
        fBmTDfkg==;
Received: from authenticated user
        by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <bage@debian.org>)
        id 1pZAIe-001orv-Aj; Mon, 06 Mar 2023 12:50:44 +0000
From:   Bastian Germann <bage@debian.org>
To:     toke@toke.dk, Kalle Valo <kvalo@kernel.org>
Cc:     Bastian Germann <bage@debian.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] wifi: ath9k: Remove Qwest/Actiontec 802AIN ID
Date:   Mon,  6 Mar 2023 13:50:40 +0100
Message-Id: <20230306125041.2221-1-bage@debian.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305210245.9831-1-bage@debian.org>
References: <20230305210245.9831-1-bage@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The USB device 1668:1200 is Qwest/Actiontec 802AIN which is also
correctly claimed to be supported by carl9170.

Supposedly, the successor 802AIN2 which has an ath9k compatible chip
whose USB ID (unknown) could be inserted instead.

Drop the ID from the wrong driver.

Signed-off-by: Bastian Germann <bage@debian.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index f521dfa2f194..1395536720b0 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -42,8 +42,6 @@ static const struct usb_device_id ath9k_hif_usb_ids[] = {
 
 	{ USB_DEVICE(0x0cf3, 0x7015),
 	  .driver_info = AR9287_USB },  /* Atheros */
-	{ USB_DEVICE(0x1668, 0x1200),
-	  .driver_info = AR9287_USB },  /* Verizon */
 
 	{ USB_DEVICE(0x0cf3, 0x7010),
 	  .driver_info = AR9280_USB },  /* Atheros */
-- 
2.39.2

