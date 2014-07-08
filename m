Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45315 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaGHC5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 22:57:24 -0400
Received: by mail-pa0-f49.google.com with SMTP id lj1so6446333pab.22
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2014 19:57:23 -0700 (PDT)
Date: Mon, 7 Jul 2014 19:57:19 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4/5] cfg80211: accept world/same regdom from driver/user
 hints
Message-ID: <20140708025719.GU1390@garbanzo.do-not-panic.com> (sfid-20140708_045727_769962_EAACF755)
References: <CA+XVXffrepXAKitqhL4C87Jxy4MiF+iAO_PP6YZkMKtqeckV+Q@mail.gmail.com>
 <20140623204800.GF1390@garbanzo.do-not-panic.com>
 <CA+XVXfcJwZJPz9rLWx6+KSWzEfkcdnjBYpzhyKfvmX7Au38akA@mail.gmail.com>
 <20140630222132.GN1390@garbanzo.do-not-panic.com>
 <CA+XVXffHGQFDQ+yAhdh+R=XuDsT4QfhvFfWK4b2Cw_DttzL-BQ@mail.gmail.com>
 <20140702020442.GP1390@garbanzo.do-not-panic.com>
 <CA+XVXffvG6GagBPMZF+iogaAeYV0kUoi4BX68J0fxOfsHjE70A@mail.gmail.com>
 <20140703221901.GS1390@garbanzo.do-not-panic.com>
 <CA+XVXffnDs4oCnyD0NzmyG6=jxqXwUFd+Tj8XAsWGC1bgcMH8A@mail.gmail.com>
 <CA+XVXfewhKpsdVo5Yq3RiKWoDe85h1ne_QVUDtFuC4sfECkV7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+XVXfewhKpsdVo5Yq3RiKWoDe85h1ne_QVUDtFuC4sfECkV7g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 07, 2014 at 12:13:20PM +0300, Arik Nemtsov wrote:
> On Sun, Jul 6, 2014 at 10:22 PM, Arik Nemtsov <arik@wizery.com> wrote:
> > Therefore I would be glad if you reconsider a dynamic initial regulatory domain.
> 
> Thinking about this a bit more, I guess we can find out the true
> initial regdomain (e.g. US) on ifup (much after wiphy is registered),
> and send it as as a real alpha2 in a driver regulatory hint. This will
> keep orig_flags pristine and allows us to change regdomains at will.

:)

> But we still need the "99" from usermode for the "user removes the SIM
> during operation" scenario. You're suggesting reg.c will get "99" and
> somehow know that it needs to restore the alpha2 to US at this point.

No I never made a recommendation to the linking.

> Currently there's no functionality to do this. There's some limited
> code to restore to the latest set user_alpha2, but that's not what we
> want.

I'll highlight you're mentioning the user_alpha2, which is used for
either users setting regulatory domains via 'iw reg set' or equivalent
and cellular base station hints, which use the same API but just qualify
the request to specifiy the source is coming from some form of cell base
station.

> We want the "US" that was set by the driver.

But here you say "driver" rather than userspace or cell base station
hints, so its unclear what you meant here. If the driver set it then
REGULATORY_STRICT_REG already supports letting the driver keep the
_orig* parameters.

> I still believe the
> simplest solution is to give it to the get_regd() callback, which will
> then return "US". It prevents complexity and more special cases from
> reg.c..

Let's separate cell base station hints from userspace from firmware
being loaded and assuming that magical firmware has now regulatory
data (which obviously I consider silly since we already provide the
same functionality with CRDA and let you override the db.txt). The
cellular base station hint infrastructure can certainly be expanded
to support overriding the *_orig parameters. The FW API looks less
attractive now as it seems more than anything the hint can actually
come from userspace and the base station hint mechanism for your
use case.

A FW API to let FW load regulatory data dynamically is still OK but
lets be clear that if you are using it for a userspace work around
for cell base astation hints it seems rather a work around for
existing APIs and you can likely implement what you want with less
code. If we don't need this FW API I rather not have it added.

  Luis
