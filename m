Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP02.calltower.com ([69.4.184.249]:42607 "EHLO
	L01SLCSMTP02.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302AbZFXWI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 18:08:28 -0400
Subject: Re: Repeater Bridge Mode with ar9170?
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1245861185.13356.2.camel@jdl-desktop>
References: <1245861185.13356.2.camel@jdl-desktop>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 17:08:30 -0500
Message-Id: <1245881310.13356.10.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-06-24 at 11:33 -0500, Jon Loeliger wrote:
> Folks,
> 
> I would like to set up a so-called "wireless repeater bridge mode"
> using an ar9170 interface and a wired ethernet interface.  I see
> that there is some support for this mode on the DD-WRT, but I was
> wondering if it is supported/available with the ar9170 driver.
> 
> If it is not already supported, can anyone point me in the right
> direction to help get it implemented?
> 
> Thanks,
> jdl

OK, so, in the other (non-mac80211) drivers, there was a mode
called IW_MODE_REPEATER that implemented 4-address framing for
clients that provided the bridging ability.

That same functionality is currently not implemented in the
mac80211 code (ie, no NL80211_IFTYPE_REPEATER mode).

My perhaps mistaken understanding of what it would take to
make this work would be to create a new NL80211_IFTYPE_REPEATER
mode that was a hybrid between _STATION and _WDS modes.  In
particular, it would act like _STATION as far as association
and authentication are concerned, but would also have _WDS-like
4-address frame handling.

Does that seem about right to you guys?  Are folks opposed to
or willing to accept development down those lines?  Or has
anyone already done such work and is willing to share?

Thanks,
jdl


