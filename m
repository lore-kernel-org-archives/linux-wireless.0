Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36833 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab2JXV0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 17:26:07 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so646475pad.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 14:26:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmonEZbKiVqnu1SDDbNDTj3qeWB2QgTN=h3NHdiZrMp8LDA@mail.gmail.com>
References: <CAG6hwVP5YkBEN9vZPGGEHbK=9ow2wJJ1x_BvSQbDzUscTiOHTA@mail.gmail.com>
	<CAJ-Vmokr0293M-yqQ6LvM4WKC+P0w0N2mHjpKK+rSFFjAmhwfQ@mail.gmail.com>
	<20121024194547.GA19060@shredder>
	<CAJ-VmonEZbKiVqnu1SDDbNDTj3qeWB2QgTN=h3NHdiZrMp8LDA@mail.gmail.com>
Date: Wed, 24 Oct 2012 14:26:05 -0700
Message-ID: <CAJ-VmonzYsUsSOyr34Xj9=mTpsHEbGNUS2RoN=BenqthGfakVw@mail.gmail.com> (sfid-20121024_232611_135526_AE0A92FA)
Subject: Re: [ath9k-devel] ath9k_htc and reported mactime
From: Adrian Chadd <adrian@freebsd.org>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 October 2012 14:22, Adrian Chadd <adrian@freebsd.org> wrote:
> Hi,
>
> can you please repeat this experiment but dump the TSF32/TSF64 fields
> there as hexadecimal, rather than decimal?
>
> I'd like to see if this is an example of "bad TSF32->TSF64 promotion".

Also, we should check to see whether the MAC is paying attention to
any beacon frames and updating _its_ timestamp using that beacon frame
timer.
That's one of the mesh-and-sta-and-ap-at-the-same-time problems - in
STA mode, the TSF gets fudged based on the AP TSF. In other modes this
doesn't necessarily hold.



Adrian
