Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:59037 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2KMTGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 14:06:23 -0500
Received: by mail-da0-f46.google.com with SMTP id n41so3326715dak.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 11:06:23 -0800 (PST)
Message-ID: <50A29A2C.9080606@cozybit.com> (sfid-20121113_200627_027942_D8BC8E16)
Date: Tue, 13 Nov 2012 11:06:20 -0800
From: Marco Porsch <marco@cozybit.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>, kvalo@adurom.com,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Javier Cardona <javier@cozybit.com>
CC: linux-wireless@vger.kernel.org
Subject: mesh powersave code layout
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I had a presentation on mesh powersave during the Barcelona Wireless 
summit. In the following discussion Kalle Valo pointed out to me, that 
there was interest in generally moving powersave code out of mac80211.

Now I am unsure where to place my mesh PS code before submission.
Currently my code layout for the mesh mode powersave is like this:

mac80211:
-mesh PS mode setting and state logic
-mesh PS mode indication towards neighbors
-neighbor PS mode tracking
-frame buffering
-frame release in Peer Service Periods
-driver configuration

drivers (ath9k, ath9k_htc, ...):
-configuration
-tracking of neighbors' beacon TBTTs
-determining next wakeup TBTT and hardware configuration for wakeup
-awake window after own beacon (software timer)


Javier Cardona recommended changing that and moving all the mesh PS code 
to mac80211 for easy maintenance. So (if possible) the idea would be to 
create new ieee80211_ops ála:
-void (*radio_sleep) (struct ieee80211_hw *hw, u64 until_tbtt);
-void (*radio_wakeup)(struct ieee80211_hw *hw);

So, where should the parts go, that are currently planned for the 
driver? Is there any general preference?

Regards,
Marco


PS:
My code is available on github: 
https://github.com/cozybit/open80211s/tree/ft-powersave .
My presentation slides should show up on linuxwireless in the following 
days.
