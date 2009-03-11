Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:44359 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbZCKANA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 20:13:00 -0400
Received: by ewy25 with SMTP id 25so1482153ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 17:12:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1236728344.26432.26.camel@maxim-laptop>
References: <1236728344.26432.26.camel@maxim-laptop>
Date: Wed, 11 Mar 2009 02:12:56 +0200
Message-ID: <40f31dec0903101712n31b6dedeuc369beec0d0f64cc@mail.gmail.com> (sfid-20090311_011304_175647_048940E0)
Subject: Re: Thanks for TX power patch
From: Nick Kossifidis <mickflemm@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/11 Maxim Levitsky <maximlevitsky@gmail.com>:
>
> First, big thanks to Nick Kossifidis
> Finally I get a decent speed out of my aspire one
> iwconfig output specifies 54M/s.
>

It's not only my work it's also Felix's work and of course Sam's work,
but thanks anyway ;-)

> Still transfer speeds are at 2.4~2.5M/s, while I could achieve 2.9~3.=
0
> Mb/s on my iwl3945. Probably ANI support with fix that, or maybe just
> that is the device maximum, for example due to noise at hardware path=
s,
> not a perfect amplifier, etc... I need to test this in windows.
>

It can also be the missing Spur mitigation stuff, missing WME stuff,
we have a lot of things to do (i'll update the TODO list on wiki
asap)...

> Also, ath5k issues many resets to the device, which results in transf=
er
> stalls for few seconds, so effective speed is much lower.
> But these are minor solvable problems, and thus thanks again.
>

Yup we need to stop calling reset so often also after i'm done with
phy stuff i'll focus on a smaller reset that'll only tweak some parts
of pcu/qcu to stop/resume queues without reseting the whole chip.

>
> So in summary your patch works fine.
>

Thanks a lot for your feedback ;-)

> But I noticed that few (or one) bugs crept into ath5k while I didn't
> update it.
>
> Latest version of wireless-testing that doesn't produce any
> oopses/problems with suspend to disk, etc : master-2009-02-24
>
>
> I now downloaded the 'compat-wireless-2009-03-10', and installed on t=
he
> above tree (I usually just install and use a wireless-testing tree, b=
ut
> this time I was lazy, so I just installed compat-wireless package)
>
>
> With or without (tested both) latest Nick's patches, it fails very ba=
dly
> with suspend to disk.
>
> After a suspend to disk, NM can't scan - iwlist scan says : device is
> busy
>
> (Btw I got same behavior with my iwl3945 - I disabled its hardware sc=
an
> to fix this temporally)
>
>
> If I unload/reload the ath5k, it seems to work. but at next suspend t=
o
> disk, once =C2=A0system hung, other time it showed many panic, in som=
ething
> related to page allocator (one even was in page_alloc_pages or so)
>
>
> Next time I just reloaded the ath5k, and got this in dmesg:
>
>
>

I got this too many times and also some kmemcheck stuff but i didn't
had any time to look at it, i don't think it's related to ath5k or
mac80211, i got such crashes with the applesmc module too.



--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
