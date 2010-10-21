Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:63124 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab0JUDzJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 23:55:09 -0400
From: Paul Stewart <pstew@google.com>
Date: Wed, 20 Oct 2010 20:21:32 -0700
Subject: [PATCH 0/2] Add CQM monitoring
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Message-Id: <20101021035501.4AF8F209D0@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a third version of this patch -- I made some cleanups including
not using the ifmgd->flags, since that could lead to race conditions.

Present CQM events to listeners under the following conditions:

- A bitrate threshold has been configured AND
  + This is the first transmitted rate since the threshold has been
    (re)configured OR
  + The current transmit rate is on the other side of the threshold from
    the previous transmit OR
  + The current transmit rate is lower than the threshold AND also lower
    than the previous bitrate we have notified about.


 include/linux/nl80211.h    |   11 +++++-
 include/net/cfg80211.h     |   18 ++++++++
 net/mac80211/cfg.c         |   15 +++++++
 net/mac80211/debugfs.c     |    4 ++
 net/mac80211/ieee80211_i.h |   23 ++++++++++
 net/mac80211/mlme.c        |    9 ++++
 net/mac80211/rate.c        |   96 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rate.h        |    8 ++++
 net/mac80211/status.c      |   18 ++++++++
 net/wireless/mlme.c        |   13 ++++++
 net/wireless/nl80211.c     |   86 ++++++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.h     |    6 +++
 12 files changed, 304 insertions(+), 3 deletions(-)

--
Paul
