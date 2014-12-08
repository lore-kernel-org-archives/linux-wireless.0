Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:32716
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969AbaLHGnX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2014 01:43:23 -0500
Date: Mon, 8 Dec 2014 07:43:16 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Julian Calaby <julian.calaby@gmail.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org, linux@rasmusvillemoes.dk,
	Joe Perches <joe@perches.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-scsi <linux-scsi@vger.kernel.org>,
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
	linux-mtd@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
	"Mailing List, Arm" <linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-pci@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/20] fix misspelling of current function in string
In-Reply-To: <CAGRGNgWDJqV=XD+6q26Ma=m1sEi1kvLWsjq6=RjRVSFTxow0Qg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1412080738210.2100@localhost6.localdomain6> (sfid-20141208_074334_228328_3E04BFE7)
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr> <CAGRGNgWDJqV=XD+6q26Ma=m1sEi1kvLWsjq6=RjRVSFTxow0Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 8 Dec 2014, Julian Calaby wrote:

> Hi Julia,
> 
> On Mon, Dec 8, 2014 at 6:20 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> > These patches replace what appears to be a reference to the name of the
> > current function but is misspelled in some way by either the name of the
> > function itself, or by %s and then __func__ in an argument list.
> 
> Would there be any value in doing this for _all_ cases where the
> function name is written in a format string?

Probably.  But there are a lot of them.  Even for the misspellings, I have 
only don about 1/3 of the cases.

On the other hand, the misspelling have to be checked carefully, because a 
misspelling of one thing could be the correct spelling of the thing thst 
was actually intended.

Joe, however, points out that a lot of these prints are just for function 
tracing, and could be removed.  I worked on another semantic patch that 
tries to do that.  It might be better to remove those prints completely, 
rather than sending one patch to transform them and then one patch to 
remove them after that.  That is why for this series I did only the ones 
where there was actually a problem.

julia
