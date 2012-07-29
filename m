Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59927 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab2G2WtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2012 18:49:06 -0400
Received: by obbuo13 with SMTP id uo13so8013678obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jul 2012 15:49:06 -0700 (PDT)
Date: Sun, 29 Jul 2012 17:48:57 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	=?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Roland Vossen <rvossen@broadcom.com>
Subject: Re: [3.2.y] Re: Brcmsmac driver woes, possible regression?
Message-ID: <20120729224857.GA21285@burratino> (sfid-20120730_004911_994878_E0A113CE)
References: <CAKprTDHQT8Oodh_YD5CWffSGJXAg-HgFMjR0STVgEZRxH4FaSQ@mail.gmail.com>
 <20120604084200.GA30645@tiikeri.vuoristo.local>
 <20120604173121.GA9238@stt008.linux.site>
 <20120605050620.GC3118@burratino>
 <CAKprTDHGqDpdZY4ErZmPEc7Ur81GeQoH8tiAL5hrfhAE0RtbvQ@mail.gmail.com>
 <20120611031544.GB3092@burratino>
 <4FE0CA49.3030909@broadcom.com>
 <20120716213122.GA3078@burratino>
 <50051A2F.3030206@broadcom.com>
 <20120723002808.GA3305@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20120723002808.GA3305@burratino>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jonathan Nieder wrote:
> Arend van Spriel wrote:

>> I guess the behaviour improved due to the last two patches listed above,
>> but I also suspect that it is only an improvement and the root cause
>> still exists.
>
> I think you're right.  Camaleón tried with all patches except the last
> one and still got the unwanted reconnects.
>
> Would 6b8da423315b and 94a2ca311cf4 be good candidates for stable@ in
> the meantime (for symptom relief and saner regulatory code) until the
> root cause is found?

To answer my own question: I guess not, at least not on the basis of
Camaleón's experience.

Results so far:

 * mainline >= 3.4.y: seemed to be ok for a few days, never showed the
   problem.
 * 3.2.19 + the 23 patches discussed in this thread: worked fine for about
   a week, never showed the problem.
 * 3.2.18: failed quickly.
 * 3.2.19 + first patch: failed quickly.
 * 3.2.2: worked ok for a while, then acted up again.  Affected.
 * 3.2.21 + 10 patches: failed quickly.
 * 3.2.21 + all 23 patches: worked ok-ish (?) for a week ("only a
   couple reconnects in 7 days, but when that happened gnome-shell was
   not segfaulting at least...").  I should have paid more attention:
   that meant it was affected!
 * 3.2.21 + 17 patches: failed quickly.
 * 3.2.21 + 19 patches: failed quickly.
 * 3.2.22 + 22 patches: failed quickly.
 * 3.2.21 + patch #23 alone: failed quickly.
 * 3.2.21 + all 23 patches: failed quickly.

Arend, you're very good at this guessing game. ;-)

I imagine the problem is still present in mainline.  Camaleón, the
next useful test would probably be mainline or wireless-testing, and
we should probably stop being so lazy and try to figure out _what_ is
happening when it reconnects and whether it is even a kernel bug.  It
might be something normal (like rekeying) not being handled well by
userspace.

Whatever it is, it seems that the kernel can help, since the
proprietary Broadcom wl driver works better if I have understood
Camaleón correctly.

Thanks,
Jonathan
