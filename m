Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:39409 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbZEMVtN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 17:49:13 -0400
Received: by rv-out-0506.google.com with SMTP id f9so554079rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 14:49:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242225507.9913.0.camel@johannes.local>
References: <1242030669.6930.10.camel@johannes.local> <9b2b86520905120709v4bd00e1eo4da26e6c5f75c4ba@mail.gmail.com>
	<1242211796.29288.7.camel@johannes.local> <9b2b86520905130736j6cde99cak6fad414531b0168c@mail.gmail.com>
	<1242225507.9913.0.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 13 May 2009 14:48:54 -0700
Message-ID: <43e72e890905131448l321b90c7i7373b1e1b24eb71c@mail.gmail.com>
Subject: Re: [RFT v9] rfkill: rewrite
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 7:38 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-05-13 at 15:36 +0100, Alan Jenkins wrote:
>
>> >> <http://picasaweb.google.com/sourcejedi.lkml/Screenshots#53349368=
57267342674>
>> >>
>> >> The kernel then hangs later on in the boot process. =C2=A0It resp=
onds to
>> >> SysRq, but does not echo normal keypresses. =C2=A0SysRq+P shows t=
hat the
>> >> kernel is in the idle task. =C2=A0I left it for three minutes, bu=
t I didn't
>> >> get any trace from the hung task detector or soft lockup detector=
=2E
>> >>
>> >> At first I thought it must be a problem with wireless-testing.
>> >> However, it went away when I eventually tried un-applying the rfk=
ill
>> >> rewrite patch.
>> >
>> > Confusing, but I think the stacktrace is just bogus. Can you recom=
pile
>> > your kernel with CONFIG_FRAME_POINTER please?
>>
>> Nope, cos it's already enabled :-).
>
> Damn, I had hoped to get relevant information. I really don't see how
> rfkill could cause a problem in regulatory code, let's ask Luis.

I'd review the code but its easier to just ask for now -- do you use
the global workqueue ? Anyway -- the more jammed up the global
workqueue is the more likely it is that last_request will not be
populated before a driver comes around with they custom reg request.
The stupid solution is to check for last_request. The right solutions
it to flush the global workqueue which I have just addressed.

Mind you I think its now worth considering adding our own workqueue to
cfg80211 so we don't have to flush every damn thing on the global
workqueue on the core initialization but I figured that can be done in
a separate series as we need to address stable as well.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
