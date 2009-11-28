Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:60454 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbZK1VIs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 16:08:48 -0500
Received: by ewy7 with SMTP id 7so2993584ewy.28
        for <linux-wireless@vger.kernel.org>; Sat, 28 Nov 2009 13:08:53 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: annotate sleeping driver ops
References: <1259439566-26397-1-git-send-email-kalle.valo@iki.fi>
	<1259440583.5428.32.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 28 Nov 2009 23:08:52 +0200
In-Reply-To: <1259440583.5428.32.camel@johannes.local> (Johannes Berg's message of "Sat\, 28 Nov 2009 21\:36\:23 +0100")
Message-ID: <87638u8ihn.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2009-11-28 at 22:19 +0200, Kalle Valo wrote:
>> To make it easier to notice cases of calling sleeping ops in atomic context,
>> annotate driver-ops.h with appropiate might_sleep() calls. At the same time,
>> also document in mac80211.h the op functions with missing contexts.
>> 
>> mac80211 doesn't seem to use get_tx_stats anywhere currently. Just to be on
>> the safe side, I documented it to be atomic, but hopefully the op can be
>> removed in the future.
>> 
>> Compile-tested only.
>
> Nice, thanks. Haven't reviewed it in detail, but I'll trust you :)
>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

Thanks for the trust! I'll, just in case, test the patch tomorrow both
with iwl3945 and wl1251 so that this trust doesn't backfire =)

But first some sleep.

-- 
Kalle Valo
