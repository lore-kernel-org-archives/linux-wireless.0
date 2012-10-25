Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44737 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758569Ab2JYSK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 14:10:27 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so1347962pad.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2012 11:10:27 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linville@tuxdriver.com
Cc: Javier Cardona <javier@cozybit.com>,
	Javier Lopez <jlopex@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	johannes@sipsolutions.net
Subject: [PATCH] mac80211: Don't inspect Sequence Control field on control frames
Date: Thu, 25 Oct 2012 11:10:18 -0700
Message-Id: <1351188618-11155-1-git-send-email-javier@cozybit.com> (sfid-20121025_201031_454299_3598369C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Per IEEE Std. 802.11-2012, Sec 8.2.4.4.1, the sequence Control field is
not present in control frames.  We noticed this problem when processing
Block Ack Requests.

Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Javier Lopez <jlopex@cozybit.com>
---
 net/mac80211/rx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f975f64..bf54336 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1467,6 +1467,10 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
 	hdr = (struct ieee80211_hdr *)rx->skb->data;
 	fc = hdr->frame_control;
+
+	if (ieee80211_is_ctl(fc))
+		return RX_CONTINUE;
+
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	frag = sc & IEEE80211_SCTL_FRAG;
 
-- 
1.7.5.4

