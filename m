Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33743 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbcASIEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 03:04:49 -0500
Received: by mail-wm0-f67.google.com with SMTP id u188so21423094wmu.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2016 00:04:49 -0800 (PST)
From: Henning Rogge <hrogge@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <hrogge@gmail.com>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: [PATCH 0/2] mac80211: add cleanup path for MPP table entries
Date: Tue, 19 Jan 2016 09:04:30 +0100
Message-Id: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20160119_090453_078827_4170B2ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently MPP table entries are only removed from memory when their
802.11s mesh interface goes down. This can make the kernel to remember
a growing list of proxied mac addresses which are not relevant or even
reachable anymore.

This patchset adds two additional cleanup paths for MPP table entries
to remove them when their corresponding mesh node is removed or when
the MPP table entry is not used for MESH_PATH_EXPIRE time.

Henning Rogge (2):
  mac80211: Remove connected MPP table entries with MPath
  mac80211: let unused MPP table entries timeout

 net/mac80211/mesh_pathtbl.c | 84 +++++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/rx.c           |  1 +
 net/mac80211/tx.c           |  8 ++++-
 3 files changed, 90 insertions(+), 3 deletions(-)

-- 
2.5.0

