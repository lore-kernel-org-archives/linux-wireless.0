Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49933 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab3DOPbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 11:31:39 -0400
Message-ID: <1366039892.8361.29.camel@jlt4.sipsolutions.net> (sfid-20130415_173143_983740_76981102)
Subject: Re: Centrino Ultimate-N 6300 AGN rfkill always Soft blocked
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: schwaahed <schwaahed@gmail.com>, linux-wireless@vger.kernel.org
Date: Mon, 15 Apr 2013 17:31:32 +0200
In-Reply-To: <1366036772.2404.3.camel@dcbw.foobar.com>
References: <CAPutgu8mCmfmsEq0jkqtAN25oUBmCxZLW-kTZrsPKFpCfdJU2A@mail.gmail.com>
	 <1365804259.10342.20.camel@dcbw.foobar.com>
	 (sfid-20130413_000245_000077_30E72639) <1366032132.8361.19.camel@jlt4.sipsolutions.net>
	 <1366036772.2404.3.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-15 at 09:39 -0500, Dan Williams wrote:

> > Yeah it seems not loaded, but how then does the soft block affect hard
> > block? All very odd, but almost certainly a platform rather than a wifi
> > issue. 
> 
> On my 2530p and a lot of other laptops, blocking the BIOS
> "switch" (either physically or softblock) hardblocks phy0.  I guess the
> BIOS twiddles a GPIO that's connected to the mPCI-E module's rfkill
> line/GPIO?

Yes, that seems to be the case. Something does, anyway, as the GPIO
state is pretty much directly reflected in the hard kill of the "phy0"
device.

> Which leads to the problem we've talked about a long time ago; you can't
> treat phy0 hardblock as a physical block that cannot be soft-unblocked,
> because some other switch might actually control it's state.  We tried
> to gray-out the "Enable Wireless" when hardblocked (since logically you
> can't soft-unblock something that's hardblocked), but it turns out you
> can't do that because unblocking BIOS switches might un-hardblock the
> phy0 wifi switch...  (and the kernel doesn't describe these
> dependencies, because, well, that's laptop-specific and would never be
> up-to-date).

Yeah ... best thing you could do is assume that if a bios rfkill exists
it controls the phy0 hard kill and in case it doesn't enable when you
unblock the bios device you pop up a message saying to switch the
physical button?

johannes

