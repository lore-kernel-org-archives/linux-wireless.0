Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:55817 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022AbXH3O6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 10:58:42 -0400
Date: Thu, 30 Aug 2007 08:58:41 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jochen Voss <voss@seehuhn.de>,
	linux wireless list <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com, netdev <netdev@vger.kernel.org>,
	bridge@linux-foundation.org
Subject: Re: oops with recent wireless-dev tree
Message-ID: <20070830145840.GU14130@parisc-linux.org>
References: <20070829223752.GA6969@seehuhn.de> <1188475530.2963.20.camel@johannes.berg> <20070830074949.7cd25b04@freepuppy.rosehill.hemminger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070830074949.7cd25b04@freepuppy.rosehill.hemminger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 30, 2007 at 07:49:49AM -0700, Stephen Hemminger wrote:
> > >     static int port_cost(struct net_device *dev)
> > >     {
> > > 	    if (dev->ethtool_ops->get_settings) {
> > >                                ^^^^
> > > 
> > > As far as I can figure out, dev->ethtool_ops is NULL and the crash
> > > happens while trying to derefernce ...->get_settings.
> 
> Devices aren't required to have ethtool_ops. The code there used to
> call ethtool directly, and it would handle the error cases. I'll rollup
> a fix this morning.

Yep, clearly my fault; that should read:

	if (dev->ethtool_ops && dev->ethtool_ops->get_settings) {

Since Stephen's already bagged fixing this, I shan't send a patch.
But if it includes something like the line above please add:

Acked-by: Matthew Wilcox <matthew@wil.cx>

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
