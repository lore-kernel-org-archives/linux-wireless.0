Return-Path: <SRS0=YAv/=7V=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF30C433E1
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Jun 2020 23:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E839F20737
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Jun 2020 23:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591660546;
	bh=5nAVtwoFHCoPigIxGOY2qWRJl5r7Z7evVNEqTcc2Ow8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=DvG3RKt3woLAW55YZIVTAECdx/CvOEOGHbG8fkUjuHWoI7RvwJgSCF1Z5tMFnaNYF
	 jKeIwSO6jlsXreMitKNTOwdFG19Q7eTCj/76/+jA/WkvBLJ8234L7/f6l8t9EL3XVN
	 8yE+7uVKmPsgPTpVIHXQ8GVOtCUa69NezPWlHyC4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbgFHXXy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Jun 2020 19:23:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731547AbgFHXXw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jun 2020 19:23:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D6CF208A9;
        Mon,  8 Jun 2020 23:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658632;
        bh=5nAVtwoFHCoPigIxGOY2qWRJl5r7Z7evVNEqTcc2Ow8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Anwz8KRDnOBdu9nYCgQgnH/w3b6OnLEAyV1wOgxM0oQXQxt183bu7M49Fs56YjNUq
         4iZ0LS4IG8wzMEgFar9yJN8OcfugUkZsyPqkNuGiWZsqSDb9fLseUxqJL4VOg7XsJv
         vx4zWEl0vybFzvHC0ILZMSjqVsGpi+z2XVLEGuHM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masashi Honma <masashi.honma@gmail.com>,
        Denis <pro.denis@protonmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 055/106] ath9k_htc: Silence undersized packet warnings
Date:   Mon,  8 Jun 2020 19:21:47 -0400
Message-Id: <20200608232238.3368589-55-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232238.3368589-1-sashal@kernel.org>
References: <20200608232238.3368589-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Masashi Honma <masashi.honma@gmail.com>

[ Upstream commit 450edd2805982d14ed79733a82927d2857b27cac ]

Some devices like TP-Link TL-WN722N produces this kind of messages
frequently.

kernel: ath: phy0: Short RX data len, dropping (dlen: 4)

This warning is useful for developers to recognize that the device
(Wi-Fi dongle or USB hub etc) is noisy but not for general users. So
this patch make this warning to debug message.

Reported-By: Denis <pro.denis@protonmail.com>
Ref: https://bugzilla.kernel.org/show_bug.cgi?id=207539
Fixes: cd486e627e67 ("ath9k_htc: Discard undersized packets")
Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200504214443.4485-1-masashi.honma@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index b5d7ef4da17f..f19393e584dc 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -999,9 +999,9 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	 * which are not PHY_ERROR (short radar pulses have a length of 3)
 	 */
 	if (unlikely(!rs_datalen || (rs_datalen < 10 && !is_phyerr))) {
-		ath_warn(common,
-			 "Short RX data len, dropping (dlen: %d)\n",
-			 rs_datalen);
+		ath_dbg(common, ANY,
+			"Short RX data len, dropping (dlen: %d)\n",
+			rs_datalen);
 		goto rx_next;
 	}
 
-- 
2.25.1

