Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:38615 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbXC1Udg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 16:33:36 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HWenn-0005bI-4J
	for linux-wireless@vger.kernel.org; Wed, 28 Mar 2007 16:31:27 -0400
Subject: Re: [Radiotap] Re: RFC: radiotap discrepancy in Linux vs OpenBSD
From: Pavel Roskin <proski@gnu.org>
To: Marcelo Tosatti <marcelo@kvack.org>
Cc: David Young <dyoung@pobox.com>, linux-wireless@vger.kernel.org,
	Scott Raynel <scottraynel@gmail.com>, radiotap@mail.ojctech.com
In-Reply-To: <20070328180413.GC17793@dmt>
References: <20070325232416.64xwkc0kw04oosg0@webmail.spamcop.net>
	 <20070326033729.GG31621@che.ojctech.com> <1174949149.28132.49.camel@dv>
	 <20070328180413.GC17793@dmt>
Content-Type: text/plain
Date: Wed, 28 Mar 2007 16:33:32 -0400
Message-Id: <1175114012.9299.4.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-03-28 at 15:04 -0300, Marcelo Tosatti wrote:
> On Mon, Mar 26, 2007 at 06:45:49PM -0400, Pavel Roskin wrote:
> > On Sun, 2007-03-25 at 22:37 -0500, David Young wrote:
> > 
> > > > One is found in the current wireless-2.6.git:
> > > > 
> > > >         IEEE80211_RADIOTAP_RX_FLAGS = 14,
> > > >         IEEE80211_RADIOTAP_TX_FLAGS = 15,
> > > >         IEEE80211_RADIOTAP_RTS_RETRIES = 16,
> > > >         IEEE80211_RADIOTAP_DATA_RETRIES = 17,
> > > 
> > > These fields are slated to become part of the standard, I just haven't got
> > > around to updating the manual page, yet.  I have time to do that tonight.
> > 
> > OK.  I was wrong to assume that non-standard fields were introduced on
> > the Linux side.
> 
> I mentioned those in the past to David Young, but I forgot to resend
> them to the radiotap list. 

Then we need to remove IEEE80211_RADIOTAP_FCS from Linux
ieee80211_radiotap.h.  It's only present in a comment, but it's a
comment that can be harmful.  I could submit a patch, but it would
conflict with a patch that does sparse annotation.

OK, I'll submit both.

-- 
Regards,
Pavel Roskin

