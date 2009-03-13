Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f165.google.com ([209.85.217.165]:56119 "EHLO
	mail-gx0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759001AbZCMV3M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 17:29:12 -0400
Received: by gxk9 with SMTP id 9so411451gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 14:29:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1236896331-5026-1-git-send-email-lrodriguez@atheros.com>
References: <1236896331-5026-1-git-send-email-lrodriguez@atheros.com>
Date: Fri, 13 Mar 2009 14:29:08 -0700
Message-ID: <43e72e890903131429h560dd786j74dd93a9e80fac12@mail.gmail.com> (sfid-20090313_222915_811550_E7A0EEA5)
Subject: Re: [ath9k-devel] [PATCH v6 0/3] ath9k: SMP fixes
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: "stable@kernel.org" <stable@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 12, 2009 at 3:18 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> This v6 removes the hotplug CPU stuff which although it technically
> would be correct is more cruft and highly unlikely. The down side
> is you will get serialization applied even if you only have one
> CPU but who cares, I doubt those nutty SGI guys are toying with
> ath9k in the lab.
>
> Yesterday I started mucking with an alternative approach to
> serialization which worked. I added just 5 udelay()s in key places
> where we had a lot of consecutive IO read/writes issued and that
> resolved the issue at least for STA mode but it didn't do the trick
> for AP mode. Technically it should be possible to groom all hardware
> access routines to do the same but I'm tired of this issue and want
> to a fix merged today not a few weeks from now. Anyway if you are
> curious you can check out that patch replacement approach for
> serialization here:
>
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/20=
09-03-12/smp-udelay-fix.patch
>
> Note that AP won't work though so if you have a lot of time in your
> hands and have an SMP box with PCI Atheros 11n and are seeing the han=
gs
> and want a neat alternative to the current serialization implementati=
on
> try adding udelays like the ones in the patch in places where we do a=
 lot
> of io read/writes. Send me the results :)
>
> The compromise is to keep serialization conditional -- we do not want=
 to
> do it for every read/write regardless of the type of card you have, t=
he
> code overhead is not great and we maintain this anyway. Adding it for=
 all
> cases would just not be optimal.
>
> Luis R. Rodriguez (3):
> =C2=A0ath9k: implement IO serialization
> =C2=A0ath9k: AR9280 PCI devices must serialize IO as well
> =C2=A0ath9k: remove dummy PCI "retry timeout" fix
>
> =C2=A0drivers/net/wireless/ath9k/ath9k.h | =C2=A0 34 ++++++++++++++++=
++++++++++++++++++
> =C2=A0drivers/net/wireless/ath9k/hw.c =C2=A0 =C2=A0| =C2=A0 28 ++++++=
+++++++++++++++++++++-
> =C2=A0drivers/net/wireless/ath9k/hw.h =C2=A0 =C2=A0| =C2=A0 =C2=A04 +=
+--
> =C2=A0drivers/net/wireless/ath9k/main.c =C2=A0| =C2=A0 =C2=A01 +
> =C2=A0drivers/net/wireless/ath9k/pci.c =C2=A0 | =C2=A0 18 -----------=
-------
> =C2=A05 files changed, 64 insertions(+), 21 deletions(-)

John, Greg,

these patches require a port down to the other stable kernels, I've
taken the time to port only the necessary patches (the first two) to
fix the SMP hang on each stable kernel and test them accordingly:

* 2.6.27
* 2.6.28
* 2.6.29

Once merged into wireless-testing the following patches can be used to
push into Linus' tree:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2009=
-03-12/serialization-v6/for-2.6.29/

Once merged into stable these can be used to merge into 2.6.27 and 2.6.=
28:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2009=
-03-12/serialization-v6/for-2.6.27/
http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2009=
-03-12/serialization-v6/for-2.6.28/

Just replace:

This is a port of commit SHA1 <BLEH>

With the respective SHA1.

I can also simply resend the ports for 27 and 28 once merged into
Linus' tree. Whatever makes it easier for you.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
