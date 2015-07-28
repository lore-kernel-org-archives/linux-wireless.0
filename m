Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:33710 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbbG1IHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 04:07:49 -0400
Received: by laah7 with SMTP id h7so63699470laa.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2015 01:07:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmo=pmv6tMs1_AY=x-MS=Q1VAXy0Xrp2ac==Nsm0=njoE8g@mail.gmail.com>
References: <1437554563-11712-1-git-send-email-martin.blumenstingl@googlemail.com>
 <CAJ-Vmom5v_Jb6f1ARoa3t99Ruht4zJMYiuS85ydHxCYoKV2n5g@mail.gmail.com>
 <CAFBinCA_zNHgx+a+dikA46GN-xPtPMrtmnXeOHwMjr4FsNF=Cg@mail.gmail.com>
 <CAJ-VmokJwqEvkUMf4BNkW9h-6BPdANjTrjgu0YJMD0RAYfQF2A@mail.gmail.com>
 <CAFBinCCzTTdkENDZ5BVPnSqXV7uFUtBabAYFuT4-sd2M=KVxLg@mail.gmail.com> <CAJ-Vmo=pmv6tMs1_AY=x-MS=Q1VAXy0Xrp2ac==Nsm0=njoE8g@mail.gmail.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Tue, 28 Jul 2015 10:07:28 +0200
Message-ID: <CAFBinCDwLBUZcwEh1QBofDg5urwviO9gWKAeiuVXHCyw+OdFfA@mail.gmail.com> (sfid-20150728_100821_266664_0FDD0316)
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

On Tue, Jul 28, 2015 at 5:47 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> Those are some high values (eg from noise/spur somewhere) and the
> driver is deciding to program in -110. So the radio thinks its deaf.
That made me think... I have a second ath9k device, this time with an
AR9300 (note, this is 3x3 instead of 2x2). I have set it up with
similar settings as the AR9227 (= AP mode) and this is the result:
# cat /sys/kernel/debug/ieee80211/phy0/ath9k/dump_nfcal
Channel Noise Floor : -95
Chain | privNF | # Readings | NF Readings
0       -122    5               -122 -122 -121 -122 -121
1       -119    5               -119 -119 -119 -119 -119
2       -121    5               -121 -121 -120 -120 -121

The values on that AR9300 device seem to be much better.

While I was at it, here is the output from a third device (TP-Link
TL-WR1043ND), which uses an Atheros AR9100 MAC/BB Rev:7 AR2133 RF
Rev:a2
Please note that this device is "STA" mode, whereas all other devices
are in "AP" mode.
# cat /sys/kernel/debug/ieee80211/phy0/ath9k/dump_nfcal
Channel Noise Floor : -95
Chain | privNF | # Readings | NF Readings
0       -89     5               -89 -89 -88 -89 -89
1       -88     5               -88 -88 -88 -88 -88
2       -81     5               -81 -81 -80 -82 -82

> Hm, I think that explains a few other NICs behaving badly too....
I have found an OpenWrt ticket where users are describing similar
problems, but on an TP-Link TL-WR1043ND (AR9100 + AR2133) ([0]
Now here comes the interesting part: Only my device with the AR9227
shows bad performance. All other devices (including the AR9100 +
AR2133 based one, which also ready "bad values") are performing fine -
at least for me.


Regards,
Martin

[0] https://dev.openwrt.org/ticket/17582
