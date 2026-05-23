Received: from forward501b.mail.yandex.net (forward501b.mail.yandex.net [178.154.239.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F8621B192
	for <linux-wireless@vger.kernel.org>; Sat, 23 May 2026 13:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779542114; cv=none; b=fAr8p5m3R9A4djgFOTAH+/hLLqUwO9v4k835gtllWEkOBihX7rLpuBZ0LshengXjA6dVrcDcPFzr4pfE7kr5H7s8bDRcEAaoxP5mLn9NUlAO05e7DO5RaHoP+kNcUVIu8hIlM67SUX72zsVfdC5vHOIrpTIXNZuypg3HPUxmAAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779542114; c=relaxed/simple;
	bh=Eu5eLLAHHTEGA+jKGeKWDtMKrGO7f7F9TrucMPp2eFw=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=oq4tkuRPKJwJwL4p/C5F30CY3sp+VEAIn9nqnzwPdLqmsp+ygQFes6Al8/xmqwz8SgHLUyFCT+pxFjK/8zEitAde7S8OsRL+xJ+NWWG1BDEQ4O35o+Ow/dbX1wVWTmE9bztTorTZiM3Rb6hlnZZ1zFkmRluvGxl/YZXmWDNqQ58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=N44wmmFd; arc=none smtp.client-ip=178.154.239.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="N44wmmFd"
Received: from mail-nwsmtp-smtp-production-main-60.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-60.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:25b4:0:640:a124:0])
	by forward501b.mail.yandex.net (Yandex) with ESMTPS id 12A2081181;
	Sat, 23 May 2026 16:09:42 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-60.sas.yp-c.yandex.net (smtp) with ESMTPSA id c9Vn5vMfiSw0-QryM3SAI;
	Sat, 23 May 2026 16:09:41 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1779541781; bh=ulSpyMaOuPtUjE/kaMsyodJ8z51dXOLCMvbX66Q6rnE=;
	h=From:Subject:In-Reply-To:Cc:Date:References:To:Message-ID;
	b=N44wmmFdnqkjkKXZAqBOogamNYjJ2FWlu12hCeniPiEE3AssJyddJla+YF1s/OiQ2
	 eVwWrbFoQbjJ7bBJV41fKqZJjYlU+7R2ZeCYB2q1aBKI6gan4m4igJ2aKmL2vTjwiD
	 mGk7wXWqgVY78znzxL+tIFHHw/a1clsrBJXl5Z88=
Authentication-Results: mail-nwsmtp-smtp-production-main-60.sas.yp-c.yandex.net; dkim=pass header.i=@0upti.me
Message-ID: <17ef89cc-32b6-43f4-831a-ab756c6b5e3a@0upti.me>
Date: Sat, 23 May 2026 16:09:38 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: shayne.chen@mediatek.com
Cc: evelyn.tsai@mediatek.com, linux-mediatek@lists.infradead.org,
 linux-wireless@vger.kernel.org, lorenzo@kernel.org, nbd@nbd.name,
 ryder.lee@mediatek.com
References: <20251215063728.3013365-7-shayne.chen@mediatek.com>
Subject: Re: [PATCH mt76 v2 7/7] wifi: mt76: mt7996: fix iface combination for
 different chipsets
Content-Language: en-US
From: Ilya K <me@0upti.me>
In-Reply-To: <20251215063728.3013365-7-shayne.chen@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hey folks, this looks like it broke mt7996 init entirely with stable kernel 7.0.10.

Specifically it trips this check in net/wireless/core.c:681:

	if (WARN_ON(types & BIT(NL80211_IFTYPE_ADHOC) &&
		    c->beacon_int_min_gcd)) {
		return -EINVAL;
	}

I'm not sure what the correct fix here is, but unsetting beacon_int_min_gcd at least makes AP mode work again...
