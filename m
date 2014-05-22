Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:50982 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaEVNf3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 09:35:29 -0400
Received: by mail-ee0-f44.google.com with SMTP id c41so2734176eek.3
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 06:35:27 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/3] mac80211: fix csa counters
Date: Thu, 22 May 2014 15:28:11 +0200
Message-Id: <1400765294-14732-1-git-send-email-michal.kazior@tieto.com> (sfid-20140522_153532_290679_2EA4BAB2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was seeing strange WARN_ON splat loops and
crashes while I was testing my multi-vif CSA.

CSA counters weren't properly reset and on some
failpaths this caused a mess. There were also
possible SMP inconsitencies/races.


Michal Kazior (3):
  mac80211: move csa counters from sdata to beacon/presp
  mac80211: use csa counter offsets instead of csa_active
  mac80211: make csa_currnet_counter atomic

 net/mac80211/cfg.c         |  72 +++++++++++++++++++----------
 net/mac80211/ibss.c        |   2 +-
 net/mac80211/ieee80211_i.h |   6 +--
 net/mac80211/mesh.c        |   2 +-
 net/mac80211/tx.c          | 112 +++++++++++++++++++++++++--------------------
 5 files changed, 114 insertions(+), 80 deletions(-)

-- 
1.8.5.3

