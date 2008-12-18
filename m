Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:39010 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYLRVRr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 16:17:47 -0500
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mBILGOVp028172
	for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 15:17:45 -0600
Received: from [127.0.1.1] (essapo-nirac25252.europe.nokia.com [10.162.252.52])
	by mgw-int02.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mBILGqSE001468
	for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 23:16:52 +0200
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH v5 0/3] mac80211 dynamic power save
To: linux-wireless@vger.kernel.org
Date: Thu, 18 Dec 2008 23:16:51 +0200
Message-ID: <20081218211532.6842.88104.stgit@tikku> (sfid-20081218_221750_551441_71A951B7)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is v5 of my dynamic powersave patches. I have tested them with
stlc45xx on Nokia N810.

I think (and hope) that the patches are close to inclusion now. Please
review.

changes in v5:

o check STA interface earlier in siwpower()
o moved queue track patch before dynamic power save patch
o add new functions ieee80211_wake_queues_by_reason() and
  ieee80211_stop_queues_by_reason() for optimised locking
o dropped "move dynamic_ps_timeout to hw.conf" for now, will resubmit
  it later when I have example driver implementation
o renamed the hw flag to IEEE80211_HW_NO_STACK_DYNAMIC_PS and inverted
  it's functionality, now drivers need to explicitly disable the feature
o folded hw flag patch to the main dynamic power save patch

changes in v4:
o add check for station interface to siwpower()
o call hw_config() also for dynamic timeout changes
o add dynamic_ prefix to workqueues
o test for IEEE80211_HW_NO_DYNAMIC_PS in siwpower()
o wrote documentation for IEEE80211_HW_NO_DYNAMIC_PS
o wrote documentation for conf->dynamic_ps_timeout

changes in v3:
o add a hw flag to notify that driver doesn't support dynamic power save and
  which will enable mac80211 implementation
o delete dynamic_ps_timer and cancel ps_enable_work during
  association, hopefully it's race free now
o provide timeout value to the drivers, for example iwlwifi should use
  it (example patch under works)
o fix a bad bug in testing IEEE80211_STA_ASSOCIATED flag with && operator

Power save related features which I'll implement later:
o disable power save when software scanning
o move dynamic_ps_timeout to hw.conf so that drivers can use it in
  case they need to
o beacon period (wakeup period) to the drivers, can be set from user
  space but otherwise is bss's DTIM value

---

Kalle Valo (3):
      mac80211: implement dynamic power save
      mac80211: track master queue status
      mac80211: enable IEEE80211_CONF_PS only when associated


 include/net/mac80211.h     |    6 +++
 net/mac80211/ieee80211_i.h |   23 +++++++++++-
 net/mac80211/main.c        |    9 +++++
 net/mac80211/mlme.c        |   60 ++++++++++++++++++++++++++++++-
 net/mac80211/tx.c          |   13 +++++++
 net/mac80211/util.c        |   86 +++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/wext.c        |   46 +++++++++++++++++++-----
 7 files changed, 226 insertions(+), 17 deletions(-)

