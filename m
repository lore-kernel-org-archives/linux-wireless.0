Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:18763 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbXLMAba (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 19:31:30 -0500
Subject: Re: mac80211 ethtool support
From: Pavel Roskin <proski@gnu.org>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240712121523h59d919f8k42fe54b992618432@mail.gmail.com>
References: <1197361048.3170.381.camel@debian.sh.intel.com>
	 <200712111350.25522.mb@bu3sch.de>
	 <1197421988.3170.405.camel@debian.sh.intel.com>
	 <200712121148.48716.mb@bu3sch.de> <1197481520.6558.140.camel@johannes.berg>
	 <1ba2fa240712121523h59d919f8k42fe54b992618432@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 19:31:28 -0500
Message-Id: <1197505888.13188.9.camel@dv> (sfid-20071213_003135_139409_D4439CB3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-12-13 at 01:23 +0200, Tomas Winkler wrote:

> > NACK. Which virtual interface should get this? wmaster sounds like the
> > "obvious" candidate but we want to get rid of it ASAP. And the others
> > ones are pretty wrong because you can, technically, have a wiphy without
> > any virtual interfaces on it.
> >
> Just a thought. What if all virtual interfaces will quasi implements
> it. It doesn't matter if all the interfaces answers the same.

I think The True Linux Way (c) would be to have EEPROM support for
devices (those that live in /sys/device) without tying it to network
interfaces or cfg80211.

See __ATTR in include/linux/device.h, although I'm not sure if
attributes are suitable for EEPROM as is.

Maybe EEPROM should even be a separate class of devices connected to
other devices.

Of course, the topic would be better suited for LKML.

-- 
Regards,
Pavel Roskin
