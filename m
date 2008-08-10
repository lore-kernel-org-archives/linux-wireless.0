Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:6224 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbYHJHYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2008 03:24:39 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1747282rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2008 00:24:38 -0700 (PDT)
Message-ID: <c85cb4470808100024q2261332ej91bc75b16d6edf0e@mail.gmail.com> (sfid-20080810_092452_453196_BB66E01C)
Date: Sun, 10 Aug 2008 10:24:38 +0300
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: Driver for the FullMAC card
Cc: "Dan Williams" <dcbw@redhat.com>, Dmitry <dbaryshkov@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1217535529.15900.4.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <g6qr98$q28$2@ger.gmane.org>
	 <1217512488.12016.8.camel@localhost.localdomain>
	 <bc64b4640807310715j41bb0029i5c8be73a311ed52@mail.gmail.com>
	 <1217514241.12016.13.camel@localhost.localdomain>
	 <1217517571.22143.17.camel@dv>
	 <1217534415.9377.12.camel@localhost.localdomain>
	 <1217535529.15900.4.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Thu, 2008-07-31 at 16:00 -0400, Dan Williams wrote:
>
> > Guess I misunderstood the scope of p80211 then.  So the prism2 usb stuff
> > really is fullmac then?  Or at least quasi-mac like the ipw2x00 cards?
>
> It's as FullMAC as it can get.  It's the same Prism chipset, just
> connected to the host system in a different way.  I don't think it's
> doing anything differently on the wireless side.
>
> Sure enough, there are some knobs to dumb it down, but probably not to
> the SoftMAC level.  I don't think it was tried, and I don't think it's
> worth trying.
>

I am not familiar at all with the prism and p80211 current status, so
taking the risk of mis-understanding Dmitry's initial mail, it does
look like one of the topics we discussed in the OLS, concluded that
fullMac best support would probably be handled by moving through
cfg80211 and see what's missing there. this approach will have 2
benefits - there is already code that can be used (and improved)
there, and there is an initial set of actions that any fullMac HW is
likely to support so developer can save lots of efforts redefining
fullMac behaviour.

Ron
