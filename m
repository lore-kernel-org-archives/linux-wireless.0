Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:57784 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbZHTSBU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 14:01:20 -0400
Received: by ey-out-2122.google.com with SMTP id 22so58895eye.37
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 11:01:20 -0700 (PDT)
Message-ID: <4A8D8F6C.1090804@gmail.com>
Date: Thu, 20 Aug 2009 19:01:16 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: jussi.kivilinna@mbnet.fi, linux-wireless@vger.kernel.org
Subject: Re: [RFC 5/5] cfg80211: scan before connect if we don't have the
 bss
References: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>	 <1250640253-18434-6-git-send-email-kilroyd@googlemail.com>	 <1250668113.16393.25.camel@johannes.local>  <4A8C52BD.5070609@gmail.com> <1250710648.8073.9.camel@johannes.local>
In-Reply-To: <1250710648.8073.9.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2009-08-19 at 20:30 +0100, Dave wrote:
>>> Hmm. What if the bssid isn't set? Then the card might select a different
>>> BSS than the one we have on the scan list.
>> That's correct. For the Agere driver that's also true when bssid is set
>> - we can't specify which AP the firmware connects to.
> 
> Ok. We may want a feature flag for the latter case so we know what's
> going on, and reject a BSSID setting.

I'll look into that.

>>> And it's all racy too -- by the time the driver calls connect_result(),
>>> the BSS might have expired after it was found here now.
>> Agreed, but with a 15s expiry period I wouldn't expect this to be a
>> problem in practice.
> 
> Well, the user could scan, take 12 seconds to pick out the AP manually,
> enter the paramters in another 2.5 seconds, and then it would already
> happen, I think?

As usual, you're right :)

>> Another alternative is for cfg80211_connect_result to trigger the scan
>> if it doesn't have the bss, and only complete the connect when the scan
>> returns. I think I like the sound of this best.

johannes said:
> Good option too, though then it would be useful to pass the channel
> pointer if available to scan only on that channel. Of course, if it
> still can't be found things are really amiss and we should probably
> disconnect and send a failed event to userspace.

Jussi said:
> This sounds best, as with rndis, driver can get currently connected
> bss from device and scan isn't required.

OK, I'll chase this option and see where it goes.


Regards,

Dave.
