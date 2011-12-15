Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59929 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab1LOVIa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 16:08:30 -0500
Received: by pbdu13 with SMTP id u13so444867pbd.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 13:08:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323968408.31153.1.camel@jlt3.sipsolutions.net>
References: <CAGXE3d9dCL+tnXg5ero51cxf3T9VPVgv8oKo51Vi_gWd8as9Xw@mail.gmail.com>
	<1323968408.31153.1.camel@jlt3.sipsolutions.net>
Date: Thu, 15 Dec 2011 22:08:29 +0100
Message-ID: <CAGXE3d9UeC4kE_v-GKLQ16fE0tp-POPEt_tJK3+Mh8E=OFkBHw@mail.gmail.com> (sfid-20111215_220833_969806_5368AE79)
Subject: Re: QoS frames in AP mode?
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 15, 2011 at 6:00 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-12-15 at 17:30 +0100, Helmut Schaa wrote:
>> just noticed a problem with QoS frames in AP mode when mac80211
>> relays for example a VOIP frame from STA1 to STA2 the frame will be
>> sent out on AC_BE and not on AC_VO.
>
> Hm. You want (T)DLS ;-)

Would be nice but if the clients don't support it we're out of luck :)

>> Unfortunately we don't have an skb priority between 256 and 263 and
>> we don't have skb->protocol set to ETH_P_IP here since we've just set
>> it to ETH_P_802_3.
>>
>> I tried using eth_type_trans on the frame but that will "pull" the ethernet
>> header and adding an skb_push afterwards seems a little bit ugly to me.
>>
>> Is it possible to just shortcut the classification if the priority is
>> already set?
>> Or should we just add 256 to the priority before sending the frame to
>> dev_queue_xmit?
>>
>> What would be an appropriate fix for this?
>
> The >= 256 is already a shortcut, so just adding 256 seems reasonable?

Haven't tried that yet but I guess this works. However, if a client is
misbehaving and sending low priority frames with a high priority TID
we might want to re-classify the frame before sending to its
destination? Not sure though.

Helmut
