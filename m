Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3379 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbYG3OdX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 10:33:23 -0400
Date: Wed, 30 Jul 2008 10:30:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/6] mac80211: allow no mac address until firmware load
Message-ID: <20080730143003.GB19408@tuxdriver.com> (sfid-20080730_163327_490908_B54AE61D)
References: <200807281544.33509.mb@bu3sch.de> <1217253397.6364.2.camel@localhost> <200807281600.39103.mb@bu3sch.de> <1217257174.28198.27.camel@localhost.localdomain> <1217257628.15381.2.camel@johannes.berg> <1217258040.28198.40.camel@localhost.localdomain> <1ba2fa240807280858o4020fec8k4c287567dff177ca@mail.gmail.com> <1217262158.28198.44.camel@localhost.localdomain> <1217416640.6379.144.camel@localhost> <1217417721.11432.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217417721.11432.21.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 30, 2008 at 07:35:21AM -0400, Dan Williams wrote:
> On Wed, 2008-07-30 at 13:17 +0200, Luis Carlos Cobo wrote:
> > So I see three options:
> > 
> > 1) Use 00:... and be happy. No problem with udev, we use an address that
> > is actually valid.
> > 
> > 2) Use 01:00... and fix udev so it ignores it.
> > 
> > 3) Use 44:44..., because it is what orinoco used and fix udev so it
> > ignores it.
> > 
> > I would go for solution 2, 00:00:00:00:00:00 is a valid address for a
> > device and multicast addresses are not, and that should be reflected on
> > udev's policy.
> 
> I guess, but having a zero MAC seems more logical to me, and it's also
> the failure case if something doesn't get properly initialized.  WEXT
> uses it for "disassociated".  We already check for the zero MAC in a
> number of places.

I'm with Dan -- use all zeroes.

John
-- 
John W. Linville
linville@tuxdriver.com
