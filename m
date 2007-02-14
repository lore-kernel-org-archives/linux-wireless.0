Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.229]:39631 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbXBNCrk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 21:47:40 -0500
Received: by wr-out-0506.google.com with SMTP id i31so50875wra
        for <linux-wireless@vger.kernel.org>; Tue, 13 Feb 2007 18:47:39 -0800 (PST)
Message-ID: <43e72e890702131847q3306ef05s8ecb2c5f8d3b5676@mail.gmail.com>
Date: Tue, 13 Feb 2007 21:47:39 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "James Ketrenos" <jketreno@linux.intel.com>,
	yorkliu@sourceforge.net
Subject: Re: network manager vs. missing firmware
Cc: "Dan Williams" <dcbw@redhat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <45D25984.7080808@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <1171392106.10344.100.camel@johannes.berg>
	 <1171394598.5329.31.camel@localhost.localdomain>
	 <45D25984.7080808@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/13/07, James Ketrenos <jketreno@linux.intel.com> wrote:
> Dan Williams wrote:
>
> > The simpler, the better I think; but it's complicated.  A sample of
> > current drivers and when they call request_firmware() from a 2.6.19
> > kernel:
> >
> > on dev->open: atmel, prism54, bcm43xx (softmac)
> > on dev->init: ipw2100, ipw2200
>
> request_firmware is also used during mode changes (ie, BSS to IBSS to
> MONITOR)

This is a bit off topic but if that's the case then we should also add
the check for Master mode and if so check to see if the AP firmware is
available and switch to on master mode. We'd then need to incorporate
the ap ipw2200 support on ipw2200

http://sourceforge.net/projects/ipw2200-ap

I wanted to try a patch to send along but I cannot find the relevent
code except the firmware there. Perhaps yorkliu can supply that
though.

> Perhaps solving the larger problem of "the driver knows something is
> horribly wrong, but has no way to tell the user" would be good.
> Firmware not being there is bad.  There are also periodic failures or
> usage conditions that keep things from working.  Right now we might have
> failures due to:
>
>         FIRMWARE missing

We should figure out a way to handle this gracefully and deal with it
in a standard way. See bellow for a suggestion.

>         RF KILL active

Based on previous conversation on this before it seems each laptop has
its own mechanism for handling RF KILL. I am not sure if there is a
way to detect if this button is on in all cases. Can someone confirm?
A suggestion on handling this is provided bellow.

>
> but maybe tomorrow we would have:
>
>         Conflict with other active wifi device / coexistence
>
> or any number of solution specific error codes that the vendor / driver
> writer would be able to articulate in a text string how to resolve.
>
> Perhaps a simple cfg80211 interface for querying the interface status
> and and associated text string (if in an error condition).  Missing
> firmware or RF kill could have standard numbers and the text string
> could be standardized to return just the name of the firmware file expected.
>
> Even if it didn't get standardized across all devices, NM or other
> utilities could provide a standard place for the user to look at the
> error and then google on it.

I think we should be able to standardize at least within wireless
devices. If we put a wrapper to request_firmware() which is specific
to wireless devices, for example, we could then handle the errors
gracefully ourselves without regard for now for the other devices. The
same applies to the RF KILL switch on open()/close() but I am not sure
if we can detect it on/off in all cases.

> Right now, things break and the user can't
> figure out why without looking at the kernel log (which many users don't
> even know exist).

True.

  Luis
