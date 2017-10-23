Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60406 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdJWU7E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Oct 2017 16:59:04 -0400
Subject: Re: A good way to get CSI info to user-space?
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <6f9182c4-cff9-066c-173a-00d09af7c903@candelatech.com>
 <1508790635.2639.24.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <76d6a1ad-2dc4-0542-808f-4be459c3508a@candelatech.com> (sfid-20171023_225931_900811_EBCCB811)
Date: Mon, 23 Oct 2017 13:59:01 -0700
MIME-Version: 1.0
In-Reply-To: <1508790635.2639.24.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/23/2017 01:30 PM, Johannes Berg wrote:
> Hi,
>
>> I have been poking at ath10k to get some CSI reporting working.
>> The CSI reports are a bit over 2k bytes in length, and they could
>> happen quite often.  As far as I can tell, there is no good way in
>> the kernel to make this available.
>>
>> I was thinking maybe a callback into the mac80211 stack, which would
>> then send a netlink event might be a useful way to implement this?
>
> The CSI data has variable length [1] but it's fundamentally always tied
> to a specific frame and as such we've always attached it to that frame
> using a radiotap vendor namespace.
>
> You can easily implement that in a mac80211 driver since it has support
> for that via RX_FLAG_RADIOTAP_VENDOR_DATA and the associated struct
> ieee80211_vendor_radiotap that you put into the skb's head.
>
> Why should anything else be needed?

So this would only show up in user-space in something like a pkt-capture?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
