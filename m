Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34764 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab2HAU6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 16:58:50 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Josh Boyer <jwboyer@redhat.com>,
	Arend van Spriel <arend@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: [PATCH 0/2] Fix lockdep warning in brcmsmac
Date: Wed,  1 Aug 2012 15:58:41 -0500
Message-Id: <1343854723-21987-1-git-send-email-seth.forshee@canonical.com> (sfid-20120801_225854_791261_4BA22052)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As reported by Josh Boyer, brcmsmac is producing lockdep warnings by
calling freq_reg_info() without holding cfg80211_lock. Currently
freq_reg_info() is the only way for a wireless driver to tell whether
OFDM is allowed on the current channel, but cfg80211_lock is outside the
scope of the wireless drivers.

Since other regulatory restrictions are communicated in the channel
definition, it makes sense to do the same for OFDM. These patches add a
new flag, IEEE80211_CHAN_NO_OFDM, which is set by regulatory to
indicated OFDM operation is prohibited. brcmsmac is modifified to use
this flag instead of consuming the regulatory data directly.

Thanks,
Seth


Seth Forshee (2):
  cfg80211: add channel flag to restrict OFDM
  brcmsmac: use channel flags to restrict OFDM

 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |    5 +----
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    3 ++-
 include/net/cfg80211.h                             |    2 ++
 net/wireless/reg.c                                 |    2 ++
 4 files changed, 7 insertions(+), 5 deletions(-)

