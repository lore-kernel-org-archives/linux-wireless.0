Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37113 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380Ab1IANSb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 09:18:31 -0400
Subject: Re: [PATCH v2 1/4] nl80211: Parse channel type attribute in an
 IBSS join request
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <an.alexsimon@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <2366540.2f8oa1FYLX@alex-1> (sfid-20110831_154959_513147_E3C5B58E)
References: <2053881.ENil2Dy3QM@alex-1>
	 <1314772577.4161.12.camel@jlt3.sipsolutions.net>
	 <2366540.2f8oa1FYLX@alex-1> (sfid-20110831_154959_513147_E3C5B58E)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 15:18:28 +0200
Message-ID: <1314883108.4022.21.camel@jlt3.sipsolutions.net> (sfid-20110901_151836_271591_EF94450B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-31 at 15:49 +0200, Alexander Simon wrote:
> > Use for what? That's confusing. You're asking if it can be used for
> > beaconing, as the old function name *clearly* said. Now you're making it
> > confusing.
> I'm not only asking for beaconing. In 4/4, i am using this function to see if 
> regdom allows me to use HT40 on the extension channel (beacons and data 
> traffic). Hence can_use_ext_chan.
> 
> Even cfg80211_set_freq in net/wireless/chan.c uses this to see if we can 
> communicate (see printk) on that channel.
> 
> So my suggestion would be to use that name. But I'd also use the old if 
> preferred.

But the type of usage should be made clear. You're going to use it for
uncontrolled transmissions, so regulatory rules that apply are different
than "can I use this channel to connect to an AP" for example. The "can
beacon" made that obvious. Obviously, if I can beacon, I can also TX
data, but vice versa isn't necessarily true depending on regulatory
rules, since data TX can happen controlled by the AP (e.g. DFS
channels).

johannes

