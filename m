Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp01.msg.oleane.net ([62.161.4.1]:34556 "EHLO
	smtp01.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbbCXImE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 04:42:04 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Michal Kazior'" <michal.kazior@tieto.com>
Cc: "'linux-wireless'" <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A319019FEF93@sbs2003.acksys.local> <CA+BoTQkJ2qYKMzWHaW2wTq1qhoDn=FYEU7Wgo+Jyevzi1bBDEA@mail.gmail.com>
In-Reply-To: <CA+BoTQkJ2qYKMzWHaW2wTq1qhoDn=FYEU7Wgo+Jyevzi1bBDEA@mail.gmail.com>
Subject: RE: ath10k: What will happens when radar is detected ?
Date: Tue, 24 Mar 2015 09:41:59 +0100
Message-ID: <01eb01d0660e$650becc0$2f23c640$@acksys.fr> (sfid-20150324_094210_304494_B88695E4)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Message d'origine-----
> De : Michal Kazior [mailto:michal.kazior@tieto.com]
> Envoyé : mardi 24 mars 2015 07:56
> À : Cedric VONCKEN
> Cc : linux-wireless
> Objet : Re: ath10k: What will happens when radar is detected ?
> 
> On 23 March 2015 at 16:16, Cedric VONCKEN <cedric.voncken@acksys.fr>
> wrote:
> > In 802.11ac standard, it is possible to dynamically reduce the channel
> > width used.
> > My question is:
> >         If I use a channel with 80 or 40 MHz width, what will happen
> > if I detect radar?
> >                 The ath10k card/driver reduces automatically the
> > channel width.
> 
> Currently entire chandef occupied will be marked as unavailable and AP
> will stop/switch to a different non-overlapping chandef via CSA.
Thanks for your answer.
> 
> I guess it should be possible to implement what you suggest, i.e.
> change only chandef width when radar is narrow and located at a suitable
> part of the chandef. This would require hw to be capable of detecting
> radar center freq and width accurately. I'm not sure if QCA988X is
> capable of that although firmware interface seems to be able to carry
> this kind of information already.
> 
> I wonder why would you want this behaviour in the first place?
> Wouldn't this actually end up with having less bandwidth and lower
> throughput (which is already penalized when radar detection is active)?
In an industrial environment we prefer to reduce the throughput but keep the link without gap. I think it can be a parameter in AP software for example.

Cédric

