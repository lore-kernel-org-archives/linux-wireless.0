Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:45290 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbaILG7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 02:59:21 -0400
Received: by mail-la0-f48.google.com with SMTP id ty20so352219lab.35
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2014 23:59:19 -0700 (PDT)
From: Henning Rogge <hrogge@gmail.com>
To: "linux-wireless @ vger . kernel . org"
	<linux-wireless@vger.kernel.org>
Cc: Henning Rogge <henning.rogge@fkie.fraunhofer.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Subject: [PATCH v4 0/2] cfg80211: Add export of mesh proxy path table
Date: Fri, 12 Sep 2014 08:58:48 +0200
Message-Id: <1410505130-7271-1-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20140912_085924_459234_7DC40AD1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patch series adds and implements two new cfg80211_ops that
allow to query the content of the mac80211s mesh proxy path table via
netlink.

v2 changes:
* split the original patch into separate cfg80211 and mac80211 part

v3 change:
* change of commit messages, added signoff

v4 change:
* another change of commit messages

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

