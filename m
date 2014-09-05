Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:60479 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314AbaIENG4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 09:06:56 -0400
Received: by mail-la0-f41.google.com with SMTP id s18so2813409lam.28
        for <linux-wireless@vger.kernel.org>; Fri, 05 Sep 2014 06:06:53 -0700 (PDT)
From: Henning Rogge <hrogge@gmail.com>
To: "linux-wireless @ vger . kernel . org"
	<linux-wireless@vger.kernel.org>
Cc: Henning Rogge <henning.rogge@fkie.fraunhofer.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Subject: [PATCH v3 0/2] cfg80211: Add export of mesh proxy path table
Date: Fri,  5 Sep 2014 15:06:42 +0200
Message-Id: <1409922404-8217-1-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20140905_150701_607006_12A3D8FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patch series adds and implements two new cfg80211_ops that
allow to query the content of the mac80211s mesh proxy path table via
netlink.

v2 changes:
* split the original patch into separate cfg80211 and mac80211 part

v3 change:
* change of commit messages, added signoff

Henning Rogge (2):
  cfg80211: add ops to query mesh proxy path table
  mac80211: implement cfg80211_ops to query mesh proxy path table

 include/net/cfg80211.h       |  7 ++++
 include/uapi/linux/nl80211.h |  6 +++
 net/mac80211/cfg.c           | 53 ++++++++++++++++++++++++
 net/mac80211/mesh.h          |  3 ++
 net/mac80211/mesh_pathtbl.c  | 31 ++++++++++++++
 net/wireless/nl80211.c       | 99 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 27 +++++++++++-
 net/wireless/trace.h         | 45 ++++++++++++++++++++
 8 files changed, 270 insertions(+), 1 deletion(-)

-- 
1.9.1

