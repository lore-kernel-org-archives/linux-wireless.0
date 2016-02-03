Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37213 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbcBCM6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 07:58:45 -0500
Received: by mail-wm0-f45.google.com with SMTP id l66so69079769wml.0
        for <linux-wireless@vger.kernel.org>; Wed, 03 Feb 2016 04:58:45 -0800 (PST)
From: Henning Rogge <hrogge@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <hrogge@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: [PATCH v3 0/3] mac80211: add cleanup path for MPP table entries
Date: Wed,  3 Feb 2016 13:58:35 +0100
Message-Id: <1454504318-24988-1-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20160203_135849_776035_FDBC20C4)
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

 net/mac80211/mesh_pathtbl.c | 102 +++++++++++++++++++++++++++++++++++++++-----
 net/mac80211/rx.c           |   1 +
 net/mac80211/tx.c           |   5 ++-
 3 files changed, 97 insertions(+), 11 deletions(-)

-- 
2.5.0

