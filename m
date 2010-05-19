Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ex-fe02.nebula.fi ([188.117.32.118]:22955 "EHLO ex07.nebula.fi"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755324Ab0ESKc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 06:32:56 -0400
From: Jussi Haakana <Jussi.Haakana@7signal.com>
To: John Linville <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 19 May 2010 13:27:24 +0300
Subject: [PATCH] cfg80211: Add a missing null pointer check
Message-ID: <0290AB2F0A8E124B9FFC144088A1A95609D6AA414B@EX-MBS04.nbl.local>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a network interface is down while setting a channel,
missing null pointer check causes an oops in cfg80211_set_freq:

# iw phy phy0 interface add ath1 type monitor
# iw dev ath1 set channel 3
Unable to handle kernel paging request for data at address 0x00000004
Faulting instruction address: 0xca16d778
Oops: Kernel access of bad area, sig: 11 [#1]
...

Signed-off-by: Jussi Haakana <Jussi.Haakana@7signal.com>
---
 net/wireless/chan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index d92d088..b01a6f6 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -50,7 +50,7 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
        struct ieee80211_channel *chan;
        int result;

-       if (wdev->iftype == NL80211_IFTYPE_MONITOR)
+       if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR)
                wdev = NULL;

        if (wdev) {
--
1.5.5.6

