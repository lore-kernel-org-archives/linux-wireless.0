Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34897 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaCUN6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 09:58:07 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so1836002eei.33
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 06:58:06 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/7] cfg80211/mac80211: implement multi-vif csa
Date: Fri, 21 Mar 2014 14:52:14 +0100
Message-Id: <1395409941-26303-1-git-send-email-michal.kazior@tieto.com> (sfid-20140321_145813_224964_D2C6C53A)
In-Reply-To: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is another part of my recent RFC. This is
just the channel switching part.

This is based on my patchset implementing
multi-vif chanctx reservations.


v2:
 * add radar_detect fix patch (wasn't present in
   the big RFC)


Michal Kazior (7):
  cfg80211: fix radar_detect combination checking
  mac80211: make check_combinations() aware of chanctx reservation
  mac80211: use chanctx reservation for AP CSA
  mac80211: use chanctx reservation for STA CSA
  mac80211: ignore cqm during csa
  mac80211: remove old unused channel switching code
  cfg80211: remove channel_switch combination check

 net/mac80211/cfg.c         | 63 +++++++++++++++++++----------
 net/mac80211/chan.c        | 79 +++++++-----------------------------
 net/mac80211/ieee80211_i.h |  5 ---
 net/mac80211/mlme.c        | 99 ++++++++++++++++++++++++++++++----------------
 net/mac80211/util.c        | 37 ++++++++++++++++-
 net/wireless/nl80211.c     | 11 ------
 net/wireless/util.c        |  2 +-
 7 files changed, 156 insertions(+), 140 deletions(-)

-- 
1.8.5.3

