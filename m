Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54305 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751317AbeCTSYP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 14:24:15 -0400
Date: Tue, 20 Mar 2018 18:24:09 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Joe Perches <joe@perches.com>, Takashi Iwai <tiwai@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiri Kosina <jikos@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, akpm@linux-foundation.org,
        cantabile.desu@gmail.com, kubakici@wp.pl,
        linux-wireless@vger.kernel.org, keescook@chromium.org,
        shuah@kernel.org, mfuzzey@parkeon.com, zohar@linux.vnet.ibm.com,
        dhowells@redhat.com, pali.rohar@gmail.com, tiwai@suse.de,
        arend.vanspriel@broadcom.com, zajec5@gmail.com, nbroeking@me.com,
        markivx@codeaurora.org, broonie@kernel.org,
        dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        Abhay_Salunke@dell.com, bjorn.andersson@linaro.org,
        jewalt@lgsinnovations.com, oneukum@suse.com, ast@fb.com,
        andresx7@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: Re: [PATCH v3 19/20] firmware: add request_firmware_cache() to help
 with cache on reboot
Message-ID: <20180320182409.GF4449@wotan.suse.de> (sfid-20180320_192439_461841_5BE523F5)
References: <20180310141501.2214-1-mcgrof@kernel.org>
 <20180310141501.2214-20-mcgrof@kernel.org>
 <20180320083055.GA21640@kroah.com>
 <20180320173409.GD4449@wotan.suse.de>
 <20180320173801.GA25040@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180320173801.GA25040@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 20, 2018 at 06:38:01PM +0100, Greg KH wrote:
> On Tue, Mar 20, 2018 at 05:34:09PM +0000, Luis R. Rodriguez wrote:
> > On Tue, Mar 20, 2018 at 09:30:55AM +0100, Greg KH wrote:
> > > On Sat, Mar 10, 2018 at 06:15:00AM -0800, Luis R. Rodriguez wrote:
> > > > +EXPORT_SYMBOL_GPL(request_firmware_cache);
> > > 
> > > I know you are just following the existing naming scheme, but please
> > > let's not continue the problem here.  Can you prefix all of the firmware
> > > exported symbols with "firmware_", and then the verb.  So this would be
> > > "firmware_request_cache",
> > 
> > Sure.
> > 
> > >  and the older function would be
> > > "firmware_request_direct".
> > 
> > Sure, so you want to also rename the old exported symbols, and add a macro
> > or static inline to enable use of the older names?
> 
> Renaming is best, let's not keep them around for no good reason :)

Sure thing, I'll rename the old firmware calls.

Since that would be a cross-tree collateral evolution, as we have discussed
before over these at kernel summits, I'd prefer to leave that large set of
renames toward the end of the series, as the last patch. This way the
Coccinelle SmPL / sed script could be run at the very end, and in case of merge
conflicts re-run.

Which BTW... *long term*, I believe a possible way to address these cross-tree
collateral evolutions, due to new merge updates and conflicts, could be for us
to embed the SmPL / sed scripts into git notes, and in turn have an *optional* git
configuration which could attempt a merge conflict resolution through
alternative means, one of which -- if enabled -- could be to try to run the SmPL or
sed script in the attached git note (if you downloaded them). One of the other
benefits of this is the commit log is no longer visually impaired by such long
semantic patches or scripts, and gives us a nice way to pull these up through a
generic tooling mechanism. This could all just be optional, no one would have
to push or fetch these -- only if they wanted the possible added benefits of
having them.

*Iff* this seems sensible, this would only mean kernel.org would have to start
accepting git notes long term, for those who optionally want to push them or
fetch them.

FWIW I've confirmed with github that they now accepts git notes, the UI for
github just needs time to develop how to interact with them, for now they just
hide them. One of the difficulties with a UI interface for them is that by
default git notes *do not* use a namespace reflective for a branch or anything.
We could stick to a actual namespace for branch / commit:

"iso" for isomorphism

git note --ref branch/iso-coccinelle/ add commit-id
vi refs/notes/branch/iso-coccinelle/commit-id
git note --ref branch/iso-coccinelle/ edit commit-id

This is rather crude though so simple interface such as the following could
be added as well:

git smpl add sp.cocci commit-id
git smpl edit commit-id
git smpl list v4.13..v4.14

Similar thing could be done for crash dumps, if we wanted...

Since this still would need to be discussed, and if agreed then implemented, in
the meantime I can just do it the old school way of embedding the SmPL and/or
sed script into the commit log, but left as the last patch in the series.

  Luis
