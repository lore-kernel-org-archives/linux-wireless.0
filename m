Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:59678 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbaATOOG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 09:14:06 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so3062586eaj.21
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 06:14:05 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/3] cfg80211: implement multi-interface CSA
Date: Mon, 20 Jan 2014 15:09:25 +0100
Message-Id: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com> (sfid-20140120_151413_796424_F6F22412)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is the cfg80211 part for CSA multi-interface
support.

It's still missing proper tracing. I'm out of
ideas how to deal with it. I've tried some pustom
trace_seq_ stuff but trace-cmd report doens't
seem to happy with that (it complains about parse
errors). Is this expected or am I missing
something? Any hints are welcome.


Changes since RFC:

 * drop rename patch (it is kind of squashed into
   the multi-intf combination patch)

 * refactor multi-intf combination patch and split
   helper functions

 * nl80211 command uses now a simple nested array
   instead of recursive nesting

 * advertise multi-intf csa support to userspace


Michal Kazior (3):
  nl80211: make chandef parser take nlattr arg
  cfg80211: implement multi-vif interface combination validation
  cfg80211: implement multi-interface CSA

 include/net/cfg80211.h       |  10 +-
 include/uapi/linux/nl80211.h |   6 +
 net/mac80211/cfg.c           |  23 +++-
 net/mac80211/ibss.c          |   4 +-
 net/mac80211/ieee80211_i.h   |   7 +-
 net/mac80211/mesh.c          |   4 +-
 net/wireless/core.h          |  36 +++++-
 net/wireless/nl80211.c       | 276 ++++++++++++++++++++++++++++++-------------
 net/wireless/rdev-ops.h      |   8 +-
 net/wireless/trace.h         |  37 ++----
 net/wireless/util.c          | 198 +++++++++++++++++++------------
 11 files changed, 405 insertions(+), 204 deletions(-)

-- 
1.8.4.rc3

