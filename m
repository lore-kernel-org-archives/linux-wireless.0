Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34220 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZBEO7W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 09:59:22 -0500
Subject: Re: [PATCH RFC] mac80211: Filter scan results
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Johannes Berg <johannes@sipsolutions.net>,
	Samuel Ortiz <samuel@sortiz.org>,
	John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240902050500p6d8e01d3k6b934f904bd41395@mail.gmail.com>
References: <20090204150857.GA5069@sortiz.org>
	 <1233789837.24227.19.camel@localhost.localdomain>
	 <1233790539.7390.23.camel@johannes.local>
	 <20090205084407.GA11126@jm.kir.nu> <20090205095217.GA13736@jm.kir.nu>
	 <1ba2fa240902050344h1deb4c3dqce0949ec154faba4@mail.gmail.com>
	 <20090205121222.GB18339@jm.kir.nu>
	 <1ba2fa240902050500p6d8e01d3k6b934f904bd41395@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 09:57:43 -0500
Message-Id: <1233845863.3028.9.camel@localhost> (sfid-20090205_155926_071730_F02173EB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-02-05 at 15:00 +0200, Tomas Winkler wrote:
> On Thu, Feb 5, 2009 at 2:12 PM, Jouni Malinen <j@w1.fi> wrote:
> > On Thu, Feb 05, 2009 at 01:44:15PM +0200, Tomas Winkler wrote:
> >
> >> Just a thought If user space will be able to merge 2 scan results we
> >> can then split then in 2 separate reports....
> >
> > Theoretically speaking, yes, WEXT could be extended to do this with some
> > kind of scan parameter that indicates which 64 kB block is requested.
> > However, I would not suggest going there and I would probably object to
> > a patch that tries to do this either in the kernel or in wpa_supplicant
> > for that matter.
> 
> I thin it can be done w/o extension of  wext, j ust the eviction of
> old scan results is done
> in user space.IRCC the time stamp of beacon/probe is part of each
> entry. And user space state machine should be able to react on
> nl[SIOCGIWSCAN] w/o issuing ioctl[SIOCSIWSCAN]:

I still don't like this.  If 177 BSSes is not enough, then get the
cfg80211 stuff working better for you.  I can't think of how this scheme
would work; which half of the results get returned when something calls
SIOCGIWSCAN?  Would the driver/stack internally flip to the other half
of the results on each call of SIOCGIWSCAN?  That doesn't work, because
then two userspace processes requesting scan results will race with each
other for them.  We had this problem before when drivers cleared the
scan list each time SIOCGIWSCAN was called.

Dan

> > If you really end up hitting a case that does not work reasonably well
> > with 64 kB fix in user space, I would suggest looking into the
> > cfg80211/nl80211 scan stuff. The only additional thing it needs in such
> > an environment is to get better optimized data structure (for which,
> > there is already a proposed implementation, too).
> 
> Guess we need to proceed with cfg anyway
> 
> Tomas
> 
> > --
> > Jouni Malinen                                            PGP id EFC895FA
> >

