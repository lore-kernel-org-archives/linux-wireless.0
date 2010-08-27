Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:26311 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab0H0L1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 07:27:16 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com
Subject: [PATCHv2 0/4] mac80211: cfg80211: support for hw-only crypts and custom control port protocols
Date: Fri, 27 Aug 2010 14:26:50 +0300
Message-Id: <1282908414-26783-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches enable usage of hw-only cipher-suites, and enable using
control port ethertypes other than ETH_P_PAE for key-negotiation.

These patches are originally written by Johannes Berg, finalized and tested by
myself.

v2: Add explicit setting to false for sdata->control_port_protocol in 
    ieee80211_setup_sdata.

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

