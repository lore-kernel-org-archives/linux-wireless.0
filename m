Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59305 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab1KVSKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 13:10:13 -0500
Received: by ywt32 with SMTP id 32so450943ywt.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2011 10:10:13 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 0/3] cfg80211: few regulatory fixes
Date: Tue, 22 Nov 2011 10:09:59 -0800
Message-Id: <1321985402-14257-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111122_191026_563815_2BD51C19)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's my queue of fixes for cfg80211 regulatory. One is a performance
fix so whether or not it goes, I'll leave it to you guys. I document it
very well though. The others are fixes that should go to stable. One of them
is based on an issue I found through the shiny new regulatory simulator, but
also helps address the issue Johannes has found. The last patch amends
Johannes' proposed fix by using the new fix I found through the regulatory
simulator.

Unfortunately I haven't had time to test these myself.. so just spitting
them all out for review.

Luis R. Rodriguez (3):
  cfg80211: allow following country IE power for custom regdom cards
  cfg80211: fix race on init and driver registration
  cfg80211: amend regulatory NULL dereference fix

 include/net/cfg80211.h |    4 ++-
 net/wireless/reg.c     |   50 +++++++++++++++++++++++++++++++++++------------
 2 files changed, 40 insertions(+), 14 deletions(-)

-- 
1.7.4.15.g7811d

