Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50182 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab1IFW02 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 18:26:28 -0400
Received: by yxj19 with SMTP id 19so3378598yxj.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Sep 2011 15:26:27 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH 0/2] QoS headers for mesh
Date: Tue,  6 Sep 2011 15:26:14 -0700
Message-Id: <1315347976-13950-1-git-send-email-javier@cozybit.com> (sfid-20110907_002632_895190_616E9FCE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh frames are required to have QoS headers to indicate the presence of a Mesh
Control Header in the payload.  These patches add QoS headers to mesh frames,
but note that they don't implement full QoS support: mesh stations don't
currently advertise QoS capabilities.

Javier Cardona (2):
  mac80211: Start implementing QoS support for mesh interfaces
  mac80211: Mesh data frames must have the QoS header

 include/linux/ieee80211.h   |    2 ++
 net/mac80211/mesh.c         |    8 ++++----
 net/mac80211/mesh_pathtbl.c |    4 ++++
 net/mac80211/rx.c           |    6 +++---
 net/mac80211/tx.c           |    5 +++--
 net/mac80211/wme.c          |   15 ++++++---------
 net/mac80211/wme.h          |    2 +-
 7 files changed, 23 insertions(+), 19 deletions(-)

-- 
1.7.6

