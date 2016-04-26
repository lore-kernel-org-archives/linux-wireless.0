Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:55787 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbcDZIGj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 04:06:39 -0400
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, sd@queasysnail.net, johannes@sipsolutions.net,
	kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	jack@suse.com, linux-kernel@vger.kernel.org, pshelar@nicira.com,
	dev@openvswitch.org, jhs@mojatatu.com, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, drbd-dev@lists.linbit.com,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next 2/8] drivers/wireless: use nla_put_u64_64bit()
Date: Tue, 26 Apr 2016 10:06:12 +0200
Message-Id: <1461657978-13360-3-git-send-email-nicolas.dichtel@6wind.com> (sfid-20160426_101058_369072_308DC10B)
In-Reply-To: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com>
References: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 drivers/net/wireless/mac80211_hwsim.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c757f14c4c00..9ed0ed1bf514 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1030,7 +1030,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	data->pending_cookie++;
 	cookie = data->pending_cookie;
 	info->rate_driver_data[0] = (void *)cookie;
-	if (nla_put_u64(skb, HWSIM_ATTR_COOKIE, cookie))
+	if (nla_put_u64_64bit(skb, HWSIM_ATTR_COOKIE, cookie, HWSIM_ATTR_PAD))
 		goto nla_put_failure;
 
 	genlmsg_end(skb, msg_head);
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 66e1c73bd507..39f22467ca2a 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -148,6 +148,7 @@ enum {
 	HWSIM_ATTR_RADIO_NAME,
 	HWSIM_ATTR_NO_VIF,
 	HWSIM_ATTR_FREQ,
+	HWSIM_ATTR_PAD,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
2.8.1

