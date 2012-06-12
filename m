Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44444 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2FLHvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 03:51:44 -0400
Received: by dady13 with SMTP id y13so6514254dad.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 00:51:44 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v3 0/4] Support proactive PREQ mechanism in Mesh
Date: Tue, 12 Jun 2012 15:50:41 +0800
Message-Id: <1339487445-25428-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120612_095148_045286_A7EF50B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These series of patches allow the support of proactive PREQ mechanism as defined in
Sec. 13.10.4.2 of IEEE Std. 802.11-2012 based on the setting of dot11MeshHWMPRootMode
as follow:

dot11MeshHWMPRootMode (2): Proactive PREQ no PREP
dot11MeshHWMPRootMode (3): Proactive PREQ with PREP

Proactive RANN is now supported if the dot11MeshHWMPRootMode is set as (4).

This v3 is modified according to Johannes's comments on v2.

Chun-Yeow Yeoh (4):
  {nl,cfg,mac}80211: implement dot11MeshHWMProotInterval and
    dot11MeshHWMPactivePathToRootTimeout
  mac80211: implement the proactive PREQ generation
  mac80211: implement the proactive PREP generation
  mac80211: invoke the timer only with correct dot11MeshHWMPRootMode
    value

 include/linux/ieee80211.h     |   39 ++++++++++++++++++++++++++
 include/linux/nl80211.h       |    9 ++++++
 include/net/cfg80211.h        |    9 ++++++
 net/mac80211/cfg.c            |   10 +++++-
 net/mac80211/debugfs_netdev.c |    6 ++++
 net/mac80211/mesh.c           |   12 ++++++--
 net/mac80211/mesh_hwmp.c      |   61 +++++++++++++++++++++++++++++++++++++----
 net/wireless/mesh.c           |    4 +++
 net/wireless/nl80211.c        |   15 +++++++++-
 9 files changed, 153 insertions(+), 12 deletions(-)

