Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:38412 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbZEVAUQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 20:20:16 -0400
Received: by bwz22 with SMTP id 22so1334298bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2009 17:20:16 -0700 (PDT)
Subject: Re: [BUG] Crda oopses the system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1242742647.23110.10.camel@ibm172>
References: <1241499867.4816.18.camel@maxim-laptop>
	 <43e72e890905121500k61545ff3mcdf099a08178b72c@mail.gmail.com>
	 <1242166051.26484.7.camel@maxim-laptop>
	 <43e72e890905131428r568e6f5eyd64566e993c83d8c@mail.gmail.com>
	 <1242256104.3241.4.camel@maxim-laptop>
	 <43e72e890905131612w275685d2tfe5066453b8b255e@mail.gmail.com>
	 <1242256950.3241.13.camel@maxim-laptop>
	 <43e72e890905131628i51255cd0wc16b7827a2514413@mail.gmail.com>
	 <1242258469.3241.19.camel@maxim-laptop>
	 <43e72e890905131707k2933f3cftfdec6e632f5b9fc3@mail.gmail.com>
	 <b6c5339f0905140720p29be483cr1968f50a6bea48e5@mail.gmail.com>
	 <1242742647.23110.10.camel@ibm172>
Content-Type: text/plain
Date: Fri, 22 May 2009 03:20:11 +0300
Message-Id: <1242951611.5206.9.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-05-19 at 17:17 +0300, Maxim Levitsky wrote:
> On Thu, 2009-05-14 at 10:20 -0400, Bob Copeland wrote:
> > On Wed, May 13, 2009 at 8:07 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > >>
> > >> I wish I had time to set up, an ath5k in AP mode. There are rumors that
> > >> it works more or less now, then I could use the same beacon frame to
> > >> test.
> > >
> > > It does and if it doesn't its a bug.
> > 
> > Just FYI, it's known to have problems if the STA uses power saving --
> > ath5k never updates the beacon.  I have a patch that should work in the
> > relevant bugzilla but I haven't been back to retest it (at first I
> > thought it was causing hangs, but later realized the hangs were due to
> > other bugs in w-t).
> > 
> 

I was just able to reproduce that bug on latest wireless-testing that I
belive contains the patches you sent for me to test.
I reproduced it against ath5k running in AP mode at home.

I finally made the ath5k send beacons (although not much works besides
this).


Note that I noticed that this bug happens once at boot, if I set NM to
use system settings, when I try to connect again it doesn't happen. Its
a race condition after all.

Best regards,
	Maxim Levitsky


