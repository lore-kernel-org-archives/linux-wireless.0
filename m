Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:58983 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab3ISSBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Sep 2013 14:01:18 -0400
Received: by mail-la0-f48.google.com with SMTP id er20so7075316lab.7
        for <linux-wireless@vger.kernel.org>; Thu, 19 Sep 2013 11:01:16 -0700 (PDT)
Message-ID: <523B3BEA.9000100@gmail.com> (sfid-20130919_200122_426878_A0C53351)
Date: Thu, 19 Sep 2013 20:01:14 +0200
From: Thomas Lindroth <thomas.lindroth@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Kernel panic in ieee80211_calculate_rx_timestamp
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I recently got a ath9k_htc based dongle and running kismet for a few
hours results in a kernel panic (divide error) in
ieee80211_calculate_rx_timestamp with kernel 3.11.0.

The problem seems to occur when the call to cfg80211_calculate_bitrate
returns 0. I've used this patch to temporarily works around the problem.

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 2265445..037b737 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2156,6 +2156,9 @@ u64 ieee80211_calculate_rx_timestamp(struct
ieee80211_local *local,

        rate = cfg80211_calculate_bitrate(&ri);

+       if (WARN_ON(!rate))
+               return 0;
+
        /* rewind from end of MPDU */
        if (status->flag & RX_FLAG_MACTIME_END)
                ts -= mpdu_len * 8 * 10 / rate;


http://i.imgur.com/BrpaCgI.jpg here is the output of the panic.

/Thomas Lindroth
