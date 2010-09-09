Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab0IINwp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 09:52:45 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 0/16 v2] iwlwifi: rewrite iwl-scan.c to avoid race conditions
Date: Thu,  9 Sep 2010 15:52:18 +0200
Message-Id: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid iwlwifi hardware scanning race conditions
that may lead to not call ieee80211_scan_completed() (what in
consequences gives "WARNING: at net/wireless/core.c:614
wdev_cleanup_work+0xb7/0xf0"), or call iee80211_scan_completed() more
then once (what gives " WARNING: at net/mac80211/scan.c:312
ieee80211_scan_completed+0x5f/0x1f1").

First problem (warning in wdev_cleanup_work) make any further scan
request from cfg80211 are ignored by mac80211 with EBUSY error,
hence NetworkManager can not perform successful scan and not allow
to establish a new connection. So after suspend/resume (but maybe
not only then) user is not able to connect to wireless network again.

We can not rely on that the commands (start and abort scan) are
successful. Even if they are successfully send to the hardware, we can
not get back notification from firmware (i.e. firmware hung or was
reseted), or we can get notification when we actually perform abort
scan in driver code or after that.

To assure we call ieee80211_scan_completed() only once when scan
was started we use SCAN_SCANNING bit. Code path, which first clear
STATUS_SCANNING bit will call ieee80211_scan_completed().
We do this in many cases, in scan complete notification, scan
abort, device down, etc. Each time we check SCANNING bit.

Tested on 3945, 4965 and 5300 adapters. Tested normal work
functionality and doing scan stress testing using scripts:
http://people.redhat.com/sgruszka/misc/test_wifi_scan_reboot.sh
http://people.redhat.com/sgruszka/misc/test_wifi_scan_updown.sh

v1 -> v2:
- fix not cleared STATUS_SCAN_HW bit in patch 2
- merged patch 7 and 8
- add 4 more patches
