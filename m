Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55474 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab0IMOJQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 10:09:16 -0400
Subject: Re: [PATCH 0/14 v4] iwlwifi: rewrite iwl-scan.c to avoid race
 conditions
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1284382005-3246-1-git-send-email-sgruszka@redhat.com>
References: <1284382005-3246-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Mon, 13 Sep 2010 07:08:29 -0700
Message-Id: <1284386909.23922.21.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-13 at 05:46 -0700, Stanislaw Gruszka wrote:
> Avoid iwlwifi hardware scanning race conditions
> that may lead to not call ieee80211_scan_completed() (what in
> consequences gives "WARNING: at net/wireless/core.c:614
> wdev_cleanup_work+0xb7/0xf0"), or call iee80211_scan_completed() more
> then once (what gives " WARNING: at net/mac80211/scan.c:312
> ieee80211_scan_completed+0x5f/0x1f1").
> 
> First problem (warning in wdev_cleanup_work) make any further scan
> request from cfg80211 are ignored by mac80211 with EBUSY error,
> hence NetworkManager can not perform successful scan and not allow
> to establish a new connection. So after suspend/resume (but maybe
> not only then) user is not able to connect to wireless network again.
> 
> We can not rely on that the commands (start and abort scan) are
> successful. Even if they are successfully send to the hardware, we can
> not get back notification from firmware (i.e. firmware hung or was
> reseted), or we can get notification when we actually perform abort
> scan in driver code or after that.
> 
> To assure we call ieee80211_scan_completed() only once when scan
> was started we use SCAN_SCANNING bit. Code path, which first clear
> STATUS_SCANNING bit will call ieee80211_scan_completed().
> We do this in many cases, in scan complete notification, scan
> abort, device down, etc. Each time we check SCANNING bit.
> 
> Tested on 3945, 4965 and 5300 adapters. Tested normal work
> functionality and doing scan stress testing using scripts:
> http://people.redhat.com/sgruszka/misc/test_wifi_scan_reboot.sh
> http://people.redhat.com/sgruszka/misc/test_wifi_scan_updown.sh
> 
> v1 -> v2:
> - fix not cleared STATUS_SCAN_HW bit in patch 2
> - merged patch 7 and 8
> - add 3 new patches
> 
> v2 -> v3:
> - merged patch 5 and 14
> - merged patch 2 and 16
> - add bugzilla reference into 3 most important patches
> - not use cancel_delayed_work_sync in work function (patch 10)
> 
> v3 -> v4:
> - add additional changelog comments in patch 9 and 13 and Wey acks
>   in other patches

Thank you, looks good to me.

Wey

