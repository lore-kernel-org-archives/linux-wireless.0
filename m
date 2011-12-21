Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63637 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab1LUKLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 05:11:12 -0500
Received: by wgbdr13 with SMTP id dr13so13979045wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 02:11:11 -0800 (PST)
From: Eyal Shapira <eyal@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>, Luciano Coelho <coelho@ti.com>
Subject: [PATCH v2 0/2] report stop sched scan when actually done
Date: Wed, 21 Dec 2011 12:11:00 +0200
Message-Id: <1324462262-10277-1-git-send-email-eyal@wizery.com> (sfid-20111221_111116_674277_467FB4B2)
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

 net/mac80211/scan.c |   10 +++-------
 net/wireless/scan.c |   17 ++++++++---------
 2 files changed, 11 insertions(+), 16 deletions(-)

-- 
1.7.4.1

