Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55640 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbaE2Hlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 03:41:42 -0400
Received: by mail-wi0-f178.google.com with SMTP id cc10so102707wib.5
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2014 00:41:41 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: luca@coelho.fi, johannes@sipsolutions.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v7 0/5] cfg/mac80211: implement multi-vif csa
Date: Thu, 29 May 2014 09:34:06 +0200
Message-Id: <1401348851-26732-1-git-send-email-michal.kazior@tieto.com> (sfid-20140529_094145_604065_745A2251)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here's yet again a re-spin of my multi-vif csa
patches. Hopefully I got everything right this
time..

I've delibarately not included documentation
fixes. I think we can handle this with follow up
patches.


v7:
 * drop drv_switch_vif_chanctx patch in favor of
   Luca's implementation
 * rework in-place reservations to be more robust
 * other fixes (see per patch notes)

Michal Kazior (5):
  mac80211: implement multi-vif in-place reservations
  mac80211: make check_combinations() aware of chanctx reservation
  mac80211: use chanctx reservation for AP CSA
  mac80211: use chanctx reservation for STA CSA
  cfg80211: remove channel_switch combination check

 include/net/cfg80211.h     |   7 +-
 include/net/mac80211.h     |   7 -
 net/mac80211/cfg.c         |  82 ++++---
 net/mac80211/chan.c        | 593 ++++++++++++++++++++++++++++++++++-----------
 net/mac80211/ieee80211_i.h |  12 +-
 net/mac80211/mlme.c        |  99 +++++---
 net/mac80211/util.c        |  42 +++-
 net/wireless/nl80211.c     |  11 -
 8 files changed, 621 insertions(+), 232 deletions(-)

-- 
1.8.5.3

