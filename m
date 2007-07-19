Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2235 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763049AbXGSWCq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 18:02:46 -0400
Date: Thu, 19 Jul 2007 17:58:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: bcm4301: A mac80211 driver using V3 firmware
Message-ID: <20070719215801.GB12449@tuxdriver.com>
References: <46963C0F.3080104@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46963C0F.3080104@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 12, 2007 at 09:34:55AM -0500, Larry Finger wrote:

> My plan is to clean up the code, check it with my BCM4306 and BCM4318 
> devices, and then make it available as a patch against the mainline source 
> for more general testing. At the same time, I will publish the results of 
> my performance testing of all 3 models. Once it is shown to be reliable, a 
> decision can be made regarding its inclusion in mainline and if it should 
> support B and G devices, or be restricted to B-only devices. The A-PHY code 
> has been stripped out.

This sounds great.  Perhaps this can be the migration vehicle for
current bcm43xx users to come to mac80211?  Especially for those with
hardware not supported by the current bcm43xx-mac80211 driver.

Are you proposing to add a third driver and deprecate the softmac
driver?  Or can we treat this as a port of the existing driver
to mac80211?  I think that might be better for users and distros,
and might let us get rid of the softmac component that much sooner.

As for the name, if we treat this as a port of the current driver to
mac80211 then perhaps we should just continue using the "bcm43xx" name?
If so, we need a new name for the v4-based driver -- "bcm43xxtoo"? :-)

Regarding hardware support, I have begun to lean towards having
the v3 driver continue to support all the hardware it does now.
I'm certainly prepared to hear the downside of that position. :-)
What exactly do we gain from using the v4 firmware?

Anyway, I'm glad to hear we are making progress on this front.
Good job, Larry!

John
-- 
John W. Linville
linville@tuxdriver.com
