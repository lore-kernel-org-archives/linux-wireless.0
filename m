Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59054 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab0JJUFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 16:05:24 -0400
Received: by ewy20 with SMTP id 20so332817ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Oct 2010 13:05:22 -0700 (PDT)
Date: Sun, 10 Oct 2010 22:05:27 +0200 (CEST)
From: "=?ISO-8859-15?Q?Bj=F6rn_Smedman?=" <bjorn.smedman@venatech.se>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	lrodriguez@atheros.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] Fix rate control for A-MPDU
Message-ID: <alpine.DEB.2.00.1010102203230.31264@bigbill>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1516192762-1286741022=:31264"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1516192762-1286741022=:31264
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1010102205121.31264@bigbill>

Hi all,

Rate control for A-MPDU is somewhat complicated, mainly because each 
subframe has its own tx status but rate control is only relevant on a per 
aggregate level. This patch series fixes some more obscure bugs in the 
rate control feedback for A-MPDU frames, mainly for the case when rate 
control feedback is carried on a frame that has failed transmission.

There are two underlying assumptions: (1) the ampdu_len and ampdu_ack_len 
fields of the tx status structure must be set correctly by the driver if 
the IEEE80211_TX_STAT_AMPDU flag is set, and (2) the value of these fields 
must not be relied upon by rate control if the flag is not set.

I've only been able to test these patches with the ath9k driver using 
the minstrel ht rate control algorithm. I have also looked at the other 
driver references to ampdu_len and they seem safe under the above 
assumptions, except ath9k's built in rate control, for which I've 
attempted a fix.

Björn Smedman (3):
 mac80211: minstrel_ht A-MPDU fix
 ath9k: A-MPDU rate control info fix
 ath9k: built-in rate control A-MPDU fix

 drivers/net/wireless/ath/ath9k/rc.c   |    6 ++++++
 drivers/net/wireless/ath/ath9k/xmit.c |   19 +++++++++++++------
 net/mac80211/rc80211_minstrel_ht.c    |    7 ++++---
 3 files changed, 23 insertions(+), 9 deletions(-)

/Björn
--8323329-1516192762-1286741022=:31264--
