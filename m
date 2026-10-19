Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.145.95.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792442568;
	b=s9MZWSkputMQloF7VHKEbTZ/gMaywwRV4MsXyvWbZOVRnVPMGT3o99aXE08kHEl92vt4
	 O/UCbbPdmItnlq0MN1bxanh8LDJPxX22R5hCv3hTrkFTvwgnxWzT82bMTyCv5o+WZ0dpR
	 gs1EV69P04bEAFYlOUYtQqD9Yc2KyqiWHhTKlXflnF11xClAHg09Rf3AjQgorFe51qyZe
	 v/WHSZEdi7VJEk9I268mvO1b9dKuRlz+4fDIXXk44/IVKnsHm+OD9RvHiOMMPEnTLMix+
	 4dDA16PXTsC9WnCI+xO+3LhHvCiUyqb02o8NfVXC1ZApTIlwP6P+/mLlVi7MfKLAhVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792442568;
	h=DMARC-Filter:From:To:Cc:Subject:In-Reply-To:References:Date:
	 X-Clacks-Overhead:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=aT0B3fFc/kY6tO3W79DOPRvYQQNzJBfIKHI87eh8Ffo=;
	b=HB5ztD3JsxNhHXz1ZwguDhR0j1FcZeMaG+i69EsgQekA6OXj2pwxY4z+lhVe+Icp9Kep
	 YS6LuA1kmkho1Q1ut62T5nsbRrqHYFoHb7KJlSj8wD9cxsqGVDabMEC+3qCz2Z+Ffsr7T
	 cUshMaPlV32AYTTgm2oXgjz5FHCGAkRUlZBwESUosNQS8daZGYe7Ti7J/C2e08CtLaDVc
	 zoP4rDIAvhqeX3Gim5CYk9Yk4bYbDxZus+SsPGnIpR0eQT0iiw89lKiSCPbDIIFIvpGXv
	 y8/mSCqtFtsBLfqWInL4q6px1EYY+voHV+vrRbEkzKp4GDVyD8JPiDAR1bsOXsbFKzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=toke.dk;
	spf=pass smtp.mailfrom=toke.dk;
	arc=none smtp.remote-ip=45.145.95.4
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C973A606A31D;
	Mon, 19 Oct 2026 20:42:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C973A606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Mehmet Fide <mehmet.fide@gmail.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 mehmet.fide@screeningeagle.com
Subject: Re: [PATCH ath-current 2/2] wifi: ath9k_htc: start ANI when an AP
 interface begins to beacon
In-Reply-To: <20261005072209.4101009-3-mehmet.fide@gmail.com>
References: <20261005072209.4101009-1-mehmet.fide@gmail.com>
 <20261005072209.4101009-3-mehmet.fide@gmail.com>
Date: Mon, 19 Oct 2026 22:42:46 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87h5ihv2ux.fsf@toke.dk>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mehmet Fide <mehmet.fide@gmail.com> writes:

> From: Mehmet Fide <mehmet.fide@screeningeagle.com>
>
> ath9k_htc_vif_reconfig() re-arms ANI after a channel change when an AP
> interface beacons. mac80211 configures the channel before it enables
> the beacon, so during a normal AP start that never triggers, and the
> start from add_interface that the previous patch removed was cancelled
> by the same channel configuration: with hostapd, ANI and the periodic
> calibration it drives did not run in AP mode until a later channel
> change.
>
> Start ANI when the beacon is enabled. The channel and its calibration
> data are in place by then, which is the state vif_reconfig() re-arms
> it in, and remove_interface() already stops it with the last AP
> interface.
>
> Fixes: a236254c35f0 ("ath9k_htc: Add ANI for AP mode")
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
