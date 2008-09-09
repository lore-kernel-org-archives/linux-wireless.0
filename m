Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51574 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbYIIDxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 23:53:19 -0400
Date: Mon, 8 Sep 2008 20:51:56 -0700
From: Greg KH <greg@kroah.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, cjb@laptop.org,
	linux-wireless@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH] libertas: clear current command on card
	removal
Message-ID: <20080909035156.GB13817@kroah.com> (sfid-20080909_055336_373352_0C3BA372)
References: <1220906080.1618.20.camel@localhost.localdomain> <20080908210110.GD24557@tuxdriver.com> <1220909957.9427.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1220909957.9427.7.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 08, 2008 at 05:39:17PM -0400, Dan Williams wrote:
> On Mon, 2008-09-08 at 17:01 -0400, John W. Linville wrote:
> > On Mon, Sep 08, 2008 at 04:34:40PM -0400, Dan Williams wrote:
> > > If certain commands were in-flight when the card was pulled or the
> > > driver rmmod-ed, cleanup would block on the work queue stopping, but the
> > > work queue was in turn blocked on the current command being canceled,
> > > which didn't happen.  Fix that.
> > > 
> > > Signed-off-by: Dan Williams <dcbw@redhat.com>
> > > ---
> > > John, this is 2.6.27 material if there's still time.
> > 
> > I have to remind you of the new "regressions only" policy.  Is this a
> > problem that we introduced in old code during the 2.6.27 merge window?
> 
> True :)  It is not a regression from 2.6.26, but a fairly serious bug
> that has existed for some time.  Thus, treat it as you like to avoid
> getting flamed by Linus & Dave.
> 
> I'll post to stable after 2.6.27 comes out then.

No, post to stable when the patch goes into Linus's tree as that is a
requirement.

To do so automatically, just add:
	CC: stable <stable@kernel.org>
in the signed-off-by: area of the patch and we will be automatically
notified when it goes into Linus's tree and will pick it up then, no
extra work for you at all (and much easier for the stable-team as well.)

thanks,

greg k-h
