Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36158 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbbAOMsD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 07:48:03 -0500
Message-ID: <1421326080.1962.10.camel@sipsolutions.net> (sfid-20150115_134812_245466_9DC1ED52)
Subject: pull-request: mac80211 2015-01-15
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 15 Jan 2015 13:48:00 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Hope it's not too late for 3.19 - we found two more issues, pull request
below.

Thanks,
johannes

The following changes since commit 1e359a5de861a57aa04d92bb620f52a5c1d7f8b1:

  Revert "mac80211: Fix accounting of the tailroom-needed counter" (2015-01-05 10:33:46 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2015-01-15

for you to fetch changes up to 20658702e08ecd693236b443837d28863b93e872:

  cfg80211: fix deadlock during reg chan check (2015-01-07 14:53:46 +0100)

----------------------------------------------------------------
Just two fixes - one for an uninialized variable and
one for a deadlock in regulatory processing.

----------------------------------------------------------------
Arik Nemtsov (1):
      cfg80211: fix deadlock during reg chan check

John Linville (1):
      mac80211: uninitialized return val in __ieee80211_sta_handle_tspec_ac_params

 net/mac80211/mlme.c |  2 +-
 net/wireless/reg.c  | 56 ++++++++++++++++++++++++++++++++---------------------
 2 files changed, 35 insertions(+), 23 deletions(-)


