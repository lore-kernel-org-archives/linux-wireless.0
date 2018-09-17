Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33756 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728669AbeIQWBN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 18:01:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id v90-v6so18025654wrc.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2018 09:33:06 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id c3-v6sm17807307wrm.56.2018.09.17.09.33.04
        for <linux-wireless@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 17 Sep 2018 09:33:05 -0700 (PDT)
From: =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] rt2x00: remove confusing AGC register
Date: Mon, 17 Sep 2018 18:32:54 +0200
Message-Id: <1537201975-3032-4-git-send-email-pozega.tomislav@gmail.com> (sfid-20180917_183318_272081_B4973FED)
In-Reply-To: <1537201975-3032-1-git-send-email-pozega.tomislav@gmail.com>
References: <1537201975-3032-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Register 66 was causing issues on RT6352 if set to the same value as
in MTK driver. With 1c reg value device was working fine in both HT20
and HT40 modes.

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index a47bbb6..a5eb17a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3839,10 +3839,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_bbp_write(rt2x00dev, 196, reg);
 
 		/* AGC init */
-		if (rt2x00_rt(rt2x00dev, RT6352))
-			reg = 0x04;
-		else
-			reg = rt2x00dev->curr_band == NL80211_BAND_2GHZ ? 0x1c : 0x24;
+		reg = rt2x00dev->curr_band == NL80211_BAND_2GHZ ? 0x1c : 0x24;
 
 		reg += 2 * rt2x00dev->lna_gain;
 		rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, reg);
-- 
1.7.0.4
