Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60188 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730AbaE2GqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 02:46:16 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so36828wiw.10
        for <linux-wireless@vger.kernel.org>; Wed, 28 May 2014 23:46:14 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/2] mac80211: fix csa counters
Date: Thu, 29 May 2014 08:38:53 +0200
Message-Id: <1401345535-22991-1-git-send-email-michal.kazior@tieto.com> (sfid-20140529_084624_055241_C09A09EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was seeing strange WARN_ON splat loops and
crashes while I was testing my multi-vif CSA.

CSA counters weren't properly reset and on some
failpaths this caused a mess. There were also
possible SMP inconsitencies/races.


v2:
 * dropped the atomic counter patch
 * fix patch 1

Michal Kazior (2):
  mac80211: move csa counters from sdata to beacon/presp
  mac80211: use csa counter offsets instead of csa_active

 net/mac80211/cfg.c         |  67 ++++++++++++++++++---------
 net/mac80211/ibss.c        |   2 +-
 net/mac80211/ieee80211_i.h |  16 +++++--
 net/mac80211/mesh.c        |   2 +-
 net/mac80211/tx.c          | 113 +++++++++++++++++++++++++--------------------
 5 files changed, 122 insertions(+), 78 deletions(-)

-- 
1.8.5.3

