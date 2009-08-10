Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:33616 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbZHJT1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 15:27:18 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1077455rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 12:27:19 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: andrey@cozybit.com, johannes@sipsolutions.net,
	linville@tuxdriver.com, devel@lists.open80211s.org
Subject: Mesh fixes and improvements [v2]
Date: Mon, 10 Aug 2009 12:15:45 -0700
Message-Id: <1249931752-18127-1-git-send-email-javier@cozybit.com>
In-Reply-To: <20090810175225.GF2733@tuxdriver.com>
References: <20090810175225.GF2733@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[v2]

Withdraw "Simulate-transmission-losses-on-plinks-to-...".
Add detail to changelogs and Kconfig.
Changed queue_work -> ieee80211_queue_work

[v1]

This series includes some fixes, testing aids and improvements to the mesh
stack.  It is important to note that the patch
"Use-3-address-format-for-mesh-broadcast-frames" breaks compatibility with
previous versions.  This is unavoidable and will keep happening as new versions
of the 802.11s drafts are produced.

Also, I'm not sure if "Simulate-transmission-losses-on-plinks-to-..." should be
merged upstream, but we find it really useful to test mesh configurations.
Please comment if you have different opinions on its adequacy or
implementation.

Cheers,

Javier


 include/linux/nl80211.h         |    4 +
 include/net/cfg80211.h          |    4 +
 net/mac80211/Kconfig            |    8 +-
 net/mac80211/cfg.c              |    6 ++
 net/mac80211/ieee80211_i.h      |    2 +-
 net/mac80211/mesh.c             |  136 ++++++++++++++++++------------------
 net/mac80211/mesh.h             |   29 +++++++-
 net/mac80211/mesh_hwmp.c        |    9 +--
 net/mac80211/mesh_pathtbl.c     |  146 +++++++++++++++++++++++++++++----------
 net/mac80211/mesh_plink.c       |    6 ++
 net/mac80211/rc80211_minstrel.c |   16 ++++-
 net/mac80211/rx.c               |   45 ++++++++-----
 net/mac80211/sta_info.h         |    1 +
 net/mac80211/tx.c               |  118 +++++++++++++++++++++++---------
 net/wireless/nl80211.c          |    9 +++
 net/wireless/util.c             |   16 +++-
 16 files changed, 384 insertions(+), 171 deletions(-)

