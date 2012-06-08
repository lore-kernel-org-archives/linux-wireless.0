Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62779 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab2FHUbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 16:31:18 -0400
Received: by dady13 with SMTP id y13so2805998dad.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 13:31:18 -0700 (PDT)
From: Jason Abele <jason@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/2] mac80211: Improvement to initial mesh metric
Date: Fri,  8 Jun 2012 13:31:07 -0700
Message-Id: <1339187469-12778-1-git-send-email-jason@cozybit.com> (sfid-20120608_223121_429036_0830EBE4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches add a feature to initialize the link rate metric with a guess
based off of RSSI when insufficient traffic has passed to allow actual
calculation of the link rate.

I am submitting this patch set on behalf of our team after
testing them with the wireless-testing tag master-2012-06-08.
Requires the patch series noted below to apply cleanly:
	[PATCH 0/2] mac80211: mesh remove unused var and fix naming

formerly sent as 3 and 5 respectively in:
	[PATCH v3 0/5] Improvement to initial mesh metric


Javier Cardona (2):
  mac80211: Keep tx rate averages for mesh peers for better metric
    calculation.
  mac80211: Use signal strength as a proxy for expected datarate.

 net/mac80211/mesh_hwmp.c |   87 +++++++++++++++++++++++++++++++++++++++++-----
 net/mac80211/sta_info.c  |    1 +
 net/mac80211/sta_info.h  |    1 +
 3 files changed, 80 insertions(+), 9 deletions(-)

-- 
1.7.9.5

