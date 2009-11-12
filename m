Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:52013 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZKLTqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 14:46:04 -0500
Received: by iwn8 with SMTP id 8so2042209iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 11:46:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911122037.39145.chunkeey@googlemail.com>
References: <167ae39b0910071400n218d3d9ey7711b1011f290a73@mail.gmail.com>
	<200911121717.36906.chunkeey@googlemail.com> <4AFC5A5E.1050405@canonical.com>
	<200911122037.39145.chunkeey@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 12 Nov 2009 11:45:50 -0800
Message-ID: <43e72e890911121145i3d9f6891m362498fad2f99f79@mail.gmail.com>
Subject: Re: Prism54/p54pci
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: tim.gardner@canonical.com, James Grossmann <cctsurf@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 12, 2009 at 11:37 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Thursday 12 November 2009 19:56:30 Tim Gardner wrote:
>> Christian Lamparter wrote:
>> > On Friday 06 November 2009 21:52:42 James Grossmann wrote:
>> >> my caps lock & scroll lock leds are not blinking, and yet the computer
>> >> is frozen.  (I'm not the best at terminology, I guess that might not
>> >> be defined as a hard lock.)  I get no odd messages in my syslog.  I am
>> >> using Ubuntu right now, so I'm guessing that they have all the
>> >> prettyness going that they can, covering the important messages, but
>> >> as it's not an actual oops, I'm not certain that's hurting us.
>> > just a update:
>> >
>> > I can confirm the freeze with ubuntu 9.10 (2.6.31-14 & 2.6.31-15-generic)
>> > + compat-wireless + p54pci (either as backport module or compiled from git).
>> > The original modules (shipped with 2.6.31-14/15) are fine though..?!
>>
>> The Ubuntu Karmic linux-backports-modules package is based on
>> compat-wireless-2.6.32-rc4. I'm wondering if its something specific to
>> the p54pci driver? I'm using iwlagn (4965) from that package with no
>> problems (so far).
>
> I put a ath5k card into the same machine and tried with the same
> compat-wireless modules. Surprise, surprise: no problems...
>
> The affected device works fine with the current wireless-testing(pulled today)
> and a vanilla 2.6.31.6 + compat-wireless (from today's git).
>
> I've no idea what voodoo is going on here, maybe there is
> something wrong in compat-wireless pci glue code (if there's any?!)

Should be easy to debug, the compat 2.6.31 code is in
compat/compat-2.6.32.[ch] and since there is no 2.6.33 yet that is
all. That and of course any ifdef which applies on the
compat/patches/.

>> Its not clear what version of stable compat-wireless you've tried.
>> Does compat-wireless-2.6.32-rc6 exhibit the same problem?
> "compiled from git", which should be compat-wireless-2009-11-12.tar.bz2
> and therefore -rc6.

Well no, I believe what Tim means is the stable compat-wireless
releases which are not based on master git on compat-wireless. These
are based on a branch for the specific stable kernel. The stable
compat-wireless releases use hpa's tree:

git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-allstable.git

and I checkout specific 2.6.3x.y branches. So for 2.6.32 I just use
master though which is based on Linus' tree and the latest *stable*
2.6.32-rcx.

  Luis
