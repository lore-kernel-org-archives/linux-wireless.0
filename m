Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56084 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030532AbXCGWYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 17:24:39 -0500
Date: Wed, 7 Mar 2007 22:24:04 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Marcelo Tosatti <marcelo@kvack.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Jeff Garzik <jeff@garzik.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Please pull 'libertas' branch of wireless-2.6
Message-ID: <20070307222404.GA23393@infradead.org>
References: <20070227205649.GH5826@tuxdriver.com> <45E8CF5E.5090305@garzik.org> <20070303052140.GA31075@infradead.org> <20070304153627.GA32380@dmt> <20070305140825.GA9982@infradead.org> <20070307181638.GA22305@dmt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070307181638.GA22305@dmt>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 07, 2007 at 03:16:38PM -0300, Marcelo Tosatti wrote:
> >  - please get rid of the ENTER/LEAVE macros
> 
> These are useful for debugging. We have removed most of the useless ones 
> already.

We've refused this on a lot of drivers.  If you really need this kind
of debugging talk to acme to use a variant of ostra for this.

> >  - please get rid of all your private ioctls and iwpriv stuff
> >    (should I add !!!! here)
> 
> Rationale being? There are a bunch of device private knobs, and iwpriv
> is the interface for such configuration. (????)

If you read netdev we're very very unhappy about device specific knobs,
as they are really painful to support.  You should also look at the
cfg80211 threads on why ioctls are really bad for moving to a knew
non-wext, non-ioctl config mechanism.  And for why iwpriv is particularly
bad look about the posts about the wext compat issues.

