Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933426AbXCRXdL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Mar 2007 19:33:11 -0400
Subject: Re: [PATCH 3/5] mac80211: fix key restricted/open display
From: Dan Williams <dcbw@redhat.com>
To: Jouni Malinen <j@w1.fi>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Hong Liu <hong.liu@intel.com>, Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070318164506.GB5358@jm.kir.nu>
References: <1174015698.3408.41.camel@devlinux-hong>
	 <200703161328.41006.flamingice@sourmilk.net>
	 <1174103177.3026.8.camel@localhost.localdomain>
	 <20070318164506.GB5358@jm.kir.nu>
Content-Type: text/plain
Date: Sun, 18 Mar 2007 19:35:46 -0400
Message-Id: <1174260946.8053.20.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-03-18 at 09:45 -0700, Jouni Malinen wrote:
> On Fri, Mar 16, 2007 at 11:46:17PM -0400, Dan Williams wrote:
> > On Fri, 2007-03-16 at 13:28 -0400, Michael Wu wrote:
> > > On Thursday 15 March 2007 23:28, Hong Liu wrote:
> > > > +	if (erq->flags & (IW_ENCODE_OPEN | IW_ENCODE_RESTRICTED))
> > > > +		if (sdata->type == IEEE80211_IF_TYPE_STA ||
> > > > +		    sdata->type == IEEE80211_IF_TYPE_IBSS)
> > > > +			sdata->u.sta.auth_algs =
> > > > +				(erq->flags & IW_ENCODE_RESTRICTED) ?
> > > > +				IEEE80211_AUTH_ALG_SHARED_KEY :
> > > > +				IEEE80211_AUTH_ALG_OPEN;
> 
> NAK.
> 
> > I think you're misreading the patch?  It looks correct to me.  The
> > second check for (erq->flags & IW_ENCODE_RESTRICTED) should ensure that
> > Shared Key is only selected when the userspace program requested it.
> 
> IW_ENCODE_RESTRICTED and Shared Key are different things (IMHO).

Yes, I _know_ that.  I thought that was apparent in my message.  But
WEXT has commingled them to some degree.  Otherwise, there's no way at
all to select between Open System or Shared Key when associating.

I would also argue that there is more of a use for selecting between SK
and OS auth than using RESTRICTED for it's real meaning anyway.

> > > IW_ENCODE_RESTRICTED simply means that the interface should not make/accept 
> > > unencrypted connections.
> 
> Agreed.
> 
> > Not quite.  Somewhere along the line WEXT turned ENCODE_RESTRICTED into
> > the selector for Shared Key, while ENCODE_OPEN is Open System.  Arguably
> > there's a larger need to specifying auth mode than rejecting unencrypted
> > associations.  Most drivers do it this way, with the exception of
> > madwifi because they like to be irritatingly different.  Nobody ever
> > really used the 'don't accept unencrypted' thing anyway in the old days,
> > plus ENCODEEXT has a separate flag for this.
> 
> Take a look at Host AP driver.. It has always mapped HFA384x WEPFLAGS
> excludeunencrypted to IW_ENCODE_RESTRICTED..

Which is somewhat unfortunate.  How does the HostAP driver select for OS
or SK when userspace programs don't know about WE-18 and therefore don't
use AUTH_ALG?

This is the same problem I submitted that "auth alg fallback" patch to
wpa_supplicant for last year.  Older drivers like orinoco or atmel just
don't have ENCODEEXT (I added it to prism54 and airo), and instead use
RESTRICTED.

There is no good way for a userspace program to set SK/OS except try
ENCODEEXT and fall back to ENCODE.  Which is, um, suboptimal.

> The IW_ENCODE_OPEN/RESTRICTED is quite unfortunate part of WEXT and
> since it has been used for two completely different things, it should
> not really be used. I would hope that this change is not introduced into
> mac80211.

Definitely.

> WE-18 introduced IW_AUTH_80211_AUTH_ALG and that should be used if user
> space wants to explicitly select which 802.11 authentication algorithm
> is to be used. Please let the IW_ENCODE_OPEN/RESTRICTED misuse die.

Obviously we want it to die.  But the better solution is to make apps
that care about "exclude unencrypted", which there are few, use
ENCODEEXT and keep OPEN/RESTRICTED be what most of the old drivers
expect it to be; the selector for OS/SK.  Then clean up all the double
meanings with cfg80211 and call it day.

Dan


