Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:40676 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbZAKHDn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2009 02:03:43 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [RFC PATCH v1 0/2] mac80211: ps-poll implementation
To: johannes@sipsolutions.net, vivek.natraj@gmail.com
Cc: linux-wireless@vger.kernel.org
Date: Sun, 11 Jan 2009 09:03:37 +0200
Message-ID: <20090111070148.3849.10799.stgit@tikku> (sfid-20090111_080348_199273_68869C1E)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's my suggestion for how to implement ps-poll in mac80211. Also
this fixes power save again for p54/stlc45xx, but most probably breaks
ath9k. I would like to hear opinions from others, especially from
Atheros. How does ath9k cope with the ps-poll method? Also I highly
recommend to get hardware waking up for multicast frames, it would be
a lot easier and reliable that way.

Open question is that should power save be disabled whenever mac80211
is ps-polling the frames. For example, p54/stlc45xx does not require to
disable power save in that case, it just stays awake long enough to
receive the data frame from the AP. So I did not disable power save
mode in this case, but I would like to hear comments what other
hardware need.

---

Kalle Valo (2):
      mac80211: use ps-poll to request frames in power save mode
      mac80211: remove multicast check from check_tim()


 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/mlme.c        |   51 +++++++++++++++++++++++++++++++++++---------
 net/mac80211/rx.c          |   35 ++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+), 10 deletions(-)

