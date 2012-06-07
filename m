Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f66.google.com ([209.85.160.66]:37645 "EHLO
	mail-pb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab2FGAcn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 20:32:43 -0400
Received: by pbbrp8 with SMTP id rp8so83152pbb.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 17:32:42 -0700 (PDT)
From: Jason Abele <jason@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 0/5] Improvement to initial mesh metric
Date: Wed,  6 Jun 2012 17:29:36 -0700
Message-Id: <1339028981-17097-1-git-send-email-jason@cozybit.com> (sfid-20120607_023246_807436_BB94EB72)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

v3 removes unnecessary comment and whitespace

v2 set squashes 5 and 6 from the previous patch set.

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
 net/mac80211/mesh_hwmp.c              |   98 +++++++++++++++++++++++++++------
 net/mac80211/sta_info.c               |    1 +
 net/mac80211/sta_info.h               |    1 +
 4 files changed, 105 insertions(+), 16 deletions(-)

-- 
1.7.9.5

