Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:43048 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752068AbeAQIhK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 03:37:10 -0500
Received: by mail-qk0-f179.google.com with SMTP id a5so21457381qkg.10
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jan 2018 00:37:09 -0800 (PST)
Subject: Re: [PATCH v2 05/10] rtlwifi: enable mac80211 fast-tx support
To: Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>, pkshih@realtek.com
References: <20180111070932.9929-1-pkshih@realtek.com>
 <20180111070932.9929-6-pkshih@realtek.com> <871sip24fc.fsf@purkki.adurom.net>
 <5A5E5C99.5020607@broadcom.com> <1516141444.410.52.camel@sipsolutions.net>
Cc: Larry.Finger@lwfinger.net, yhchuang@realtek.com,
        linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A5F0B32.4090006@broadcom.com> (sfid-20180117_093726_108305_AB7DA3F5)
Date: Wed, 17 Jan 2018 09:37:06 +0100
MIME-Version: 1.0
In-Reply-To: <1516141444.410.52.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/16/2018 11:24 PM, Johannes Berg wrote:
> On Tue, 2018-01-16 at 21:12 +0100, Arend van Spriel wrote:
>>
>> When I saw this flying by I had the same feeling. This is clearly not
>> how it was intended although you could interpret the comments of the
>> .set_frag_threshold() callback and IEEE80211_HW_SUPPORTS_TX_FRAG.
>> However, the fragmentation threshold is a user-configurable stack
>> parameter as per the standard. This patch effectively kill that option
>> for the user although there may be RF conditions in which fragmentation
>> can help. Having the user configure a fragmentation threshold of 2346
>> also disables fragmentation and allows mac80211 to use cached fastpath.
>>
>
>          /* fast-xmit doesn't handle fragmentation at all */
>          if (local->hw.wiphy->frag_threshold != (u32)-1 &&
>              !ieee80211_hw_check(&local->hw, SUPPORTS_TX_FRAG))
>                  goto out;
>
> so internally at least it has to be -1, does 2346 really do that?
> remember, but it might well :-)

I am getting old. In my recollection the fragmentation threshold would 
be set to maximum MPDU size, which I believed to be 2346. Not sure if 
that still is true today. To be sure taken a look in the 2016 spec:

"""
dot11FragmentationThreshold OBJECT-TYPE
SYNTAX Unsigned32 (256..65535)
UNITS "octets"
MAX-ACCESS read-write
STATUS current
DESCRIPTION
"This is a control variable.
It is written by an external management entity.
Changes take effect as soon as practical in the implementation.
This attribute specifies the maximum size of an individually addressed
MPDU beyond which the corresponding MSDU or MMPDU is fragmented, except
when an MSDU is transmitted under an HT-immediate or HT-delayed block ack
agreement, or when an MSDU is carried in an A-MSDU, or when an MSDU or
MMPDU is carried in an A-MPDU that does not contain a VHT single MPDU.
Fields added to the MPDU by security encapsulation are not counted against
the limit specified by this attribute. An MSDU or MMPDU might be
fragmented even if it is smaller."
DEFVAL { 65535 }
::= { dot11OperationEntry 5 }
"""

Anyway, the fact remains that we should leave it up to the user to 
control the value.

Regards,
Arend
