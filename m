Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55031 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609Ab1IHAuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 20:50:00 -0400
Received: by pzk37 with SMTP id 37so370400pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 17:49:59 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH v2 0/3] QoS headers for mesh
Date: Wed,  7 Sep 2011 17:49:51 -0700
Message-Id: <1315442994-304-1-git-send-email-javier@cozybit.com> (sfid-20110908_025004_781494_AC4E125B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh frames are required to QoS headers to indicate the presence of a Mesh
Control Header in the payload.  These patches add QoS headers to mesh frames,
but note that they don't implement full QoS support: mesh stations don't
currently advertise QoS capabilities.

v2: 
- Pretend all mesh stations are QoS capable (Johannes). I've also checked that
  mesh stations must support QoS (I could only find that in the informative
  sections of the 11s draft, section Y.1), so this seems to be the right thing.
  I would like to prevent the creation of mesh interfaces if the underlying
  hardware does not support QoS.  That will be in a follow up patch.

- Do not strip the QoS header in mesh traffic until any frames to be forwarded
  have been cloned.

Javier Cardona (3):
  mac80211: Start implementing QoS support for mesh interfaces
  mac80211: Mesh data frames must have the QoS header
  mac80211: Mark all mesh stations as QoS capable

---
 include/linux/ieee80211.h   |    2 ++
 net/mac80211/mesh.c         |    9 +++++----
 net/mac80211/mesh_pathtbl.c |    4 ++++
 net/mac80211/mesh_plink.c   |    2 +-
 net/mac80211/rx.c           |   14 +++++++-------
 net/mac80211/tx.c           |    9 +++++++--
 net/mac80211/wme.c          |   16 +++++++---------
 net/mac80211/wme.h          |    3 ++-
 8 files changed, 35 insertions(+), 24 deletions(-)

-- 
1.7.6

