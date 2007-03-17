Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933230AbXCQDnt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2007 23:43:49 -0400
Subject: Re: [PATCH 3/5] mac80211: fix key restricted/open display
From: Dan Williams <dcbw@redhat.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Hong Liu <hong.liu@intel.com>, Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200703161328.41006.flamingice@sourmilk.net>
References: <1174015698.3408.41.camel@devlinux-hong>
	 <200703161328.41006.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 23:46:17 -0400
Message-Id: <1174103177.3026.8.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-03-16 at 13:28 -0400, Michael Wu wrote:
> On Thursday 15 March 2007 23:28, Hong Liu wrote:
> > +	if (erq->flags & (IW_ENCODE_OPEN | IW_ENCODE_RESTRICTED))
> > +		if (sdata->type == IEEE80211_IF_TYPE_STA ||
> > +		    sdata->type == IEEE80211_IF_TYPE_IBSS)
> > +			sdata->u.sta.auth_algs =
> > +				(erq->flags & IW_ENCODE_RESTRICTED) ?
> > +				IEEE80211_AUTH_ALG_SHARED_KEY :
> > +				IEEE80211_AUTH_ALG_OPEN;
> > +
> This is not right because encrypted access points often do not require shared 
> key authentication to associate. In fact, some cannot or refuse to use shared 
> key authentication and your patch prevents retrying with a different 
> authentication algorithm.

I think you're misreading the patch?  It looks correct to me.  The
second check for (erq->flags & IW_ENCODE_RESTRICTED) should ensure that
Shared Key is only selected when the userspace program requested it.

> IW_ENCODE_RESTRICTED simply means that the interface should not make/accept 
> unencrypted connections. In client mode without wpa_supplicant, the AP 
> selection code already refuses to select any APs without encryption enabled 
> if the default key is set. In adhoc mode, there's no such check, but I'm not 
> sure how much it matters.

Not quite.  Somewhere along the line WEXT turned ENCODE_RESTRICTED into
the selector for Shared Key, while ENCODE_OPEN is Open System.  Arguably
there's a larger need to specifying auth mode than rejecting unencrypted
associations.  Most drivers do it this way, with the exception of
madwifi because they like to be irritatingly different.  Nobody ever
really used the 'don't accept unencrypted' thing anyway in the old days,
plus ENCODEEXT has a separate flag for this.

So I think the patch is correct.  Ideally all this gets fixed and all
the overloaded meanings go away with cfg80211 :)

Acked-by: Dan Williams <dcbw@redhat.com>

Dan


