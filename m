Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60647 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184AbbHXMig (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2015 08:38:36 -0400
Message-ID: <1440419912.3735.16.camel@sipsolutions.net> (sfid-20150824_143839_166291_6477A976)
Subject: Re: mac80211: When adding a new station, notify driver before
 adding to hash
From: Johannes Berg <johannes@sipsolutions.net>
To: Marty Faltesek <mfaltesek@google.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 24 Aug 2015 14:38:32 +0200
In-Reply-To: <CAOiWkA-rNVHiVZo5oSuEOk_o6ioPzfpd0qzw_QsekRSHQ1EeEw@mail.gmail.com> (sfid-20150821_190043_990070_A3C0773A)
References: <CAOiWkA9iotcGij6wNeCUw+2iSfvWZGH+=vv_R2bwuDp92aXukw@mail.gmail.com>
	 <1440143840.2107.2.camel@sipsolutions.net>
	 <1440143920.2107.3.camel@sipsolutions.net>
	 <CAOiWkA-rNVHiVZo5oSuEOk_o6ioPzfpd0qzw_QsekRSHQ1EeEw@mail.gmail.com>
	 (sfid-20150821_190043_990070_A3C0773A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-08-21 at 13:00 -0400, Marty Faltesek wrote:
> It's not IBSS and the stack is messed up, I guess because of statics.
> It's probably more likely this manually crafted stack:
> 
> __queue_work    (fails BUG_ON(!list_empty(&work->entry));) NULL work
> causes this check fail.
> queue_work_on   WORK_STRUCT_PENDING_BIT check passes cause NULL work.
> queue_work
> ieee80211_queue_work
> ath10k_sta_rc_update
> drv_sta_rc_update
> rate_control_rate_update
> ieee80211_rx_h_action
> ieee80211_rx_handlers
> ieee80211_invoke_rx_handlers
> ieee80211_prepare_and_rx_handle
> __ieee80211_rx_handle_packet
> ieee80211_rx

Ok. Still, I think the best solution would be to check sta->uploaded?

johannes
