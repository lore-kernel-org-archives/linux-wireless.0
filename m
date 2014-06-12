Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:51537 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbaFLNC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 09:02:29 -0400
Received: by mail-wi0-f179.google.com with SMTP id cc10so2929127wib.12
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2014 06:02:28 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: luca@coelho.fi, johannes@sipsolutions.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v9 0/5] cfg/mac80211: implement multi-vif csa
Date: Thu, 12 Jun 2014 14:54:35 +0200
Message-Id: <1402577680-17888-1-git-send-email-michal.kazior@tieto.com> (sfid-20140612_150233_394925_55C2054B)
In-Reply-To: <1401972980-21484-1-git-send-email-michal.kazior@tieto.com>
References: <1401972980-21484-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The patchset implements multi-interface
reservations and multi-interface channel
switching.

There are still some cases that aren't handled
well (at least degradation of number of channels
due to interface combinations that I'm aware of).


v9:
 * free use-after-free [Eliad]

Michal Kazior (5):
  mac80211: implement multi-vif in-place reservations
  mac80211: make check_combinations() aware of chanctx reservation
  mac80211: use chanctx reservation for AP CSA
  mac80211: use chanctx reservation for STA CSA
  cfg80211: remove channel_switch combination check

 include/net/cfg80211.h     |   7 +-
 include/net/mac80211.h     |   7 -
 net/mac80211/cfg.c         |  82 +++--
 net/mac80211/chan.c        | 728 ++++++++++++++++++++++++++++++++++++---------
 net/mac80211/ieee80211_i.h |  30 +-
 net/mac80211/mlme.c        |  99 +++---
 net/mac80211/util.c        |  44 ++-
 net/wireless/nl80211.c     |  11 -
 8 files changed, 772 insertions(+), 236 deletions(-)

-- 
1.8.5.3

