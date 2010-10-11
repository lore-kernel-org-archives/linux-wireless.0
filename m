Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dee.erg.abdn.ac.uk ([139.133.204.82]:54926 "EHLO erg.abdn.ac.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752588Ab0JKL4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 07:56:55 -0400
Message-ID: <56374.148.187.160.35.1286798194.squirrel@148.187.160.35>
In-Reply-To: <1286790947.3634.9.camel@jlt3.sipsolutions.net>
References: <20100930102508.GB3581@gerrit.erg.abdn.ac.uk>
    <1285857487.5137.2.camel@jlt3.sipsolutions.net>
    <42875.148.187.160.35.1285917725.squirrel@148.187.160.35>
    <1285921839.3739.16.camel@jlt3.sipsolutions.net>
    <20101011051410.GA3977@gerrit.erg.abdn.ac.uk>
    <1286790947.3634.9.camel@jlt3.sipsolutions.net>
Date: Mon, 11 Oct 2010 12:56:34 +0100 (BST)
Subject: Re: [Patch 1/1] wext: fix 32/64 bit alignment issue for 'point'
     type
From: gerrit@erg.abdn.ac.uk
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Gerrit Renker" <gerrit@erg.abdn.ac.uk>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> However, I don't understand this patch. Your original patch would have
> fixed this just as well, since after it
>
> IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN
>
> would be
>
> (IW_EV_LCP_PK_LEN + 4) - IW_EV_LCP_PK_LEN == 4
>
> and at the same time fixes the userspace problem, if anyone really wants
> to use wext in new applications that don't use iwlib still...
>
Good catch, this is much better (I got lost in all the other constants).
I will check if I have not missed anything and resubmit if there are no
side effects.

Thanks a lot for the review and suggestion, this looks good.

