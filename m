Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50056 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab2JVOb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 10:31:29 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so2457412oag.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2012 07:31:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVP5YkBEN9vZPGGEHbK=9ow2wJJ1x_BvSQbDzUscTiOHTA@mail.gmail.com>
References: <CAG6hwVP5YkBEN9vZPGGEHbK=9ow2wJJ1x_BvSQbDzUscTiOHTA@mail.gmail.com>
Date: Mon, 22 Oct 2012 07:31:28 -0700
Message-ID: <CAJ-Vmokr0293M-yqQ6LvM4WKC+P0w0N2mHjpKK+rSFFjAmhwfQ@mail.gmail.com> (sfid-20121022_163132_701698_90153F7B)
Subject: Re: [ath9k-devel] ath9k_htc and reported mactime
From: Adrian Chadd <adrian@freebsd.org>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


On 20 October 2012 19:32, Thomas Pedersen <thomas@cozybit.com> wrote:
> Hi list,
>
> We're seeing some issue with reported mactime by the ath9k_htc (AR9271)
> card. Here is a mesh node sampling peer beacons:
>

[snip]

> The number after "at" is rx_status->mactime, "now" is drv_get_tsf(), and
> offset (ie. stack delay) is mactime - tsf. RX_FLAG_MACTIME_MPDU is on for
> all frames, and mesh sync is not adjusting the TSF.
>
> How can we possibly receive frames from the future!?
>

1) Are you correctly merging the TSF32 values? Are you comparing TSF32
to TSF64, are you converting 32->64, etc? TSF32 wraps pretty quickly
and there's some kooky logic needed to make sure your TSF64 calculated
value is correct.

2) Are all your mesh nodes synchronised? Why don't you print out the
timestamp inside the beacon frame as well, and compare whether they're
all in reasonable sync?



Adrian
