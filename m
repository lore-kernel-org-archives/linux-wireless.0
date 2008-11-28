Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:18638 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbYK1TuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 14:50:04 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx06.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mASJnbic001864
	for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2008 21:50:01 +0200
Received: from localhost.localdomain (essapo-nirac25338.europe.nokia.com [10.162.253.38])
	by mgw-int01.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mASJnjSg003187
	for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2008 21:49:46 +0200
From: Kalle Valo <kalle.valo@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC v3] mac80211 dynamic power save
Date: Fri, 28 Nov 2008 21:49:40 +0200
Message-Id: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com> (sfid-20081128_205009_436711_4E21FF28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is v3 of my dynamic powersave patches. I have tested them only
with stlc45xx on Nokia N810. I'm also working with iwl3945 and iwlagn
patches based on these patches, I'll try to send them during this
weekend.

These are RFC patches, not yet to be applied. Hopefully in next round
they are ready.

Patch 3 contains a new flag IEEE80211_HW_NO_DYNAMIC_PS. So all drivers
which firmware doesn't support dynamic power save should use this flag
to enable the feature in mac80211. This is a separate patch just for
easier review. If it's ok, I'll fold it to patch 2.

Patch 4 moves the dynamic_ps_timeout to ieee80211_conf struct. That
way the drivers which have dynamic power save support in firmware can
use the same timeout provided by user space. If this ok I'll fold this
to patch 2.

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
o documentation for dynamic_ps_timeout and IEEE80211_HW_NO_DYNAMIC_PS
o prefix ieee80211_ps_[enable|disable]_work with _dynamic

Power save related features which I'll implement later:
o disable power save when software scanning
o beacon period (wakeup period) to the drivers, can be set from user
  space but otherwise is bss's DTIM value

I'll add missing features to the wiki tomorrow.


