Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:25134 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657AbZEIBYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 21:24:10 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1394673rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 08 May 2009 18:24:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1241831891.4903.80.camel@localhost.localdomain>
References: <1241677107.2918.4.camel@localhost.localdomain>
	<1241696104.27208.2.camel@johannes.local> <1241704437.4903.15.camel@localhost.localdomain>
	<1241705979.27208.31.camel@johannes.local> <1241827331.4903.75.camel@localhost.localdomain>
	<43e72e890905081813r58888509je62856008cc62d22@mail.gmail.com>
	<1241831891.4903.80.camel@localhost.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 8 May 2009 18:23:52 -0700
Message-ID: <43e72e890905081823w2087e84aq3294ae1461e75b38@mail.gmail.com>
Subject: Re: Warning when terminating wpa_supplicant (wext driver)
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 8, 2009 at 6:18 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Johannes,
>
>> >> > > Copying Wey-Yi, but I think she's aware of this? It's definitely a
>> >> > > driver issue. I _suspect_, but am not sure, that the driver kills the
>> >> > > aggregation session when we disassoc or something and we only tell it
>> >> > > about the STA removal after that, when it already killed the STA. Thus
>> >> > > it would be a consequence of iwlwifi not implementing a proper
>> >> > > sta_notify() callback.
>> >> >
>> >> > I don't see it with nl80211 driver, but that might be pure luck.
>> >>
>> >> Hmm, ok, that points to something else maybe... Now I wish I had my
>> >> ftrace-mac80211 patch ready. Well, the patch is almost ready but we
>> >> can't use ftrace in modules yet...
>> >>
>> >> Maybe there's some timing issue. I still think it's iwlwifi getting
>> >> confused about what mac80211 is telling it as described, but it seems
>> >> it's a little more subtle than what I said.
>> >
>> > something similar now happened during normal operation:
>>
>> Just curious, have you applied johill's latest idle fix patch? I've
>> been running iperf overnight with it and my woes are gone. I tested RX
>> though, I'm leaving TX running now but haven't yet seen any warn.
>
> this is still running wireless-testing.git from yesterday with the debug
> addBA patch from Johannes.

Ok yeah wl from yesterday didn't have johill's patch applied yet.

>From the looks of it the intel hardware doesn't want to stop the
aggregation session which is API-breakage -- which is why you get the
WARN_ON. This is happening when you are disassociating. I have a
feeling johill's other patch will fix your issue but regardless I
believe this just highlights more we should flush our queues (both RX
and TX) before scanning.

  Luis
