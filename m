Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50152 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab1LUADT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 19:03:19 -0500
Received: by wibhm6 with SMTP id hm6so1677230wib.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 16:03:18 -0800 (PST)
From: Eyal Shapira <eyal@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>, Luciano Coelho <coelho@ti.com>
Subject: [PATCH 0/2] report stop sched scan when actually done
Date: Wed, 21 Dec 2011 02:03:08 +0200
Message-Id: <1324425790-3030-1-git-send-email-eyal@wizery.com> (sfid-20111221_010329_759582_846E9692)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes in mac/cfg80211 to notify userspace
of NL80211_CMD_SCHED_SCAN_STOPPED only when the driver
actually reported back that it was stopped. Also
blocks other attempts until we're really done.

This fixes a scenario where stop sched scan
is issued and immediately afterwards a new sched scan
is requested (e.g. with other parameters).
Current state caused a race where the driver started
stopping the sched scan but didn't finish and got
another sched scan request which it couldn't handle.

Eyal Shapira (2):
  mac80211: mark stopped sched scan only after driver does
  nl80211: report stopped sched scan only after driver does

 net/mac80211/scan.c |    9 ++++++---
 net/wireless/scan.c |   17 ++++++++---------
 2 files changed, 14 insertions(+), 12 deletions(-)

-- 
1.7.4.1

