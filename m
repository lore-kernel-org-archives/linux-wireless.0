Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46139 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932604AbcBDMfE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 07:35:04 -0500
Message-ID: <1454589301.2564.8.camel@sipsolutions.net> (sfid-20160204_133511_774506_606C83BF)
Subject: Re: mac80211_hwsim + iperf + netns
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 04 Feb 2016 13:35:01 +0100
In-Reply-To: <CABPxzYL3mGHyoKE0tkL4yg_4NL+U41+15Bm3f=JPq2vfD+Xnkg@mail.gmail.com> (sfid-20160204_132919_648388_1E9DFAD5)
References: <CABPxzY+HpP=NTrAaUEzV5nFm=LK93m=kxPV14-cdftt+VPsWNw@mail.gmail.com>
	 <CA+BoTQ=s_SMgs9zkgYjKOHKDwRORWk-Re7XZ=AiKiHCuNc0L8A@mail.gmail.com>
	 <1454588396.2564.7.camel@sipsolutions.net>
	 <CABPxzYL3mGHyoKE0tkL4yg_4NL+U41+15Bm3f=JPq2vfD+Xnkg@mail.gmail.com>
	 (sfid-20160204_132919_648388_1E9DFAD5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-02-04 at 17:58 +0530, Krishna Chaitanya wrote:
> On Thu, Feb 4, 2016 at 5:49 PM, Johannes Berg <johannes@sipsolutions.
> net> wrote:
> > On Thu, 2016-02-04 at 12:32 +0100, Michal Kazior wrote:
> > > 
> > >  ip netns add ns1
> > >  ip netns exec ns1 bash # get the PID in the session and don't
> > > close
> > > it
> > >  iw phy phyX set netns $pid_of_that_shell
> > > 
> > 
> > If you also have a recent enough iw version, you can use
> > 
> > iw phy phyX set netns name ns1
> > 
> My iw has this option, but it throws an error.
> Does this command have any prerequisites?
> 
> # iw phy phy1 set netns name ns1
> Invalid parameter: nsname(name)
> 

This happens if the ns1 doesn't exist.

johannes
