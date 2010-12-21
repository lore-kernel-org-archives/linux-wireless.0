Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:50022 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab0LURsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 12:48:20 -0500
Received: by fxm18 with SMTP id 18so4600991fxm.2
        for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 09:48:19 -0800 (PST)
Message-ID: <4D10E862.6090005@lwfinger.net>
Date: Tue, 21 Dec 2010 11:48:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: rtlwifi/rtl8192ce: Logs spammed with cfg80211 calls
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the new drivers rtlwifi/rtl8192ce, I'm getting my logs spammed with the
following:

wlan10: authenticate with c0:3f:0e:be:2b:45 (try 1)
wlan10: authenticated
wlan10: associate with c0:3f:0e:be:2b:45 (try 1)
wlan10: RX AssocResp from c0:3f:0e:be:2b:45 (capab=0x411 status=0 aid=2)
wlan10: associated
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
wlan10: authenticate with c0:3f:0e:be:2b:45 (try 1)
wlan10: authenticated

I see no indication of deauthentication by the AP. What might the driver be
doing to cause cfg80211 to call CRDA over and over?

Thanks,

Larry
