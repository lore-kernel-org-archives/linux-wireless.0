Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:33677 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbcGSNOB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 09:14:01 -0400
Received: by mail-wm0-f45.google.com with SMTP id r190so26112286wmr.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 06:14:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Tue, 19 Jul 2016 15:13:58 +0200
Message-ID: <CA+BoTQ=Bi070XDXNjq6ypzs3w0+9OYM_8tXeikSR_a0TMN2P=g@mail.gmail.com> (sfid-20160719_151406_430623_A504EECB)
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 July 2016 at 12:09, Felix Fietkau <nbd@nbd.name> wrote:
> Hi,
>
> With Toke's ath9k txq patch I've noticed a pretty nasty performance
> regression when running local iperf on an AP (running the txq stuff) to
> a wireless client.
>
> Here's some things that I found:
> - when I use only one TCP stream I get around 90-110 Mbit/s
> - when running multiple TCP streams, I get only 35-40 Mbit/s total

What is the baseline here (i.e. without fq/txq stuff)? Is it ~100mbps?

Did you try running multiple streams, each on separate tids (matching
the same AC perhaps) or different clients?


Michał
