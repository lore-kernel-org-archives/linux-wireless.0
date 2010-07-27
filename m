Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48457 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab0G0Da1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 23:30:27 -0400
Received: by pwi5 with SMTP id 5so301597pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 20:30:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim-0qoS7o+fcQ6uA18AC_gQSiiDe4Tv_L1FT1Ae@mail.gmail.com>
References: <AANLkTim-0qoS7o+fcQ6uA18AC_gQSiiDe4Tv_L1FT1Ae@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Jul 2010 20:30:07 -0700
Message-ID: <AANLkTikxmBhhwBq=rUd0PufAWnxqJAHjrrdiHYcuE26e@mail.gmail.com>
Subject: Re: Confused - bisecting wireless-testing
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 26, 2010 at 8:27 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> 04:23  * mcgrof is confused, I just did a git bisect -i on
> wireless-testing on some patch on Fri Jul 2 00:09:49 2010  and ended
> up with a 2.6.34 top level
>          Makefile
> 04:23 < mcgrof> it was git rebase -i ba17bc5e55ba541d2a8765fca53b6883b667ab21
> 04:23 < mcgrof> eh
> 04:24 < mcgrof> how am I supposed to bisect wl now
> 04:24 < mcgrof> the odd thing though is that the top commit is ancient
> 04:24 < mcgrof> http://paste.pocoo.org/show/242077/
> 04:24 < mcgrof> but the other ones are OK
>
> I realize we should use wireless-2.6.git to bisect stable but I need
> to bisect against recent patches that spans different master- tags
> from you, I figured git bisecting wireless-testing would work now that
> you are using a different method to move your tree forward but am I
> wrong? Should I only bisect between master tags still?

Heh I just realize what I said didn't make sense, what I meant was I
was *going* to bisect but in order to first find my first good
starting point I am going through the tree trying to find a good
starting point to bisect and to do that I use interactive rebase (git
rebase -i sha1sum) to specific sha1sums until I find a good compile
that works. Only after I've done this would I then bisect.

The interactive bisect on ba17bc5e55ba541d2a8765fca53b6883b667ab21
throws me back to 2.6.34 though, for some odd reason.

  Luis
