Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48362 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbeCUKEZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 06:04:25 -0400
Date: Wed, 21 Mar 2018 11:04:22 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Joe Perches <joe@perches.com>, Takashi Iwai <tiwai@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiri Kosina <jikos@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        akpm@linux-foundation.org, cantabile.desu@gmail.com,
        kubakici@wp.pl, linux-wireless@vger.kernel.org,
        keescook@chromium.org, shuah@kernel.org, mfuzzey@parkeon.com,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        pali.rohar@gmail.com, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        Abhay_Salunke@dell.com, bjorn.andersson@linaro.org,
        jewalt@lgsinnovations.com, oneukum@suse.com, ast@fb.com,
        andresx7@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: Re: [PATCH v3 19/20] firmware: add request_firmware_cache() to help
 with cache on reboot
Message-ID: <20180321100422.GB22453@kroah.com> (sfid-20180321_110430_149643_C69D643F)
References: <20180310141501.2214-1-mcgrof@kernel.org>
 <20180310141501.2214-20-mcgrof@kernel.org>
 <20180320083055.GA21640@kroah.com>
 <20180320173409.GD4449@wotan.suse.de>
 <20180320173801.GA25040@kroah.com>
 <20180320182409.GF4449@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180320182409.GF4449@wotan.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 20, 2018 at 06:24:09PM +0000, Luis R. Rodriguez wrote:
> On Tue, Mar 20, 2018 at 06:38:01PM +0100, Greg KH wrote:
> > On Tue, Mar 20, 2018 at 05:34:09PM +0000, Luis R. Rodriguez wrote:
> > > On Tue, Mar 20, 2018 at 09:30:55AM +0100, Greg KH wrote:
> > > > On Sat, Mar 10, 2018 at 06:15:00AM -0800, Luis R. Rodriguez wrote:
> > > > > +EXPORT_SYMBOL_GPL(request_firmware_cache);
> > > > 
> > > > I know you are just following the existing naming scheme, but please
> > > > let's not continue the problem here.  Can you prefix all of the firmware
> > > > exported symbols with "firmware_", and then the verb.  So this would be
> > > > "firmware_request_cache",
> > > 
> > > Sure.
> > > 
> > > >  and the older function would be
> > > > "firmware_request_direct".
> > > 
> > > Sure, so you want to also rename the old exported symbols, and add a macro
> > > or static inline to enable use of the older names?
> > 
> > Renaming is best, let's not keep them around for no good reason :)
> 
> Sure thing, I'll rename the old firmware calls.

Ah, in looking at this closer, that might take a bit of time, as there
are a _lot_ of callers of request_firmware().  So maybe a macro/wrapper
is good for that one so we can propagate the changes through the
different subsystems and do this over a few kernel releases.

But for anything new, let's get it right the first time :)

thanks,

greg k-h
