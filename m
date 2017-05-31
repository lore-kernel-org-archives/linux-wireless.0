Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19311 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbdEaNGF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 09:06:05 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Norik Dzhandzhapanyan <norikd@ethertronics.com>
CC: Adrian Chadd <adrian@freebsd.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] Per chain RSSI reporting
Date: Wed, 31 May 2017 13:05:59 +0000
Message-ID: <87h901mb1g.fsf@kamboji.qca.qualcomm.com> (sfid-20170531_150609_393054_23C81ABF)
References: <SN1PR08MB1373BF583E9CE2AA6A0F6381B0FC0@SN1PR08MB1373.namprd08.prod.outlook.com>
        <CAJ-VmomiKOgV4pJWNKdOCzsUJZYEixvP4p5bQ9X1FBqAGk_o0w@mail.gmail.com>
        <SN1PR08MB137316C4132262145C58CEA3B0FD0@SN1PR08MB1373.namprd08.prod.outlook.com>
In-Reply-To: <SN1PR08MB137316C4132262145C58CEA3B0FD0@SN1PR08MB1373.namprd08.prod.outlook.com>
        (Norik Dzhandzhapanyan's message of "Sat, 27 May 2017 02:09:22 +0000")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Norik Dzhandzhapanyan <norikd@ethertronics.com> writes:

> Inserting the smoothing function here is motivated by what we see as
> 'spikes' in rssi data under weak rssi conditions. Figured its best to
> get rid of the 'bogus' data as close to the source as possible. Also
> to minimize the impact on the changes.
>
> I believe the averaging that happens at higher levels is based on EWMA
> macros in net/mac80211/sta_info.c which not wifi card/chipset
> specific. Didn't want to touch that since other cards seem to not have
> this spikey behavior. And, it doesnt seem to have an effect on the
> ath10k data anyway (iw reports the exact same values for both).
>
> I wonder if it would be acceptable to pass a module load time
> parameter which would indicate an average factor with 0 (as default)
> to indicate no averaging?

I don't know what Johannes thinks, but in my opinion this kind of
smoothing should be in mac80211 and not in drivers. The driver should be
as simple as possible.

--=20
Kalle Valo=
