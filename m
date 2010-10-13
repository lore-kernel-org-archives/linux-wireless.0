Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:5048 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab0JMWsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 18:48:36 -0400
Received: from hpaq3.eem.corp.google.com (hpaq3.eem.corp.google.com [172.25.149.3])
	by smtp-out.google.com with ESMTP id o9DMmZJj013473
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 15:48:35 -0700
Received: from iwn38 (iwn38.prod.google.com [10.241.68.102])
	by hpaq3.eem.corp.google.com with ESMTP id o9DMm36s025751
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 15:48:34 -0700
Received: by iwn38 with SMTP id 38so5495387iwn.2
        for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 15:48:33 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 13 Oct 2010 15:48:32 -0700
Message-ID: <AANLkTik4KsDNF3MbSX82ocaWxKX62UYzfaMfXYB14Om-@mail.gmail.com>
Subject: [PATCH 0/6] Create CQM events for transmit bitrate change events
From: Paul Stewart <pstew@google.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Present CQM events to listeners under the following conditions:

- A bitrate threshold has been configured AND
+ This is the first transmitted rate since the threshold has been
(re)configured OR
+ The current transmit rate is on the other side of the threshold from
the previous transmit OR
+ The current transmit rate is lower than the threshold AND also lower
than the previous bitrate we have notified about.


 include/linux/nl80211.h    |    4 ++
 include/net/cfg80211.h     |   18 ++++++++
 include/net/mac80211.h     |    3 +
 net/mac80211/cfg.c         |   17 +++++++
 net/mac80211/ieee80211_i.h |   16 +++++++
 net/mac80211/main.c        |   11 +++++
 net/mac80211/rate.c        |   74 ++++++++++++++++++++++++++++++++
 net/mac80211/rate.h        |    8 +++
 net/mac80211/status.c      |   14 ++++++
 net/wireless/mlme.c        |   13 ++++++
 net/wireless/nl80211.c     |  102 +++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.h     |    6 +++
 12 files changed, 284 insertions(+), 2 deletions(-)

--
Paul
