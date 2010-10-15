Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148Ab0JOOtO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 10:49:14 -0400
Date: Fri, 15 Oct 2010 16:51:30 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] iwlwifi: one less commit_rxon while scan
Message-ID: <20101015145129.GA4046@redhat.com>
References: <1286977193-12144-1-git-send-email-sgruszka@redhat.com>
 <1286977193-12144-2-git-send-email-sgruszka@redhat.com>
 <20101014084238.GB2286@redhat.com>
 <1287071679.13051.10.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1287071679.13051.10.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

On Thu, Oct 14, 2010 at 08:54:39AM -0700, Guy, Wey-Yi wrote:
> > Any comments about iwl_update_chain_flags, iwl_bg_bt_full_concurrency ?
> > I would like to know how to deal with them, should we deffer commit_rxon
> > to scan complete, or cancel the scan. Or maybe this is no problem
> > at all, because in example committing rxon vs scan was problem of
> > older firmware?
> > 
> 
> iwl_update_chain_flags() is used when PSP mode change,
> iwl_bg_bt_full_concurrency() is used only for BT coex and in BT full
> concurrency mode. For both case, I do not see any reason we can not
> defer to scan complete.

I think deferring could be a bit hard for iwl_update_chain_flags, since
according to the comments we need perform commit_rxon in order regarding
other commands sending to the device.

Looking more closely at this:

* iwl_update_chain_flags is called from:

1) iwl_chain_noise_calibration
2) iwlagn_bt_traffic_change_work 
3) iwl_power_update_mode

Ad 1) iwl_chain_noise_calibration:

Called only from iwl_bg_run_time_calib_work, we check STATUS_SCANNING
there.

Ad 2) iwlagn_bt_traffic_change_work 

Queued as work from iwl_rx_scan_complete_notif, since scan_completed
work is queued first we, should not have pending scan, as long as new
scan request do not income in the maintime. Adding STATUS_SCANNING 
check and return is probably what we need to prevent that corner case.

Ad 3) iwl_power_update_mode

Called from many places. In some of them we for sure not perform scanning,
because we do the check or scan cancel before, or this is alive start.
Fixing remaining calls and add WARNING in iwl_power_update_mode in is
what I plan to do.

* iwl_bg_bt_full_concurrency is queued from rs_bt_update_lq. 

I think we can check if scanning is pending and schedule that work for
late time, or set additional bit that we need to change full_concurrency,
and based on that bit do bg_bt_full_concurrency from scan_completed.

Stanislaw
