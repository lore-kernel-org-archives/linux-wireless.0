Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:34788 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382Ab1IHOkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 10:40:10 -0400
Received: by gyd5 with SMTP id 5so718467gyd.15
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 07:40:05 -0700 (PDT)
Message-ID: <4E68D3BF.5090201@ti.com> (sfid-20110908_164032_680742_E8EE6FCE)
Date: Thu, 08 Sep 2011 17:39:59 +0300
From: Victor Goldenshtein <victorg@ti.com>
Reply-To: victorg@ti.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result event.
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>  <1315224151-16552-4-git-send-email-VictorG@ti.com>  <1315224512.4075.10.camel@jlt3.sipsolutions.net> <4E6736D9.3070804@ti.com>  <1315387619.4002.3.camel@jlt3.sipsolutions.net> <4E686125.5050208@ti.com>  <1315464556.3948.0.camel@jlt3.sipsolutions.net>  <4E688321.7090704@ti.com> <1315474047.7091.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1315474047.7091.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2011 12:27, Johannes Berg wrote:
> On Thu, 2011-09-08 at 11:56 +0300, Victor Goldenshtein wrote:
>
>> If I understood you correctly.. I can create new
>> NL80211_ATTR_HW_CAPABILITY (u32) attribute which will advertise all
>> capabilities with "dev->wiphy.flags".
>
> No, I don't think you can advertise wiphy.flags since those flags are
> internal -- you'll have to map single wiphy flags to single capability
> flags which are also defined in nl80211.h.
>
> I'd call it "NL80211_ATTR_CAPABILITIES" to sidestep the issue of it
> being a driver of HW or whatever capability.
>
> johannes
>

Sorry, I'm not sure that I'm entirely understand, you mean to create 
*nested* "NL80211_ATTR_CAPABILITIES" attribute which will contain all 
new capability flags, mapped from wiphy.flags? and to do it within 
existing nl80211_send_wiphy() function?

Thanks,
Victor.
