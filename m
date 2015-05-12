Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932574AbbELUp7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 16:45:59 -0400
Date: Tue, 12 May 2015 22:45:56 +0200
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
Subject: Re: [PATCH v2 1/5] firmware: fix __getname() missing failure check
Message-ID: <20150512204556.GO23057@wotan.suse.de> (sfid-20150512_224604_568483_4127E954)
References: <1431455457-25322-1-git-send-email-mcgrof@do-not-panic.com>
 <1431455457-25322-2-git-send-email-mcgrof@do-not-panic.com>
 <CA+55aFwSQqkA_yzvePe7p-aJkbVJc9od=wLvXvs9B=NcckFfoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFwSQqkA_yzvePe7p-aJkbVJc9od=wLvXvs9B=NcckFfoA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 12, 2015 at 01:31:58PM -0700, Linus Torvalds wrote:
> On Tue, May 12, 2015 at 11:30 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > +
> > +       path = __getname();
> > +       if (unlikely(!path))
> > +               return PTR_ERR(path);
> 
> This makes no sense.
> 
> PTR_ERR() on NULL is an insane operation. It's a very non-intuitive
> and misleading way of writing "0".
> 
> So not only is that "return 0;", that's not likely what you want _anyway_.
> 
> If you intended to return an error, you should just have done so, eg
> 
>         if (unlikely(!path))
>                 return -ENOMEM;
> 
> which actually does something sane, and is more readable.

Will fix, thanks.

 Luis
