Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:34827 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbbG1WIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 18:08:18 -0400
Received: by lahh5 with SMTP id h5so77056066lah.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2015 15:08:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmokfovc806T+Ja6nQhbGUDM=uU7MmKwad6Uc2hNYV+DDtA@mail.gmail.com>
References: <1437554563-11712-1-git-send-email-martin.blumenstingl@googlemail.com>
 <CAJ-Vmom5v_Jb6f1ARoa3t99Ruht4zJMYiuS85ydHxCYoKV2n5g@mail.gmail.com>
 <CAFBinCA_zNHgx+a+dikA46GN-xPtPMrtmnXeOHwMjr4FsNF=Cg@mail.gmail.com>
 <CAJ-VmokJwqEvkUMf4BNkW9h-6BPdANjTrjgu0YJMD0RAYfQF2A@mail.gmail.com>
 <CAFBinCCzTTdkENDZ5BVPnSqXV7uFUtBabAYFuT4-sd2M=KVxLg@mail.gmail.com>
 <CAJ-Vmo=pmv6tMs1_AY=x-MS=Q1VAXy0Xrp2ac==Nsm0=njoE8g@mail.gmail.com>
 <CAFBinCDwLBUZcwEh1QBofDg5urwviO9gWKAeiuVXHCyw+OdFfA@mail.gmail.com> <CAJ-Vmokfovc806T+Ja6nQhbGUDM=uU7MmKwad6Uc2hNYV+DDtA@mail.gmail.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Wed, 29 Jul 2015 00:07:57 +0200
Message-ID: <CAFBinCDqn5HCb3APpqfFULwrmqPGpuj2upFOC=5qZUZzHWBnVg@mail.gmail.com> (sfid-20150729_000821_481617_D38FF51E)
Subject: Re: [PATCH RESEND] ath9k: Fix NF CCA limits for AR9287 and AR9227
To: Adrian Chadd <adrian@freebsd.org>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 28, 2015 at 7:25 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> So the values aren't "bad" on the 1043nd - they're in 1/2 or 1/4dB,
> but there's no scalar quantity (ie, it's not in dBm.) The 1043nd
> calibrates down to around -95 or so, which "sounds" like it's in dBm
> but it isn't, and any similarity is just coincidence.
Ok, then we'll ignore the 1043nd from now on.

> It does sound like your AR9227 sees noise. can you fire up the
> spectral analysis stuff to plot what the NIC is seeing? (yes, the
> AR9287/AR9227 has spectral analysis mode, same as the AR9280, AR9285,
> and >= AR9300.)
I am assuming that "background" mode is what you want, see [0].
Thus I ran the following on my AR9227 device:
# echo background > /sys/kernel/debug/ieee80211/phy1/ath9k/spectral_scan_ctl
# echo trigger > /sys/kernel/debug/ieee80211/phy1/ath9k/spectral_scan_ctl
# cat /sys/kernel/debug/ieee80211/phy1/ath9k/spectral_scan0 > /tmp/samples

The result can be found here: [1].
Note that at this point no client was connected to my AP. My patch
(from the initial mail) was applied - but that shouldn't have any
effect on the spectral scan output (at least that's what I'm
assuming).

Just for documentation purposes - those are the NF values that I have
seen a few seconds before getting the spectral scan data:
# cat /sys/kernel/debug/ieee80211/phy1/ath9k/dump_nfcal
Channel Noise Floor : -93
Chain | privNF | # Readings | NF Readings
0     -104   5          -109 -109 -109 -104 -104
1     -97    5          -97 -97 -97 -97 -97


Regards,
Martin


[0] https://wireless.wiki.kernel.org/en/users/drivers/ath9k/spectral_scan
[1] https://dl.dropboxusercontent.com/u/26940713/tmp/spectral_out
