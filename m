Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:37485 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbYGYDmr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 23:42:47 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3844173wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2008 20:42:47 -0700 (PDT)
Message-ID: <3ace41890807242042h1420b4dby2a00a99691a4bb85@mail.gmail.com> (sfid-20080725_054253_893983_D7B5D577)
Date: Fri, 25 Jul 2008 04:42:47 +0100
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890807240105k5626c793if9cb9a2e3f62835b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com>
	 <200807221940.20009.herton@mandriva.com.br>
	 <4886AA3B.3000406@lwfinger.net> <4886C50E.6040304@lwfinger.net>
	 <1216824917.13587.9.camel@johannes.berg>
	 <48874F09.7060400@lwfinger.net>
	 <3ace41890807232028u576371a6ra944431327cac76c@mail.gmail.com>
	 <488815DE.2000903@lwfinger.net>
	 <3ace41890807240105k5626c793if9cb9a2e3f62835b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 24, 2008 at 9:05 AM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> On Thu, Jul 24, 2008 at 6:40 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> <snipped>
>> I will be submitting the proper patch tomorrow, particularly if it works for
>> others.
>
> I was being over-optimistic... it worked for me for a good while but
> doesn't after a reboot/what-not.
> So it probably needs to be done but there may be more missing.
> Do we need to start the seq number from some where?

I put the patch on top of
a520bdbe7d344296482f9355e29b0018ea58760f
(current wireless-testing master head), and did
make -C /lib/modules/`uname -r`/build M=`pwd` rtl8187.ko and replaced
the one shipped in kernel-2.6.25.12-100.fc9 (that should be essentially also
wireless testing head), depmod -a , and it works. Wierd. The as
shipped module has the problem
Larry described earlier - I could get an ip address, and leaving a ping running
it fails after about the 7th ping packets, quite soon.

So my problem seems to be largely due to the tx seq no change.
(maybe with some other issues thrown in occasionally).

Is adding the couple of lines likely to cause problems? it
is an improvement in my case although so far it seems to work say, maybe
2/3 or 3/4 of the time (i.e. I patch a few new kernel rpms, it either
work or it
doesn't and if it doesn't I go back to the trust-worthy one before
July 14), and the code seems to be
a sensible (for the time being). Maybe Larry is affected by more than one
problem, like possibly the power management issue Herton mentioned.

Hin-Tak
