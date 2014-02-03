Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:37515 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbaBCKDr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 05:03:47 -0500
Received: by mail-ee0-f52.google.com with SMTP id e53so3525495eek.11
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 02:03:46 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 0/2] cfg80211: add channel switching awareness
Date: Mon,  3 Feb 2014 10:58:47 +0100
Message-Id: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com> (sfid-20140203_110350_856803_C8E66F09)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The patchset aims at making cfg80211 aware of
channel switches.

This makes it possible for more elegant channel
switching behavior by moving the decision up to
cfg80211.

Until now mac80211 could start channel switching
internally for STA, mesh and IBSS interfaces
without userspace interaction. This bypassed
interface combination checks at the very least.

Now mac80211 requests cfg80211 to channel switch
an interface, in a similar manner as userspace
asks cfg80211 for a channel switch. This makes it
possible to perform interface combination checks
(albeit it is not implemented yet).

The channel switch is split into two phases now -
start and finalize. This is required to make
cfg80211 in control of the whole channel
switching process. It also makes it apparent that
mac80211's STA CSA offload doesn't work quite well
here. Can we kill it?

The initial patchset has a lot of TODOs in the
code and the idea is to provide follow up patches
that implement missing functionality.

Major drawback now is cfg80211 will refuse a
channel switch if there's one in progress already,
although this shouldn't be much of a problem in
most use cases.

This approach should be suited for multi-interface
CSA as well as some other cases such as
"GO-follows-STA".

The patchset seemed to work in my limited testing
(ath9k as AP and iwldvm as STA).


Michal Kazior (2):
  mac80211: merge STA CSA code
  cfg80211: move channel switch logic to cfg80211

 include/net/cfg80211.h     |  80 ++++++++++++++++++++--
 net/mac80211/cfg.c         | 100 ++++++++++++++++++++-------
 net/mac80211/ibss.c        |   4 +-
 net/mac80211/ieee80211_i.h |   6 +-
 net/mac80211/mesh.c        |   6 +-
 net/mac80211/mlme.c        | 133 +++++++++---------------------------
 net/wireless/ap.c          |   5 +-
 net/wireless/chan.c        | 163 +++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.c        |  23 +++++--
 net/wireless/core.h        |  18 +++++
 net/wireless/ibss.c        |   1 +
 net/wireless/mesh.c        |   5 +-
 net/wireless/nl80211.c     |  24 +++++--
 net/wireless/rdev-ops.h    |  21 ++++--
 net/wireless/sme.c         |   1 +
 net/wireless/trace.h       |  17 ++++-
 net/wireless/util.c        |   6 ++
 17 files changed, 454 insertions(+), 159 deletions(-)

-- 
1.8.5.3

