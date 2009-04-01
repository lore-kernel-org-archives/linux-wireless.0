Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:40831 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765065AbZDAO3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 10:29:05 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Kalle Valo <kalle.valo@iki.fi>,
	Johannes Berg <johannes@sipsolutions.net>
CC: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
Date: Wed, 1 Apr 2009 07:29:01 -0700
Subject: RE: more thoughts on power saving (was: wireless powersaving (in
 NM?))
Message-ID: <E9954878DD1FB34FAE5187FB88C58A3546FDD123@orsmsx506.amr.corp.intel.com> (sfid-20090401_162909_624541_23BD8722)
References: <1237891149.4320.73.camel@johannes.local>
	<1238583879.5970.195.camel@johannes.local> <87zlf0hbk4.fsf@litku.valot.fi>
In-Reply-To: <87zlf0hbk4.fsf@litku.valot.fi>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If I understand correctly, based on implementation, if VoIP support silence detection (which most of the codec support it), it will not constantly sending packets; that might be the reason for bad quality.

Wey-Yi Guy
Intel Corporation
2111 N.E. 25th Avenue  M/S JF3-308                 
Hillsboro OR 97124-5961
USA
Work Phone: 503-264-6023 (OR)
Cell Phone: 503-329-8410
Email: wey-yi.w.guy@intel.com
 

-----Original Message-----
From: Kalle Valo [mailto:kalle.valo@gmail.com] On Behalf Of Kalle Valo
Sent: Wednesday, April 01, 2009 4:13 AM
To: Johannes Berg
Cc: Dan Williams; Guy, Wey-Yi W; linux-wireless; Matthew Garrett; Marcel Holtmann
Subject: Re: more thoughts on power saving (was: wireless powersaving (in NM?))

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
