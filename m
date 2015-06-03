Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:56278 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbbFCVxU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 17:53:20 -0400
Date: Wed, 3 Jun 2015 23:52:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Scott Branden <sbranden@broadcom.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stable <stable@vger.kernel.org>, Andrew Kurn <kurn@sfu.ca>
Subject: Re: New USB ID 2001:3c25
Message-ID: <20150603215258.GB7438@1wt.eu> (sfid-20150603_235324_678070_1B9851DF)
References: <556E6000.90402@lwfinger.net> <6A6FBA3BBCB70741B2E7FD80BFDD32DB2B33CF50@SJEXCHMB10.corp.ad.broadcom.com> <20150603175412.GA7362@1wt.eu> <877frkfwga.fsf@nemi.mork.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <877frkfwga.fsf@nemi.mork.no>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 03, 2015 at 09:01:09PM +0200, Bjørn Mork wrote:
> Willy Tarreau <w@1wt.eu> writes:
> > On Wed, Jun 03, 2015 at 05:50:49PM +0000, Scott Branden wrote:
> >> Hi Larry,
> >> 
> >> There is no problem applying this patch to the stable tree.
> >> I didn't know it was my responsibility to inform the stable mailing list every time a patch is accepted
> >> in the latest kernel that could be applied to the stable tree?
> >
> > Just adding a Cc: stable@... in the commit message is enough to get it
> > automatically queued once applied. Please check SubmittingPatches and
> > stable_kernel_rules.txt for more information.
> 
> It isn't absolutely clear to me that those rules applies to "wireless",
> being a sub-subsystem of "net".  Quoting from stable_kernel_rules.txt :
> 
> "- If the patch covers files in net/ or drivers/net please follow netdev stable
>    submission guidelines as described in
>    Documentation/networking/netdev-FAQ.txt"
> 
> And the netdev-FAQ.txt goes into great detail describing the procedure,
> which basically is "Give davem a hint that the patch should go to
> stable".  (and I'd like to note that this works very well in practice).
> 
> But I have noticed that some stable patches seem to flow more directly
> into stable from "wireless" than from the rest of "net". I just don't
> think the current _written_ docs support that procedure.  Those docs
> are possibly wrong?  You should probably know much better than me :)

I'd say that if it's something that you submit through the regular netdev
process, David will automatically handle the backports and feed stable if
he spots this is needed (hence sometimes some hints in the commit message
about what oldest version should benefit from the backport can help it get
properly spotted if there's any ambiguity). If you didn't go through that
process, there's almost no chance he will detect your work and propose it
and then it makes sense to Cc stable.

I know that sometimes it can be ambiguous, hence the benefit of being
the clearest possible in the commit message all the time so that anyone
could possibly detect that your work needs to be backported if it slips
through the process.

Regards,
Willy

