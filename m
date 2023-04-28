Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C46C7EE24
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Apr 2023 15:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346298AbjD1PI4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Apr 2023 11:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346268AbjD1PIv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2023 11:08:51 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50683AAC
        for <linux-wireless@vger.kernel.org>; Fri, 28 Apr 2023 08:08:49 -0700 (PDT)
From:   Martin Kaistra <martin.kaistra@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1682694519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wl/okVjd8oapw6a7KoMGgkkv8gc8/ZY89jL34lwNBnY=;
        b=sb6Fx7weRGvJWO0sx8AnU8/tHgAQWIM3r47XWTMVh6V6v/wi+YPKXqZEx6LLdu/UoSwl/Z
        hADcDlPQbV9/NIS/wn1jumW3ENWsuKeex9B96cpBO+5cl4O6wEH8Q3By5qlcIlMWXjTgFN
        PNKD8Zia/N57oYcP4TDAWQupYe4ARlhQz6LflCx+nG+ZValVESo/bxEwSXEXUfAJadevc4
        JP4IeS1osukpBLczwTlJGfPqnpn2lICE0UZeBbsQDM8kGBQH3e0FFreebs6hDIusXYXSL/
        0yAFmpyj9j0aO1ZrUzUmJaknztubi9hD1LB+T0CKWdU2s+CUT1fXjsgpn6ArfA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1682694519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wl/okVjd8oapw6a7KoMGgkkv8gc8/ZY89jL34lwNBnY=;
        b=8qfPq3DybeTZdF7D+jlRNFQ92e8oYb7MLGj2klvB2/2tcCO+Rpgr0jltjlZOwq9Z9Go42L
        Z81DEqVrdcQFiLAA==
To:     linux-wireless@vger.kernel.org
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v4 05/18] wifi: rtl8xxxu: Allow setting rts threshold to -1
Date:   Fri, 28 Apr 2023 17:08:20 +0200
Message-Id: <20230428150833.218605-6-martin.kaistra@linutronix.de>
In-Reply-To: <20230428150833.218605-1-martin.kaistra@linutronix.de>
References: <20230428150833.218605-1-martin.kaistra@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The default setting in hostapd.conf for rts threshold is -1, which means
disabled. Allow to set it.

Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 37794739c71c8..9d08a1c8c3b34 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6655,7 +6655,7 @@ static void rtl8xxxu_configure_filter(struct ieee80211_hw *hw,
 
 static int rtl8xxxu_set_rts_threshold(struct ieee80211_hw *hw, u32 rts)
 {
-	if (rts > 2347)
+	if (rts > 2347 && rts != (u32)-1)
 		return -EINVAL;
 
 	return 0;
-- 
2.30.2

