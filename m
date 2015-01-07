Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:52146 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbAGNeZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 08:34:25 -0500
Received: by mail-wg0-f43.google.com with SMTP id k14so1202387wgh.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 05:34:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420541514.1966.16.camel@sipsolutions.net>
References: <1419847199-25493-1-git-send-email-arik@wizery.com> <1420541514.1966.16.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 7 Jan 2015 15:34:09 +0200
Message-ID: <CA+XVXfeFWbVLCpebTQpv9FZPaDUEt1NJ6GpnyRoZ1UG91nMymw@mail.gmail.com> (sfid-20150107_143434_337089_7877A8AC)
Subject: Re: [PATCH] cfg80211: fix deadlock during reg chan check
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 6, 2015 at 12:51 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2014-12-29 at 11:59 +0200, Arik Nemtsov wrote:
>> If a P2P GO is active, the cfg80211_reg_can_beacon function will take
>> the wdev lock, in its call to cfg80211_go_permissive_chan. But the wdev lock
>> is already taken by the parent channel-checking function, causing a
>> deadlock.
>> Split the checking code into two parts. The first part will check if the
>> wdev is active and saves the channel under the wdev lock. The second part
>> will check actual channel validity according to type.
>
> I'm not convinced this is the right thing to do. When checking for the
> current wdev that it can use a channel, then it seems that it's own
> current BSS connection (if any) shouldn't actually be taken into account
> - ergo the lock shouldn't have to be taken, that interface should be
> excluded from the "can beacon due to concurrent check" anyway.

We have a couple of checks we want to add in the pipeline that also
need "this" wdev in the concurrent check, so I'd prefer to avoid this.

Unless we treat the exclude_wdev as "already locked wdev", which I
think is unglier than what I do here.

>
> Also, the only reason this can happen anyway is when you call "can
> beacon" for a station interface - which seems nonsensical. Given that

This is not true. This happens with current code for a p2p-go
interface during channel validity checks in reg.c.

Arik
