Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:15336 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759016AbYAYXUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 18:20:41 -0500
Received: by fg-out-1718.google.com with SMTP id e21so812102fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2008 15:20:39 -0800 (PST)
Message-ID: <247d6d340801251520g75fb2701nb2c0ce71f1d178e6@mail.gmail.com> (sfid-20080125_232049_135506_771AF0D4)
Date: Sat, 26 Jan 2008 01:20:39 +0200
From: "Guy Cohen" <guy@cguy.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Linux 2.6.24-rc7
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"Michael Buesch" <mb@bu3sch.de>, "Dan Williams" <dcbw@redhat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080125224631.GH14687@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	 <alpine.LFD.1.00.0801250934030.14161@hp.linux-foundation.org>
	 <alpine.LFD.1.00.0801251011590.14161@hp.linux-foundation.org>
	 <200801251930.27022.mb@bu3sch.de>
	 <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org>
	 <20080125194807.GD14687@tuxdriver.com>
	 <20080125195037.GE14687@tuxdriver.com>
	 <20080125211815.GF14687@tuxdriver.com>
	 <alpine.LFD.1.00.0801251354350.5056@hp.linux-foundation.org>
	 <20080125224631.GH14687@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/26/08, John W. Linville <linville@tuxdriver.com> wrote:
> On Fri, Jan 25, 2008 at 01:56:15PM -0800, Linus Torvalds wrote:
> > And why is it suddenly smart to do this in three drivers rather than one
> > upper layer?
>
> Two drivers, FWIW... :-)

IMO, The right place to put a conditional memmove is at the 802.11 to
802.3 conversion. currnetly iwlwifi always hands an aligned 802.11
frame to mac80211. If it is needed to re-align the frame after
stripping the odd 802.11 header to support CPUs that can't handle it,
it makes sense to do it there.

> John
