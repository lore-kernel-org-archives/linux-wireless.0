Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:39117 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab3COSWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 14:22:41 -0400
Received: by mail-lb0-f178.google.com with SMTP id n1so3042767lba.37
        for <linux-wireless@vger.kernel.org>; Fri, 15 Mar 2013 11:22:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1362651722.8694.25.camel@jlt4.sipsolutions.net>
References: <1362608366-10771-1-git-send-email-johannes@sipsolutions.net> <1362651722.8694.25.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 15 Mar 2013 11:22:19 -0700
Message-ID: <CAB=NE6VTCdBzsQ7j7VgpbERUqYDuE-=9B=eoRa0rdSE7AiE7ew@mail.gmail.com> (sfid-20130315_192244_602563_6A0409CD)
Subject: Re: [PATCH 3.9] mac80211: always synchronize_net() during station removal
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 7, 2013 at 2:22 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2013-03-06 at 23:19 +0100, Johannes Berg wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> If there are keys left during station removal, then a
>> synchronize_net() will be done (for each key, I have a
>> patch to address this for 3.10), otherwise it won't be
>> done at all which causes issues because the station
>> could be used for TX while it's being removed from the
>> driver -- that might confuse the driver.
>>
>> Fix this by always doing synchronize_net() if no key
>> was present any more.
>
> Applied.

This applies to v3.8 as well, do you want it there too?

  LUis
