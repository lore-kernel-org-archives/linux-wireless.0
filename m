Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34112 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755005AbeARJlS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 04:41:18 -0500
Received: by mail-io0-f176.google.com with SMTP id c17so24195839iod.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jan 2018 01:41:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMNDV2kK33fWYVNNAO8=ZqgxyPdXxTdOrxdQnW6ORMFM1hkrxQ@mail.gmail.com>
References: <CAMNDV2kK33fWYVNNAO8=ZqgxyPdXxTdOrxdQnW6ORMFM1hkrxQ@mail.gmail.com>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Thu, 18 Jan 2018 11:41:17 +0200
Message-ID: <CANUX_P3Vij4AeiWuOyi5XFiiAF5nqQERR8tDyrRoKZMLFmKoQw@mail.gmail.com> (sfid-20180118_104123_782894_57E38545)
Subject: Re: A few questions about iwlwifi and its rate control mechanism
To: Tambet Arak <tambet.arak@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Jan 18, 2018 at 11:09 AM, Tambet Arak <tambet.arak@gmail.com> wrote:
> Hi all,
>

[snip]

>
> In any case, I was looking into how to optimally tune wireless
> reception at work, since the APs are aging and only support up to MCS7
> (65 Mb/s), so any improvements would help. I'm using a HP laptop with
> a Intel Centrino Advanced-N 6235, driven by iwlwifi / iwldvm (vanilla
> Linux 4.14.8). I noticed that `iw dev wlo1 station dump` generally
> reports a 58.5-65 Mb/s rx bitrate, but when the connection is taxed
> (e.g. downloading a file), it drops.

What do you mean by 'drop'. Disassociated? Or associated but no traffic?
Association state can be checked with iw <iface> link

>
> Since the only other OS on my machine is Windows, I tested by
> downloading a large file there and generally the average throughput
> was slightly higher. I'm not a Windows user, so I don't have a clue if
> `netsh show interfaces` reports a correct effective bit rate, but it
> was always fixed to 65 Mb/s in my tests.
>
> This led me to digging around in iwlwifi. It seems that iwlwifi
> registers its own rate control algorithm (iwl-agn-rs) with the
> mac80211 subsystem and this is hardcoded.
>
> Hence a few questions:
>
> - Why does iwlwifi have / need its own rc algorithm, instead of using minstrel?

Because Intel devices' firmware works differently from atheros for
which minstrel was designed.
This is one of the main reasons.

> - It seems that iwl-agn-rs is not configurable by the end user. Would
> there be any interest in development for iwl-agn-rs configurability,
> e.g. being less / more conservative about lowering rates? I'm mostly
> interested in rx performance - I'm making the assumption here that rx
> rates are negotiated with the AP (as opposed to being forced).

Not really. iwl-agn-rs is very old and serves EOL'ed devices. Newer
devices have a algorithm that is not very different, but it was more
tested.
It shouldn't be too hard to forbid high rates though. You can just put
some limits in the existing code if you want.

> - Is there any documentation regarding iwlwifi or its rc algorithm
> implementation? If so, I would kindly appreciate pointers.

Well... System requirements are typically confidential, but you can
always dig in the code.
