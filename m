Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:44345 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaCXGhe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 02:37:34 -0400
Received: by mail-ob0-f178.google.com with SMTP id wp18so5220487obc.37
        for <linux-wireless@vger.kernel.org>; Sun, 23 Mar 2014 23:37:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395414428.4164.16.camel@jlt4.sipsolutions.net>
References: <1395410520-26939-1-git-send-email-michal.kazior@tieto.com>
	<1395411440.4164.15.camel@jlt4.sipsolutions.net>
	<CA+BoTQk5RiFPjDGMSwFHd6GGt=x9M6QXGZcdENtMjQrDcORicg@mail.gmail.com>
	<1395414428.4164.16.camel@jlt4.sipsolutions.net>
Date: Mon, 24 Mar 2014 07:37:33 +0100
Message-ID: <CA+BoTQ=zZo-f=w3KaWPC6TJ6TmoW+XOBHNwyYCSkbc1cnedihQ@mail.gmail.com> (sfid-20140324_073737_822173_2E8BEE3C)
Subject: Re: [PATCH] ath10k: dont call csa_finish more than once
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 March 2014 16:07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-03-21 at 15:58 +0100, Michal Kazior wrote:
>
>> > Didn't we have this discussion on the hwsim patch before?
>>
>> Oh. I'm not aware of the discussion. Probably missed it.
>
> Or I got it wrong :)
>
>> > I'd argue that if all drivers must track this, then the mac80211 API is
>> > defective.
>>
>> I can make this a mac80211 patch then?
>
> Yeah I guess. What was the reason for this though? Here it's multi-vif?
> Before I think we were talking about races?

Before multi-vif if ieee80211_csa_finalize() failed and left
csa_active==true driver could end up poking the csa_finalize_work()
over and over again I guess?

For multi-vif csa using reservation there are 2 reasons:
 a) channel switches across interfaces may not be tightly
synchronized. I did tests where 2 long (cs_count=100) channel switches
were a few seconds apart. In that case driver poked csa_finalize work
quite a lot resulting in a mess.
 b) my current approach has the following flow:

1. reserve_chanctx()
2. (some time later) driver calls csa_finish, and csa_finalize calls
use_reserved_chanctx() because reserved_chanctx is set
3. (possibly some time later, for multi-vif reservations) csa_finalize
is called again but this time without reserved_chanctx, so it verifies
if bss_conf.chandef is csa_chandef (after successful reservation it
should be).

This means if driver would poke csa_finalize() more than once then
use_reserved_chanctx() would be called again and again as a result.


Michał
