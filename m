Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38258 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaBENw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 08:52:56 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] mac80211: move VHT related RX_FLAG to another variable
References: <1391597333-6398-1-git-send-email-emmanuel.grumbach@intel.com>
	<1391597333-6398-2-git-send-email-emmanuel.grumbach@intel.com>
	<8738jxllqy.fsf@kamboji.qca.qualcomm.com>
	<CANUX_P2Z+FTZz83D5HR7w9z3F3=nhP8p_4wRb-5XBe0kv1vu2A@mail.gmail.com>
Date: Wed, 5 Feb 2014 15:52:50 +0200
In-Reply-To: <CANUX_P2Z+FTZz83D5HR7w9z3F3=nhP8p_4wRb-5XBe0kv1vu2A@mail.gmail.com>
	(Emmanuel Grumbach's message of "Wed, 5 Feb 2014 15:49:11 +0200")
Message-ID: <87y51pk6od.fsf@kamboji.qca.qualcomm.com> (sfid-20140205_145259_630532_B206BE84)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <egrumbach@gmail.com> writes:

> On Wed, Feb 5, 2014 at 3:41 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:
>>
>>> ieee80211_rx_status.flags is full. Define a new vht_flag
>>> variable to be able to set more VHT related flags and make
>>> room in flags.
>>>
>>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>>
>> [...]
>>
>>> @@ -866,9 +863,6 @@ enum mac80211_rx_flags {
>>>       RX_FLAG_AMPDU_DELIM_CRC_KNOWN   = BIT(20),
>>>       RX_FLAG_MACTIME_END             = BIT(21),
>>>       RX_FLAG_VHT                     = BIT(22),
>>> -     RX_FLAG_80MHZ                   = BIT(23),
>>> -     RX_FLAG_80P80MHZ                = BIT(24),
>>> -     RX_FLAG_160MHZ                  = BIT(25),
>>
>> Doesn't this break ath10k?
>
> yep it does... It seems that I need to run with a few more drivers enabled :)

For changes like this allmodconfig is your best friend ;)

-- 
Kalle Valo
