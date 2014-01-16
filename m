Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:47097 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaAPKd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 05:33:29 -0500
Received: by mail-bk0-f42.google.com with SMTP id my12so1105005bkb.15
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 02:33:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389864706.4345.1.camel@jlt4.sipsolutions.net>
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
	<1389787494-7361-10-git-send-email-michal.kazior@tieto.com>
	<1389792139.4338.6.camel@jlt4.sipsolutions.net>
	<CA+BoTQ=UJNLD3dmzD4PDK1exSJFeWTdpkAHc2YvVbktugw_AyQ@mail.gmail.com>
	<1389864706.4345.1.camel@jlt4.sipsolutions.net>
Date: Thu, 16 Jan 2014 11:33:27 +0100
Message-ID: <CA+BoTQk62antiWbq7MxmjP_caj7xTOj699eiQO-TPFY32oX+5Q@mail.gmail.com> (sfid-20140116_113332_847518_1FDB65A6)
Subject: Re: [RFC 9/9] mac80211: implement multi-interface CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 January 2014 10:31, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2014-01-16 at 10:28 +0100, Michal Kazior wrote:
>> On 15 January 2014 14:22, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Wed, 2014-01-15 at 13:04 +0100, Michal Kazior wrote:
>> >> This implements a fairly simple multi-interface
>> >> CSA. It doesn't support multiple channel
>> >> contexts so it doesn't support multi-channel.
>> >
>> > It seems that this also means that somewhere you need to advertise the
>> > multi-switch feature. I guess you need that anyway, but this makes it
>> > obvious.
>>
>> I don't really understand. Do we really need it? You want to advertise
>> it just to cfg80211 or all the way up to userspace?
>
> It seems it would be needed all the way to userspace so it knows whether
> it can expect multi-vif CSA to be available? Or would you just want to
> try & fail? Wouldn't that potentially impact channel selection since
> you'd want to not pick radar channels for multi-vif? Not really sure ...
>
> Maybe the expectation is that internally there will be no drivers that
> don't support it, i.e. if a driver implements the cfg80211 API at all
> then it must support multi-vif CSA?

Typically if you run more than one AP on a DFS channel and you detect
a radar you want to move all APs - so you either succeed with
multi-vif CSA or you fallback and re-start them.

If you assume a driver supports multi-channel but isn't capable of
multi-interface CSA you'll be running into timing issues. After you
detect radar you have a limited time to quiesce. You might end up
exceeding that limit if you move APs one-by-one.

With my patches as they are new hostap will try sending new channel
switch command but since it doesn't contain ifindex old kernel will
respond with a -EINVAL and userspace has no way of knowing if the
command was actually malformed or isn't supported. hostap could still,
however, work in a best effort manner and fallback to the old command
variant.


Michał
