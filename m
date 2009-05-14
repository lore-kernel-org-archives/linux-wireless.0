Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:55409 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177AbZENSaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 14:30:35 -0400
Message-Id: <20090514182845.684003914@atheros.com>
Date: Thu, 14 May 2009 21:28:45 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] ath9k: Power save mode fixes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series addresses couple of issues in power save mode operations in
ath9k. The driver will now try to receive all buffered broadcast and
multicast frames after DTIM beacons. In addition, the transitions
between power save states are optimized in a way which should reduce
both CPU use and the amount of time spent in awake state. This change
seems to also improve the stability of the connection when using power
save mode.

There are still some remaining issues in the timeout=0 power save case
("iwconfig wlan0 power on"), but the patches here seem to make the
default mode (timeout=500, "iwconfig wlan0 power timeout 500ms") behave
much more nicely.

-- 
Jouni Malinen                                            PGP id EFC895FA
