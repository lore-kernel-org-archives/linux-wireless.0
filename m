Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:60303 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbXCRQpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Mar 2007 12:45:10 -0400
Date: Sun, 18 Mar 2007 09:45:07 -0700
From: Jouni Malinen <j@w1.fi>
To: Dan Williams <dcbw@redhat.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Hong Liu <hong.liu@intel.com>, Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/5] mac80211: fix key restricted/open display
Message-ID: <20070318164506.GB5358@jm.kir.nu>
References: <1174015698.3408.41.camel@devlinux-hong> <200703161328.41006.flamingice@sourmilk.net> <1174103177.3026.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1174103177.3026.8.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 16, 2007 at 11:46:17PM -0400, Dan Williams wrote:
> On Fri, 2007-03-16 at 13:28 -0400, Michael Wu wrote:
> > On Thursday 15 March 2007 23:28, Hong Liu wrote:
> > > +	if (erq->flags & (IW_ENCODE_OPEN | IW_ENCODE_RESTRICTED))
> > > +		if (sdata->type == IEEE80211_IF_TYPE_STA ||
> > > +		    sdata->type == IEEE80211_IF_TYPE_IBSS)
> > > +			sdata->u.sta.auth_algs =
> > > +				(erq->flags & IW_ENCODE_RESTRICTED) ?
> > > +				IEEE80211_AUTH_ALG_SHARED_KEY :
> > > +				IEEE80211_AUTH_ALG_OPEN;

NAK.

> I think you're misreading the patch?  It looks correct to me.  The
> second check for (erq->flags & IW_ENCODE_RESTRICTED) should ensure that
> Shared Key is only selected when the userspace program requested it.

IW_ENCODE_RESTRICTED and Shared Key are different things (IMHO).

> > IW_ENCODE_RESTRICTED simply means that the interface should not make/accept 
> > unencrypted connections.

Agreed.

> Not quite.  Somewhere along the line WEXT turned ENCODE_RESTRICTED into
> the selector for Shared Key, while ENCODE_OPEN is Open System.  Arguably
> there's a larger need to specifying auth mode than rejecting unencrypted
> associations.  Most drivers do it this way, with the exception of
> madwifi because they like to be irritatingly different.  Nobody ever
> really used the 'don't accept unencrypted' thing anyway in the old days,
> plus ENCODEEXT has a separate flag for this.

Take a look at Host AP driver.. It has always mapped HFA384x WEPFLAGS
excludeunencrypted to IW_ENCODE_RESTRICTED..

The IW_ENCODE_OPEN/RESTRICTED is quite unfortunate part of WEXT and
since it has been used for two completely different things, it should
not really be used. I would hope that this change is not introduced into
mac80211.

WE-18 introduced IW_AUTH_80211_AUTH_ALG and that should be used if user
space wants to explicitly select which 802.11 authentication algorithm
is to be used. Please let the IW_ENCODE_OPEN/RESTRICTED misuse die.

-- 
Jouni Malinen                                            PGP id EFC895FA
