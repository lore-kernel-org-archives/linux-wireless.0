Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbXCHCib (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 21:38:31 -0500
Subject: Re: Please pull 'libertas' branch of wireless-2.6
From: Dan Williams <dcbw@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Marcelo Tosatti <marcelo@kvack.org>, Jeff Garzik <jeff@garzik.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070307222404.GA23393@infradead.org>
References: <20070227205649.GH5826@tuxdriver.com>
	 <45E8CF5E.5090305@garzik.org> <20070303052140.GA31075@infradead.org>
	 <20070304153627.GA32380@dmt> <20070305140825.GA9982@infradead.org>
	 <20070307181638.GA22305@dmt>  <20070307222404.GA23393@infradead.org>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 21:40:51 -0500
Message-Id: <1173321651.12017.6.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-03-07 at 22:24 +0000, Christoph Hellwig wrote:
> On Wed, Mar 07, 2007 at 03:16:38PM -0300, Marcelo Tosatti wrote:
> > >  - please get rid of the ENTER/LEAVE macros
> > 
> > These are useful for debugging. We have removed most of the useless ones 
> > already.
> 
> We've refused this on a lot of drivers.  If you really need this kind
> of debugging talk to acme to use a variant of ostra for this.
> 
> > >  - please get rid of all your private ioctls and iwpriv stuff
> > >    (should I add !!!! here)
> > 
> > Rationale being? There are a bunch of device private knobs, and iwpriv
> > is the interface for such configuration. (????)
> 
> If you read netdev we're very very unhappy about device specific knobs,
> as they are really painful to support.  You should also look at the
> cfg80211 threads on why ioctls are really bad for moving to a knew
> non-wext, non-ioctl config mechanism.  And for why iwpriv is particularly
> bad look about the posts about the wext compat issues.

We are unhappy with specific knobs _if_and_only_if_ they duplicate
functionality that's currently available.

That means, for example, the prism2 WPA ioctls, because WE-19 has
equivalent functionality.  Other examples include many of the madwifi
ioctls like auth_mode for which there are WEXT calls.  Others include
the ones for creating virtual STAs that are now subsumed by mac80211.

For stuff that's seriously not common among drivers, there's nothing
else that drivers can do but provide private ioctls.

Dan


