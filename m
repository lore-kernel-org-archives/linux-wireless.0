Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:52965 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab1CCKQR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 05:16:17 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Pv5Zu-0007iu-FD
	for linux-wireless@vger.kernel.org; Thu, 03 Mar 2011 11:16:14 +0100
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 11:16:14 +0100
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 11:16:14 +0100
To: linux-wireless@vger.kernel.org
From: jpo234 <pommnitz@yahoo.com>
Subject: Re: Regulatory database improvements
Date: Thu, 3 Mar 2011 10:15:55 +0000 (UTC)
Message-ID: <loom.20110303T105332-715@post.gmane.org>
References: <AANLkTinzfBmpJ6-O=o-zi+oh9miLRo-UZUM=MhcnQmk=@mail.gmail.com> <loom.20110303T091059-822@post.gmane.org> <AANLkTinO8mVVFuZRJVSROr=7fGAj1G2x07KSS1c+bnNx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@...> writes:
> How does an amplifier change regulatory rules? The rules are static,
> likely what you want is not per wiphy rules but per wiphy
> modifications to help you comply by the additions you are making. No?
> 
>   Luis
Well, the regulatory rules are static for off the shelf equipment. However,
there are exceptions granted by the regulator. Our equipment falls under
such an exception. Besides these regulatory restrictions there are 
restrictions on the input that the amplifier accepts.

What I want is a way to say "wlan1 is special, it must only be used on the
following channels and must not exceed the following tx power". I'm not sure
whether this is what you mean.
I want to be able to override the system wide regulatory rules on a per wiphy
base.
My specific case looks like this:
  * the tx power from the WLAN card that is fed into the amplifier must be
    restricted with rules different from the generic regulatory rules in my
    environment (the amplifier shuts down if the tx power is to high).
  * the amplifier works only on a narrow band of frequencies, so the WLAN card
    should be limited to these frequencies.
  * the frequency range that some customers are allowed to be used is even
    narrower than the range supported by the amplifier.

Regards
  Joerg

