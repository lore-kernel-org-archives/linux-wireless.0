Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33697 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaFENDy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 09:03:54 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so9667192wib.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2014 06:03:53 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: luca@coelho.fi, johannes@sipsolutions.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v8 0/5] cfg/mac80211: implement multi-vif csa
Date: Thu,  5 Jun 2014 14:56:15 +0200
Message-Id: <1401972980-21484-1-git-send-email-michal.kazior@tieto.com> (sfid-20140605_150358_067955_A30BBF68)
In-Reply-To: <1401348851-26732-1-git-send-email-michal.kazior@tieto.com>
References: <1401348851-26732-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am sooo getting used to re-spinning :-)

Hopefully I won't need to respin 42 times.


v8:
 * a lot of updates, see patch notes

Michal Kazior (5):
  mac80211: implement multi-vif in-place reservations
  mac80211: make check_combinations() aware of chanctx reservation
  mac80211: use chanctx reservation for AP CSA
  mac80211: use chanctx reservation for STA CSA
  cfg80211: remove channel_switch combination check

 include/net/cfg80211.h     |   7 +-
 include/net/mac80211.h     |   7 -
 net/mac80211/cfg.c         |  82 +++--
 net/mac80211/chan.c        | 727 ++++++++++++++++++++++++++++++++++++---------
 net/mac80211/ieee80211_i.h |  30 +-
 net/mac80211/mlme.c        |  99 +++---
 net/mac80211/util.c        |  44 ++-
 net/wireless/nl80211.c     |  11 -
 8 files changed, 771 insertions(+), 236 deletions(-)

-- 
1.8.5.3

