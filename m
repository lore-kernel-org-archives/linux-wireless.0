Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41354 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbeIJH3N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 03:29:13 -0400
MIME-Version: 1.0
References: <20180906035323.GA11337@nems_nctu_lu> <877ejzynz9.fsf@toke.dk>
 <CADMDV=ws-iM6+L+CLyrGK=srV56jbYgBbOVWg2AxEX0gR6t8WQ@mail.gmail.com> <87sh2mykmt.fsf@toke.dk>
In-Reply-To: <87sh2mykmt.fsf@toke.dk>
From: Dave Taht <dave.taht@gmail.com>
Date: Sun, 9 Sep 2018 16:44:53 -0700
Message-ID: <CAA93jw4ud9f2hwhz5nqJa3B0p8N7hP=Hd9ZyGok-k16_-sonoQ@mail.gmail.com> (sfid-20180910_043735_764128_54AF44EE)
Subject: Re: [PATCH] ath9k: add reset for airtime station debugfs
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: git@louie.lu, Kalle Valo <kvalo@codeaurora.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 6, 2018 at 4:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.=
dk> wrote:
>
> Louie Lu <git@louie.lu> writes:
>
> > Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> =E6=96=BC 2018=E5=B9=B4=
9=E6=9C=886=E6=97=A5 =E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=885:27=E5=AF=AB=E9=
=81=93=EF=BC=9A
> >
> >> Louie Lu <git@louie.lu> writes:
> >>
> >> > Let user can reset station airtime status by debugfs, it will
> >> > reset all airtime deficit to ATH_AIRTIME_QUANTUM and reset rx/tx
> >> > airtime accumulate to 0.
> >>
> >> No objections to the patch, but I'm curious which issues you were
> >> debugging that led you to needing it? :)
> >>
> > I'm testing to get the packet queue time + airtime in
> > ath_tx_process_buffer,
>
> Right; I've been thinking that it would be useful to make the CoDel
> enqueue time available to drivers. And minstrel, for that matter
> (lowering the number of retries for packets that has queued for a long
> time, for instance). Good to hear that others are looking into something
> similar :)

Yea! Seeing retransmits scale down would be a goodness. Last I looked
ath9k was at, like 10?, when it should be, like, 2, at mcs0 and 10 at
mcs15.

I can't seem to publish a link to this directly, but it's open access
if you search via https://scholar.google.com/:

"Resolving Bufferbloat in TCP Communication over IEEE 802.11 n WLAN by
Reducing MAC Retransmission Limit at Low Data Rate"

even their simple bifurcated model worked well.




>
> > it would be useful if I can reset the station airtime accumulated
> > value, so I can observe in each test round (e.g. 5 ping) airtime
> > accumulated
> >
> > Also to reset the deficit to make sure it run like fresh one.
>
> Yup, makes sense.
>
> -Toke



--=20

Dave T=C3=A4ht
CEO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-669-226-2619
