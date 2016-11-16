Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15281 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933122AbcKPQRK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 11:17:10 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Sven Eckelmann <sven.eckelmann@open-mesh.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        Simon Wunderlich <simon.wunderlich@open-mesh.com>
Subject: Re: [RFC 1/2] ath9k: work around AR_CFG 0xdeadbeef chip hang
Date: Wed, 16 Nov 2016 16:16:42 +0000
Message-ID: <87wpg3mmc6.fsf@kamboji.qca.qualcomm.com> (sfid-20161116_171714_442249_FBA370D5)
References: <20161114144226.15748-1-sven.eckelmann@open-mesh.com>
In-Reply-To: <20161114144226.15748-1-sven.eckelmann@open-mesh.com> (Sven
        Eckelmann's message of "Mon, 14 Nov 2016 15:42:25 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@open-mesh.com> writes:

> From: Simon Wunderlich <simon.wunderlich@open-mesh.com>
>
> QCA 802.11n chips (especially AR9330/AR9340) sometimes end up in a state =
in
> which a read of AR_CFG always returns 0xdeadbeef. This should not happen
> when when the power_mode of the device is ATH9K_PM_AWAKE.
>
> This problem is not yet detected by any other workaround in ath9k. No way
> is known to reproduce the problem easily.
>
> Signed-off-by: Simon Wunderlich <simon.wunderlich@open-mesh.com>
> [sven.eckelmann@open-mesh.com: port to recent ath9k, add commit message]
> Signed-off-by: Sven Eckelmann <sven.eckelmann@open-mesh.com>

[...]

> +void ath_hw_hang_work(struct work_struct *work)
> +{
> +	struct ath_softc *sc =3D container_of(work, struct ath_softc,
> +					    hw_hang_work.work);
> +
> +	if (ath_hw_hang_deadbeef(sc))
> +		goto requeue_worker;
> +
> +requeue_worker:
> +	ieee80211_queue_delayed_work(sc->hw, &sc->hw_hang_work,
> +				     msecs_to_jiffies(ATH_HANG_WORK_INTERVAL));
> +}

The goto doesn't make any sense, either me or the function is missing
something :)

--=20
Kalle Valo=
