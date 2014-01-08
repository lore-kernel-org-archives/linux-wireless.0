Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:39558 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260AbaAHPbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 10:31:14 -0500
Received: by mail-ea0-f171.google.com with SMTP id h10so890791eak.16
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jan 2014 07:31:12 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 0/4] cfg80211: implement multi-BSS CSA
Date: Wed,  8 Jan 2014 16:26:54 +0100
Message-Id: <1389194818-7864-1-git-send-email-michal.kazior@tieto.com> (sfid-20140108_163117_469260_5B946839)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to implement multi-BSS CSA. So far I've
prepared some cfg80211 patches and I'd like to get
feedback whether this kind of apprach is okay or
not.


Michal Kazior (4):
  nl80211: make chandef parser take nlattr arg
  cfg80211: rename function argument to be more readable
  cfg80211: implement multi-vif interface combination validation
  cfg80211: implement multi-BSS CSA

 include/net/cfg80211.h       |  10 +-
 include/uapi/linux/nl80211.h |   2 +
 net/mac80211/cfg.c           |  10 +-
 net/wireless/core.h          |  36 +++++--
 net/wireless/nl80211.c       | 227 +++++++++++++++++++++++++++++--------------
 net/wireless/rdev-ops.h      |   8 +-
 net/wireless/trace.h         |  29 +-----
 net/wireless/util.c          | 158 ++++++++++++++++++------------
 8 files changed, 306 insertions(+), 174 deletions(-)

-- 
1.8.4.rc3

