Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:34100 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbbG0Wac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2015 18:30:32 -0400
Received: by lafd3 with SMTP id d3so47412333laf.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2015 15:30:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmom5v_Jb6f1ARoa3t99Ruht4zJMYiuS85ydHxCYoKV2n5g@mail.gmail.com>
References: <1437554563-11712-1-git-send-email-martin.blumenstingl@googlemail.com>
 <CAJ-Vmom5v_Jb6f1ARoa3t99Ruht4zJMYiuS85ydHxCYoKV2n5g@mail.gmail.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Tue, 28 Jul 2015 00:30:11 +0200
Message-ID: <CAFBinCA_zNHgx+a+dikA46GN-xPtPMrtmnXeOHwMjr4FsNF=Cg@mail.gmail.com> (sfid-20150728_003036_118253_AACFF458)
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

Hi Adrian,

On Mon, Jul 27, 2015 at 9:13 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> I wonder if this is a mis-merge on my part (I'm the freebsd maintainer.)
>
> can you log the noisefloor calibrated values before and after the
> patch? I'd like to see how low it calibrrates to.
Sure, I hope dump_nfcal provides all values you need.

result with my patch applied (HT20):
# cat /sys/kernel/debug/ieee80211/phy1/ath9k/dump_nfcal
Channel Noise Floor : -95
Chain | privNF | # Readings | NF Readings
0       -106    5               -110 -105 -109 -106 -106
1       -97     5               -97 -97 -97 -97 -97

Result before my patch (HT20):
# cat /sys/kernel/debug/ieee80211/phy1/ath9k/dump_nfcal
Channel Noise Floor : -91
Chain | privNF | # Readings | NF Readings
0 -120 0
1 -120 0

Result before my patch (HT40):
# cat /sys/kernel/debug/ieee80211/phy1/ath9k/dump_nfcal
Channel Noise Floor : -91
Chain | privNF | # Readings | NF Readings
0 -110 5 -110 -110 -110 -110 -110
1 -110 5 -110 -110 -110 -110 -110
3 -110 5 -110 -110 -110 -110 -110
4 -110 5 -110 -110 -110 -110 -110


Let me know if this helps you or if you need more information.


Regards,
Martin
