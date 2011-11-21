Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52228 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab1KUCXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 21:23:06 -0500
Received: by ghbz2 with SMTP id z2so2300796ghb.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 18:23:05 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH 0/3] Add session timeout support for tx aggregation
Date: Sun, 20 Nov 2011 21:22:49 -0500
Message-Id: <1321842172-6732-1-git-send-email-mar.kolya@gmail.com> (sfid-20111121_032311_122233_16C6FEEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Currently tx aggregation is not being timed out even if timeout is specified when aggregation is opened. Tx tid stays active until delba arrives from recipient (i.e. recipient times out tid when it is inactive). The problem with this approach is that delba can get lost in the air and tx tid will stay perpetually opened on the originator while closed on recipient thus all data sent via this tid will be lost.
  The problem manifests itself with connection becoming slow/unusable with ping times jumping to 4s. At such time opened tx tid can be seen on one side of the connection without corresponding rx tid one the other side. This seems to be happening quite often soon after connection on ar9102 I have.
  This patch implements tx tid timeouting in way very similar to rx tid timeouting.

  All comments and suggestions are appreciated.
  Thanks.

kolya (3):
  mac80211: add tx agg session timer to timeout inactive tids in way
    similar to rx agg sessions are being timed out
  mac80211: use WLAN_BACK_RECIPIENT instead of hardcoded 0
  mac80211: format debugfs agg_status output

 net/mac80211/agg-rx.c      |    7 ++++---
 net/mac80211/agg-tx.c      |   35 ++++++++++++++++++++++++++++++++++-
 net/mac80211/debugfs_sta.c |    8 +++++---
 net/mac80211/sta_info.h    |    2 ++
 net/mac80211/tx.c          |    9 +++++++++
 5 files changed, 54 insertions(+), 7 deletions(-)

-- 
1.7.4.1

