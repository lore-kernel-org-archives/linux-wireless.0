Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51089 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1AZGjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 01:39:08 -0500
Received: by gyb11 with SMTP id 11so16635gyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 22:39:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295952127.3650.12.camel@jlt3.sipsolutions.net>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
 <1295869283.3639.7.camel@jlt3.sipsolutions.net> <AANLkTi=cSdi_i=RBtcp_aLG92S3xdMvJEMSfVdqX=qAK@mail.gmail.com>
 <1295950241.3650.3.camel@jlt3.sipsolutions.net> <1295952127.3650.12.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 26 Jan 2011 08:38:52 +0200
Message-ID: <AANLkTikF3Ru_25Tzcntrma3_spgURV-pfTr=t8RHereK@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Probe-resp offloading support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 25, 2011 at 12:42, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2011-01-25 at 11:10 +0100, Johannes Berg wrote:
>> On Mon, 2011-01-24 at 23:21 +0200, Arik Nemtsov wrote:
>>
>> > Well a wiphy flag won't do here. Probe requests may be filtered in
>> > some modes (AP-mode) but needed in others (p2p?).
>> > I think flexibility is a nice added bonus here. A FW can decide to
>> > handle most standard probe-requests and simply not pass them up.
>> > Others ("complicated" ones) it can pass up to hostapd and expect it to reply.
>> >
>> > The current patches leave this policy in the hands of the driver/fw.
>>
>> That is _very_ dangerous. If the user has older firmware that doesn't
>> know about WSC2, how would the user know not to configure WSC2 in
>> hostapd? That needs to be known to hostapd so it can verify this
>> situation. For P2P, we already know whether or not P2P is supported, but
>> that's rather vague in case there will ever be a revision of the P2P
>> spec with say different IEs.
>>
>> Additionally, a "regular AP" (not P2P, not WSC) would still want to
>> reply to probe requests from WSC/P2P devices with the normal template.
>>
>> IMHO it would be smarter to rework the firmware to only reply to probe
>> requests if the probe response is configured. Then, if WSC, P2P, or
>> similar technologies are in use on the interface, hostapd can simply
>> decide to not configure the probe response and have host-based
>> processing. Would that be a change you could still make?
>
>
> Of course, firmware can reply to non-p2p/non-wsc2 probe requests with a
> static probe response template.
>
> The question is how much knowledge you want to put into the firmware
> about those protocols. If you want to put all knowledge in there, then
> at least you need to indicate to hostapd which protocols the firmware
> knows not to reply to.
>
> Also, a way to turn off this behaviour would still be good for future
> protocol changes. If P2P changes in 3 years, I'm sure this firmware
> won't be updated to match since you'll be a few hardware generations
> ahead. Then, being able to turn off the offload completely would allow
> users to take advantage of new protocols without changing hardware. Of
> course, you may want to force users to buy new hardware that way -- but
> in that case we *still* need the advertisement of what's possible so
> users know right away that they need to buy new hardware and don't try
> to configure something that just fails in strange ways.
>

Like I said in a previous email - I think a white list (or black list)
of IEs in FW is the way to go here. Not all probe-responses should be
offloaded.

Its also conceivable that an old driver/fw won't work when some
protocol is changed/updated, even if hostapd supports it.
I'm not sure the probe-resp will be the culprit here..

Arik
