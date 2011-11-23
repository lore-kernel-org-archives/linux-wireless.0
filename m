Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61342 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab1KWCum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 21:50:42 -0500
Received: by vbbfc26 with SMTP id fc26so22487vbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2011 18:50:42 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH v2 0/3] mac80211: timeout tx agg sessions in way similar to rx agg sessions
Date: Tue, 22 Nov 2011 21:50:27 -0500
Message-Id: <1322016630-27332-1-git-send-email-mar.kolya@gmail.com> (sfid-20111123_035046_552802_8E57CF1D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Currently tx aggregation is not being timed out even if timeout is
specified when aggregation is opened. Tx tid stays active until delba
arrives from recipient (i.e. recipient times out tid when it is
inactive).
  The problem with this approach is that delba can get lost in the air
and tx tid will stay perpetually opened on the originator while closed
on recipient thus all data sent via this tid will be lost.
 The problem manifests itself with connection becoming slow/unusable
with ping times jumping to 4s. At such time opened tx tid can be seen
on one side of the connection without corresponding rx tid one the
other side. This seems to be happening quite often soon after
connection on ar9102 I have.
  This patch implements tx tid timeouting in way very similar to rx tid
timeouting.

  All comments and suggestions are appreciated.

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>

Nikolay Martynov (3):
  mac80211: timeout tx agg sessions in way similar to rx agg sessions
  mac80211: trivial: use WLAN_BACK_RECIPIENT instead of hardcoded 0
  mac80211: log reason and initiator when rx agg is stopped

 net/mac80211/agg-rx.c   |    9 ++++++---
 net/mac80211/agg-tx.c   |   35 ++++++++++++++++++++++++++++++++++-
 net/mac80211/sta_info.h |    2 ++
 net/mac80211/tx.c       |    8 ++++++++
 4 files changed, 50 insertions(+), 4 deletions(-)

-- 
1.7.4.1

