Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:33112 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbbG0Xut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2015 19:50:49 -0400
Received: by igbpg9 with SMTP id pg9so114472588igb.0
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2015 16:50:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFBinCA_zNHgx+a+dikA46GN-xPtPMrtmnXeOHwMjr4FsNF=Cg@mail.gmail.com>
References: <1437554563-11712-1-git-send-email-martin.blumenstingl@googlemail.com>
	<CAJ-Vmom5v_Jb6f1ARoa3t99Ruht4zJMYiuS85ydHxCYoKV2n5g@mail.gmail.com>
	<CAFBinCA_zNHgx+a+dikA46GN-xPtPMrtmnXeOHwMjr4FsNF=Cg@mail.gmail.com>
Date: Mon, 27 Jul 2015 16:50:48 -0700
Message-ID: <CAJ-VmokJwqEvkUMf4BNkW9h-6BPdANjTrjgu0YJMD0RAYfQF2A@mail.gmail.com> (sfid-20150728_015100_187382_882EE69B)
Subject: Re: [PATCH RESEND] ath9k: Fix NF CCA limits for AR9287 and AR9227
From: Adrian Chadd <adrian@freebsd.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

is it never getting any readings before your patch? NF Readings all
look empty...




-adrian


On 27 July 2015 at 15:30, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
> Hi Adrian,
>
> On Mon, Jul 27, 2015 at 9:13 PM, Adrian Chadd <adrian@freebsd.org> wrote:
>> I wonder if this is a mis-merge on my part (I'm the freebsd maintainer.)
>>
>> can you log the noisefloor calibrated values before and after the
>> patch? I'd like to see how low it calibrrates to.
> Sure, I hope dump_nfcal provides all values you need.
>
> result with my patch applied (HT20):
> # cat /sys/kernel/debug/ieee80211/phy1/ath9k/dump_nfcal
> Channel Noise Floor : -95
> Chain | privNF | # Readings | NF Readings
> 0       -106    5               -110 -105 -109 -106 -106
> 1       -97     5               -97 -97 -97 -97 -97
>
> Result before my patch (HT20):
> # cat /sys/kernel/debug/ieee80211/phy1/ath9k/dump_nfcal
> Channel Noise Floor : -91
> Chain | privNF | # Readings | NF Readings
> 0 -120 0
> 1 -120 0
>
> Result before my patch (HT40):
> # cat /sys/kernel/debug/ieee80211/phy1/ath9k/dump_nfcal
> Channel Noise Floor : -91
> Chain | privNF | # Readings | NF Readings
> 0 -110 5 -110 -110 -110 -110 -110
> 1 -110 5 -110 -110 -110 -110 -110
> 3 -110 5 -110 -110 -110 -110 -110
> 4 -110 5 -110 -110 -110 -110 -110
>
>
> Let me know if this helps you or if you need more information.
>
>
> Regards,
> Martin
