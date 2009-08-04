Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57912 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296AbZHDVym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 17:54:42 -0400
Received: by bwz19 with SMTP id 19so3348149bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 14:54:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907312308.31066.mb@bu3sch.de>
References: <83a869cd0907271349h248204at74cc1603419fc83b@mail.gmail.com>
	 <200907281808.35906.mb@bu3sch.de>
	 <83a869cd0907311404o793c1733p43e936437a923340@mail.gmail.com>
	 <200907312308.31066.mb@bu3sch.de>
Date: Tue, 4 Aug 2009 23:54:42 +0200
Message-ID: <83a869cd0908041454i474b0ee4hfb770c7c5166be7f@mail.gmail.com>
Subject: Re: [RESEND] [PATCHv2] b43 add harware tkip
From: gregor kowski <gregor.kowski@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/31/09, Michael Buesch <mb@bu3sch.de> wrote:
> On Friday 31 July 2009 23:04:17 gregor kowski wrote:
>> Hi Michael,
>>
>> > It's mapped to 4, because you removed the old API support.
>> > (I'm not sure whether we want to remove that support, yet. Gimme some
>> > time
>> > on it...)
>> >
>> Does the old API still useful ?
>
> Well, I'm not sure. Why do we remove it at all? It just avoids one single
> if condition in your tkip patch, doesn't it?
>
because you ask it : "We should probably remove that new_kidx_api crap
alltogether." [1] :)
There is really bugs in the current code. You could see it by enabling
B43_DBG_KEYS.
With the current code and new API, you will see that 54 pairwise keys
are dumped, not only 50.


[1]
> >> +     /* FIXME : for b43_new_kidx_api, there can be 54 key
> >> +      * instead of 50 in RCMTA and TKIPTSCTTAK.
> >> +      */
> >
> > I don't understand this comment.
> if  b43_new_kidx_api is true :
> - we set max_nr_keys to 58
> - we program B43_MMIO_RCMTA_COUNT to 50
> - in b43_key_write we can allocate key up to index 58 (4 for default,
> 54 for sta)
>
> But there is only 50 entries for TKIPTSCTTAK, and a comment on bcm-v4
> suggest there is 50 entries for RCMTA. So if there more than 50
> station we will overflow RCMTA and TKIPTSCTTAK.

Yeah well. The key handling is pretty weird.
There are 50 pairwise keys available. max_nr_keys includes pairwise
keys, group keys (4)
and another copy of the group keys (4) used with older firmware. So we
end up at 58.

To summarize it, in practice we have 50 pairwise keys and 4 group
keys. You can ignore
the additional 4 "rx keys" as they are not used in recent fw and are
just a copy of the
group keys.

> So the fix will be do to something like
> dev->max_nr_keys = (dev->dev->id.revision >= 5) ? 58 : 20;
> if (b43_new_kidx_api())
> dev->max_nr_keys -= 4;

Hm, I don't think this is correct. There are lots of weird assumptions
all over the code.
We should probably remove that new_kidx_api crap alltogether.
