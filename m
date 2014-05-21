Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41802 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbaEUUAA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 16:00:00 -0400
Message-ID: <1400702385.4136.18.camel@jlt4.sipsolutions.net> (sfid-20140521_220005_011580_C99D0E7B)
Subject: Re: [PATCHv2] nl80211: Provide TDLS link state
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Wed, 21 May 2014 21:59:45 +0200
In-Reply-To: <CAMcMvsiGJrJFee_nuGC1L8tRuTJLZR3nikU+4F-Zo1mgNeuNjw@mail.gmail.com> (sfid-20140521_181740_112931_AC558836)
References: <20140520203657.2C281E0300@pstew.mtv.corp.google.com>
	 <20140520223316.EFCF1E0007@pstew.mtv.corp.google.com>
	 <1400668890.4136.1.camel@jlt4.sipsolutions.net>
	 <CAMcMvsiGJrJFee_nuGC1L8tRuTJLZR3nikU+4F-Zo1mgNeuNjw@mail.gmail.com>
	 (sfid-20140521_181740_112931_AC558836)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-21 at 09:17 -0700, Paul Stewart wrote:

>  I still think this might be too heavyweight in situations where the
> firmware handles TDLS links. Think about a system where the firmware
> is completely responsible for terminating incoming TDLS requests and
> offers no facility to notify the kernel as the TDLS link (initiated
> remotely) was established.

Is it really that bad to demand the firmware notify the host? It's not
like this is a very frequent event, and if querying is supported then
notification can't be all that much more difficult.

We're not in a great position to demand that upstream, I guess, it
should be easier for you :-)

If it's really such a big problem, in theory one could support
get_station() (which gives you a MAC address) and not dump_station(). I
wouldn't necessarily recommend it, but it does seem possible.


> Unless the driver polls the firmware for
> ALL MAC addresses, there's no way for a station entry to magically
> appear.  I wan this method so we can directly ask the firmware "hey,
> is there a TDLS link to 02:00:00:00:01:00?"  This pre-supposes that
> user-space has some knowledge about this remote host (suppose we're
> streaming media to it) and we want to know whether in this case, for
> diagnostic reasons, whether TDLS was established between them at this
> time.

But then the next diagnostic thing will be ... oh, let's see what
 * the signal quality is
 * bitrate is used
 * etc.

all of which is covered by station information (and can optionally be
made available for the station entry.) Right now you're only asking "is
there a link" but I see no reason that (in particular for
diagnostics/debug!) you wouldn't want more :-)

johannes

