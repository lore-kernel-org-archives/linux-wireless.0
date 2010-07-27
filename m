Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63580 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab0G0Rag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 13:30:36 -0400
Received: by pwi5 with SMTP id 5so557124pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 10:30:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=ZbskS-7TA8Mp5SKrRMrxOpNQJLpxnCHoRs-tb@mail.gmail.com>
References: <1276857140.3638.22.camel@jlt3.sipsolutions.net>
	<AANLkTinHXxhwrOmhRxveekG7_C7WeydUdSBL2R7DwOvJ@mail.gmail.com>
	<AANLkTinch-sygnRmB6LKi6xLNYVKY6Ap3YL4_PMNdmKQ@mail.gmail.com>
	<AANLkTik=1LX_12ZskP5vwkSrTVFO9jH6uu8pyByGmLg6@mail.gmail.com>
	<1280226169.19098.12.camel@jlt3.sipsolutions.net> <AANLkTi=ZbskS-7TA8Mp5SKrRMrxOpNQJLpxnCHoRs-tb@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 27 Jul 2010 10:29:18 -0700
Message-ID: <AANLkTikFjgzL1DOfUVS_N_=p5N3r0Qp7VoC5+-9cbb1a@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix sw scan bracketing
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 8:54 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Jul 27, 2010 at 3:22 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2010-07-27 at 02:22 -0700, Luis R. Rodriguez wrote:
>>> To address and review all this I need more time and instead I think
>>> its easier to ask for revert of this patch.
>>
>> I'm OK with a revert, but *ONLY* if at the same time you remove the
>> double-scan-detected message from ath9k and stop claiming it's a
>> mac80211 bug :-)
>
> Deal :)

I just reviewed this and noticed both of these prints are using
KERN_DEBUG, and since the warning will become valid *after* this gets
properly fixed, are you OK with just a revert of your patch?

  Luis
