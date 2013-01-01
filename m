Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54420 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab3AAEZm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Dec 2012 23:25:42 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq7so6517532wib.5
        for <linux-wireless@vger.kernel.org>; Mon, 31 Dec 2012 20:25:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn1UyObSBrpAq+oJOm+Q1PuC=Y9J0cFH3aC3LkPei6QZYw@mail.gmail.com>
References: <773DB8A82AB6A046AE0195C68612A31901412125@sbs2003.acksys.local>
	<CAD2nsn1UyObSBrpAq+oJOm+Q1PuC=Y9J0cFH3aC3LkPei6QZYw@mail.gmail.com>
Date: Mon, 31 Dec 2012 20:20:35 -0800
Message-ID: <CAJ-VmomdWE2d3qUzgOR0=pnoKzeJpFG1rOT1XH3gTB-dtosuVg@mail.gmail.com> (sfid-20130101_052550_791121_57F2E566)
Subject: Re: [RFC] ATH9K: infinite loop in Tasklet
From: Adrian Chadd <adrian@freebsd.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Cedric VONCKEN <cedric.voncken@acksys.fr>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 December 2012 06:19, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
> On Tue, Dec 11, 2012 at 3:31 PM, Cedric VONCKEN
> <cedric.voncken@acksys.fr> wrote:
>>         Any suggestion to fix correctly this issue ?
>
> having a count to break out from the loop is bit hacky. I would
> suggest to enable as many prints and see
> why the infinite loop counts(ofcourse you can have a loop count to
> figure out and break the loop).

IMHO both need to be done. It's possible that it's taking way too long
to handle frames in the driver layer. The ath/ath9k driver layer
assumes that it can dequeue frames from the hardware FASTER than it
can queue those frames to the network stack layer. If the latter falls
behind (or both, really) then you can hit this condition.

FWIW, I've done this in FreeBSD's ath(4) driver in both the TX and RX
path, to ensure that I give the tasklets all a fair crack at being
scheduled.



Adrian
