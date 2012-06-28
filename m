Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64817 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2F1OSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 10:18:50 -0400
Received: by bkcji2 with SMTP id ji2so2048788bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 07:18:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340876555.4491.33.camel@jlt3.sipsolutions.net>
References: <1340821557-27009-1-git-send-email-arik@wizery.com>
 <1340871433.4491.20.camel@jlt3.sipsolutions.net> <CA+XVXfdKLeaHpLmqsXROH9VojHkB4EP-BpcFDLb8ZCtjb_XCbQ@mail.gmail.com>
 <1340875844.4491.26.camel@jlt3.sipsolutions.net> <CA+XVXfcDNcy+RjdxraqJ6LnYWt3XdtF-X-Ah9FdP=ZibnYp15g@mail.gmail.com>
 <1340876555.4491.33.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 28 Jun 2012 17:18:33 +0300
Message-ID: <CA+XVXfcSQsYn3Pu8=SYtmMD6b1CeUF_qMhp=DFw8j4+HSqdhTw@mail.gmail.com> (sfid-20120628_161854_122868_4F771840)
Subject: Re: [PATCH] mac80211: allow Rx in reconfig only after removing BA sessions
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 28, 2012 at 12:42 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-06-28 at 12:38 +0300, Arik Nemtsov wrote:
>> On Thu, Jun 28, 2012 at 12:30 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Thu, 2012-06-28 at 11:37 +0300, Arik Nemtsov wrote:
>> >> On Thu, Jun 28, 2012 at 11:17 AM, Johannes Berg
>> >> <johannes@sipsolutions.net> wrote:
>> >> > On Wed, 2012-06-27 at 21:25 +0300, Arik Nemtsov wrote:
>> >> >> Previously, a connected STA/AP could send us some AMPDUs right after
>> >> >> recovery, without the driver knowing anything about it.
>> >> >
>> >> > Huh, that description doesn't make a lot of sense? The STA/AP can send
>> >> > us AMPDUs anyway without the driver knowing anything about it since it
>> >> > has no idea we're restarting ...
>> >>
>> >> Well the point is to drop them early in the Rx path. Should I change
>> >> the description or you don't like the patch in general?
>> >
>> > I don't mind the patch, I just don't quite understand it still.
>> >
>> > The driver is receiving the AMPDUs anyway, and if it's passing them up
>> > why do we need to drop them?
>>
>> Well if the de-aggregration is in HW, they won't make it as far as
>> mac80211. So this patch is for SW de-aggregators.
>
> I don't think there's anyone doing AMPDU SW deaggregation? There
> definitely isn't any code in mac80211 to do it ;-)
>
>> But come to think of it, if the de-aggregation is done in SW, I guess
>> there's no real issue with accepting them, since mac80211 didn't
>> really reboot.
>
> Or are you thinking of the reorder buffer?
>
>> I guess we can drop the patch? It just seemed more correct to put the
>> in_reconfig to false there.
>
> I don't see how it's more correct? We're done reconfiguring and then
> decide to drop all BA sessions ;-)
>
> In a way, heck, it seems more correct to leave as-is. If we send a BA
> action frame and receive a response to it maybe (is there a response to
> delBA?) we don't want to drop it. Or if we send delBA and the peer wants
> to start right away again, ...?

Yea it's a good point. Let's drop this.

Arik
