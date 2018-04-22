Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:45070 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753529AbeDVVPz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Apr 2018 17:15:55 -0400
Received: by mail-vk0-f54.google.com with SMTP id 203so8204550vka.12
        for <linux-wireless@vger.kernel.org>; Sun, 22 Apr 2018 14:15:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180422.145420.1197041027922699603.davem@davemloft.net>
References: <1524119910.3024.12.camel@sipsolutions.net> <173c5f98-36bc-2e52-1e64-3a5f89008d46@candelatech.com>
 <1524151617.3024.25.camel@sipsolutions.net> <20180422.145420.1197041027922699603.davem@davemloft.net>
From: Roopa Prabhu <roopa@cumulusnetworks.com>
Date: Sun, 22 Apr 2018 14:15:53 -0700
Message-ID: <CAJieiUh8Pnu5GVSWz04WSZ5L0YVpVBmeY+H_MjhL0k6SWwbcqw@mail.gmail.com> (sfid-20180422_231605_297490_E8FF4046)
Subject: Re: [PATCH 1/3] ethtool: Support ETHTOOL_GSTATS2 command.
To: David Miller <davem@davemloft.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 22, 2018 at 11:54 AM, David Miller <davem@davemloft.net> wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Thu, 19 Apr 2018 17:26:57 +0200
>
>> On Thu, 2018-04-19 at 08:25 -0700, Ben Greear wrote:
>>>
>>> Maybe this could be in followup patches?  It's going to touch a lot of files,
>>> and might be hell to get merged all at once, and I've never used spatch, so
>>> just maybe someone else will volunteer that part :)
>>
>> I guess you'll have to ask davem. :)
>
> Well, first of all, I really don't like this.
>
> The first reason is that every time I see interface foo become foo2,
> foo3 is never far behind it.
>
> If foo was not extensible enough such that we needed foo2, we beter
> design the new thing with explicitly better extensibility in mind.
>
> Furthermore, what you want here is a specific filter.  Someone else
> will want to filter on another criteria, and the next person will
> want yet another.
>
> This needs to be properly generalized.
>
> And frankly if we had moved to ethtool netlink/devlink by now, we
> could just add a netlink attribute for filtering and not even be
> having this conversation.


+1.

Also, the RTM_GETSTATS api was added to improve stats query efficiency
(with filters).
 we should look at it  to see if this fits there. Keeping all stats
queries in one place will help.
