Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:53203 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756218AbdLVPro (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 10:47:44 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v3 10/11] ath10k: wmi: disable softirq's while calling
 ieee80211_rx
Date: Fri, 22 Dec 2017 15:47:39 +0000
Message-ID: <873742ahno.fsf@kamboji.qca.qualcomm.com> (sfid-20171222_164748_704988_46C8D509)
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
        <20170917194013.8658-11-erik.stromdahl@gmail.com>
In-Reply-To: <20170917194013.8658-11-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Sun, 17 Sep 2017 21:40:12 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>

Please explain in the commit log why this is needed.

> ---
>  drivers/net/wireless/ath/ath10k/wmi.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless=
/ath/ath10k/wmi.c
> index 38a97086708b..10bb5be6ab00 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -2408,7 +2408,10 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, st=
ruct sk_buff *skb)
>  		   status->freq, status->band, status->signal,
>  		   status->rate_idx);
> =20
> +	local_bh_disable();
>  	ieee80211_rx(ar->hw, skb);
> +	local_bh_enable();

ieee80211_rx_ni()?

--=20
Kalle Valo=
