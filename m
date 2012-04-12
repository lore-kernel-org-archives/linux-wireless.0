Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40958 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762823Ab2DLVcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:32:42 -0400
Received: by mail-pb0-f46.google.com with SMTP id un15so2840406pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 14:32:42 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>,
	Pavel Zubarev <pavel.zubarev@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org, ashok@cozybit.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] mac80211_hwsim: fixup for tsf setting
Date: Thu, 12 Apr 2012 14:32:21 -0700
Message-Id: <1334266343-3970-3-git-send-email-javier@cozybit.com> (sfid-20120412_233245_475407_54FA8374)
In-Reply-To: <1334266343-3970-1-git-send-email-javier@cozybit.com>
References: <1334266343-3970-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Last patch I sent failed to take into account the offset of each phy.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 2d2bfce..3edd473 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -694,6 +694,7 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 		    ieee80211_is_probe_resp(mgmt->frame_control))
 			mgmt->u.beacon.timestamp = cpu_to_le64(
 				rx_status.mactime +
+				(data->tsf_offset - data2->tsf_offset) +
 				24 * 8 * 10 / txrate->bitrate);
 
 		memcpy(IEEE80211_SKB_RXCB(nskb), &rx_status, sizeof(rx_status));
-- 
1.7.5.4

