Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:60116 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab3CQVzy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 17:55:54 -0400
Received: by mail-we0-f176.google.com with SMTP id s43so4436346wey.35
        for <linux-wireless@vger.kernel.org>; Sun, 17 Mar 2013 14:55:52 -0700 (PDT)
Date: Sun, 17 Mar 2013 22:55:44 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: Sam Leffler <sleffler@chromium.org>
Subject: Radiotap injected rates
Message-ID: <20130317215544.GA7031@gobelin> (sfid-20130317_225607_486363_11F51621)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Some time ago the rate selection for radiotap injected frames did not
make it essentially for mac80211 getting short in IEEE80211_TX_CTL_*s.

Would it be acceptable to replace the originally proposed:


-	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
+	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
+	    !(info->flags & IEEE80211_TX_CTL_NO_RC))
 		CALL_TXH(ieee80211_tx_h_rate_ctrl);

with something like :

-	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
+	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
+	    !(info->flags & IEEE80211_TX_CTL_INJECTED && info->control.rates[i]))
		CALL_TXH(ieee80211_tx_h_rate_ctrl);

?

 
Karl
