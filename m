Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17024 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750846AbcJJUdS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 16:33:18 -0400
Date: Mon, 10 Oct 2016 22:33:14 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Johannes Berg <johannes@sipsolutions.net>, kvalo@codeaurora.org,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] Revert "rtlwifi: rtl818x: constify local structures"
In-Reply-To: <90ea968e-dc19-5c2e-8aa4-6296a1d04381@lwfinger.net>
Message-ID: <alpine.DEB.2.10.1610102232360.3438@hadrien> (sfid-20161010_223321_054836_6573C663)
References: <20161010152520.9812-1-Larry.Finger@lwfinger.net> <1476118573.7895.13.camel@sipsolutions.net> <90ea968e-dc19-5c2e-8aa4-6296a1d04381@lwfinger.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Mon, 10 Oct 2016, Larry Finger wrote:

> On 10/10/2016 11:56 AM, Johannes Berg wrote:
> > On Mon, 2016-10-10 at 10:25 -0500, Larry Finger wrote:
> > > This reverts commit d86e64768859fca82c78e52877ceeba04e25d27a.
> > >
> > > For drivers rtl8188ee, rtl8192ce, rtl8192ee, rtl8723ae, and
> > > rtl8821ae,
> > > the Coccinelle script missed the fact that the code changes the
> > > firmware
> > > name. When that happens, the kernel issues a BUG splat because
> > > it is unable to overwrite the old name.
> >
> > Hmm. That seems somewhat problematic, for example if you have multiple
> > devices that use the same driver but need different firmware?
> >
> > Not that I really know what's going on, but changing static variables
> > based on runtime seems like it could cause issues in such cases.
>
> I think the situation is OK, but I have created a patch that converts all the
> firmware names into local strings in the routines that initiate firmware
> loading. That way the affected structs can be constified without problem.

Great, thanks :)

julia

>
> @Kalle: Please drop the patch with this subject.
>
> Thanks,
>
> Larry
>
