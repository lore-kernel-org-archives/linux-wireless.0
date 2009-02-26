Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:40771 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753144AbZBZOiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 09:38:13 -0500
Date: Thu, 26 Feb 2009 16:37:58 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] nl80211: Authentication and association events
Message-ID: <20090226143758.GB24380@jm.kir.nu> (sfid-20090226_153817_996961_252D3008)
References: <20090218200210.GA13955@jm.kir.nu> <1234988740.4023.51.camel@johannes.local> <20090220192557.GA17914@jm.kir.nu> <1235440527.4455.45.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1235440527.4455.45.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2009 at 05:55:27PM -0800, Johannes Berg wrote:
> On Fri, 2009-02-20 at 21:25 +0200, Jouni Malinen wrote:
> > +enum nl80211_auth_type {
> > +	NL80211_AUTHTYPE_UNSPECIFIED,
> 
> This seems a little odd, is that really useful? And if it is, what do we
> do? Try all?

This is not supposed to be used and was there only to follow the
do-not-use-zero-in-nl80211 policy.. However, it looks like the example I
used (nl80211_iftype) actually uses the unspecified value or well at
least it is documented as something that could potentially be used. I
can just remove this and the _after_last, _max from here since they are
not really supposed to be used anywhere..

> Should we have some more code in cfg80211 to keep track of the BSSes
> we're authenticated/the one we're associated to, and have some commands
> to query those from userspace?

It would probably be useful to add this eventually. Whatever is
requesting the association has most of the information, but it would be
could to allow other applications have access to it and also remove the
need to store that in the control application.

-- 
Jouni Malinen                                            PGP id EFC895FA
