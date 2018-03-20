Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58671 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751269AbeCTTvy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 15:51:54 -0400
Date: Tue, 20 Mar 2018 19:51:48 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 19/20] firmware: add request_firmware_cache() to help
 with cache on reboot
Message-ID: <20180320195148.GH4449@wotan.suse.de> (sfid-20180320_205200_186828_940D4432)
References: <20180310141501.2214-1-mcgrof@kernel.org>
 <20180310141501.2214-20-mcgrof@kernel.org>
 <20180320083055.GA21640@kroah.com>
 <20180320173409.GD4449@wotan.suse.de>
 <20180320173801.GA25040@kroah.com>
 <20180320182409.GF4449@wotan.suse.de>
 <5dc49c7f-56f6-28df-38da-bfa998afbdbb@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5dc49c7f-56f6-28df-38da-bfa998afbdbb@linuxfoundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 20, 2018 at 02:54:44PM -0400, Konstantin Ryabitsev wrote:
> On 03/20/18 14:24, Luis R. Rodriguez wrote:
> > *Iff* this seems sensible, this would only mean kernel.org would have to start
> > accepting git notes long term, for those who optionally want to push them or
> > fetch them.
> 
> We don't disallow them. You just need to make sure you're fetching and
> pushing them, because they aren't by default. You can set this in your
> kernel.org origin section of .git/config:
> 
> [remote origin]
>   ...
>   fetch = +refs/notes/*:refs/notes/*
> 
> And then push them separately as "git push origin refs/notes/*".

Superb, thanks!

> Since frontends clone with --mirror, the notes will be available on all
> git.kernel.org nodes (e.g. see
> https://git.kernel.org/mricon/hook-test/c/a8d310d4c13)

Good to know thanks, and it looks good!

> If you do start using notes, I strongly suggest you pick a dedicated
> refspace for it instead of putting things into the default
> refs/notes/commits, e.g.:
> 
> git notes --ref crosstree [...]
> 
> This will create refs/notes/crosstree that has less of a chance to be
> clobbered by someone else's use of notes.

Indeed, the default is crap. I was suggesting perhaps having it also be
per branch, so:

git note --ref branch/iso-coccinelle/ add commit-id

If it was required sed I guess

git note --ref branch/sed/ add commit-id

And if we wanted a resolution handler which could manage the above for you:

git note --ref branch/merger-script add commit-id

Which could use the above two to run what is needed to mimic the commit.

  Luis
