Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61427 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab1GROLt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 10:11:49 -0400
Received: by gyh3 with SMTP id 3so1291053gyh.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2011 07:11:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310724023.4164.22.camel@jlt3.sipsolutions.net>
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
 <1310600747-9583-6-git-send-email-thomas@cozybit.com> <20110714062522.GA2534@jm.kir.nu>
 <CAG6hwVN3HED+LZdKN0zpNfjmK9FmBuBWnZ0qe9gYTPPYmCedTg@mail.gmail.com> <1310724023.4164.22.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Mon, 18 Jul 2011 07:11:28 -0700
Message-ID: <CAPjQAd895Ggdf0gK+HhnTMkNPX3mkd9=CqXhxU1whtMJvptZ=Q@mail.gmail.com> (sfid-20110718_161153_236538_BB5638EB)
Subject: Re: [PATCH 5/5] mac80211: mesh beacon includes TIM IE
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 15, 2011 at 3:00 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-07-14 at 13:16 -0700, Thomas Pedersen wrote:
>> On Wed, Jul 13, 2011 at 11:25 PM, Jouni Malinen <j@w1.fi> wrote:
>> > On Wed, Jul 13, 2011 at 04:45:47PM -0700, Thomas Pedersen wrote:
>> >> Even though we don't currently implement PS for mesh points, the
>> >> standard asks us to include a TIM element in beacons. Include an empty
>> >> element for now.
>> >
>> > Is it allowed to not support PS in this type of case? AP does not have
>> > such option..
>> >
>>
>> You're right, it doesn't look like PS support is optional. The
>> standard requires us to respect the PS states of peers. Support for
>> this will require some work, but in the meantime, we can include a TIM
>> element indicating no frames buffered here, as well as a Mesh Awake
>> Window which never expires.
>>
>> Otherwise, until we implement proper PS, might it be better not to
>> include the TIM IE at all?
>
> Or just not pretend to support the latest mesh draft ...
>
> I don't think PS support can be hard. We have all of it in AP mode
> anyway, so you just need to generalise that a bit, maybe refactor like I
> said in my other email, and you should be able to get it up & running
> pretty quickly?

Mesh frame buffering can probably reuse most of the AP mode, yes.  The
difficult part is on the receiving STA as it must track the beacon
transmit times of each mesh peer.  I don't know how/if we can
implement this in a vendor-neutral mac80211ish sort of way.

That said, only buffering seems to be mandatory: "A mesh STA SHALL
have the capability to buffer frames and to perform mesh power mode
tracking" but "A mesh STA MAY use mesh power modes to reduce its power
consumption".

Cheers,

Javier


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
