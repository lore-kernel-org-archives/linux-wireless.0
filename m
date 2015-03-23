Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42486 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbbCWPBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 11:01:39 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/4] ath10k: add WOW disconnect/magic-packet support
References: <1425887720-11466-1-git-send-email-janusz.dziedzic@tieto.com>
	<1425887720-11466-2-git-send-email-janusz.dziedzic@tieto.com>
Date: Mon, 23 Mar 2015 17:01:29 +0200
In-Reply-To: <1425887720-11466-2-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Mon, 9 Mar 2015 08:55:18 +0100")
Message-ID: <87fv8vep12.fsf@kamboji.qca.qualcomm.com> (sfid-20150323_160142_765333_78BEEC48)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Add support for WOW disconnect and magic-packet.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

[...]

> +#ifdef CONFIG_PM
> +int ath10k_wow_init(struct ieee80211_hw *hw);

[...]

> +#else
> +static inline int ath10k_wow_init(struct ieee80211_hw *hw)
> +{
> +	return 0;
> +}

In pending branch I changed these to:

int ath10k_wow_init(struct ath10k *ar);

-- 
Kalle Valo
