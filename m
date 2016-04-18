Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34885 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbcDRFQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 01:16:53 -0400
Received: by mail-wm0-f52.google.com with SMTP id a140so102769625wma.0
        for <linux-wireless@vger.kernel.org>; Sun, 17 Apr 2016 22:16:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460845552.2075.28.camel@sipsolutions.net>
References: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	<1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	<1460636302-31161-3-git-send-email-michal.kazior@tieto.com>
	<1460845384.2075.27.camel@sipsolutions.net>
	<1460845552.2075.28.camel@sipsolutions.net>
Date: Mon, 18 Apr 2016 07:16:52 +0200
Message-ID: <CA+BoTQmuTAjR-cSuJmsAm5Ms3sTrtPT8HxE_tYf1EGOMGeHVcw@mail.gmail.com> (sfid-20160418_071658_963225_AB8106CE)
Subject: Re: [PATCHv3 2/5] mac80211: implement fair queueing per txq
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dave Taht <dave.taht@gmail.com>,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	Avery Pennarun <apenwarr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 April 2016 at 00:25, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2016-04-17 at 00:23 +0200, Johannes Berg wrote:
>> On Thu, 2016-04-14 at 14:18 +0200, Michal Kazior wrote:
>> >
>> >
>> > +++ b/net/mac80211/fq.h
>> >
>> Now that you've mostly rewritten it, why keep it in a .h file?
>>
>
> I think I just confused this with codel.h, but still - why a .h file
> with all this "real" code, meaning the file can really only be included
> once?

I guess .h file can give the compiler an opportunity for more
optimizations. With .c you would need LTO which I'm not sure if it's
available everywhere.


Michał
