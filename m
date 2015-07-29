Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33254 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbbG2JCm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 05:02:42 -0400
Received: by wicmv11 with SMTP id mv11so210077300wic.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2015 02:02:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <871tfr8ne9.fsf@kamboji.qca.qualcomm.com>
References: <CAMQd7mbWC7rj8-eU7Jv21ehT8KrpC=L=xWxzDQxHEU_ePNSdUg@mail.gmail.com>
	<CA+BoTQmd0Uoi=2MNMsDXYe1yKsYa3P8uvVzWwXoMynQGtjeD4w@mail.gmail.com>
	<CAMQd7maioLviTaLHp+f03HafABijKD_d92K_SRO8XS51poKGqg@mail.gmail.com>
	<CA+BoTQkA0k1RBwzKFchcWebuWUmdoaqvaAq4BRz2o3C-GGUCog@mail.gmail.com>
	<CAMQd7ma7hehYLBf-5hUD0sViUwWGX8vy7ENXuBi8Q49F88A45Q@mail.gmail.com>
	<CA+BoTQkqttvPkk6qk6YV8SYPVnEcADfcUkLBCpjFoZBab81Byg@mail.gmail.com>
	<871tfr8ne9.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 29 Jul 2015 11:02:40 +0200
Message-ID: <CAMQd7mY+upL+t9q0yJ0uL_jw_STEKL+hhe1PF_D5yPwfTkcgZg@mail.gmail.com> (sfid-20150729_110247_432006_D48C568C)
Subject: Re: QCA6174 hw2.1 irq_mode=0 broken on 4.2-rc3, working on 4.1.2
From: Enrico Tagliavini <enrico.tagliavini@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yeah that's what I meant. My idea was to first bisect only the ath10k
directory, so restricting the bisect on the commits touching stuff
there. I guess if the issue is more broad it will come up somewhere
else as well, so this is a good starting point, I hope. Thank you for
pointing it out though, this will actually be the first time I do a
proper bisect.

Also do you want me to bisect Kalle's sources or Linus' master? By
what Michał said I guess Kalle's but I ask to be sure.

Also to be clear: I'm using Linus' sources at the moment, as provided
by Fedora rawhide.

For me it's the same, so let me know what you prefer and is more
useful to solve this issue.

On 29 July 2015 at 08:54, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>>> This wont work for bisecting. I have to setup something else. Is
>>> it ok if I restrict the bisect on the ath10k tree? That has enough
>>> commit already to begin with, plus I'm going to be on the road in less
>>> than two weeks.
>>
>> As long as you establish a working and a non-working commit id on
>> kvalo tree it should be fine I guess.
>
> And you can always limit the bisect to a certain directory, but the risk
> here is that if the regression is outside ath10k bisect won't find it.
> So you need to carefully consider is it safe to do or not. From the man
> page:
>
> "Cutting down bisection by giving more parameters to bisect start
>
>        You can further cut down the number of trials, if you know what
>        part of the tree is involved in the problem you are tracking
>        down, by specifying path parameters when issuing the bisect start
>        command:
>
>            $ git bisect start -- arch/i386 include/asm-i386"
>
> Also if you can even just narrow down the regression to a smaller set of
> patches, let's say few hundred, might make it easier to find the
> regression.
>
> --
> Kalle Valo
