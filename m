Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756862Ab3EWMTb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 08:19:31 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Jake Edge <jake@lwn.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFT/RFC 0/4] iwlegacy: workaround for firmware frame tx rejection
Date: Thu, 23 May 2013 14:20:56 +0200
Message-Id: <1369311660-15378-1-git-send-email-sgruszka@redhat.com> (sfid-20130523_141934_783298_AE7244FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jake, please test this set and check if it not cause association
problems you reported earlier this month.

Please apply it together with this mac80211 patch:
http://marc.info/?l=linux-wireless&m=136879090123023&w=2 
which I already posted and is queued to upstream. Not having
it may cause troubles and influence negatively this set test.

Johannes, is need to check beacon bssid or even if rx frame
is a beacon to unblock queues? I think if we receive any frame
(not necessary beacon or our bssid beacon) on passive channel,
that mean we can use that channel. But that depend how firmware
is implemented, if firmware require our bssid beacon to unblock
channel, driver of course need that too.

Stanislaw Gruszka (4):
  iwlegacy: small refactoring of il_{stop,wake}_queue
  iwlegacy: add il_{stop,wake}_queues_by_reason functions
  iwlegacy: workaround for firmware frame tx rejection
  Revert "iwl4965: workaround connection regression on passive channel"

 drivers/net/wireless/iwlegacy/4965-mac.c | 22 ++++++++++++++++-
 drivers/net/wireless/iwlegacy/common.c   | 10 ++++++++
 drivers/net/wireless/iwlegacy/common.h   | 41 ++++++++++++++++++++++++++++----
 3 files changed, 68 insertions(+), 5 deletions(-)

-- 
1.7.11.7

