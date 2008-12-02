Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:43869 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYLBUD6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:03:58 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mB2K3qBk007929
	for <linux-wireless@vger.kernel.org>; Tue, 2 Dec 2008 22:03:55 +0200
Received: from [127.0.1.1] (essapo-nirac253161.europe.nokia.com [10.162.253.161])
	by mgw-int01.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mB2K3pP3027142
	for <linux-wireless@vger.kernel.org>; Tue, 2 Dec 2008 22:03:52 +0200
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [RFC PATCH v4 0/5] mac80211 dynamic power save
To: linux-wireless@vger.kernel.org
Date: Tue, 02 Dec 2008 22:03:51 +0200
Message-ID: <20081202200219.5507.83250.stgit@tikku> (sfid-20081202_210402_396981_3F1ED037)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is v4 of my dynamic powersave patches. I have tested them only
with stlc45xx on Nokia N810. I'm also working with iwl3945 and iwlagn
patches based on these patches, but I haven't finished them yet.

These are RFC patches, not yet to be applied.

Patch 3 contains a new flag IEEE80211_HW_NO_DYNAMIC_PS. So all drivers
which firmware doesn't support dynamic power save should use this flag
to enable the feature in mac80211. This is a separate patch just for
easier review. If it's ok, I'll fold it to patch 2.

Patch 4 moves the dynamic_ps_timeout to ieee80211_conf struct. That
way the drivers which have dynamic power save support in firmware can
use the same timeout provided by user space. If this ok I'll fold this
to patch 2.

Patch 5 contains internal interface mac80211 to enable and disable
queues. The original idea and design is from Johannes Berg, I just did
the implementation based on those. All the bugs are mine, of course.

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

TODO:
o test with iwlwifi (only in-tree driver using IEEE80211_CONF_PS)

Power save related features which I'll implement later:
o disable power save when software scanning
o beacon period (wakeup period) to the drivers, can be set from user
  space but otherwise is bss's DTIM value

---

Kalle Valo (5):
      mac80211: track master queue status
      mac80211: move dynamic_ps_timeout to hw.conf
      mac80211: add IEEE80211_HW_NO_DYNAMIC_PS flag
      mac80211: implement dynamic power save
      mac80211: enable IEEE80211_CONF_PS only when associated


 include/net/mac80211.h     |   10 +++++++
 net/mac80211/ieee80211_i.h |   22 +++++++++++++++-
 net/mac80211/main.c        |    9 +++++++
 net/mac80211/mlme.c        |   60 +++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/tx.c          |   13 ++++++++++
 net/mac80211/util.c        |   60 ++++++++++++++++++++++++++++++++++++++++----
 net/mac80211/wext.c        |   46 ++++++++++++++++++++++++++++------
 7 files changed, 203 insertions(+), 17 deletions(-)

