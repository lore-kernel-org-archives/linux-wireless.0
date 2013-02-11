Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:49308 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab3BKVsi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 16:48:38 -0500
Received: by mail-ob0-f179.google.com with SMTP id un3so6547012obb.38
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 13:48:37 -0800 (PST)
Message-ID: <51196734.6050507@lwfinger.net> (sfid-20130211_224842_224705_77C248E9)
Date: Mon, 11 Feb 2013 15:48:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Catalin Iacob <iacobcatalin@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Initialize rate_init member of struct rate_control_ops
References: <1360617485-6194-1-git-send-email-iacobcatalin@gmail.com>  <511964AB.6080701@lwfinger.net> (sfid-20130211_223751_227537_E9EE373A) <1360618939.8738.50.camel@jlt4.sipsolutions.net>
In-Reply-To: <1360618939.8738.50.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/11/2013 03:42 PM, Johannes Berg wrote:
> On Mon, 2013-02-11 at 15:37 -0600, Larry Finger wrote:
>
>>> +	.rate_init = rtl_rate_init,
>>>    	.tx_status = rtl_tx_status,
>>>    	.get_rate = rtl_get_rate,
>>>    };
>>
>> Shouldn't rate_control_rate_init() in net/mac80211/rate.h be changed to protect
>> against the oops? I don't see any value in the client driver having to provide a
>> dummy routine. The rtlwifi family of drivers use their own rate-control
>> mechanism, and get no rate-control info from mac80211.
>
> In this case, I see no value in them providing rate control operations
> at all, and they could just set IEEE80211_HW_HAS_RATE_CONTROL, no?

I think that makes sense.

Larry


