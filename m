Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:36673 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbZGKUVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2009 16:21:36 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: cancel/restart all timers across suspend/resume
References: <1242391067.5799.53.camel@johannes.local>
	<1242553242.10005.76.camel@johannes.local> <m2hbxjky1q.fsf@igel.home>
	<1247334562.30647.111.camel@johannes.local>
Date: Sat, 11 Jul 2009 22:21:30 +0200
In-Reply-To: <1247334562.30647.111.camel@johannes.local> (Johannes Berg's
	message of "Sat, 11 Jul 2009 19:49:22 +0200")
Message-ID: <m2ab3bkm2d.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2009-07-11 at 18:02 +0200, Andreas Schwab wrote:
>> 
>> Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org> writes:
>> 
>> > We forgot to cancel all timers in mac80211 when suspending.
>> > In particular we forgot to deal with some things that can
>> > cause hardware reconfiguration -- while it is down.
>> 
>> This is breaking suspend on my iBook.
>
> Yeah, bug 13337,

Thanks, I missed that one.

> but the fix at
> http://mid.gmane.org/8763dznnki.fsf@scholz.fias.uni-frankfurt.de works.

With that patch suspend works here too, but resume hangs halfway
through.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
