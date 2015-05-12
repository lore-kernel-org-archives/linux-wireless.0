Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39926 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbbELVG0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 17:06:26 -0400
Date: Tue, 12 May 2015 23:06:21 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Ming Lei <ming.lei@canonical.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	David Howells <dhowells@redhat.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Paul Bolle <pebolle@tiscali.nl>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Kyle McMartin <kyle@kernel.org>
Subject: Re: [PATCH v2 3/5] firmware: check for possible file truncation early
Message-ID: <20150512210621.GP23057@wotan.suse.de> (sfid-20150512_230653_024608_76C00DE3)
References: <1431455457-25322-1-git-send-email-mcgrof@do-not-panic.com>
 <1431455457-25322-4-git-send-email-mcgrof@do-not-panic.com>
 <CA+55aFxQhGLtwEdtKcQLh2CLE5-hM-o-4=mWj3sB6rKgCmdSKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFxQhGLtwEdtKcQLh2CLE5-hM-o-4=mWj3sB6rKgCmdSKQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 12, 2015 at 01:35:59PM -0700, Linus Torvalds wrote:
> On Tue, May 12, 2015 at 11:30 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> >
> > Instead of waiting until the last second to fail
> > on a request_firmware*() calls due to filename
> > truncation we can do an early check upon boot
> > and immediatley avoid any possible issues upfront.
> 
> Why? This looks stupid. Why add this special case, when normal path
> lookup results in the proper errors

It seemed silly to proceed late if we can catch the possible name errors
early. It does indeed have the cost of all that early cruft code.

> And if invalid pathnames are so frequent that this special case is
> somehow worth it, we should fix whoever generates that crap, instead
> of adding this insane special case.

OK, I'm all for ignoring non-upstream drivers.

> And if we don't handle the errors from normal path lookup properly,
> then we should fix *that*.

That was done on patch 2, originally I was going for a simple early
check which can be put on all API calls prior to doing anything too
intrusive:

+static int sysdata_validate_filename(const char *name)
+{
+       if (!name)
+               return -EINVAL;
+       /* POSIX.1 2.4: an empty pathname is invalid, match other checks */
+       if (name[0] == '\0')
+               return -ENOENT;
+}

Since the truncation was possible too though it seemed worthy to add given
that quite a few callers can end up re-using the same code.

> In other words, I see absolutely no reason for this patch. Regardless
> of the reason for it, it seems entirely broken.

OK I'll get rid of all these early checks.

  Luis
