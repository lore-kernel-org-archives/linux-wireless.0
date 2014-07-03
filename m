Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbaGCPfq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2014 11:35:46 -0400
Date: Thu, 3 Jul 2014 17:35:44 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Subject: Re: [wireless-regdb] [PATCH] crda: db2rd, parse/print CAC time
Message-ID: <20140703153544.GC27687@wotan.suse.de> (sfid-20140703_173549_436617_E326BAFC)
References: <1404302531-18132-1-git-send-email-janusz.dziedzic@tieto.com> <CAB=NE6WN=6cu1rfHjLV32bvwAY6tnW9wrpVx5WHfdu0SJMvC0A@mail.gmail.com> <CALhHN=pfaLS_Axuky82QkUy1yaJw7qd+_Sss5h3nti9Li2g1Fw@mail.gmail.com> <CALhHN=oDHmz4Y4ZZUbyCU=gsM5_J=X7GH90qpCA_nqsjv9eK+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALhHN=oDHmz4Y4ZZUbyCU=gsM5_J=X7GH90qpCA_nqsjv9eK+A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 03, 2014 at 08:34:37AM +0200, Janusz Dziedzic wrote:
> On 3 July 2014 08:26, Janusz Dziedzic <janusz.dziedzic@tieto.com> wrote:
> > On 3 July 2014 00:06, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> >> On Wed, Jul 2, 2014 at 5:02 AM, Janusz Dziedzic
> >> <janusz.dziedzic@tieto.com> wrote:
> >>> db2rd, parse and print DFS CAC time
> >>>
> >>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> >>
> >>
> >> This doesn't print the DFS CAC if its a in a line like this:
> >>
> >> (5250 - 5330 @ 0), (20), (60000), DFS, AUTO-BW
> >>
> > will check this, BTW BW=0 is not allowed I think.
> >
> 
> Did such test:
> country AE: DFS-FCC
>         (2402 - 2482 @ 40), (20)
>         (5170 - 5250 @ 80), (17)
>         (5250 - 5330 @ 0), (24), (60000), DFS, AUTO-BW
>         (5490 - 5730 @ 80), (24), DFS
>         (5735 - 5835 @ 80), (30)
> 
> And get:
> ./db2rd < db.txt
> 
> country AE: DFS-FCC
>     (2402.000 - 2482.000 @ 40.000), (20.00), (N/A)
>     (5170.000 - 5250.000 @ 80.000), (17.00), (N/A)
>     (5250.000 - 5330.000 @ 0.000), (24.00), (60000), DFS, AUTO-BW
>     (5490.000 - 5730.000 @ 80.000), (24.00), (N/A), DFS
>     (5735.000 - 5835.000 @ 80.000), (30.00), (N/A)
> 
> Seems works fine. Did you install reglib, could be you are using old one?
> I am using x86_64.

Heh yeah that's the issue, sorry, patch pushed!

  Luis
