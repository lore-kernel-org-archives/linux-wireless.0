Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6822 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932464AbcIBQae (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 12:30:34 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: Re: ath10k: fix throughput regression in multi client mode
Date: Fri, 2 Sep 2016 16:30:26 +0000
Message-ID: <87inuez2lb.fsf@kamboji.qca.qualcomm.com> (sfid-20160902_183056_010211_8126F2D9)
References: <425ad8d804bf46feada839a8e0d0c77e@euamsexm01a.eu.qualcomm.com>
In-Reply-To: <425ad8d804bf46feada839a8e0d0c77e@euamsexm01a.eu.qualcomm.com>
        (Kalle Valo's message of "Wed, 31 Aug 2016 10:24:15 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
>> commit 7a0adc83f34d ("ath10k: improve tx scheduling") is causing
>> severe throughput drop in multi client mode. This issue is originally
>> reported in veriwave setup with 50 clients with TCP downlink traffic.
>> While increasing number of clients, the average throughput drops
>> gradually. With 50 clients, the combined peak throughput is decreased
>> to 98 Mbps whereas reverting given commit restored it to 550 Mbps.
>>=20
>> Processing txqs for every tx completion is causing overhead. Ideally for
>> management frame tx completion, pending txqs processing can be avoided.
>> The change partly reverts the commit "ath10k: improve tx scheduling".
>> Processing pending txqs after all skbs tx completion will yeild enough
>> room to burst tx frames.
>>=20
>> Fixes: 7a0adc83f34d ("ath10k: improve tx scheduling")
>> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
>
> I'm planning to queue this to 4.8 if no objections.

Actually the patch doesn't apply to ath-current branch so I'll apply to
ath-next instead.

--=20
Kalle Valo=
