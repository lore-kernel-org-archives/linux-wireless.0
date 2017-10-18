Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:51784 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761176AbdJRG4e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 02:56:34 -0400
Message-ID: <1508309791.2674.1.camel@sipsolutions.net> (sfid-20171018_085640_576687_EEE735CA)
Subject: Re: using verifier to ensure a BPF program uses certain metadata?
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 18 Oct 2017 08:56:31 +0200
In-Reply-To: <20171017225806.b5xubolkyocfgnjc@ast-mbp> (sfid-20171018_005813_040290_4671FB34)
References: <1508139524.10607.25.camel@sipsolutions.net>
         <20171017225806.b5xubolkyocfgnjc@ast-mbp>
         (sfid-20171018_005813_040290_4671FB34)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alexei,

> > https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
> > .git/log/?h=bpf
> 
> bpf bits looks pretty straightforward.

Thanks for looking at this!

> attach looks fine too. I'm assuming there is some rtnl or other lock,
> so multiple assigns cannot race?

Yes.

> It's missing query interface though.
> Please add support to return prog_id.

Good point, this is about half a year old, so ... :)

[...]
> > Now, I realize that people could trivially just work around this in
> > their program if they wanted, but I think most will take the
> > reminder
> > and just implement
> > 
> >     if (ctx->is_data_ethernet)
> >         return DROP_FRAME;
> > 
> > instead, since mostly data frames will not be very relevant to
> > them.
> > 
> > What do you think?
> 
> sounds fine and considering new verifier ops after Jakub refactoring
> a check that is_data_ethernet was accessed would fit nicely.
> Without void** hack.

Ok, thanks! I'll have to check what Jakub is doing there, do you have a
pointer to that refactoring?

johannes
