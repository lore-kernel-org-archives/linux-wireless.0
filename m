Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:46784 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbXHUDOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 23:14:34 -0400
Date: Mon, 20 Aug 2007 20:13:13 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 08/20] mac80211: remove unused ioctls (3)
Message-ID: <20070821031313.GN1415@jm.kir.nu>
References: <20070815144920.135826000@sipsolutions.net> <20070815145045.151670000@sipsolutions.net> <20070818040943.GH1415@jm.kir.nu> <1187601341.6090.50.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187601341.6090.50.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 20, 2007 at 11:15:41AM +0200, Johannes Berg wrote:
> On Fri, 2007-08-17 at 21:09 -0700, Jouni Malinen wrote:
> 
> > Create IBSS is a somewhat commonly used configuration and so is mixed
> > cell configuration in Cisco-world (and the only point for the
> > privacy_mismatch check that is left broken after this patch).
> 
> I was under the impression that the auth mechanism setting would still
> do that. What is "mixed cell configuration" anyway?

As far as I know, it is an option that allows the client to associate
with a network that has a mismatch in the privacy setting (with its own
configuration). This would only happen in case the same SSID/beacon
frame were to be used to advertise multiple networks with conflicting
security policies (open and encryption), i.e., a "mixed cell".

> > No, but iwpriv.. See the pattern here.. ;-)
> 
> Oh, I can see that, but none of these things are documented nor do any
> existing tools use them. I don't contend the fact that these may indeed
> be useful, but I think none of them should be private ioctls. If you
> have a use case for all of these I'd be happy to see an explanation so
> we can add this with proper documentation elsewhere. Without
> documentation, they are a rather useless special configurations nobody
> will ever touch.

iwpriv is an existing tool that uses these. I'm perfectly fine with
doing this any other way, so no problems there, and I can also accept
that there is unfortunate lack of documentation for many of the
parameters.

-- 
Jouni Malinen                                            PGP id EFC895FA
