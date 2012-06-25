Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:44203 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab2FYJAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 05:00:31 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: iwlwifi: "GF was set with SGI:SISO"
References: <87lijfjkjk.fsf@nemi.mork.no>
	<1340613038.4589.10.camel@jlt3.sipsolutions.net>
Date: Mon, 25 Jun 2012 10:59:54 +0200
In-Reply-To: <1340613038.4589.10.camel@jlt3.sipsolutions.net> (Johannes Berg's
	message of "Mon, 25 Jun 2012 10:30:38 +0200")
Message-ID: <878vfbhilx.fsf@nemi.mork.no> (sfid-20120625_110036_585744_2CB50E08)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> There's nothing you can do about it, I'll just downgrade it -- see patch
> below, also for an explanation.

Thanks.  That looks like the only sensible solution.  I did some commit
digging, and it seems this log message was introduced out of the blue
with no explanation during code refactoring.

>> This is the first time I notice this issue, so I don't think it's very
>> reproducible.
>
> Too bad, I would've been interested in a command trace when this
> happens, but it would have to be a fairly long-running trace before the
> error message happens.
>
> Were you in some special place when this happened?

No it was at home, and it's been a few months since the access points
there were changed in any way (hardware, firmware, config). 

> It has to be an 11n
> AP that is greenfield capable, with no 11a/b/g stations connected to it.

That sounds likely at the time this happened. The access points are two
Netgear WNDR4500 routers if that matters.  I.e. Linux 2.6.22 with
Broadcoms proprietary closed source drivers. 

> Maybe some 11g client disconnected from the AP and then the messages
> started showing up?

Could very well be.  The 11g client would probably be my phone then.  It
tends to do connects/disconnects on its own, so it sounds likely that it
could just have disconnected when the log messages started appearing.

> [PATCH] iwlwifi: turn down "GF was set with SGI:SISO" message

I don't think I can test this in any other way than building it, as I am
unable to trigger the problem again.  It went away on the first
disconnect/reconnect (while suspending the laptop) and I have not seen
the messages again.

But the solution look sane to me FWIW.


Bjørn
