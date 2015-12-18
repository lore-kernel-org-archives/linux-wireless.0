Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37756 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbbLRJtL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 04:49:11 -0500
Received: by mail-wm0-f41.google.com with SMTP id p187so56779796wmp.0
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2015 01:49:11 -0800 (PST)
From: Pawel Kulakowski <pawel.kulakowski@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@qca.qualcomm.com,
	Pawel Kulakowski <pawel.kulakowski@tieto.com>
Subject: [PATCH] ath9k: Enable support for cloned SKBS
Date: Fri, 18 Dec 2015 10:48:57 +0100
Message-Id: <1450432137-30668-1-git-send-email-pawel.kulakowski@tieto.com> (sfid-20151218_104919_792803_63B3031C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ath9k driver does not modify tx skbs, so SUPPORTS_CLONED_SKBS
flag can be set. Enabling this flag significant reduce number
of copy operation during TCP Tx. This is especially noticeable
on platforms with slower CPU (lower CPU usage brings
profits in better TCP Tx troughput results).

Tested on MIPS with 560 MHz clock
Without CLONED_SKBS flag:
TCP Tx 145 Mb/s (iperf result)
__copy_user_common consumes 12.9% of CPU (result from perf tool)
0% CPU Idle

With CLONED_SKBS flag:
TCP Tx 170 Mb/s (iperf result)
__copy_user_common consumes 1.8% of CPU (result from perf tool)
12% CPU Idle

Signed-off-by: Pawel Kulakowski <pawel.kulakowski@tieto.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 2e2b92b..ab7a1ac 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -828,6 +828,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
 	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
+	ieee80211_hw_set(hw, SUPPORTS_CLONED_SKBS);
 
 	if (ath9k_ps_enable)
 		ieee80211_hw_set(hw, SUPPORTS_PS);
-- 
1.9.1

