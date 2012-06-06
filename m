Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53644 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2FFXTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 19:19:47 -0400
Received: by pbbrp8 with SMTP id rp8so197408pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 16:19:47 -0700 (PDT)
From: Jason Abele <jason@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 0/5] Improvement to initial mesh metric
Date: Wed,  6 Jun 2012 16:19:30 -0700
Message-Id: <1339024775-15405-1-git-send-email-jason@cozybit.com> (sfid-20120607_011951_333038_0A03A614)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This v2 set squashes 5 and 6 from the previous patch set.

I am submitting this patch set on behalf of the cozybit team after
testing them with the wireless-testing tag master-2012-06-06

The first patch was previously submitted by Timo Lindhorst and adds
important features to hwsim.

The remaining patches add a feature to initialize the link rate metric
with a guess based off of RSSI when insufficient traffic has passed to
allow actual calculation of the link rate.

Thanks
Jason


Javier Cardona (4):
  mac80211: Remove unused variable
  mac80211: Keep tx rate averages for mesh peers for better metric
    calculation.
  mac80211: Rename stainfo variable for the more common sta
  mac80211: Use signal strength as a proxy for expected datarate.

Timo Lindhorst (1):
  mac80211_hwsim: Report rate info in tx status

 drivers/net/wireless/mac80211_hwsim.c |   21 +++++++
 net/mac80211/mesh_hwmp.c              |   99 +++++++++++++++++++++++++++------
 net/mac80211/sta_info.c               |    1 +
 net/mac80211/sta_info.h               |    1 +
 4 files changed, 106 insertions(+), 16 deletions(-)

-- 
1.7.9.5

