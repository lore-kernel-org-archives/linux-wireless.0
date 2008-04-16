Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:59170 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbYDPRzK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 13:55:10 -0400
Subject: Re: 2.6.25-rc9 -- bcm4306 performance is in the toilet
From: Pavel Roskin <proski@gnu.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a44ae5cd0804161045h37aafedbk5ff69bbb3c5ff850@mail.gmail.com>
References: <48056406.2060502@gmail.com> <48060D71.6020507@lwfinger.net>
	 <a44ae5cd0804161012w7c07efb0w68f9a8664f077556@mail.gmail.com>
	 <1208367041.11676.55.camel@johannes.berg>
	 <a44ae5cd0804161045h37aafedbk5ff69bbb3c5ff850@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 13:55:07 -0400
Message-Id: <1208368507.2979.4.camel@dv> (sfid-20080416_192734_529711_0B173BF8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-16 at 13:45 -0400, Miles Lane wrote:

> Am I required to get the linux-wireless git kernel tree in order to
> get the newer nl80211.h?

You can take the latest compat-wireless, as suggested on the iw page:
http://linuxwireless.org/en/users/Documentation/iw

> I checked in the 2.6.25-rc9 tree and was surprised to find four copies
> of nl80211.h:
> 0 2008-04-14 23:48 ./include/config/nl80211.h
> 10074 2008-04-11 16:32 ./include/linux/nl80211.h
> 510 2008-04-11 16:32 ./net/wireless/nl80211.h
> 10074 2008-04-15 05:50 ./usr/include/linux/nl80211.h
> 
> It seems interesting that two copies have the same byte count and that
> one of the files is empty.  What's up with that?

Only files in "include" are for external use.  Files under
"include/config" indicate kernel configuration.  You don't need that.
That leaves include/linux/nl80211.h

Another approach.  iw sources include linux/nl80211.h, and defconfig
refers to "include".  That gives the same answer.

-- 
Regards,
Pavel Roskin
