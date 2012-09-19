Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60208 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab2ISTp4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 15:45:56 -0400
Received: by weyx8 with SMTP id x8so797826wey.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2012 12:45:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348083291.7081.11.camel@jlt4.sipsolutions.net>
References: <1348049313-7650-1-git-send-email-johannes@sipsolutions.net>
 <CA+XVXfcxHENu1HzY+-WkyMr6g+3P2wSyj7BhDsfKgZoB7fZHRg@mail.gmail.com> <1348083291.7081.11.camel@jlt4.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 19 Sep 2012 22:45:39 +0300
Message-ID: <CA+XVXfd1ZiYjZaRUFeZvDVvi5gqmE6fVs=qjZW-JshRaWxSoRA@mail.gmail.com> (sfid-20120919_214559_747282_57594F11)
Subject: Re: [PATCH 0/3] mac80211: avoid useless delBA frames
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 19, 2012 at 10:34 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-09-19 at 22:32 +0300, Arik Nemtsov wrote:
>> On Wed, Sep 19, 2012 at 1:08 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > There are a few situations where it's completely pointless
>> > to send delBA action frames, so let's remove them.
>>
>> Maybe it's a good opportunity to also fix ieee80211_reconfig? I
>> remember you mentioned some FW/HW issue there, perhaps this was solved
>> in the meantime. Otherwise we can add a HW flag for that I guess.
>
> Not sure what you mean?

All BA sessions are destroyed right after reconfig. For devices that
manage these in FW, the FW was just reloaded and doesn't know about
existing sessions at all.
So I guess there's sense in sending the delBA, but no sense calling
the driver ampdu callback (at least for how 12xx works).

>
> FWIW these patches were sitting in my tree as part of a larger set of
> changes around the driver ampdu callback to help drivers with internal
> queues drop or flush frames appropriately and to react to the different
> situations. I didn't think about reconfig at all with this.

Yea. These handle other situations.
