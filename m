Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:10081 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751071AbdKTL5Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Nov 2017 06:57:24 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Christian Lamparter <chunkeey@gmail.com>
CC: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix recent bandwidth conversion bug
Date: Mon, 20 Nov 2017 11:57:21 +0000
Message-ID: <87tvxpf9i8.fsf@kamboji.qca.qualcomm.com> (sfid-20171120_125738_297305_02024DC5)
References: <20171101200157.27096-1-chunkeey@gmail.com>
        <224e2890-3775-967b-d4ce-4297574c0642@dd-wrt.com>
        <1666282.PC3nhpCf9f@debian64>
In-Reply-To: <1666282.PC3nhpCf9f@debian64> (Christian Lamparter's message of
        "Thu, 02 Nov 2017 20:34:06 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@gmail.com> writes:

> On Wednesday, November 1, 2017 9:37:53 PM CET Sebastian Gottschall wrote:
>> a additional array bounds check would be good
>
> Ah, about that:
>
> the bw variable in ath10k_htt_rx_h_rates() is extracted from info2
> in the following way [0]:
> |	bw =3D info2 & 3;
>
> the txrate.bw variable in ath10k_update_per_peer_tx_stats() is set by [1]=
:
> |	txrate.bw =3D ATH10K_HW_BW(peer_stats->flags);
>
> ATH10K_HW_BW is a macro defined as [2]:
> |	#define ATH10K_HW_BW(flags)		(((flags) >> 3) & 0x3)
>
> In both cases the bandwidth values already are limited to 0-3 by
> the "and 3" operation.

Until someone changes that part of the code (and the firmware
interface). IMHO a switch is safer as there we don't have any risk of
out of bands access.

--=20
Kalle Valo=
