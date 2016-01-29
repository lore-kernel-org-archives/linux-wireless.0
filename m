Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34725 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbcA2KJE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 05:09:04 -0500
Received: by mail-wm0-f67.google.com with SMTP id p63so8876414wmp.1
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jan 2016 02:09:04 -0800 (PST)
From: Henning Rogge <hrogge@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <hrogge@gmail.com>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: [PATCH v2 0/3] mac80211: add cleanup path for MPP table entries
Date: Fri, 29 Jan 2016 11:08:55 +0100
Message-Id: <1454062138-18012-1-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20160129_110912_217907_D9DCA8CD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently MPP table entries are only removed from memory when their
802.11s mesh interface goes down. This can make the kernel to remember
a growing list of proxied mac addresses which are not relevant or even
reachable anymore.

This patchset adds two additional cleanup paths for MPP table entries
to remove them when their corresponding mesh node is removed or when
the MPP table entry is not used for MESH_PATH_EXPIRE time.

Henning Rogge (3):
  mac80211: Remove MPP table entries with MPath
  mac80211: let unused MPP table entries timeout
  mac80211: Unify mesh and mpp path removal function

 net/mac80211/mesh_pathtbl.c | 132 +++++++++++++++++++++++++++++++++++---------
 net/mac80211/rx.c           |   1 +
 net/mac80211/tx.c           |   6 +-
 3 files changed, 112 insertions(+), 27 deletions(-)

-- 
2.5.0

