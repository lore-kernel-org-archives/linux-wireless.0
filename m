Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:8720 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753347AbdLVP01 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 10:26:27 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v3 05/11] ath10k: htt: High latency TX support
Date: Fri, 22 Dec 2017 15:26:22 +0000
Message-ID: <87o9mqain5.fsf@kamboji.qca.qualcomm.com> (sfid-20171222_162631_519327_FA17BE02)
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
        <20170917194013.8658-6-erik.stromdahl@gmail.com>
In-Reply-To: <20170917194013.8658-6-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Sun, 17 Sep 2017 21:40:07 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> Add HTT TX function for HL interfaces.
> Intended for SDIO and USB.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>

[...]

> +	/* Prepend the HTT header and TX desc struct to the data message
> +	 * and realloc the skb if it does not have enough headroom.
> +	 */
> +	if (skb_headroom(msdu) < HTT_TX_HL_NEEDED_HEADROOM) {
> +		struct sk_buff *tmp_skb =3D msdu;

Style: please have the variable declaration in the beginning of the
function.

--=20
Kalle Valo=
