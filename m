Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63510 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2FFKVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:21:00 -0400
Received: by dady13 with SMTP id y13so8594095dad.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 03:20:59 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH 0/4] Support proactive PREQ mechanism in Mesh
Date: Wed,  6 Jun 2012 18:20:35 +0800
Message-Id: <1338978039-4269-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120606_122104_484695_18F90616)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These series of patches allow the support of proactive PREQ mechanism as defined in
Sec. 13.10.4.2 of IEEE Std. 802.11-2012 based on the setting of dot11MeshHWMPRootMode
as follow:

dot11MeshHWMPRootMode (2): Proactive PREQ no PREP
dot11MeshHWMPRootMode (3): Proactive PREQ with PREP

Proactive RANN is now supported if the dot11MeshHWMPRootMode is set as (4).

Chun-Yeow Yeoh (4):
  {nl,cfg,mac}80211: implement dot11MeshHWMProotInterval and
    dot11MeshHWMPactivePathToRootTimeout
  mac80211: implement the proactive PREQ generation
  mac80211: implement the proactive PREP generation
  mac80211: invoke the timer only with correct dot11MeshHWMPRootMode
    value

 include/linux/nl80211.h       |    9 +++++
 include/net/cfg80211.h        |    2 +
 net/mac80211/cfg.c            |   12 ++++++-
 net/mac80211/debugfs_netdev.c |    6 +++
 net/mac80211/mesh.c           |    9 +++--
 net/mac80211/mesh_hwmp.c      |   72 +++++++++++++++++++++++++++++++++++------
 net/wireless/mesh.c           |    4 ++
 net/wireless/nl80211.c        |   14 ++++++++
 8 files changed, 113 insertions(+), 15 deletions(-)

