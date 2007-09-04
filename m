Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:52897 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbXIDAVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2007 20:21:43 -0400
Date: Mon, 3 Sep 2007 17:20:02 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: port of my recent patches to net-2.6.24
Message-ID: <20070904002002.GU1835@jm.kir.nu>
References: <1188027470.9529.5.camel@johannes.berg> <200708270029.35845.flamingice@sourmilk.net> <1188211612.6756.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188211612.6756.8.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 27, 2007 at 12:46:52PM +0200, Johannes Berg wrote:
> On Mon, 2007-08-27 at 00:29 -0400, Michael Wu wrote:

> > Patch 12:
> > -	int allow_broadcast_always; /* whether to allow TX of broadcast frames
> > -				     * even when there are no associated STAs
> > -				     */
> > -
> > Hmm.. that seems useful.. yet nothing is using it? What happen here?
> 
> It's "used" in wireless-dev in ioctls, but talking to Jouni he seemed to
> have a better idea instead so was OK with removing it.

For the original reason for adding this (making it easier to do some
continuous TX tests), yes, it can be done in other ways. The only thing
I can think of here would be some special frames (like broadcast data
frames as a beacon of some upper layer service) that would be used by
clients that are capable of receiving frames when not associated (e.g.,
they use monitor mode). This is getting a bit speculative here, so
unless someone can point out a real example that depends on this, I
would go ahead and remove it now.

-- 
Jouni Malinen                                            PGP id EFC895FA
