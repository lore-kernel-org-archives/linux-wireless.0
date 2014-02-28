Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:37438 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaB1PMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 10:12:00 -0500
Received: by mail-ea0-f169.google.com with SMTP id d10so2754903eaj.14
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 07:11:58 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 0/3] cfg80211/mac80211: multi-vif csa preparation
Date: Fri, 28 Feb 2014 16:06:44 +0100
Message-Id: <1393600007-28766-1-git-send-email-michal.kazior@tieto.com> (sfid-20140228_161204_629248_E833CE5B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

These are some of the changes I think are
necessary for getting multi-vif and multi-chan
channel switching working.

This is based on Luca's interface combination
patchset v7.

This is taken from my local prototype. However
since Luca's patchsets are still under review
there's nothing more sane I can provide now ;-)

The patch #3 depends on my cfg80211_leave() fix.


Michal Kazior (3):
  cfg80211: allow drivers to iterate over matching combinations
  mac80211: add max channel calculation utility function
  cfg80211: export interface stopping function

 include/net/cfg80211.h     | 41 ++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/util.c        | 43 ++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.c        | 36 +++++++++++++++++++++++++++++++---
 net/wireless/core.h        |  3 +++
 net/wireless/trace.h       | 15 ++++++++++++++
 net/wireless/util.c        | 49 +++++++++++++++++++++++++++++++++++++++-------
 7 files changed, 178 insertions(+), 10 deletions(-)

-- 
1.8.5.3

