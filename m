Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from the.earth.li ([46.43.34.31]:52923 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934621Ab3DJV04 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 17:26:56 -0400
Date: Wed, 10 Apr 2013 14:26:55 -0700
From: Jonathan McDowell <noodles@earth.li>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: Re: [Ilw] Problems with Intel 2230 and AP mode
Message-ID: <20130410212655.GE31591@earth.li> (sfid-20130410_232703_105927_4BF5EBBE)
References: <20130402190831.GQ31591@earth.li>
 <0BA3FCBA62E2DC44AF3030971E174FB301965EC0@HASMSX103.ger.corp.intel.com>
 <20130403182153.GT31591@earth.li>
 <0BA3FCBA62E2DC44AF3030971E174FB301969684@HASMSX103.ger.corp.intel.com>
 <20130407220314.GX31591@earth.li>
 <0BA3FCBA62E2DC44AF3030971E174FB301969FA5@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301969FA5@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 08, 2013 at 05:52:47AM +0000, Grumbach, Emmanuel wrote:
> > > > > > >
> > > > > > > I'm trying to build my own wifi router, cobbling together
> > > > > > > a Debian (wheezy) box, hostapd (1.0) and an Intel 2230.
> > > > > > > I'm seeing various problems with the 2230 and I'm
> > > > > > > wondering if I'm mad for trying to use this card in AP
> > > > > > > mode (in which case is there an alternative Intel card I
> > > > > > > should use, or is an ath9k my best bet), or if it's
> > > > > > > worthwhile reporting the issues and trying fixes.
> > > > > > >
> > > > > > > I'm using 3.8.5 (and previously 3.8.4). I tried 3.9-rc4
> > > > > > > briefly but it was unusable - as soon as there was any
> > > > > > > traffic I saw errors like:
> > > ...
> > > > Can you please try the patch attached?
> > > >
> > > > Note that I couldn't really test it so...
> > > >
> > > > Also, it seems that the best way to reproduce the issue is to have a
> > > > station disappear while TX AMPDU is working.
> > >
> > > I suspect that's being caused by the cell phones appearing briefly and
> > > then disappearing. I've applied the patch to 3.9-rc5 (and also "iwlwifi:
> > > dvm: don't send HCMD in restart flow" which I saw hit stable but isn't
> > > in rc5) and I've had the following WARNING:
...
> > Stupid me - can you please try with this one?
> 
> Err again.... Take this one instead... Sorry...

This is looking good - up for over 48 hours now on 3.9-rc6 + your patch
and no "txq_id mismatch" messages, no WARNINGs and no sign of the
firmware restart messages either. Thanks!

J.

-- 
Real Programmers don't drink decaf.
