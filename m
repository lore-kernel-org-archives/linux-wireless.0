Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:61270 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773AbaIELju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 07:39:50 -0400
Received: by mail-la0-f44.google.com with SMTP id gl10so83330lab.17
        for <linux-wireless@vger.kernel.org>; Fri, 05 Sep 2014 04:39:49 -0700 (PDT)
From: Henning Rogge <hrogge@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Subject: [PATCH v2 0/2] Add cfg80211_ops for querying the mesh proxy path table
Date: Fri, 05 Sep 2014 13:39:46 +0200
Message-ID: <2453987.UPN20YN3D3@rogge-hp-probook-6470b> (sfid-20140905_133954_140693_F92B56EF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Henning Rogge" <henning.rogge <at> fkie.fraunhofer.de>

The following patch series adds and implements two new cfg80211_ops that
allow to query the content of the mac80211s mesh proxy path table via
netlink.

v2 changes:
* split the original patch into separate cfg80211 and mac80211 part

Henning Rogge (2):
  Add two new cfg80211 operations for querying the content of the the
    mac80211s proxy path table
  Implement get_mpp and dump_mpp cfg80211_ops to export the content of
    the 802.11s mesh proxy path table to userspace.

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


