Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:45061 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab0G0XbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 19:31:08 -0400
Received: by pxi14 with SMTP id 14so669255pxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 16:31:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimdDhHudW6_7Hwcf6UCumY_EgqGd7CLtmSgOzEz@mail.gmail.com>
References: <AANLkTimdDhHudW6_7Hwcf6UCumY_EgqGd7CLtmSgOzEz@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 27 Jul 2010 16:30:47 -0700
Message-ID: <AANLkTi=h+Ra9h=7E1q0Wnnmh=UYmGNxS8cP7E-LNER=G@mail.gmail.com>
Subject: Re: regulatory hiccup
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 23, 2010 at 12:30 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> This is 2.6.35-rc4, but this bug (?) might exist in other versions ,too.
>
> Early in boot, all was well:
>
> [ 5524.214376] cfg80211: Calling CRDA to update world regulatory domain
> [ 5524.219025] cfg80211: Calling CRDA for country: US
> [ 5524.238440] cfg80211: Regulatory domain changed to country: US
> [ 5524.238443]     (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [ 5524.238446]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
> [ 5524.238448]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
> [ 5524.238451]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [ 5524.238454]     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [ 5524.238456]     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [ 5524.238459]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
>
> Then, after fiddling with an AP for a bit, I got:
>
> [11747.264221] cfg80211: Calling CRDA for country: US
> [11747.282664] cfg80211: Current regulatory domain updated by AP to: US
> [11747.282672]     (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [11747.282680]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1600 mBm)
> [11747.282688]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 1600 mBm)
>
> (Note lots of missing channels after that.)  iw phy phy0 info showed
> all the channels above 5.33GHz disabled.  I didn't see some other APs
> that were there.
>
> Later on I disconnected, CRDA got called again, and all was well.
>
> The AP that I had just connected to when everything broke was an
> EnGenuis ESR7750 (brand new), and maybe it sent something wrong, but
> surely if it says US it shouldn't disable other APs on US bands that
> CRDA says is OK.

If you are saying the the AP's Country IE is a subset of what CRDA has
and complaining that we follow that, yes that is true. We were being
very careful and only recently revisited this again with our
regulatory folks. It was determined to be fair to disregard the AP's
own regulatory data and follow our own since we do keep good tabs on
our wireless-regdb. Patches for that were sent by Linville and will be
part of 2.6.36, you can either cherry pick those or wait for
2.6.36-rc1 or the respective compat-wireless-2.6.36-rc1

  Luis
