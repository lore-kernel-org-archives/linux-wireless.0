Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:10018 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZFISBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 14:01:34 -0400
Received: by wf-out-1314.google.com with SMTP id 26so75208wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2009 11:01:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200906082016.29793.mb@bu3sch.de>
References: <83a869cd0906071450h24ed4119s44d00db0d97d59e2@mail.gmail.com>
	 <200906081720.59594.mb@bu3sch.de>
	 <83a869cd0906081104m2ecdf049rdcc7694f0974ca28@mail.gmail.com>
	 <200906082016.29793.mb@bu3sch.de>
Date: Tue, 9 Jun 2009 20:01:36 +0200
Message-ID: <83a869cd0906091101p26887a9fx3a6e65f700eac631@mail.gmail.com>
Subject: Re: [PATCH] b43 add harware tkip
From: gregor kowski <gregor.kowski@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 8, 2009 at 8:16 PM, Michael Buesch<mb@bu3sch.de> wrote:
> On Monday 08 June 2009 20:04:33 gregor kowski wrote:
>> > Why do you write phase1, if TKIP is not used?
>> I clear the value in shared memory.
>
> Yeah, that's what I don't understand here. Does buf contain only zero bytes in this case?

Opps, in a version version the code was before the memcpy into buf, so
it was always zero. Now if can have other value...
I will change that.

>>
>> But there is only 50 entries for TKIPTSCTTAK, and a comment on bcm-v4
>> suggest there is 50 entries for RCMTA. So if there more than 50
>> station we will overflow RCMTA and TKIPTSCTTAK.
>
> Yeah well. The key handling is pretty weird.
> There are 50 pairwise keys available. max_nr_keys includes pairwise keys, group keys (4)
> and another copy of the group keys (4) used with older firmware. So we end up at 58.
>
> To summarize it, in practice we have 50 pairwise keys and 4 group keys. You can ignore
> the additional 4 "rx keys" as they are not used in recent fw and are just a copy of the
> group keys.
But do you agree that index=55 is an valid sta index that can be
returned by b43_key_write ?
In that case both keymac_write and rx_tkip_phase1_write will use the
55-4=51 entry and overflow.


>
>> So the fix will be do to something like
>> dev->max_nr_keys = (dev->dev->id.revision >= 5) ? 58 : 20;
>> if (b43_new_kidx_api())
>> dev->max_nr_keys -= 4;
>
> Hm, I don't think this is correct. There are lots of weird assumptions all over the code.
> We should probably remove that new_kidx_api crap alltogether.
Yes I think it could simply the code.

>
>> >> -             if (algorithm == B43_SEC_ALGO_TKIP) {
>> >> -                     /* FIXME: No TKIP hardware encryption for now. */
>> >> +             if (algorithm == B43_SEC_ALGO_TKIP &&
>> >> +                             (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE) ||
>> >> +                                key->flags & IEEE80211_KEY_FLAG_WMM_STA )) {
>> >> +                     /* We support only one rx queue (no QOS) and pairwise key */
>> >
>> > This comment doesn't really make sense to me, too.
>> > What does QoS have to do with the RX queue?
>> each QOS queue got it's own tkip counters (iv16, iv32) (check tkip.c
>> software implementation for more info).
>
> Yeah, but what does --> ___RX___ <-- (receive) have to do with that?
> We do always only have one RX queue.
>From what I understood in case of QOS, the 80211 frame contain an
header that contains the queue number (what is parsed by
ieee80211_parse_qos). For each queue tkip counter are different : look
at soft implementation, it got an array of iv (one for each queue).
What is strange is that I did see only one counter for TX.

Gregor
