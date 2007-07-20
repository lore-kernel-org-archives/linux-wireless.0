Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:41447 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751965AbXGTBi1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 21:38:27 -0400
Message-ID: <46A01209.4030200@lwfinger.net>
Date: Thu, 19 Jul 2007 20:38:17 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Stefano Brivio <stefano.brivio@polimi.it>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: bcm4301: A mac80211 driver using V3 firmware
References: <46963C0F.3080104@lwfinger.net>	<20070719215801.GB12449@tuxdriver.com> <20070720012714.0dc0298a@morte>
In-Reply-To: <20070720012714.0dc0298a@morte>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefano Brivio wrote:
> On Thu, 19 Jul 2007 17:58:01 -0400
> "John W. Linville" <linville@tuxdriver.com> wrote:
> 
>> Are you proposing to add a third driver and deprecate the softmac
>> driver?  Or can we treat this as a port of the existing driver
>> to mac80211?  I think that might be better for users and distros,
>> and might let us get rid of the softmac component that much sooner.
> 
> I agree. Let's treat this as a port, as soon as it's stable. By the way, I
> hope I'll be able to contribute again starting on July, 25.

For the initial tests, it will be a third driver called bcm4301; however, it is a port and should be 
presented as such.

>> As for the name, if we treat this as a port of the current driver to
>> mac80211 then perhaps we should just continue using the "bcm43xx" name?
>> If so, we need a new name for the v4-based driver -- "bcm43xxtoo"? :-)
> 
> Should the ported driver support 802.11g devices as well, it should be
> called bcm43xx, IMHO. Else, IIRC, we already discussed that and it should
> be called bcm4301. bcm43xx-mac80211 could be renamed to "bcm43xx-v4", it
> would be more meaningful than "bcm43xtoo", maybe.
> 
>> Regarding hardware support, I have begun to lean towards having
>> the v3 driver continue to support all the hardware it does now.
> 
> I agree. But I would wait a little more time, I mean, when the ported driver
> is stable, then let's consider the status of "bcm43xx-v4". Michael is
> actually making some progress, even if - sadly - he's alone right now.

I wish I could be of more help, but I've gotten all that I can from the specs.

> The final plan should be something like this:
> 1) bcm43xx gets stable and merged;
> 2) bcm43xx-mac80211 is renamed to bcm43xx-v4 and doesn't get merged;
> 3) when bcm43xx-v4 gets stable, the PCI IDs list of bcm43xx gets stripped
> down and it is renamed to bcm4301, while bcm43xx-v4 is renamed to bcm43xx.
> 
> This could lead to some troubles. The other possible plan:
> 1) bcm43xx-mac80211 gets stable and merged, while bcm43xx is renamed to
> bcm4301 and its PCI IDs list stripped down;
> would sound a lot simpler. Even if the first plan could be better for users
> and distributions. So I'd say, let's have a stable driver at least, before
> to take a decision.
> 
>> What exactly do we gain from using the v4 firmware?
> 
> Other than crypto hardware, support for 802.11n devices, and maybe 802.11a
> devices too (I started working on that but I'm not doing that right now).
> 
>> Anyway, I'm glad to hear we are making progress on this front.
>> Good job, Larry!
> 
> Me too! Good job!

Thanks guys for your comments and compliments.

My preferred plan is as follows:

1. For more general testing, I'll distribute my driver as a patch to be applied to wireless-dev as 
it needs ssb, which is not yet in mainline. If we are still in testing when ssb is merged, I'll 
change to making patches against mainline.

2. Once the problems have been cleared and ssb is in -mm, it gets sent there as a port from softmac 
to mac80211 for the current bcm43xx. An additional consideration is that a port from softmac to 
mac80211 will be more easily merged than if it looks like a new driver.

3. If the port of softmac to mac80211 is merged before Michael's driver, it will be known as bcm43xx 
with bcm43xx-mac80211 remaining in wireless-dev.

4. Once bcm43xx-mac80211 gets merged to mainline, then Michael's driver should become bcm43xx and my 
driver gets its PCI IDs stripped to the 802.11b-only devices and once again becomes bcm4301. This 
name change for Michael's driver would cause some disruption for current users as their firmware 
would have the wrong name/version. That might be too much of a problem.

I think this is a path that always has a stable driver with at least moderate performance in 
mainline throughout the entire transformation. When either driver gets merged, that will be one more 
nail in softmac's coffin!

Larry
