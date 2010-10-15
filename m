Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60327 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756013Ab0JOQBK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 12:01:10 -0400
Subject: Re: [PATCH 2/2] iwlwifi: one less commit_rxon while scan
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20101015145129.GA4046@redhat.com>
References: <1286977193-12144-1-git-send-email-sgruszka@redhat.com>
	 <1286977193-12144-2-git-send-email-sgruszka@redhat.com>
	 <20101014084238.GB2286@redhat.com> <1287071679.13051.10.camel@wwguy-ubuntu>
	 <20101015145129.GA4046@redhat.com>
Content-Type: text/plain
Date: Fri, 15 Oct 2010 09:00:19 -0700
Message-Id: <1287158419.13051.26.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Fri, 2010-10-15 at 07:51 -0700, Stanislaw Gruszka wrote:
> Hello
> 
> On Thu, Oct 14, 2010 at 08:54:39AM -0700, Guy, Wey-Yi wrote:
> > > Any comments about iwl_update_chain_flags, iwl_bg_bt_full_concurrency ?
> > > I would like to know how to deal with them, should we deffer commit_rxon
> > > to scan complete, or cancel the scan. Or maybe this is no problem
> > > at all, because in example committing rxon vs scan was problem of
> > > older firmware?
> > > 
> > 
> > iwl_update_chain_flags() is used when PSP mode change,
> > iwl_bg_bt_full_concurrency() is used only for BT coex and in BT full
> > concurrency mode. For both case, I do not see any reason we can not
> > defer to scan complete.
> 
> I think deferring could be a bit hard for iwl_update_chain_flags, since
> according to the comments we need perform commit_rxon in order regarding
> other commands sending to the device.
> 
> Looking more closely at this:
> 
> * iwl_update_chain_flags is called from:
> 
> 1) iwl_chain_noise_calibration
> 2) iwlagn_bt_traffic_change_work 
> 3) iwl_power_update_mode
> 
> Ad 1) iwl_chain_noise_calibration:
> 
> Called only from iwl_bg_run_time_calib_work, we check STATUS_SCANNING
> there.

This should only call once when we first associate, and we check
STATUS_SCANNING, justlike you mention, should be ok

> 
> Ad 2) iwlagn_bt_traffic_change_work 
> 
> Queued as work from iwl_rx_scan_complete_notif, since scan_completed
> work is queued first we, should not have pending scan, as long as new
> scan request do not income in the maintime. Adding STATUS_SCANNING 
> check and return is probably what we need to prevent that corner case.
> 
Agree

> Ad 3) iwl_power_update_mode
> 
> Called from many places. In some of them we for sure not perform scanning,
> because we do the check or scan cancel before, or this is alive start.
> Fixing remaining calls and add WARNING in iwl_power_update_mode in is
> what I plan to do.
> 
> * iwl_bg_bt_full_concurrency is queued from rs_bt_update_lq. 
> 
> I think we can check if scanning is pending and schedule that work for
> late time, or set additional bit that we need to change full_concurrency,
> and based on that bit do bg_bt_full_concurrency from scan_completed.
> 

overall, I agree with your plan, for both iwl_bg_bt_full_concurrency and
iwlagn_bt_traffic_change_work can be delay to scan complete.

Thanks
Wey


