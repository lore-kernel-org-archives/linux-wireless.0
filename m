Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:35767 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbbGCOUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2015 10:20:52 -0400
Received: by ykdy1 with SMTP id y1so96947237ykd.2
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jul 2015 07:20:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55966D1B.1040603@neratec.com>
References: <CAHr=Vq=hJr6WUQgFXftMSG2zYgwtCXgoTaXBzRfM8-kQa2-K2w@mail.gmail.com>
	<55966D1B.1040603@neratec.com>
Date: Fri, 3 Jul 2015 07:20:51 -0700
Message-ID: <CAHr=VqnpJ_+ovmB3gqm+X9WX98ZeVuO8VZ2cq6OFPcdjy8Rkgg@mail.gmail.com> (sfid-20150703_162056_466819_7C34CDAB)
Subject: Re: wireless-regdb: update CA rules for 5600 - 5650 mHz
From: Wei Zhong <wzhong@google.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 3, 2015 at 4:08 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>
> On 07/02/2015 07:44 AM, Wei Zhong wrote:
> > commit 2fef4cad8a1bd9cbbf178e59a1b3ca672b057095
> > Author: Wei Zhong <wzhong@google.com>
> > Date:   Wed Jul 1 22:39:09 2015 -0700
> >
> >     wireless-regdb: update CA rules for 5600 - 5650 mHz
> >
> >     Related regulation:
> >     http://www.ic.gc.ca/eic/site/smt-gst.nsf/eng/sf10971.html#s6.2.3
> >
> >     Frequency Bands 5470-5600 MHz and 5650-5725 MHz
> >     Until further notice, devices subject to this section [i.e. Wifi device
> >     supporting 5 GHz bands] shall not be capable of transmitting in the band
> >     5600-5650 MHz. This restriction is for the protection of Environment
> >     Canada’s weather radars operating in this band.
> >
> > diff --git a/db.txt b/db.txt
> > index 809cd3c..da0cfad 100644
> > --- a/db.txt
> > +++ b/db.txt
> > @@ -216,7 +216,8 @@ country CA: DFS-FCC
> >         (2402 - 2472 @ 40), (30)
> >         (5170 - 5250 @ 80), (17), AUTO-BW
> >         (5250 - 5330 @ 80), (24), DFS, AUTO-BW
> > -       (5490 - 5730 @ 160), (24), DFS
> > +       (5490 - 5600 @ 80), (24), DFS
> > +       (5650 - 5730 @ 40), (24), DFS
> >         (5735 - 5835 @ 80), (30)
> >
> >  # Source:
> > --
>
> I believe this could also be interpreted differently. If the change is only about
> removing the weather radar band (5600-5650), the change should be
>
>  -       (5490 - 5730 @ 160), (24), DFS
>  +       (5490 - 5570 @ 80), (24), DFS
>  +       (5570 - 5590 @ 20), (24), DFS
>  +       (5650 - 5730 @ 80), (24), DFS
>
> The second rule explicitly states that channel 116 remains available for HT20. If
> this level of strict correctness is not needed, rule 1 and 2 combined would be
>
>  -       (5490 - 5730 @ 160), (24), DFS
>  +       (5490 - 5590 @ 80), (24), DFS

I agree. 5590 is more strict than 5600.

>
>  +       (5650 - 5730 @ 80), (24), DFS

5690 MHz is not a channel can be used, is it still necessary to mark
this band as 80MHz while in practice it is not possible to fully
unitize the entire band?

>
>
> Cheers
> Zefir
