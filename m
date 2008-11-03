Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32000 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbYKCWnF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 17:43:05 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2008 14:43:05 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] Revert "ath5k: honor FIF_BCN_PRBRESP_PROMISC in STA mode"
Date: Mon, 3 Nov 2008 14:42:59 -0800
Message-ID: <1225752181-1343-2-git-send-email-lrodriguez@atheros.com> (sfid-20081103_234310_991483_B8F282C7)
In-Reply-To: <1225752181-1343-1-git-send-email-lrodriguez@atheros.com>
References: <1225752181-1343-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please revert  ba7273afa2db548ba556d6b2325c36d9c91fad95, titled,
"ath5k: honor FIF_BCN_PRBRESP_PROMISC in STA mode".

While this patch reduces interrupt load it will cause sporadic
connectivity issues as the STA will no longer receive beacons and
at times, when idle or during/after heavy traffic, it may miss the
beacon probe response and disconnect from the AP as mac80211 assumes
it out of range.

In the future we can work on enabling the beacon filter only on
certain conditions, like scanning, and use the beacon miss interrupt
to trigger probe requests under normal operation as this can help
save power but that requires better integration and coordination
with mac80211 to make it more aware of these decisions. Right now
mac80211 expects beacons so give it beacons.

  Luis
