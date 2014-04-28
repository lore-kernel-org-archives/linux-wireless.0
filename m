Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40909 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaD1GQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2014 02:16:32 -0400
Received: by mail-wi0-f178.google.com with SMTP id bs8so5079196wib.17
        for <linux-wireless@vger.kernel.org>; Sun, 27 Apr 2014 23:16:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1398439255.4152.10.camel@jlt4.sipsolutions.net>
References: <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
	<1397050174-26121-1-git-send-email-michal.kazior@tieto.com>
	<1398439255.4152.10.camel@jlt4.sipsolutions.net>
Date: Mon, 28 Apr 2014 08:16:30 +0200
Message-ID: <CA+BoTQ=UmtPX73bf84gNJ9m9o0dJPV9LzgpORM765UaOrJ5WPA@mail.gmail.com> (sfid-20140428_081815_941469_91E5E171)
Subject: Re: [PATCH v4 00/13] cfg80211/mac80211: implement multi-vif chanctx reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 April 2014 17:20, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi,
>
>> The patchset incrementally improves chanctx
>> reservations in order to support multi-vif
>> reservations and in-place multi-vif reservations
>> (typically for single-channel hardware, but
>> multi-channel benefits from this too).
>
> I've applied the first 12 patches, i.e. all but patch 13. As far as
> patch 13 is concerned, I (a) need more time to review it, and (b) would
> like to understand better how you intend to use it.

Sure.


> I also don't really like the "stub" thing. :)

I agree that it's not the most beautiful thing to have but I wanted to
make my intention clear how conflicting channel reservation/switching
is going to be handled (AP and CSA channel switching patches come
later). I can remove the stub and just introduce the hook in one of
the channel switching patches or I can change the comment to something
more meaningful if that makes any more sense to you.


> Maybe it would also make sense to insert the "recalc" refactoring
> somewhere around here?

Do you mean Zhao Gang's recalc refactoring patches? Patch 13 stills
interacts with some recalc code and might produce minor conflicts.


Michał
