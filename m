Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59231 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932892AbbLRStq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 13:49:46 -0500
Message-ID: <1450464582.2849.68.camel@sipsolutions.net> (sfid-20151218_194953_405905_E88B5286)
Subject: pull-request: mac80211-next 2015-12-18
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 18 Dec 2015 19:49:42 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Before we all go on vacation/holidays, I have a few bugfixes for
net-next. The remain-on-channel ones are quite necessary since Ilan's
patch broke things quite a bit, causing crashes.

If the issue with the strange mail formatting persists let me know and
I'll send these through some other client in the future.

Enjoy the holidays and happy New Year :)

Thanks,
johannes


The following changes since commit 1b894521e60c1b91db1e8ba1278660e5c89f1b5f:

  mac80211: handle HW ROC expired properly (2015-12-07 11:06:37 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2015-12-18

for you to fetch changes up to c45932df56120a73b05f391be9730185eb51eecf:

  regulatory: fix world regulatory domain data (2015-12-11 17:42:06 +0100)

----------------------------------------------------------------
A few more updates for the next cycle:
 * remove pretty much unused and useless REG_DEBUG option
 * make regdomain messages debugging only
 * fix two bugs in the new remain-on-channel code
 * fix the world regdomain data for consistency

----------------------------------------------------------------
Dave Young (1):
      wireless: change cfg80211 regulatory domain info as debug messages

Johannes Berg (4):
      mac80211: recalculate SW ROC only when needed
      mac80211: fix remain-on-channel cancellation
      cfg80211: remove CFG80211_REG_DEBUG
      regulatory: fix world regulatory domain data

 net/mac80211/offchannel.c |  12 ++--
 net/wireless/Kconfig      |  13 ----
 net/wireless/reg.c        | 167 ++++++++++++++++------------------------------
 3 files changed, 64 insertions(+), 128 deletions(-)
