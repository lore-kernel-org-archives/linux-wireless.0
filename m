Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59692 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbZDALNE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 07:13:04 -0400
Received: by fxm2 with SMTP id 2so2883224fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 01 Apr 2009 04:13:01 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	"Guy\, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
Subject: Re: more thoughts on power saving (was: wireless powersaving (in NM?))
References: <1237891149.4320.73.camel@johannes.local>
	<1238583879.5970.195.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 01 Apr 2009 14:12:59 +0300
In-Reply-To: <1238583879.5970.195.camel@johannes.local> (Johannes Berg's message of "Wed\, 01 Apr 2009 13\:04\:39 +0200")
Message-ID: <87zlf0hbk4.fsf@litku.valot.fi> (sfid-20090401_131311_409871_F4810B81)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Hi,
>
> So I had a few more thoughts.
>
> Let me start with a story :)
>
>         I use my N810 device for landline calls via SIP these days.
>         Every time I'm in a call, audio is very choppy and I can barely
>         understand the person I'm talking to -- my fix is to "ping -i
>         0.05" the device to disable its powersaving...
>
>
> Now, why is audio choppy? I was blaming it on the wireless powersaving,
> and disabling that clearly fixes it. But is the problem really just
> there? I think it might also be the application -- its playback buffer
> is smaller than the networking latency I am experiencing due to
> wireless. I think I could probably tolerate an additional audio latency
> of 150ms (my beacon interval being 102.4ms) or so, if audio wasn't
> choppy.

What's the DTIM count in your AP? N810 wakes up only for DTIM beacons,
that might increase the latency.

> That means the application (telepathy sofiasip I guess) would have
> to have 150ms or so playback buffer to make the playback smooth with
> delay. [1]

[...]

> [1] I don't quite see why this doesn't happen automatically, it seems it
> must discard packets that don't fit into its idea of the stream timing

N810 only disables the power save when there's a frame to transmit. I
guess the SIP connection isn't constantly sending anything and that's
why you get bad quality.

-- 
Kalle Valo
