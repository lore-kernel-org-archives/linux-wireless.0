Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35257 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbbHXQMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2015 12:12:44 -0400
Received: by qkbm65 with SMTP id m65so73873668qkb.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2015 09:12:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1440419912.3735.16.camel@sipsolutions.net>
References: <CAOiWkA9iotcGij6wNeCUw+2iSfvWZGH+=vv_R2bwuDp92aXukw@mail.gmail.com>
	<1440143840.2107.2.camel@sipsolutions.net>
	<1440143920.2107.3.camel@sipsolutions.net>
	<CAOiWkA-rNVHiVZo5oSuEOk_o6ioPzfpd0qzw_QsekRSHQ1EeEw@mail.gmail.com>
	<1440419912.3735.16.camel@sipsolutions.net>
Date: Mon, 24 Aug 2015 12:12:43 -0400
Message-ID: <CAOiWkA95hm3LWwNt3EP1-OESjx775BC8YAznwy48XorSERuiew@mail.gmail.com> (sfid-20150824_181247_928422_0DED893E)
Subject: Re: mac80211: When adding a new station, notify driver before adding
 to hash
From: Marty Faltesek <mfaltesek@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, that would address the issue in a simple way. Would this be
applicable to any of the other ops vectors? I will create a patch.

On Mon, Aug 24, 2015 at 8:38 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2015-08-21 at 13:00 -0400, Marty Faltesek wrote:
>> It's not IBSS and the stack is messed up, I guess because of statics.
>> It's probably more likely this manually crafted stack:
>>
>> __queue_work    (fails BUG_ON(!list_empty(&work->entry));) NULL work
>> causes this check fail.
>> queue_work_on   WORK_STRUCT_PENDING_BIT check passes cause NULL work.
>> queue_work
>> ieee80211_queue_work
>> ath10k_sta_rc_update
>> drv_sta_rc_update
>> rate_control_rate_update
>> ieee80211_rx_h_action
>> ieee80211_rx_handlers
>> ieee80211_invoke_rx_handlers
>> ieee80211_prepare_and_rx_handle
>> __ieee80211_rx_handle_packet
>> ieee80211_rx
>
> Ok. Still, I think the best solution would be to check sta->uploaded?
>
> johannes
