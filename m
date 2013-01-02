Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3ABOlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:41:08 -0500
Message-ID: <1357137688.9839.43.camel@jlt4.sipsolutions.net> (sfid-20130102_154112_296903_A0F65E82)
Subject: Re: [PATCH] nl80211: allow ad-hoc to set WMM parameters from outside
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 02 Jan 2013 15:41:28 +0100
In-Reply-To: <201301021436.55010.chunkeey@googlemail.com> (sfid-20130102_143701_280650_6146D5CB)
References: <1354042232-32428-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <CAJ-Vmok_UDVykup4xHCigrBbzErOhUQOZMATJ+=qkBFOHQS+Bg@mail.gmail.com>
	 <1357131499.9839.19.camel@jlt4.sipsolutions.net>
	 <201301021436.55010.chunkeey@googlemail.com>
	 (sfid-20130102_143701_280650_6146D5CB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-02 at 14:36 +0100, Christian Lamparter wrote:

> I can't find anything useful in the 802.11-2012 spec either. There's
> something vague in 4.7 "Difference between ESS and IBSS LANs" on page 80:
> "The services that apply to an IBSS are the SSs [Station ServiceS]. [...].
> The parameters that  control differentiation of the delivery of MSDUs with
> different priority using EDCA are >FIXED<. [...]".
> 
> But what does this mean? Does it translate into: "Every peer of an IBSS
> truly independent of each other when it comes to the WMM parameters.
> Each peer can advertise (in beacons, probes, ...) and have its own set
> of fixed parameters and no one needs to sync those from anyone else"?
> 
> Or does "fixed" just mean that everyone has to go with the default WMM
> parameters from 8-105 [i.e.: no one can change them at all]?

Yeah it's a little vague, but I think it means *fixed* as you describe.
The WMM spec describes them as fixed and also doesn't include the WMM
Parameter IE in beacons/probe responses, so all of this would be an
extension to the spec and we have to be careful not to break the spec
(default) case (which is correct right now, afaict, with default
parameters and no parameters IE)

Interoperating with FreeBSD would be useful though.

johannes


