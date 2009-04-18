Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:38043 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZDRRsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 13:48:18 -0400
Received: by ewy24 with SMTP id 24so618644ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 18 Apr 2009 10:48:17 -0700 (PDT)
Message-ID: <49EA125F.5060303@tuffmail.co.uk> (sfid-20090418_194823_366142_15639075)
Date: Sat, 18 Apr 2009 18:48:15 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rfkill rewrite bug
References: <49DCA88E.6060400@tuffmail.co.uk>	 (sfid-20090408_153722_059382_FB44D658) <1239204090.16477.1.camel@johannes.local>	 <49DCDD2E.80705@tuffmail.co.uk>  <49E38BBC.5010708@tuffmail.co.uk>	 (sfid-20090413_205524_915082_56358705) <1239741968.4205.1.camel@johannes.local>	 <49E98C86.2040308@tuffmail.co.uk>	 (sfid-20090418_101208_980691_83127E2F) <1240043283.5792.0.camel@johannes.local>	 <49E9A0C7.8040602@tuffmail.co.uk>	 (sfid-20090418_114338_695917_3CBF9024) <1240057470.4755.7.camel@johannes.local>	 <49E9F677.80109@tuffmail.co.uk> (sfid-20090418_174945_153562_3F1E7019) <1240070230.2978.2.camel@johannes.local>
In-Reply-To: <1240070230.2978.2.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2009-04-18 at 16:49 +0100, Alan Jenkins wrote:
>
>   
>>> That's odd, I thought I added a set_sw_state() to rfkill which would
>>> disable that rfkill. But there's rfkill_set_global_sw_state() which
>>> should do what you want -- can you try replacing the EEE set_sw_state
>>> call with that?
>>>       


> No, that's done asynchronously in rfkill_sync_work(). But actually, heh,
> that means set_sw_state can _not_ work before registering.
>   

Ah, I think I see it now.

Um, what's the use-case for calling set_sw_state() before registration? 
Is it actually needed?

I think it was doing _something_.  If the initial wireless state is
soft-blocked, but rfkill.default_state = 1 (unblocked), then without the
set_sw_state() call, the wireless would remain soft blocked.  When the
first sync_work calls rfkill_set_block(false), the "prev" value would
also be false, so it would return without calling .set_block().  And
you'd have an inconsistency, because "/sys/class/rfkill/rfkill0/state"
would say "1" (unblocked).

You'd have a similar problem the other way around, if the wireless was
initially enabled, but the user specified rfkill.default_state = 0.

So maybe you need a "first time, force sync" flag instead.  That would
also help if you had a write-only rfkill line, no?

Regards
Alan



