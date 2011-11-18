Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:51544 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab1KRLCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 06:02:05 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCHv3 0/3] add NoAck per tid support
Date: Fri, 18 Nov 2011 12:01:45 +0100
Message-Id: <1321614110-32392-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111118_120223_064930_58AD43F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for NoAck per WMM Queue. The Unicast QoS
Header is adapted accordingly for each outgoing frame.
The NoAck policy for the individual queues is turned and off through
a tid bitmap with nl80211 commands.

I have tested this feature on ath9k as well as ath5k devices. There is
an iw patch as well to make use of this feature.

It should apply well on the latest wireless-testing kernel.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>

---
Changes to PATCH:

consider NO_ACK flag when calculating duration
check if set_txq_noack op is implemented before calling it

Changes to PATCHv2:

change from TXQ_PARAM enhancement to separate command. This should be
more clean and enables more configuration options.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>

Simon Wunderlich (3):
  mac80211: remove debugfs noack test
  wireless: Add NoAck per tid Support
  mac80211: Add NoAck per tid Support

 include/linux/nl80211.h    |   10 ++++++++++
 include/net/cfg80211.h     |    6 ++++++
 net/mac80211/cfg.c         |   11 +++++++++++
 net/mac80211/debugfs.c     |   35 -----------------------------------
 net/mac80211/ieee80211_i.h |    4 +++-
 net/mac80211/iface.c       |    2 ++
 net/mac80211/tx.c          |   10 +---------
 net/mac80211/wme.c         |    8 ++++++--
 net/wireless/nl80211.c     |   28 ++++++++++++++++++++++++++++
 9 files changed, 67 insertions(+), 47 deletions(-)

-- 
1.7.7.3

