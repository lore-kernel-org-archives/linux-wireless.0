Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:35299 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbZGWKN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:13:26 -0400
Received: by bwz28 with SMTP id 28so709536bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 03:13:25 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 0/7] implement background scan
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Thu, 23 Jul 2009 12:13:32 +0200
Message-ID: <20090723100732.5147.73989.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series implements basic background scanning in mac80211
by interrupting the scan after each scanned channel to allow RX/TX.

I only tested the patches on current wireless-testing with iwlagn
in sw-scan mode and it works fine already. Nevertheless, it would
be great if somebody could test the patches on other hardware as well.

A scan now takes ~13s on my iwl4965 with a total of 31 channels
(17 passive channels) while associated. Two possibilities for the
future to reduce the time a scan takes:
- leave the operating channel as soon as RX and TX were idle for
  a small period of time (currently we just stay 250ms on the
  operating channel after each scanned channel).
- Scan multiple channels in a row if the qos latency allows us to
  do so.

Helmut
---

Helmut Schaa (7):
      cfg80211: increase scan result expire time
      mac80211: rename scan_state to next_scan_state
      mac80211: implement basic background scanning
      mac80211: Replace {sw,hw}_scanning variables with a bitfield
      mac80211: introduce a new scan state "decision"
      mac80211: advance the state machine immediately if no delay is needed
      mac80211: refactor the scan code


 net/mac80211/ibss.c        |    2 
 net/mac80211/ieee80211_i.h |   41 ++++++
 net/mac80211/iface.c       |    4 -
 net/mac80211/main.c        |    2 
 net/mac80211/mesh.c        |    2 
 net/mac80211/mlme.c        |    8 +
 net/mac80211/rx.c          |    8 +
 net/mac80211/scan.c        |  300 ++++++++++++++++++++++++++++++++------------
 net/mac80211/tx.c          |    6 -
 net/wireless/scan.c        |    2 
 10 files changed, 275 insertions(+), 100 deletions(-)

-- 
Signature
