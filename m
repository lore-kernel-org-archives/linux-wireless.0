Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54958 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab0IQXI1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 19:08:27 -0400
Received: by bwz11 with SMTP id 11so3128487bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 16:08:25 -0700 (PDT)
Message-Id: <813e28bb1320cc3825ae17e86f7e7bff8a451a87.1284763835.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1284763834.git.chunkeey@googlemail.com>
References: <cover.1284763834.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 17 Sep 2010 22:22:50 +0200
Subject: [PATCH 2/7] carl9170: fix noise dBm conversion
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ever since carl9170 gained support to read the noisefloor,
the reported noisefloor level was pretty poor.

Initially I assumed that something was wrong in the PHY
setup and it would be impossible to fix without any
guidances. But this was not the case. In fact the nf
readings were correct and the thing that was broken
was the "simple" sign extension code!

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/phy.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index fe265e3..7df8f71 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -1558,9 +1558,9 @@ static int carl9170_set_power_cal(struct ar9170 *ar, u32 freq,
 static int carl9170_calc_noise_dbm(u32 raw_noise)
 {
 	if (raw_noise & 0x100)
-		return ~((raw_noise & 0x0ff) >> 1);
+		return ~0x1ff | raw_noise;
 	else
-		return (raw_noise & 0xff) >> 1;
+		return raw_noise;
 }
 
 int carl9170_get_noisefloor(struct ar9170 *ar)
-- 
1.7.1

