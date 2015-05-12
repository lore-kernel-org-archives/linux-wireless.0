Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:37234 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbbELUb7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 16:31:59 -0400
MIME-Version: 1.0
In-Reply-To: <1431455457-25322-2-git-send-email-mcgrof@do-not-panic.com>
References: <1431455457-25322-1-git-send-email-mcgrof@do-not-panic.com>
	<1431455457-25322-2-git-send-email-mcgrof@do-not-panic.com>
Date: Tue, 12 May 2015 13:31:58 -0700
Message-ID: <CA+55aFwSQqkA_yzvePe7p-aJkbVJc9od=wLvXvs9B=NcckFfoA@mail.gmail.com> (sfid-20150512_223221_575761_7D03CCF2)
Subject: Re: [PATCH v2 1/5] firmware: fix __getname() missing failure check
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
> +
> +       path = __getname();
> +       if (unlikely(!path))
> +               return PTR_ERR(path);

This makes no sense.

PTR_ERR() on NULL is an insane operation. It's a very non-intuitive
and misleading way of writing "0".

So not only is that "return 0;", that's not likely what you want _anyway_.

If you intended to return an error, you should just have done so, eg

        if (unlikely(!path))
                return -ENOMEM;

which actually does something sane, and is more readable.

PTR_ERR() is for when you get an error pointer, so a sequence like

        if (IS_ERR(ptr))
                return PTR_ERR(ptr);

is sensible (it checks whether the ptr has an error value in it, and
then returns the integer error value of the pointer).

But for a NULL pointer? No.

                       Linus
