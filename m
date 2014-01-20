Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63674 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbaATOcD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 09:32:03 -0500
Received: by mail-ee0-f46.google.com with SMTP id c13so3388883eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 06:32:02 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] mac80211: implement multi-interface CSA
Date: Mon, 20 Jan 2014 15:27:11 +0100
Message-Id: <1390228033-19162-1-git-send-email-michal.kazior@tieto.com> (sfid-20140120_153207_807164_10347777)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is the final change for multi-interface CSA.
It depends on my patchset for multi-interface CSA
in cfg80211 and mac80211 CSA fixes.

linux and hostap trees can be found at:

 https://github.com/kazikcz/linux/tree/multi-interface-csa-review-2014-01-20-1
 https://github.com/kazikcz/hostap/tree/multi-interface-csa-review-2014-01-20-1


Changes since RFC:

 * rebase against mac80211-next and adjust

 * update backup beacon pointers (thanks Eliad!)

 * advertise multi-interface CSA via wiphy flag

 * actually check chanctx->refcount when
   validating channel switch


Michal Kazior (2):
  ath9k: prepare for multi-interface CSA support
  mac80211: implement multi-interface CSA

 drivers/net/wireless/ath/ath9k/ath9k.h  |   4 +-
 drivers/net/wireless/ath/ath9k/beacon.c |  29 ++-
 drivers/net/wireless/ath/ath9k/main.c   |  12 +-
 drivers/net/wireless/ath/ath9k/xmit.c   |   2 +-
 net/mac80211/cfg.c                      | 376 +++++++++++++++++++++++++++-----
 net/mac80211/chan.c                     | 117 +++++++---
 net/mac80211/ibss.c                     |   2 +-
 net/mac80211/ieee80211_i.h              |  23 +-
 net/mac80211/iface.c                    |   5 +-
 net/mac80211/main.c                     |   6 +
 net/mac80211/mesh.c                     |   2 +-
 net/mac80211/mlme.c                     |   9 +-
 net/mac80211/tx.c                       |  15 +-
 13 files changed, 477 insertions(+), 125 deletions(-)

-- 
1.8.4.rc3

