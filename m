Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:57094 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3BCBD0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2013 20:03:26 -0500
Received: by mail-pb0-f47.google.com with SMTP id rp8so2652254pbb.20
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2013 17:03:26 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 0/3] implement active mesh scanning
Date: Sat,  2 Feb 2013 17:02:18 -0800
Message-Id: <1359853341-29237-1-git-send-email-thomas@cozybit.com> (sfid-20130203_020333_794624_39F746E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set improves the mesh scanning functionality by:

	- responding to broadcast or directed probe requests
	- allowing the user to generate a directed mesh probe request, ie:
		iw mesh0 scan ssid foo
	  on a mesh interface will send probe requests where the ssid "foo" has
	  been filled into the mesh ID IE.

Also patch 1 caches the mesh beacon in a struct beacon_data each time it
changes so probe responses can be quickly built. This is also convenient when
the TIM IE becomes needed for PS.

Applies on mac80211-next/master

Thomas Pedersen (3):
  mac80211: cache mesh beacon
  mac80211: generate mesh probe requests
  mac80211: generate mesh probe responses

 net/mac80211/cfg.c         |    2 +
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mesh.c        |  199 +++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/mesh.h        |    3 +
 net/mac80211/mesh_plink.c  |    6 +-
 net/mac80211/rx.c          |    5 +-
 net/mac80211/tx.c          |   72 +++++-----------
 net/mac80211/util.c        |    1 +
 8 files changed, 229 insertions(+), 60 deletions(-)

-- 
1.7.10.4

