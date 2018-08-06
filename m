Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cloudserver094114.home.pl ([79.96.170.134]:52441 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727517AbeHFMiy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Aug 2018 08:38:54 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kees Cook <keescook@chromium.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Will Deacon <will.deacon@arm.com>,
        device-mapper development <dm-devel@redhat.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        drbd-dev@lists.linbit.com,
        linux-block <linux-block@vger.kernel.org>, qat-linux@intel.com,
        linux-ppp@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>,
        linux-afs@lists.infradead.org,
        "open list:NETWORKING DRIVERS (WIRELESS)"
        <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 10/18] x86/power/64: Remove VLA usage
Date: Mon, 06 Aug 2018 12:28:28 +0200
Message-ID: <1782361.6NaZWiq7ky@aspire.rjw.lan> (sfid-20180806_123051_494272_9C93EE4E)
In-Reply-To: <CAGXu5j+NPCc2hq5x7JUwgKYvY6zKN28YdtHbHVapnpgC3GwCsg@mail.gmail.com>
References: <20180724164936.37477-1-keescook@chromium.org> <CAJZ5v0gVDotjufLKUW0YuQu2vA4fmU_gqia=ZA4DocW4XHxx0w@mail.gmail.com> <CAGXu5j+NPCc2hq5x7JUwgKYvY6zKN28YdtHbHVapnpgC3GwCsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, July 25, 2018 8:01:47 PM CEST Kees Cook wrote:
> On Wed, Jul 25, 2018 at 4:32 AM, Rafael J. Wysocki <rafael@kernel.org> wrote:
> > On Tue, Jul 24, 2018 at 6:49 PM, Kees Cook <keescook@chromium.org> wrote:
> >> In the quest to remove all stack VLA usage from the kernel[1], this
> >> removes the discouraged use of AHASH_REQUEST_ON_STACK by switching to
> >> shash directly and allocating the descriptor in heap memory (which should
> >> be fine: the tfm has already been allocated there too).
> >>
> >> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> >>
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >> Acked-by: Pavel Machek <pavel@ucw.cz>
> >
> > I think I can queue this up if there are no objections from others.
> >
> > Do you want me to do that?
> 
> Sure thing. It looks like the other stand-alone patches like this one
> are getting taken into the non-crypto trees, so that's fine.
> 

Applied now, thanks!
