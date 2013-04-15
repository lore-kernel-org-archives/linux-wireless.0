Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab3DOOht (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 10:37:49 -0400
Message-ID: <1366036772.2404.3.camel@dcbw.foobar.com> (sfid-20130415_163753_659716_F0EBFC0E)
Subject: Re: Centrino Ultimate-N 6300 AGN rfkill always Soft blocked
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: schwaahed <schwaahed@gmail.com>, linux-wireless@vger.kernel.org
Date: Mon, 15 Apr 2013 09:39:32 -0500
In-Reply-To: <1366032132.8361.19.camel@jlt4.sipsolutions.net>
References: <CAPutgu8mCmfmsEq0jkqtAN25oUBmCxZLW-kTZrsPKFpCfdJU2A@mail.gmail.com>
	 <1365804259.10342.20.camel@dcbw.foobar.com>
	 (sfid-20130413_000245_000077_30E72639) <1366032132.8361.19.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-15 at 15:22 +0200, Johannes Berg wrote:
> On Fri, 2013-04-12 at 17:04 -0500, Dan Williams wrote:
> > On Thu, 2013-04-11 at 20:03 -0400, schwaahed wrote:
> > > Hello,
> > > 
> > > I have an HP Elitebook 8460w laptop containing a Centrino Ultimate-N
> > > 6300 AGN (linux-3.8.6 iwlwifi module -  firmware version 9.221.4.1
> > > build 25532)
> > 
> > I notice that your 'rfkill list all' dumps below don't contain an entry
> > for hp-wmi.  Is that module loaded on your machine?  It's needed at
> > least for earlier models of the Elitebook, up at least until the xx40
> > series.  Perhaps it needs to be updated for your laptop?  You might ask
> > on the general kernel lists if anyone knows how rfkill is supposed to
> > work for the 8460 and if hp-wmi supports it, or if some other mechanism
> > is used.
> 
> Yeah it seems not loaded, but how then does the soft block affect hard
> block? All very odd, but almost certainly a platform rather than a wifi
> issue. 

On my 2530p and a lot of other laptops, blocking the BIOS
"switch" (either physically or softblock) hardblocks phy0.  I guess the
BIOS twiddles a GPIO that's connected to the mPCI-E module's rfkill
line/GPIO?

Which leads to the problem we've talked about a long time ago; you can't
treat phy0 hardblock as a physical block that cannot be soft-unblocked,
because some other switch might actually control it's state.  We tried
to gray-out the "Enable Wireless" when hardblocked (since logically you
can't soft-unblock something that's hardblocked), but it turns out you
can't do that because unblocking BIOS switches might un-hardblock the
phy0 wifi switch...  (and the kernel doesn't describe these
dependencies, because, well, that's laptop-specific and would never be
up-to-date).

Dan

