Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:48730 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934822AbXGSXpt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 19:45:49 -0400
Date: Fri, 20 Jul 2007 01:27:14 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: bcm4301: A mac80211 driver using V3 firmware
Message-ID: <20070720012714.0dc0298a@morte>
In-Reply-To: <20070719215801.GB12449@tuxdriver.com>
References: <46963C0F.3080104@lwfinger.net>
	<20070719215801.GB12449@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 19 Jul 2007 17:58:01 -0400
"John W. Linville" <linville@tuxdriver.com> wrote:

> Are you proposing to add a third driver and deprecate the softmac
> driver?  Or can we treat this as a port of the existing driver
> to mac80211?  I think that might be better for users and distros,
> and might let us get rid of the softmac component that much sooner.

I agree. Let's treat this as a port, as soon as it's stable. By the way, I
hope I'll be able to contribute again starting on July, 25.
 
> As for the name, if we treat this as a port of the current driver to
> mac80211 then perhaps we should just continue using the "bcm43xx" name?
> If so, we need a new name for the v4-based driver -- "bcm43xxtoo"? :-)

Should the ported driver support 802.11g devices as well, it should be
called bcm43xx, IMHO. Else, IIRC, we already discussed that and it should
be called bcm4301. bcm43xx-mac80211 could be renamed to "bcm43xx-v4", it
would be more meaningful than "bcm43xtoo", maybe.

> Regarding hardware support, I have begun to lean towards having
> the v3 driver continue to support all the hardware it does now.

I agree. But I would wait a little more time, I mean, when the ported driver
is stable, then let's consider the status of "bcm43xx-v4". Michael is
actually making some progress, even if - sadly - he's alone right now. 

The final plan should be something like this:
1) bcm43xx gets stable and merged;
2) bcm43xx-mac80211 is renamed to bcm43xx-v4 and doesn't get merged;
3) when bcm43xx-v4 gets stable, the PCI IDs list of bcm43xx gets stripped
down and it is renamed to bcm4301, while bcm43xx-v4 is renamed to bcm43xx.

This could lead to some troubles. The other possible plan:
1) bcm43xx-mac80211 gets stable and merged, while bcm43xx is renamed to
bcm4301 and its PCI IDs list stripped down;
would sound a lot simpler. Even if the first plan could be better for users
and distributions. So I'd say, let's have a stable driver at least, before
to take a decision.

> What exactly do we gain from using the v4 firmware?

Other than crypto hardware, support for 802.11n devices, and maybe 802.11a
devices too (I started working on that but I'm not doing that right now).

> Anyway, I'm glad to hear we are making progress on this front.
> Good job, Larry!

Me too! Good job!


-- 
Ciao
Stefano
