Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:44648 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaEUUTG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 16:19:06 -0400
Received: by mail-ob0-f169.google.com with SMTP id vb8so2763645obc.14
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2014 13:19:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400702385.4136.18.camel@jlt4.sipsolutions.net>
References: <20140520203657.2C281E0300@pstew.mtv.corp.google.com>
	<20140520223316.EFCF1E0007@pstew.mtv.corp.google.com>
	<1400668890.4136.1.camel@jlt4.sipsolutions.net>
	<CAMcMvsiGJrJFee_nuGC1L8tRuTJLZR3nikU+4F-Zo1mgNeuNjw@mail.gmail.com>
	<1400702385.4136.18.camel@jlt4.sipsolutions.net>
Date: Wed, 21 May 2014 13:19:05 -0700
Message-ID: <CAMcMvsh-zKuNgMSyo73VmsEUkM9YnhVtkg_Vigdter0QarJ6_g@mail.gmail.com> (sfid-20140521_221910_722894_FE1663D5)
Subject: Re: [PATCHv2] nl80211: Provide TDLS link state
From: Paul Stewart <pstew@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 21, 2014 at 12:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2014-05-21 at 09:17 -0700, Paul Stewart wrote:
>
>>  I still think this might be too heavyweight in situations where the
>> firmware handles TDLS links. Think about a system where the firmware
>> is completely responsible for terminating incoming TDLS requests and
>> offers no facility to notify the kernel as the TDLS link (initiated
>> remotely) was established.
>
> Is it really that bad to demand the firmware notify the host? It's not
> like this is a very frequent event, and if querying is supported then
> notification can't be all that much more difficult.

I think firmware vendors are coming to the point of view that they
must minimize host processor wakeups.  They may argue from that
perspective that the firmware should divulge such information only on
request.

> We're not in a great position to demand that upstream, I guess, it
> should be easier for you :-)
>
> If it's really such a big problem, in theory one could support
> get_station() (which gives you a MAC address) and not dump_station(). I
> wouldn't necessarily recommend it, but it does seem possible.
>

Okay.  I suppose I can shelve this until I can ask for firmware
changes to support this pattern.  I'm not sure I'll get it, though,
and I'm doubtful whether that's a tenable path for others.
