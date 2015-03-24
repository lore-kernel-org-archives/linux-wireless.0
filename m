Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37167 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbbCXG4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 02:56:14 -0400
Received: by wixw10 with SMTP id w10so85979134wix.0
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2015 23:56:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <773DB8A82AB6A046AE0195C68612A319019FEF93@sbs2003.acksys.local>
References: <773DB8A82AB6A046AE0195C68612A319019FEF93@sbs2003.acksys.local>
Date: Tue, 24 Mar 2015 07:56:12 +0100
Message-ID: <CA+BoTQkJ2qYKMzWHaW2wTq1qhoDn=FYEU7Wgo+Jyevzi1bBDEA@mail.gmail.com> (sfid-20150324_075617_600900_6A3FB131)
Subject: Re: ath10k: What will happens when radar is detected ?
From: Michal Kazior <michal.kazior@tieto.com>
To: Cedric VONCKEN <cedric.voncken@acksys.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 March 2015 at 16:16, Cedric VONCKEN <cedric.voncken@acksys.fr> wrote:
> In 802.11ac standard, it is possible to dynamically reduce the channel
> width used.
> My question is:
>         If I use a channel with 80 or 40 MHz width, what will happen if
> I detect radar?
>                 The ath10k card/driver reduces automatically the channel
> width.

Currently entire chandef occupied will be marked as unavailable and AP
will stop/switch to a different non-overlapping chandef via CSA.

I guess it should be possible to implement what you suggest, i.e.
change only chandef width when radar is narrow and located at a
suitable part of the chandef. This would require hw to be capable of
detecting radar center freq and width accurately. I'm not sure if
QCA988X is capable of that although firmware interface seems to be
able to carry this kind of information already.

I wonder why would you want this behaviour in the first place?
Wouldn't this actually end up with having less bandwidth and lower
throughput (which is already penalized when radar detection is
active)?


Michał
