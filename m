Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47167 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1LSQgx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 11:36:53 -0500
Received: by pbdu13 with SMTP id u13so1932611pbd.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 08:36:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324310130.3414.3.camel@jlt3.sipsolutions.net>
References: <1324288978-27162-1-git-send-email-helmut.schaa@googlemail.com>
	<1324310130.3414.3.camel@jlt3.sipsolutions.net>
Date: Mon, 19 Dec 2011 17:36:53 +0100
Message-ID: <CAGXE3d_dH1jeSVrmANd_OARqwY_NUkKu3He6Y7mP8atzas88pA@mail.gmail.com> (sfid-20111219_173657_653934_D67F1458)
Subject: Re: [PATCH] mac80211: Fix frame classification in AP mode for relayed frames
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 19, 2011 at 4:55 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-12-19 at 11:02 +0100, Helmut Schaa wrote:
>> When mac80211 relays a frame from STA1 to STA2 in AP mode it will get
>> re-classified in the tx path. Unfortunately the frame protocol field
>> is always set to ETH_P_8023 while the classification only kicks in
>> for ETH_P_IP. Hence, a high priority frame from STA1 will be send to
>> STA2 as best effort.
>>
>> To allow proper re-classification of received frames, set the
>> skb->protocol field to the correct value without using eth_type_trans
>> as that would pull of the ethernet header. Also, set the network
>> header position correctly as otherwise the classification code won't
>> find the IP header.
>>
>> This means that every frame relayed by a mac80211 AP will be
>> re-classified and might change its traffic class when the associated
>> STA and mac80211 use different 802.1d <-> TID mappings.
>>
>> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>> ---
>>
>> We could also reuse the TID used by the source STA but I guess we should
>> always classify frames according to our own mapping instead of relying
>> on the associated STAs to do the right thing.
>
> Not sure that's useful, since we classify almost nothing anyway.

Currently we only use the IPv4 DSCP field for assigning TIDs to
frames. That seems to be sufficient for VOIP traffic at least.

> If this was somehow hooked up to tc or iptables that would be
> more useful I guess?

Agreed. This would make sense in the future but I don't feel like
implementing this right now.

So, you'd prefer to just copy over the TID as used by the source
STA (via the priority+256 hack maybe)?

Helmut
