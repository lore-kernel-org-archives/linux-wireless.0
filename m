Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab1BJJvh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 04:51:37 -0500
Date: Thu, 10 Feb 2011 10:50:06 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: "'Larry Finger'" <Larry.Finger@lwfinger.net>,
	"'John W Linville'" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	=?utf-8?B?J+WGr+aYpeeHlSc=?= <amyfcy_feng@realsil.com.cn>,
	=?utf-8?B?J+eGiuWFieWuiSc=?= <guangan_xiong@realsil.com.cn>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI0=?= =?utf-8?Q?=3A?= about Mac80211
 scan issue
Message-ID: <20110210095006.GB2228@redhat.com>
References: <4d4eec04.v8FQZqbn2LYPF8zs%Larry.Finger@lwfinger.net>
 <20110207151209.GG2319@redhat.com>
 <B84A4806C46340989E2A6AD2EB663300@realsil.com.cn>
 <20110209105405.GB5528@redhat.com>
 <B8DE8263FD784AC082CFDB7E9269BAEA@realsil.com.cn>
 <20110210074140.GA2228@redhat.com>
 <39A39FA0AD1A481480DE0BD469AAA79E@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <39A39FA0AD1A481480DE0BD469AAA79E@realsil.com.cn>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 10, 2011 at 03:48:57PM +0800, 李朝明 wrote:
> Yes, that flush can work well, but before drv_flush in
> ieee80211_start_sw_scan have no queue stop actions.
> Below are corresponding code:
> static int ieee80211_start_sw_scan(struct ieee80211_local *local)
> {
> 	/*
> 	 * Hardware/driver doesn't support hw_scan, so use software
> 	 * scanning instead. First send a nullfunc frame with power save
> 	 * bit on so that AP will buffer the frames for us while we are not
> 	 * listening, then send probe requests to each channel and wait for
> 	 * the responses. After all channels are scanned, tune back to the
> 	 * original channel and send a nullfunc frame with power save bit
> 	 * off to trigger the AP to send us all the buffered frames.
> 	 *
> 	 * Note that while local->sw_scanning is true everything else but
> 	 * nullfunc frames and probe requests will be dropped in
> 	 * ieee80211_tx_h_check_assoc().
> 	 */
> 	drv_sw_scan_start(local);
> 
> 	ieee80211_offchannel_stop_beaconing(local);
> 
> 	local->leave_oper_channel_time = 0;
> 	local->next_scan_state = SCAN_DECISION;
> 	local->scan_channel_idx = 0;
> 
> 	drv_flush(local, false);

I looked at wireless-testing tree where code was currently
changed by b23b025fe246f3acc2988eb6d400df34c27cb8ae
"mac80211: Optimize scans on current operating channel."
We stop queues and flush only when leaving operating channel in
ieee80211_scan_state_leave_oper_channel(), what seems to be correct.

Regarding linux-2.6 tree. I think you have right and we have bug
in mac80211, because we do not stop queues before flush in
ieee80211_offchannel_stop_beaconing() when working in STA mode.
Also comment in above function seems to be wrong. 

I'm not sure what to do with that, maybe Johannes will
have some insight?

Anyway, chaoming_li, could you clone current wireless-testing
tree and see how things work there?

