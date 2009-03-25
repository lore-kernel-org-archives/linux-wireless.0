Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60570 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbZCYTeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 15:34:13 -0400
Received: by fxm2 with SMTP id 2so207305fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 12:34:09 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 0/5] mac80211: beacon filtering
References: <20090322195619.26460.48292.stgit@tikku>
	<1237900276.4320.86.camel@johannes.local>
	<87iqly0ydm.fsf@litku.valot.fi>
	<1237973445.4320.135.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 25 Mar 2009 21:34:05 +0200
In-Reply-To: <1237973445.4320.135.camel@johannes.local> (Johannes Berg's message of "Wed\, 25 Mar 2009 10\:30\:45 +0100")
Message-ID: <87eiwl1jo2.fsf@litku.valot.fi> (sfid-20090325_203418_375539_004B47E9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2009-03-25 at 11:01 +0200, Kalle Valo wrote:
>
>> > This actually affects the entire stack, take for example the BSS load
>> > element, which could potentially change frequently. Unless
>> > wpa_supplicant would want to use it for roaming, we could ignore it.
>> >
>> > However, how do we know which elements the various pieces of the stack
>> > need?
>> 
>> I think we can just start with a fixed list and start improving that.
>> Or did you think of creating the list dynamically?
>
> It has to be dynamic, no? Much of the information in there would be
> things wpa_supplicant is only interested in. If it was just the kernel
> code -- yes, we could just have a static list somewhere -- but much of
> the 11k things for instance are only useful for wpa_supplicant.

But if we already know what wpa_supplicant needs, can't we do the
first implementation with a static list? Sure, the dynamic list is
something we should aim for.

Do we have any knowledge how different hardware support beacon
checksumming? I only know how stlc45xx does it.

-- 
Kalle Valo
