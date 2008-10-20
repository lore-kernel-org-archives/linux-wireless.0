Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:48142 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbYJTI5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 04:57:03 -0400
Received: by gxk9 with SMTP id 9so3329552gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 01:57:02 -0700 (PDT)
Message-ID: <43e72e890810200157j30e27aden1d8b76ce7fbb8177@mail.gmail.com> (sfid-20081020_105723_308389_10343F06)
Date: Mon, 20 Oct 2008 01:57:02 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: Re-enable aggregation
Cc: Sujith <Sujith.Manoharan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Luis.Rodriguez@atheros.com,
	tomasw@gmail.com
In-Reply-To: <1224492335.18024.34.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <43e72e890810200135o1581c904i456a35298f8a56a9@mail.gmail.com>
	 <1224492335.18024.34.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2008 at 1:45 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-10-20 at 01:35 -0700, Luis R. Rodriguez wrote:
>
>> >> + *   @is_part_ampdu: set to indicate that the wireless core should should
>> >> + *           treat this frame as part of an AMPDU
>> >
>> > I thought we said we could keep the flag instead of moving to the skb
>> > here?
>>
>> That was just because the changes required to add this was too much
>> for 2.6.27 but since we don't care about this fix in 2.6.27 we can do
>> whatever is needed to fix this properly.
>
> Right, but adding random stuff into skb isn't really "properly" imho.
> And we don't really need this afaict.

Agreed -- which is why I was suggesting we should consider using
skb->do_not_fragment instead. Although I didn't finish complete review
to ensure that is the only reason we need this. That is a more generic
flag. Thoughts?

  Luis
