Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757699AbcHCSNq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 14:13:46 -0400
Date: Wed, 3 Aug 2016 19:37:05 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	Daniel Wagner <daniel.wagner@bmw-carit.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeff Mahoney <jeffm@suse.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Daniel Wagner <wagi@monom.org>,
	Bastien Nocera <hadess@hadess.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	David Howells <dhowells@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Julia Lawall <julia.lawall@lip6.fr>,
	linux-input@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of
 completion
Message-ID: <20160803173705.GQ3296@wotan.suse.de> (sfid-20160803_201437_088992_24FE0851)
References: <C528E404-0CA5-46B4-B551-B1D4B58BC053@gmail.com>
 <37a3cd66-262e-ffbe-ea7a-a6d5b1ca1c8b@bmw-carit.de>
 <20160801194408.GZ3296@wotan.suse.de>
 <0f9350fa-e8b5-9d64-b2d3-afda5e5f6bbf@bmw-carit.de>
 <20160802063419.GG3296@wotan.suse.de>
 <2713d779-ef55-793d-f37e-d1414bb1bfc2@bmw-carit.de>
 <20160802074106.GI3296@wotan.suse.de>
 <ef14dc68-d2f8-0934-7be5-dfb3a4771f27@bmw-carit.de>
 <20160803155540.GL3296@wotan.suse.de>
 <20160803161821.GB32965@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160803161821.GB32965@dtor-ws>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 03, 2016 at 09:18:21AM -0700, Dmitry Torokhov wrote:
> On Wed, Aug 03, 2016 at 05:55:40PM +0200, Luis R. Rodriguez wrote:
> > 
> > I accept all help and would be glad to make enhancements instead of
> > the old API through new API. The biggest thing here first I think is
> > adding devm support, that I think should address what seemed to be
> > the need to add more code for a transformation into the API. I'd
> 
> I am confused. Why do we need devm support, given that devm is only
> valid in probe() paths[*] and we do know that we do not want to load
> firmware in probe() paths because it may cause blocking?

Its a good point, I hadn't gone on to implement devm support on the sysdata API
yet here so this requirement was not known to me. This certainly would put a
limitation to the idea of using devm then to deal with the firmware for you,
given that not all users of firmware are on probe, and as you note we want to
by default avoid firmware calls on probe since init+probe are called serially
by default unless a driver is using the new async probe. Nevertheless, even if
we had userspace or the driver always asking for async probe, most users of the
firmware API are not on probe anyway, so the gains of using devm to help with
freeing the firmware for the driver on probe would be very limited.

With that in mind, in retrospect then the current sysdata approach to require a
callback for synchronous calls would seem to work around this issue and
generalize a solution given we'd have:

For the sync case:

const struct sysdata_file_desc sysdata_desc = {
	SYSDATA_DEFAULT_SYNC(driver_sync_req_cb, dev),
	.keep = false, /* not explicitly needed as default is false */
};
ret = sysdata_file_request();
...

Behind the scenes firmware_class would call driver_sync_req_cb(),
since that's where we know the firmware will be consumed and since
the driver has explicitly asked that it no longer needs to keep the
firmware around (keep == false), it will free it on behalf of the
driver.

Since current synchronous calls for firmware do not have a callback
this would mean a driver changing to the sysdata API if it wanted
to take advantage of this feature of letting firmware_class free
the firmware for you, you'd need a bit more code than before.

For the asynchronous case this is a bit different given that the
current async firmware API requires a callback, so if keep == false
on the async sysdata API we just remove the release_firmware()
calls when converting over.

Given this, other than the bikeshedding aspects [0] ("sysdata", "driver data",
"firmware), perhaps the sysdata API is done then.

[0] http://phk.freebsd.dk/sagas/bikeshed.html

> [*] Yes, I know there are calls to devm* outside of probe() but I am
> pretty sure they are buggy unless they explicitly freed with devm* as
> well and then there is no point.

Really ? If so that's good to know.. and it should mean grammar could
be used to hunt this down, specially since we have now some grammar
basics to help us check for calls on probe or init. On the grammar
we'd just only complain if a call was used not in a probe path.

> IN all other cases it is likely wrong
> as it messes up with order of freeing resources.

Good to know, thanks. Hopefully the above semantics of the driver
using keep should suffice. Which gets me to think, what if devm
had something similar to white-list uses outside of probe so that
if a keep (or another flag name) was set then its vetting that
the order of freeing of resources is understood and fine.

  Luis
