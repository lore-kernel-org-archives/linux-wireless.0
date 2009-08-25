Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:54230 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbZHYXwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 19:52:34 -0400
Received: by iwn42 with SMTP id 42so1465399iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 16:52:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090825233827.GA10998@mosca>
References: <1251224728-7180-1-git-send-email-lrodriguez@atheros.com>
	<b6c5339f0908251145h3a075b86hab00d2223f9acc58@mail.gmail.com>
	<20090825185842.GA7357@mosca> <b6c5339f0908251222h5fb281c3vf3ecea8b27eb02ed@mail.gmail.com>
	<20090825233827.GA10998@mosca>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 25 Aug 2009 16:52:16 -0700
Message-ID: <43e72e890908251652k82f542bx1e6897b12eadc2e9@mail.gmail.com>
Subject: Re: [PATCH] ath5k: fix print on warning on ath5k_hw_to_driver_rix()
To: Bob Copeland <me@bobcopeland.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 25, 2009 at 4:38 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> On Tue, Aug 25, 2009 at 12:22:55PM -0700, Bob Copeland wrote:
>> On Tue, Aug 25, 2009 at 2:58 PM, Luis R.
>> Rodriguez<lrodriguez@atheros.com> wrote:
>> > OK how about the band info, think that's useful?
>>
>> Yeah, band is useful.  We don't have to pretty print it though
>> (unless you really feel like it), %d would work just as well.
>>
>> Also WARN_ON_ONCE might be a good idea.
>
> Alright, first let me see if I can reproduce after cleaning
> curband crap a little.
>
>> >> which could indicate some
>> >> race condition with flushing the rx queue on channel changes.
>> >
>> > I'll see if I can reproduce somehow.
>> >
>> >> I haven't yet seen a hw rate we didn't know about.
>> >
>> > So you've seen this lately as well?
>>
>> I saw it some time ago, but then changed the order of how the
>> curchan/curband variables were set when we change channels and
>> haven't seen since.  But kerneloops says a lot of other people
>> are still hitting it as well :(
>
> OK that's good to know too.
>
>> Hmm, ath5k_rx_stop probably wants an equivalent to txq_drainq in
>> there somewhere.
>
> True.
>
> First thing I saw upon a quick review was we were relying on our own
> curband for RX instead of the cfg80211 hw->conf band. Now granted
> that *may* be updated properly, and it seems that may be the case,
> but since do not tend to trust drivers here's a removal of all that
> crap first. I'll test this first to see if I run into the same warning.
> If this doesn't cure it then we are indeed processing old frames on RX
> and need to flush 'em out prior to a channel change first.
>
> Good thing is after a few hours I can reproduce at least.

Whah, the warn is still there.

[ 7281.492622] ------------[ cut here ]------------
[ 7281.492655] WARNING: at drivers/net/wireless/ath/ath5k/base.c:1133
ath5k_tasklet_rx+0x57b/0x720 [ath5k]()
[ 7281.492663] Hardware name: 7660A14
[ 7281.492668] invalid driver rate index mapped for hw_rix: 1b on freq: 5540

  Luis
