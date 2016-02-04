Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46201 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbcBDMvb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 07:51:31 -0500
Message-ID: <1454590287.2564.9.camel@sipsolutions.net> (sfid-20160204_135147_252014_6986FE79)
Subject: Re: mac80211_hwsim + iperf + netns
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 04 Feb 2016 13:51:27 +0100
In-Reply-To: <CABPxzY+N=3cuMB4Z7q6gqPkhh1GoiCrpG6G3E2bHLB96oqZfyw@mail.gmail.com> (sfid-20160204_134343_938123_4EC6FB6C)
References: <CABPxzY+HpP=NTrAaUEzV5nFm=LK93m=kxPV14-cdftt+VPsWNw@mail.gmail.com>
	 <CA+BoTQ=s_SMgs9zkgYjKOHKDwRORWk-Re7XZ=AiKiHCuNc0L8A@mail.gmail.com>
	 <1454588396.2564.7.camel@sipsolutions.net>
	 <CABPxzYL3mGHyoKE0tkL4yg_4NL+U41+15Bm3f=JPq2vfD+Xnkg@mail.gmail.com>
	 <1454589301.2564.8.camel@sipsolutions.net>
	 <CABPxzY+N=3cuMB4Z7q6gqPkhh1GoiCrpG6G3E2bHLB96oqZfyw@mail.gmail.com>
	 (sfid-20160204_134343_938123_4EC6FB6C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-02-04 at 18:13 +0530, Krishna Chaitanya wrote:
> On Thu, Feb 4, 2016 at 6:05 PM, Johannes Berg <johannes@sipsolutions.
> net> wrote:
> > On Thu, 2016-02-04 at 17:58 +0530, Krishna Chaitanya wrote:
> > > On Thu, Feb 4, 2016 at 5:49 PM, Johannes Berg <johannes@sipsoluti
> > > ons.
> > > net> wrote:
> > > > On Thu, 2016-02-04 at 12:32 +0100, Michal Kazior wrote:
> > > > > 
> > > > >  ip netns add ns1
> > > > >  ip netns exec ns1 bash # get the PID in the session and
> > > > > don't
> > > > > close
> > > > > it
> > > > >  iw phy phyX set netns $pid_of_that_shell
> > > > > 
> > > > 
> > > > If you also have a recent enough iw version, you can use
> > > > 
> > > > iw phy phyX set netns name ns1
> > > > 
> > > My iw has this option, but it throws an error.
> > > Does this command have any prerequisites?
> > > 
> > > # iw phy phy1 set netns name ns1
> > > Invalid parameter: nsname(name)
> > > 
> > 
> > This happens if the ns1 doesn't exist.
> ok, so we need latest iprotue2 to create the
> namespace?

for this way to work, yes. you could hack your own C program to do the
required unshare() call and exec bash and then use the PID ... I used
to have one but can't find it now.

johannes
