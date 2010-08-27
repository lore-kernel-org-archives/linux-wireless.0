Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:27909 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab0H0LIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 07:08:12 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com
Subject: [PATCH 0/4] mac80211: cfg80211: support for hw-only crypts and custom control port protocols
Date: Fri, 27 Aug 2010 14:07:35 +0300
Message-Id: <1282907259-30825-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches enable usage of hw-only cipher-suites, and enable using
control port ethertypes other than ETH_P_PAE for key-negotiation.

These patches are originally written by Johannes Berg, finalized and tested by
myself.

Johannes Berg (4):
  cfg80211: allow vendor specific cipher suites
  mac80211: allow vendor specific cipher suites
  cfg80211: allow changing port control protocol
  mac80211: allow changing port control protocol

 include/linux/nl80211.h    |   16 ++++++++++++++-
 include/net/cfg80211.h     |   24 +++++++++++++++------
 net/mac80211/cfg.c         |    5 ++-
 net/mac80211/ieee80211_i.h |    4 +++
 net/mac80211/iface.c       |    2 +
 net/mac80211/key.c         |   38 ++++++++++++++++++++++++++++-------
 net/mac80211/key.h         |    6 ++--
 net/mac80211/main.c        |   47 ++++++++++++++++++++++++++++++++++++++-----
 net/mac80211/mlme.c        |    3 ++
 net/mac80211/rx.c          |    8 ++++++-
 net/mac80211/tx.c          |   32 +++++++++++++++++++++++++----
 net/wireless/nl80211.c     |   25 ++++++++++++++++++++--
 net/wireless/util.c        |    9 +++++++-
 net/wireless/wext-sme.c    |    2 +
 14 files changed, 184 insertions(+), 37 deletions(-)

