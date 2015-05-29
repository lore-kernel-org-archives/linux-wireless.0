Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34526 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbbE2LsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 07:48:03 -0400
Received: by wicmc15 with SMTP id mc15so13730663wic.1
        for <linux-wireless@vger.kernel.org>; Fri, 29 May 2015 04:48:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432899554.2104.17.camel@sipsolutions.net>
References: <1432039021-29666-1-git-send-email-michal.kazior@tieto.com>
	<1432285043-8878-1-git-send-email-michal.kazior@tieto.com>
	<1432285043-8878-2-git-send-email-michal.kazior@tieto.com>
	<1432897812.2104.7.camel@sipsolutions.net>
	<CA+BoTQmkg8KBhFGqSsdt6Sks6JGUDGnM2oSzMSEWtCEz-abwzA@mail.gmail.com>
	<1432899554.2104.17.camel@sipsolutions.net>
Date: Fri, 29 May 2015 13:48:01 +0200
Message-ID: <CA+BoTQ=6MBoXqhX2ALJG5S+EYbZbw+Zad2j9UfEqpyKUBFfyug@mail.gmail.com> (sfid-20150529_134807_095633_4C432DCD)
Subject: Re: [PATCH v2 2/2] mac80211: guard against invalid ptr deref
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 May 2015 at 13:39, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2015-05-29 at 13:34 +0200, Michal Kazior wrote:
>
>> > I'm a bit undecided about this. Is this really the only place that
>> > assumes use_4addr implies that it's a VLAN, in a context like this?
>>
>> Hmm.. I guess TDLS could also have use_4addr and still be a
>> IFTYPE_STATION, right?
>
> No, TDLS can neither get here (VLAN assignment) nor does it actually set
> use_4addr. The only other thing that can set use_4addr is the station
> interface itself, but then we also can't get here.

Good point.


> That wasn't really my point though - I was thinking more along the lines
> of code in rx.c, tx.c that just checks use_4addr? Not really sure.

>From what I see wdev.use_4addr is always used after checking for
IFTYPE_AP_VLAN. u.mgd.use_4addr on the other hand is used after
checking for IFTYPE_STATION.


Michał
