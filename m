Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48010 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804AbbELOlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 10:41:07 -0400
Message-ID: <55521102.9020306@candelatech.com> (sfid-20150512_164112_683379_21CBDC00)
Date: Tue, 12 May 2015 07:41:06 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>,
	s prasad <sprasad.kandregula@gmail.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: Ath10 firmware crashing in Monitor mode(Sniffer mode)
References: <CAJa-X95EBdGASnz3KAdYz5R6w5g-a=dBy5VCZYwHp6SzQ+gUSw@mail.gmail.com>	<CA+BoTQkFSQe0di1vqqB5cAPKaizRkBT5cu4fA8dQ_uR_a2HdJw@mail.gmail.com>	<CAJa-X96spUg7+EZqH-Mv3s7OzbHzmXmcZ7uOw1KvPShexW6D_w@mail.gmail.com>	<CA+BoTQ=Qpws=928TZe22Ds-UO_qQJ2Om+=DW=VUNUS59o1BQAA@mail.gmail.com>	<CAJa-X96KPw6dY0pK1zc8UD4TdQcG0KuA3m6DSueVVyK-VPhn9g@mail.gmail.com>	<CA+BoTQ=bqHPrdgGVfSfdJa5vobDBRdxRwMR_wJzUj4Z9WjotoQ@mail.gmail.com>	<CAJa-X945Xvn0jHQVcKn-pyYQVNpxXnqjOH_VHJv8pVwR4kFXcw@mail.gmail.com> <CA+BoTQmLFGAn2z=E3J1C2qfNP34v57B7-rtALUQhNXrHqJeA6Q@mail.gmail.com>
In-Reply-To: <CA+BoTQmLFGAn2z=E3J1C2qfNP34v57B7-rtALUQhNXrHqJeA6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/12/2015 03:14 AM, Michal Kazior wrote:
> On 12 May 2015 at 11:31, s prasad <sprasad.kandregula@gmail.com> wrote:
>> May I know, is this firmware or driver constraint?
>> If somebody have patch for this, am ready to test it.
>
> Short answer: There's nothing, yet.
>
> Long answer:
>
>  From what I know official firmware doesn't support injecting packets
> via monitor vdev. This is a firmware limitation.
>
> A way around this may be creating and using an additional vdev, e.g.
> AP. This will be rather ugly but may work. There's no patch for it.
>
> An alternative would be to ask Ben to modify his CT-firmware branch.

I gave this a decent try a month or two ago, and had no luck.  The hardware
(from what I can tell), just will not send a frame to an unknown peer.

I noticed the other day that ANQP will not work on ath10k, and I suspect
similar issues..so I will be in that code again.  Maybe I'll learn
how to trick it into sending arbitrary frames.

All that said, there is no way to specify rate-ctrl info on a per-pkt
basis when injecting frames, so I don't know what good injecting frames
on a mgt device will accomplish.

Thanks,
Ben

> Also there's a problem with submitting raw 802.11 frames to firmware.
> There's some work ongoing [1].
>
> [1]: http://lists.infradead.org/pipermail/ath10k/2015-May/005144.html
>
>
> Michał
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
