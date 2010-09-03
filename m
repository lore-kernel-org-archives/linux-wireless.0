Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:46483 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab0ICPFf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 11:05:35 -0400
Subject: Re: [PATCH 0/13] iwlwifi: rewrite iwl-scan.c to avoid race
 conditions
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
References: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Fri, 03 Sep 2010 08:04:53 -0700
Message-Id: <1283526293.5211.18.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gruszka,

On Fri, 2010-09-03 at 04:57 -0700, Stanislaw Gruszka wrote:
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

A lot of changes, great jobs. How much test you done for different
devices? Scan is a very important function and I am also not expert in
this area.

Thanks
Wey

