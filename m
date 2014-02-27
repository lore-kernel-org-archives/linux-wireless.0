Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:34949 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaB0OlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:41:25 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Subject: [RFC v2 0/4] mac802111: channel context reservation (was: multi-vif/multi-channel CSA implementation)
Date: Thu, 27 Feb 2014 16:41:17 +0200
Message-Id: <1393512081-31453-1-git-send-email-luca@coelho.fi> (sfid-20140227_154139_149351_40E5B438)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Hi,

I have changed my strategy slightly.  Instead of trying to get all the
CSA stuff done at once, I'm sending this patchset to add the concept
of channel reservation.

The last patch "mac80211: add usage of CS channel reservation for STA"
should be looked at as a proof of concept for the channel context
reservation feature. ;)

This series is based on top of mac80211-next/master, without including
my combination check changes.  When the combination check patchset
gets applied, I can either send the "merge" of the two features as a
separate patchset or I can modify this patchset accordingly (though I
prefer the former, so I can do things in small steps ;).

Please review and let me know what you think.  The changes from my
first RFC are inlined in the commit message of the 2/4 patch.

--
Cheers,
Luca.

Luciano Coelho (4):
  mac80211: split ieee80211_vif_change_channel in two
  mac80211: implement chanctx reservation
  mac80211: allow reservation of a running chanctx
  mac80211: add usage of CS channel reservation for STA

 include/net/mac80211.h     |   7 ++
 net/mac80211/chan.c        | 228 +++++++++++++++++++++++++++++++++++++++++----
 net/mac80211/ieee80211_i.h |  18 +++-
 net/mac80211/mlme.c        |  70 ++++++--------
 4 files changed, 264 insertions(+), 59 deletions(-)

-- 
1.8.5.3

