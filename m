Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57650 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758618Ab2EKKD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 06:03:29 -0400
Received: by dady13 with SMTP id y13so2897784dad.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2012 03:03:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336730159.4310.16.camel@jlt3.sipsolutions.net>
References: <20120510203021.240931880@sipsolutions.net>
	<20120510203304.806786399@sipsolutions.net>
	<CAJwzM1=KxQqGRu34C9N-SFcwY3ayVsLnP4BS4iOr7dFgO+qu3A@mail.gmail.com>
	<1336730159.4310.16.camel@jlt3.sipsolutions.net>
Date: Fri, 11 May 2012 15:33:29 +0530
Message-ID: <CAJwzM1=hFmaj-tA7ru2Li9c2EGL5wbPbcGoA6aws=f+dRNmvTA@mail.gmail.com> (sfid-20120511_120352_532474_F4919467)
Subject: Re: [RFC 2/2] cfg80211: provide channel to start_ap function
From: Avinash Patil <avinashapatil@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 How does mwifiex work with this? Is it easier/harder to do?

set_channel handler from cfg80211 is issued first where we set channel
to FW. After that in start_ap, we set beacon, dtim interval, SSID,
security etc and start AP.
Its easier to move to new implementation, but unit testing and
internal review of this patch may take some time and by then merge
window may expire.

Regards,
Avinash.

On Fri, May 11, 2012 at 3:25 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2012-05-11 at 15:21 +0530, Avinash Patil wrote:
>> Hi Johannes,
>>
>> Are these patches meant for 3.5?
>>
>> If so, we will have to modify our AP solution mwifiex AP-STA to set
>> channel in start_ap itself.
>
> I don't know if they'll still go there since it's really close, but I
> think they can go in soon. I sent them as [PATCH] today.
>
> How does mwifiex work with this? Is it easier/harder to do?
>
> johannes
>
