Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:51113 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab0IIPc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 11:32:59 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 9 Sep 2010 08:32:56 -0700
Subject: RE: [PATCH 0/16 v2] iwlwifi: rewrite iwl-scan.c to avoid race
 conditions
Message-ID: <E9954878DD1FB34FAE5187FB88C58A3501280FDC3D@orsmsx506.amr.corp.intel.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gruszka,

Do we have any bugzilla bug# can associated to this set of patches?

Thanks
Wey

-----Original Message-----
From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
Sent: Thursday, September 09, 2010 6:52 AM
To: Johannes Berg; Guy, Wey-Yi W; Chatre, Reinette; John W. Linville
Cc: linux-wireless@vger.kernel.org; Stanislaw Gruszka
Subject: [PATCH 0/16 v2] iwlwifi: rewrite iwl-scan.c to avoid race conditions

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
