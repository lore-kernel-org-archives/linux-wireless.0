Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:25746 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYI0P31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2008 11:29:27 -0400
Received: by fg-out-1718.google.com with SMTP id 19so940478fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 27 Sep 2008 08:29:25 -0700 (PDT)
Date: Sat, 27 Sep 2008 17:29:12 +0200
From: Davide Pesavento <davidepesa@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] Fix modpost failure when rx handlers are not inlined.
Message-ID: <20080927152912.GA18970@PesaBook.pesa.homelinux.org> (sfid-20080927_172936_791779_114DA9E4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When CONFIG_MAC80211_MESH=n and CONFIG_MAC80211_NOINLINE=y,
gcc doesn't optimize out a call to ieee80211_rx_h_mesh_fwding,
even if the previous comparison is always false in this case.
This leads to the following errors during modpost:

ERROR: "mpp_path_lookup" [net/mac80211/mac80211.ko] undefined!
ERROR: "mpp_path_add" [net/mac80211/mac80211.ko] undefined!

Fix by removing the possibility of uninlining
ieee80211_rx_h_mesh_fwding rx handler.

Signed-off-by: Davide Pesavento <davidepesa@gmail.com>

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c489865..77e7b01 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1379,7 +1379,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	return RX_QUEUED;
 }
 
-static ieee80211_rx_result debug_noinline
+static ieee80211_rx_result
 ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
-- 
1.6.0.2

