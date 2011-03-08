Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab1CHTjZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 14:39:25 -0500
Subject: Re: 2.6.38-rc7, iwlagn warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>, wwguy <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTinJ3RU+6asQrOmKdW6-EkL8Jw2BXOTuZKqw_Vdu@mail.gmail.com>
References: <AANLkTin0PGOfHr3AvQk-BAhyMY7ihYMU1-wX4RJG=1YT@mail.gmail.com>
	 <20110304134648.GB9866@tuxdriver.com>
	 <1299251879.24333.3.camel@wwguy-ubuntu>
	 <AANLkTinfCc0e4BtBxoq7MHtgv54HJk-yU=gQj9Xm_=R9@mail.gmail.com>
	 <AANLkTi=+jfk5+tWewwnx+SHj+FQAXd03sPC3mDW32GUK@mail.gmail.com>
	 <AANLkTikUE-LLSBNH=cNmPZ+Wenff5RxKcfK0kJXp9Wk+@mail.gmail.com>
	 <1299334144.3826.8.camel@jlt3.sipsolutions.net>
	 <AANLkTikQHUq95e9=3tG5WrayaxUu+K1FdAftJ3y72BTn@mail.gmail.com>
	 <1299597447.4676.25.camel@jlt3.sipsolutions.net>
	 <AANLkTinj1f0Kx5X6eqYEdyzT_3XLbtbLtwbp7jPN2LSH@mail.gmail.com>
	 <1299602750.3734.2.camel@jlt3.sipsolutions.net>
	 <AANLkTimBfOM8yxdh_Z4Bw_ww4WRtQXzdoEx6ZL_TT5YU@mail.gmail.com>
	 <1299604680.3734.4.camel@jlt3.sipsolutions.net>
	 <AANLkTimgroA-LoAR1WftEZxNnBHtUwSGENpdWMEPMKaF@mail.gmail.com>
	 <1299608207.31279.19.camel@dcbw.foobar.com>
	 <AANLkTinJ3RU+6asQrOmKdW6-EkL8Jw2BXOTuZKqw_Vdu@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 20:39:15 +0100
Message-ID: <1299613155.3734.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-08 at 19:10 +0000, Mathias Burén wrote:

> > Could you also grab /var/log/daemon.log or /var/log/NetworkManager.log,
> > whichever one exists?  And just to  make sure, when this problem
> > happens, there is only one wpa_supplicant running at the time, right?
> > Is something like wicd also running?
> >
> > The logs there look like something external is telling the supplicant to
> > disassociate, which could be NM or some other tool, but NM should not be
> > exhibiting this behavior if NM itself was used to start the adhoc
> > network.

> dameon.log http://www.2shared.com/file/9ntZ37Q9/daemon.html
> 
> I think the problem is Ubuntu-related, I can see error messages about
> dnsmasq (which NetworkManager uses for its DHCP purposes, right). I
> set the phone to static IPs, then suddenly the whole thing started
> working. No warning in dmesg...

Yeah -- if you configure /etc/dnsmasq.conf to not listen on all
interfaces, or you just disable it, then it should all work.

In any case, I'll look more into the warning, but even if I fix the
warning it won't really work any better for you until you manage to fix
the dnsmasq thing -- maybe file a bug against Ubuntu.

johannes

