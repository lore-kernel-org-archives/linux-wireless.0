Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44642 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab2FGEjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 00:39:45 -0400
Received: by dady13 with SMTP id y13so304475dad.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 21:39:44 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v2 0/4] Support proactive PREQ mechanism in Mesh
Date: Thu,  7 Jun 2012 12:39:19 +0800
Message-Id: <1339043963-2043-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120607_063952_558296_BF77498F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These series of patches allow the support of proactive PREQ mechanism as defined in
Sec. 13.10.4.2 of IEEE Std. 802.11-2012 based on the setting of dot11MeshHWMPRootMode
as follow:

dot11MeshHWMPRootMode (2): Proactive PREQ no PREP
dot11MeshHWMPRootMode (3): Proactive PREQ with PREP

Proactive RANN is now supported if the dot11MeshHWMPRootMode is set as (4).

This v2 is modified according to Johannes's comments.

Chun-Yeow Yeoh (4):
  {nl,cfg,mac}80211: implement dot11MeshHWMProotInterval and
    dot11MeshHWMPactivePathToRootTimeout
  mac80211: implement the proactive PREQ generation
  mac80211: implement the proactive PREP generation
  mac80211: invoke the timer only with correct dot11MeshHWMPRootMode
    value

 include/linux/ieee80211.h     |   17 +++++++++++
 include/linux/nl80211.h       |    9 ++++++
 include/net/cfg80211.h        |    2 +
 net/mac80211/cfg.c            |   12 ++++++-
 net/mac80211/debugfs_netdev.c |    6 ++++
 net/mac80211/mesh.c           |    9 ++++--
 net/mac80211/mesh_hwmp.c      |   64 ++++++++++++++++++++++++++++++++++------
 net/wireless/mesh.c           |    4 ++
 net/wireless/nl80211.c        |   17 ++++++++++-
 9 files changed, 124 insertions(+), 16 deletions(-)

