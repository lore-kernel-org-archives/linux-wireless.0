Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:54694 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab3H0O7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 10:59:51 -0400
Received: by mail-we0-f169.google.com with SMTP id t61so4121612wes.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 07:59:50 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	johannes@sipsolutions.net
Subject: [PATCH 0/2] mac80211: fix minstrel fixed_rate management
Date: Tue, 27 Aug 2013 16:59:45 +0200
Message-Id: <1377615587-6015-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20130827_165954_250301_9734C10A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This couple of patches add/fix fixed_rate management of minstrel/minstrel_ht
rate controller. In particular:
*[PATCH 1/2]: add the capability to use a particular rate to minstrel rate
 controller
*[PATCH 2/2]: restore the mcs index configured according to fixed_rate value
 since it has been overridden in minstrel_ht_update_stats throughput computation

Regards,
Lorenzo

Lorenzo Bianconi (2):
  mac80211: add fixed_rate management to minstrel rc
  mac80211: do not override fixed_rate_idx in minstrel_ht_update_stats

 net/mac80211/rc80211_minstrel.c    | 14 ++++++++++++++
 net/mac80211/rc80211_minstrel_ht.c | 23 +++++++++++++----------
 2 files changed, 27 insertions(+), 10 deletions(-)

-- 
1.8.1.2

