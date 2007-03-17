Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933045AbXCQEf5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 00:35:57 -0400
Subject: Re: [PATCH 3/5] mac80211: fix key restricted/open display
From: Dan Williams <dcbw@redhat.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Hong Liu <hong.liu@intel.com>, Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200703162357.22669.flamingice@sourmilk.net>
References: <1174015698.3408.41.camel@devlinux-hong>
	 <200703161328.41006.flamingice@sourmilk.net>
	 <1174103177.3026.8.camel@localhost.localdomain>
	 <200703162357.22669.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 00:38:36 -0400
Message-Id: <1174106316.3026.19.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-03-16 at 23:57 -0400, Michael Wu wrote:
> On Friday 16 March 2007 23:46, Dan Williams wrote:
> > I think you're misreading the patch?  It looks correct to me.  The
> > second check for (erq->flags & IW_ENCODE_RESTRICTED) should ensure that
> > Shared Key is only selected when the userspace program requested it.
> >
> This breaks authentication algorithm fallback for sure.

Well, then it's broken in most of the non mac80211 drivers then.

> > Not quite.  Somewhere along the line WEXT turned ENCODE_RESTRICTED into
> > the selector for Shared Key, while ENCODE_OPEN is Open System.  Arguably
> > there's a larger need to specifying auth mode than rejecting unencrypted
> > associations.  Most drivers do it this way, with the exception of
> > madwifi because they like to be irritatingly different.  Nobody ever
> > really used the 'don't accept unencrypted' thing anyway in the old days,
> > plus ENCODEEXT has a separate flag for this.
> >
> Even if it got redefined along the way, mac80211 has no need for that 
> particular definition since it can automatically cycle between authentication 
> algorithms. Besides, "its meaning depends on the card used" according to the 
> iwconfig man page.

Well, if mac80211 can cycle (is this like airo's auto_wep?) then I guess
we don't care about the auth mode.  As long as we don't break userspace
programs that try to set the auth mode, I'm fine with that.

> > So I think the patch is correct.  Ideally all this gets fixed and all
> > the overloaded meanings go away with cfg80211 :)
> >
> > Acked-by: Dan Williams <dcbw@redhat.com>
> >
> NACK. It is not useful and if implemented, gives the user an unnecessary 
> choice that can only cause more problems.

As long as existing stuff isn't broken, and as long as mac80211 silently
ignores it, and as long as the auth cycle stuff works, then fine.

Dan


