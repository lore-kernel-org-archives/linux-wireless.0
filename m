Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47450 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751299AbdJXNgU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Oct 2017 09:36:20 -0400
Subject: Re: A good way to get CSI info to user-space?
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <6f9182c4-cff9-066c-173a-00d09af7c903@candelatech.com>
 <1508790635.2639.24.camel@sipsolutions.net>
 <76d6a1ad-2dc4-0542-808f-4be459c3508a@candelatech.com>
 <1508824462.2639.25.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <d1746cd6-d889-a253-3638-8011d1ebd4fb@candelatech.com> (sfid-20171024_153627_647605_27805FE4)
Date: Tue, 24 Oct 2017 06:36:12 -0700
MIME-Version: 1.0
In-Reply-To: <1508824462.2639.25.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/23/2017 10:54 PM, Johannes Berg wrote:
> On Mon, 2017-10-23 at 13:59 -0700, Ben Greear wrote:
>
>>> The CSI data has variable length [1] but it's fundamentally always tied
>>> to a specific frame and as such we've always attached it to that frame
>>> using a radiotap vendor namespace.
>>>
>>> You can easily implement that in a mac80211 driver since it has support
>>> for that via RX_FLAG_RADIOTAP_VENDOR_DATA and the associated struct
>>> ieee80211_vendor_radiotap that you put into the skb's head.
>>>
>>> Why should anything else be needed?
>>
>> So this would only show up in user-space in something like a pkt-capture?
>
> Sure. But since you can easily add virtual monitor interfaces at any
> time, that doesn't really mean anything.

Adding a monitor device is a pretty big hammer on ath10k, at least, and
probably not something one would want running continuously in a production
environment.

The CSI data is one part, but tx-beamforming is another area of interest.

If I get a chance, I'll try to add a way to pass some of this opaque
info up through netlink events.  I'm thinking something like:

mac80211_nl_send_opaque_event(mac80211-handle, int data-type, u8* data, int data_len);

data-type would be:
NLD_ATH_CSI_DATA = 0,
NLD_ATH_TXBF_DATA = 1,
NLD_PRIVATE_START = 5000,
....


'iw events' could be made to dump raw hex for external programs to decode, or maybe
decode it a bit itself in some cases.  And, third-party programs can open a netlink
monitor socket and get the data directly.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
