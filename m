Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm25-vm4.bullet.mail.ir2.yahoo.com ([212.82.97.37]:26623 "HELO
	nm25-vm4.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751654Ab3LFIar convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 03:30:47 -0500
References: <1386294806-18083-1-git-send-email-jlopex@cozybit.com>
Message-ID: <1386318275.76079.YahooMailNeo@web172703.mail.ir2.yahoo.com> (sfid-20131206_093050_402294_E1C18A8D)
Date: Fri, 6 Dec 2013 08:24:35 +0000 (GMT)
From: Dani Camps <danicamps81@yahoo.com>
Reply-To: Dani Camps <danicamps81@yahoo.com>
Subject: Re: [PATCH] mac80211_hwsim: Fix NULL pointer dereference
To: Javier Lopez <jlopex@cozybit.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"j@w1.fi" <j@w1.fi>
In-Reply-To: <1386294806-18083-1-git-send-email-jlopex@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Javier,

I tested your patch and my problem is now solved.

Thanks!

Daniel



El Viernes 6 de diciembre de 2013 2:53, Javier Lopez <jlopex@cozybit.com> escribió:
mac80211_hwsim was crashing when receiving tx information from user
space. Crash happens because txi->rate_driver_data[0] is pointing to a
non valid memory address.

This code path is only used by wmediumd and wmediumd doesn't provide
multiple channel support, so we can update txi->rate_driver_data[0]
to point to the mac80211_hwsim_data channel information struct
(data2->channel).

Signed-off-by: Javier Lopez <jlopex@cozybit.com>
---
drivers/net/wireless/mac80211_hwsim.c |    1 +
1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 9c0cc8d..eddf7bf 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2013,6 +2013,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
    }

    txi->status.ack_signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
+    txi->rate_driver_data[0] = data2->channel;

    if (!(hwsim_flags & HWSIM_TX_CTL_NO_ACK) &&
       (hwsim_flags & HWSIM_TX_STAT_ACK)) {
-- 
1.7.9.5
