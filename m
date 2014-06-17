Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:57155 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066AbaFQNGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2014 09:06:48 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so7087871wes.41
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jun 2014 06:06:47 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: luca@coelho.fi, johannes@sipsolutions.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v10 0/5] cfg/mac80211: implement multi-vif csa
Date: Tue, 17 Jun 2014 14:58:53 +0200
Message-Id: <1403009938-1084-1-git-send-email-michal.kazior@tieto.com> (sfid-20140617_150657_394384_175BE88E)
In-Reply-To: <1402577680-17888-1-git-send-email-michal.kazior@tieto.com>
References: <1402577680-17888-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The patchset implements multi-interface
reservations and multi-interface channel
switching.

There are still some cases that aren't handled
well (at least degradation of number of channels
due to interface combinations that I'm aware of).


v10:
 * rebase to latest mac80211-next/master
   (90c18a8b34add196da9b07fd37d0f3b4b451c6b3)
 * fix compilation [Luca]

Michal Kazior (5):
  mac80211: implement multi-vif in-place reservations
  mac80211: make check_combinations() aware of chanctx reservation
  mac80211: use chanctx reservation for AP CSA
  mac80211: use chanctx reservation for STA CSA
  cfg80211: remove channel_switch combination check

 include/net/cfg80211.h     |   7 +-
 include/net/mac80211.h     |   7 -
 net/mac80211/cfg.c         |  82 +++--
 net/mac80211/chan.c        | 729 ++++++++++++++++++++++++++++++++++++---------
 net/mac80211/ieee80211_i.h |  30 +-
 net/mac80211/mlme.c        |  99 +++---
 net/mac80211/util.c        |  44 ++-
 net/wireless/nl80211.c     |  11 -
 8 files changed, 773 insertions(+), 236 deletions(-)

-- 
1.8.5.3

