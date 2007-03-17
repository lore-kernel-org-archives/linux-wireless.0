Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbXCQRUw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 13:20:52 -0400
Subject: Re: [PATCH 3/5] mac80211: fix key restricted/open display
From: Dan Williams <dcbw@redhat.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Hong Liu <hong.liu@intel.com>, Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200703170058.01020.flamingice@sourmilk.net>
References: <1174015698.3408.41.camel@devlinux-hong>
	 <200703162357.22669.flamingice@sourmilk.net>
	 <1174106316.3026.19.camel@localhost.localdomain>
	 <200703170058.01020.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 13:23:28 -0400
Message-Id: <1174152208.7163.4.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-03-17 at 00:57 -0400, Michael Wu wrote:
> On Saturday 17 March 2007 00:38, Dan Williams wrote:
> > On Fri, 2007-03-16 at 23:57 -0400, Michael Wu wrote:
> > > On Friday 16 March 2007 23:46, Dan Williams wrote:
> > > > I think you're misreading the patch?  It looks correct to me.  The
> > > > second check for (erq->flags & IW_ENCODE_RESTRICTED) should ensure that
> > > > Shared Key is only selected when the userspace program requested it.
> > >
> > > This breaks authentication algorithm fallback for sure.
> >
> > Well, then it's broken in most of the non mac80211 drivers then.
> >
> Why is that? The reason this breaks mac80211 is because auth_algs is a 
> bitfield which indicates what authentication algorithms can be used. This 
> patch makes it so that if a user chooses an authentication algorithm, that is 
> the only one that will ever be used.

Well, what I meant here was that older fullmac drivers don't do fallback
and users must explicitly choose the auth method they required (which
sucks).  Therefore, we've got to make sure that everything works as
expected.  And I think you're right, mac80211 can just ignore requests
to explicitly set the WEP auth alg.

> > Well, if mac80211 can cycle (is this like airo's auto_wep?) then I guess
> > we don't care about the auth mode.  As long as we don't break userspace
> > programs that try to set the auth mode, I'm fine with that.
> >
> mac80211 should just ignore the bits. Airo's auto_wep appears to cycle through 
> different encryption keys while mac80211 does not.

Half-right.  auto_wep can be 0 -> 4.  0 is off, and 1 - 4 is the max
index of WEP keys to try.  It cycles through _both_ the WEP keys and the
auth modes trying each one out of the card isn't currently connected.
Sort of crack to include the WEP keys too, but it appears to be the same
thing.

Dan


