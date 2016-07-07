Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35658 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724AbcGFXIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 19:08:37 -0400
Received: by mail-oi0-f67.google.com with SMTP id d132so180326oig.2
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2016 16:08:37 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH 0/5] Improve wireless netdev detection
Date: Thu,  7 Jul 2016 02:08:45 -0500
Message-Id: <1467875330-7835-1-git-send-email-denkenz@gmail.com> (sfid-20160707_010855_453684_CF867D15)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current mechanism to detect hot-plug / unplug of wireless devices is
somewhat arcane.  One has to listen to NEW_WIPHY/DEL_WIPHY events over
nl80211 as well as RTM_NEWLINK / RTM_DELLINK events over rtnl, then
somehow find a correlation between these events.  This involves userspace
sending GET_INTERFACE or GET_WIPHY commands to the kernel, which incurs
additional roundtrips.

This patch series proposes that NEW_INTERFACE and DEL_INTERFACE events are
always emitted, regardless of whether a netdev was added/removed by the
driver or explicitly via NEW_INTERFACE/DEL_INTERFACE commands.

One side effect of this approach is that multiple NEW_INTERFACE/DEL_INTERFACE
events might be generated for P2P interfaces.  Once when a wdev is created
or destroyed, and once when the associated p2p netdev is connecte or 
disconnected.  It is likely that only the caller of P2P oriented
NEW_INTERFACE / DEL_INTERFACE commands is interested in the status of these
operations.  E.g. the caller is / should be using SOCKET_OWNER attribute.
Thus one possibility is to not emit NEW_INTERFACE/DEL_INTERFACE events in
such cases.

Denis Kenzior (5):
  nl80211: Add nl80211_notify_iface
  core: Notify of new wireless netdevs
  nl80211: Emit NEW_INTERFACE only in special cases
  core: Notify when wireless netdev is removed
  nl80211: Emit DEL_INTERFACE only in special cases

 net/wireless/core.c    |  4 ++++
 net/wireless/nl80211.c | 63 ++++++++++++++++++++++++++++++++++++++------------
 net/wireless/nl80211.h |  3 +++
 3 files changed, 55 insertions(+), 15 deletions(-)

-- 
2.7.3

