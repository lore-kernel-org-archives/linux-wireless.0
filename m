Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5914C4707F
	for <linux-wireless@archiver.kernel.org>; Sat, 22 May 2021 17:18:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7388361261
	for <linux-wireless@archiver.kernel.org>; Sat, 22 May 2021 17:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhEVRUB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 22 May 2021 13:20:01 -0400
Received: from mail1.protonmail.ch ([185.70.40.18]:38508 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbhEVRUA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 May 2021 13:20:00 -0400
Date:   Sat, 22 May 2021 17:18:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connolly.tech;
        s=protonmail; t=1621703914;
        bh=WlHj8+hYLpUTFjiTZdr99nZUavHMI2QsMlfTHObc/l8=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=MfV4u3OEmc0gkMCptyVJapnyaue9CQJfU2dxSaC2tvGYMRqb5nuBcP4ndMS8zW93R
         1XsJIBHZuMxb2Xuql43GlaAxniDDP0g2+Bj1eVoGIi8L+5YTKc+oW7sYbej2Sm7vAu
         UoNjEUqM9c7J6CL/86SeZY54baUvCHlJIoTMg+iA=
To:     caleb@connolly.tech, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Caleb Connolly <caleb@connolly.tech>
Cc:     ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Caleb Connolly <caleb@connolly.tech>
Subject: [PATCH] ath10k: demote chan info without scan request warning
Message-ID: <20210522171609.299611-1-caleb@connolly.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Some devices/firmwares cause this to be printed every 5-15 seconds,
though it has no impact on functionality. Demote this to a debug
message.

Signed-off-by: Caleb Connolly <caleb@connolly.tech>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/a=
th/ath10k/wmi.c
index d48b922215eb..6c69f7ef0546 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2795,7 +2795,7 @@ void ath10k_wmi_event_chan_info(struct ath10k *ar, st=
ruct sk_buff *skb)
 =09switch (ar->scan.state) {
 =09case ATH10K_SCAN_IDLE:
 =09case ATH10K_SCAN_STARTING:
-=09=09ath10k_warn(ar, "received chan info event without a scan request, ig=
noring\n");
+=09=09ath10k_dbg(ar, ATH10K_DBG_WMI, "received chan info event without a s=
can request, ignoring\n");
 =09=09goto exit;
 =09case ATH10K_SCAN_RUNNING:
 =09case ATH10K_SCAN_ABORTING:
--
2.31.1


