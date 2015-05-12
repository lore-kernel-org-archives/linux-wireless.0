Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:38054 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbbELUf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 16:35:59 -0400
MIME-Version: 1.0
In-Reply-To: <1431455457-25322-4-git-send-email-mcgrof@do-not-panic.com>
References: <1431455457-25322-1-git-send-email-mcgrof@do-not-panic.com>
	<1431455457-25322-4-git-send-email-mcgrof@do-not-panic.com>
Date: Tue, 12 May 2015 13:35:59 -0700
Message-ID: <CA+55aFxQhGLtwEdtKcQLh2CLE5-hM-o-4=mWj3sB6rKgCmdSKQ@mail.gmail.com> (sfid-20150512_223635_698216_036D5F81)
Subject: Re: [PATCH v2 3/5] firmware: check for possible file truncation early
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Ming Lei <ming.lei@canonical.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	David Howells <dhowells@redhat.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Paul Bolle <pebolle@tiscali.nl>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Kyle McMartin <kyle@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 12, 2015 at 11:30 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
>
> Instead of waiting until the last second to fail
> on a request_firmware*() calls due to filename
> truncation we can do an early check upon boot
> and immediatley avoid any possible issues upfront.

Why? This looks stupid. Why add this special case, when normal path
lookup results in the proper errors?

And if invalid pathnames are so frequent that this special case is
somehow worth it, we should fix whoever generates that crap, instead
of adding this insane special case.

And if we don't handle the errors from normal path lookup properly,
then we should fix *that*.

In other words, I see absolutely no reason for this patch. Regardless
of the reason for it, it seems entirely broken.

                         Linus
