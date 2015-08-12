Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:32949 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbbHLVOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2015 17:14:32 -0400
Received: by obbhe7 with SMTP id he7so22850783obb.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2015 14:14:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1439413727.15847.0.camel@sipsolutions.net>
References: <CAF7g2RHhY_aEHF7nr4VdzVrUf+_cdoKxXbUkajQcx_LxpvvFSA@mail.gmail.com>
 <1439413727.15847.0.camel@sipsolutions.net>
From: Kobi Cohen-Arazi <kobi.cohenarazi@gmail.com>
Date: Wed, 12 Aug 2015 14:13:51 -0700
Message-ID: <CAF7g2RGORavCuvoYzese0usNatsie5tjyN_7J_JgFDK9zurzLQ@mail.gmail.com> (sfid-20150812_231435_727835_98B35C11)
Subject: Re: iw coalesce show - disabled at init?
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,


On Wed, Aug 12, 2015 at 2:08 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2015-08-12 at 11:36 -0700, Kobi Cohen-Arazi wrote:
>> Hi,
>>
>> When loading a wifi driver that supports set_coalesce and running "iw
>> show" command:
>> $ iw ... coalesce show
>> It would always show coalesce as disabled.
>> I think the reason for this is that there are no coalesce rules
>> cached
>> in cfg/netlink layers yet. (empty set of rules).
>>
>> Is my understanding correct? if yes, Is this by design?
>> Ideally, at startup, 80211 should query the driver for the current
>> coalesce rules and use it as the initial state.
>>
>
> Typically devices/drivers shouldn't *have* any such rules at startup,
> so the point is moot. If the driver/device you're using behaves
> differently, arguably that's a bug. Marvell?

Nope :) not Marvell.

So what you're saying is that at startup, drivers should have coalesce
_disabled_ (i.e. no rules for coalesce) ?

- Kobi
