Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36771 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdGHH1v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Jul 2017 03:27:51 -0400
Received: by mail-wr0-f194.google.com with SMTP id 77so12225290wrb.3
        for <linux-wireless@vger.kernel.org>; Sat, 08 Jul 2017 00:27:51 -0700 (PDT)
From: Mathias Kresin <dev@kresin.me>
To: sgruszka@redhat.com, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rt2x00: call clk_get_rate only if we have a clock
Date: Sat,  8 Jul 2017 09:27:43 +0200
Message-Id: <1499498863-6865-1-git-send-email-dev@kresin.me> (sfid-20170708_092755_548770_9F5C50C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If clk_get returns an error, rt2x00dev->clk is set to NULL. In
contrast to the common clock framework provided clk_get_rate(), at
least the ramips and bcm63xx legacy implementation of the clk API
access the rate member of the clk struct without a NULL check. This
results into a kernel panic if we do not have a (SoC) clock.

Call clk_get_rate only if we have a clock to fix the issues. This
approach is similar to what is done in the kernel at various places.
Usually clk_get_rate() is only called if clk_get_rate() doesn't return
an error.

Signed-off-by: Mathias Kresin <dev@kresin.me>
---

Resend, the first mail had the wrong list in cc.

 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index d11c7b2..2a525b9 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -2059,6 +2059,9 @@ static void rt2800_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 
 static inline bool rt2800_clk_is_20mhz(struct rt2x00_dev *rt2x00dev)
 {
+	if (!rt2x00dev->clk)
+		return 0;
+
 	return clk_get_rate(rt2x00dev->clk) == 20000000;
 }
 
-- 
2.7.4
