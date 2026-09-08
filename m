Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAE2503BDE;
	Tue,  8 Sep 2026 09:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859508; cv=none; b=Y0ucNqhfxHayFDSSDHNN51H7/o813xgvXij7as3UciJFhbn/9UtLPNNoKS0+WDK/lYNSHPkAjYczFvyveXy0e3gZUAHUcUVU6/l8jP+U3X+gvuwYmnJDl1gFrefLtZPGjBjbgtQDTs35yUKEnjyS6/3pQPbQzwPxMgNVr2bLg8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859508; c=relaxed/simple;
	bh=xnIwvgCs9q5EgM25zXBqII6HE4rh3StqZvZ8755QyiU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=p7KNWdzLqSqVG/MmqCSyMHefJ/ZYwXO2idYFxOCuJYZCrriDBcNd3Ka4SabaL/G7fAVyYjyXhnCQm1Byvpb02g1cE9OWSf9VXVB4npkB6xXXC6nAil1n7nB07Fq7lfbZggVwZSGnEI8bWloeTGR67OG4hGVkivKB/XEw/XiEBB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: Thomas Fourier <fourier.thomas@gmail.com>, Kalle Valo
 <kvalo@kernel.org>, "open list:QUALCOMM ATHEROS ATH9K WIRELESS DRIVER"
 <linux-wireless@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] wifi: ath9k: Fix potential spin_lock() before
 spin_lock_init()
In-Reply-To: <20260804080913.67985-2-fourier.thomas@gmail.com>
References: <20260804080913.67985-2-fourier.thomas@gmail.com>
Date: Tue, 08 Sep 2026 11:25:01 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87pkyof636.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Thomas Fourier <fourier.thomas@gmail.com> writes:

> The function ath9k_init_wmi() initializes wmi->wmi_lock. It is called in
> ath9k_htc_probe_device(), and the priv->initialized flag is set.
> However, the ath9k_wmi_event_tasklet takes the lock before checking the
> priv->initialized flag, so the lock may not be initialized before
> being taken.  This could be the case, for example, if the spin_lock_init()
> is reordered with tasklet_setup() in ath9k_init_wmi() by the compiler or
> CPU.
>
> There is a write memory barrier before setting the priv->initialized,
> but no corresponding read memory barrier is used after checking the
> flag.
>
> Move priv->initialized at the start of ath9k_wmi_event_tasklet() and
> add a corresponding read memory barrier.
>
> Fixes: 24355fcb0d4c ("wifi: ath9k: delay all of ath9k_wmi_event_tasklet() until init is complete")
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/wmi.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
> index 284e8c13b043..df4a3a625536 100644
> --- a/drivers/net/wireless/ath/ath9k/wmi.c
> +++ b/drivers/net/wireless/ath/ath9k/wmi.c
> @@ -146,6 +146,15 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
>  	unsigned long flags;
>  	u16 cmd_id;
>  
> +	/* Check if ath9k_htc_probe_device() completed. */
> +	if (!data_race(priv->initialized))
> +		return;

Moving this out of the loop changes behaviour: Before, the loop would
keep spinning waiting for initialisation, now we just exit. I don't see
any guarantee that we'll come back here, so this has the risk of
stalling things. We'll need to re-schedule the tasklet before returning
if we're moving the check here.

-Toke
