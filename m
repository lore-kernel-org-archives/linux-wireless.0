Received: from mx1.emlix.com (mx1.emlix.com [178.63.209.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3304333D4F8
	for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 06:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.63.209.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781244195; cv=none; b=S68Lnyay1H1jEfJxXlcYRDMkgf2M2TrHi9ZTYLwXpcaN+LXS++sFkKoOZfh7f+5M/1YgwZcxvNyL0NgGEXeIVmqcQBsesgex9VQQvyoJVpUPZ7dz6edE/+QONQod9+/JVcpTdFF+UNTEhyOGqVMp6UuyiuEODxVluQPeEvSvAFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781244195; c=relaxed/simple;
	bh=VC+t9RwHWgm+RSvL+HK4uXw8Irv93XGYg+Oa8q85pTc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H1WpTxDcDX4fOny0xmdETqa+KQWek1FLKB6SuHtCRaHMLl7TmAlokPTFBuVtdo6ZVYT+LAHC/fjcaERrA6uSoi85Z7fxttswyrEuqVNT2SJtgdl6Kc9uqwqiIfXZVf87zx4Ni4fIE3IuPRvMbIkp2Ztjs0qzbTNW2TOS3Fmy5n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=emlix.com; spf=pass smtp.mailfrom=emlix.com; dkim=pass (2048-bit key) header.d=emlix.com header.i=@emlix.com header.b=ln1U+Gw0; dkim=pass (2048-bit key) header.d=emlix.com header.i=@emlix.com header.b=afRai8bN; arc=none smtp.client-ip=178.63.209.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=emlix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=emlix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=emlix.com header.i=@emlix.com header.b="ln1U+Gw0";
	dkim=pass (2048-bit key) header.d=emlix.com header.i=@emlix.com header.b="afRai8bN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=emlix.com;
	s=20250930; t=1781243650;
	bh=0aZh00dNzAGWl+I8nNb9AioHZgXgmC5ZrOZnA8sfeMg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ln1U+Gw0T/n+5mJ5NDyvi1+Jc2H5Sf6ER0EFcyt/bTiV9E4bDq/9mUhibVbdvHPCS
	 qMziZGjc7Mw4L7/iCVs+AtMhVeYnqrMz4A8iqQG7u2+xM/psIB/CUWyjJZC2if2gGB
	 WkHO/m6jFPcY6/bVWBSjOVVW9NX+25WQsCSNqT2TWqRyShrta7hdhQ5w19EmOHZEI2
	 h/ZhN+MRIxT1RfZ7TaTHLuHA/Amfjs1+AGqt7ARu8kJ422Pf+Ds6KHh5tP11T1qFYr
	 kCjge4j/76ck7nU5XK8oNggV2ldYgY4aD8Scd/7uPiekghqteQztf7TVRjq1JDLc/T
	 6YJsmCrtAbELw==
Received: from mx1.emlix.com (localhost [127.0.0.1])
	by mx1.emlix.com (Postfix) with ESMTP id F033A5F9B2;
	Fri, 12 Jun 2026 07:54:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=emlix.com;
	s=20250930; t=1781243649;
	bh=0aZh00dNzAGWl+I8nNb9AioHZgXgmC5ZrOZnA8sfeMg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=afRai8bN83zDiGmC6kwbLr0J3aJhlqLKuASbT2OyRW7FnmBohXEbQbDZylZHd/fYQ
	 6theFEior+DK43A07wJGSfA3LmzO0DtIsovlXhMWD3OpZyaZAxcFqiYIaf8eMJdFQq
	 4ZGs9ZCvNcSy4PwZMuXqW4OFjMz2Ht9rz3aP0iNRWMPf3msk+UXd7jvN6fWmEv/ccK
	 v5C9kWM5bIsDkcJz2tjYljk/k8zwYJvB27dgARhMMSrZFW6+bvS0CP3jpVySOkstPw
	 RrzFX8D1F4Qau9tOrap2DdP/4KiB/ZfyqxmwRbMRfYfxy2SKbsIZ1y/2ZniMIikAUk
	 WGwFy4zzsTecw==
Received: from mailer.emlix.com (p5098be52.dip0.t-ipconnect.de [80.152.190.82])
	(using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.emlix.com (Postfix) with ESMTPS id C69A65F769;
	Fri, 12 Jun 2026 07:54:09 +0200 (CEST)
Message-ID: <386a2777-ec67-491b-ae5e-d6a18a204e33@emlix.com>
Date: Fri, 12 Jun 2026 07:54:08 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: mac80211: correctly decode TTLM with default link
 map
To: Benjamin Berg <benjamin@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>, Ruikai Peng <ruikai@pwno.io>,
 Johannes Berg <johannes.berg@intel.com>
References: <20260129113349.d6b96f12c732.I69212a50f0f70db185edd3abefb6f04d3cb3e5ff@changeid>
Content-Language: en-US
From: =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>
In-Reply-To: <20260129113349.d6b96f12c732.I69212a50f0f70db185edd3abefb6f04d3cb3e5ff@changeid>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: ClamAV using ClamSMTP

Hello,

I believe this fix is incomplete.

Am 29.01.26 um 11:33 schrieb Benjamin Berg:
> @@ -6190,8 +6190,10 @@ ieee80211_parse_adv_t2l(struct ieee80211_sub_if_data *sdata,
>  		return -EINVAL;
>  	}
>  
> -	link_map_presence = *pos;
> -	pos++;
> +	if (!(control & IEEE80211_TTLM_CONTROL_DEF_LINK_MAP)) {
> +		link_map_presence = *pos;
> +		pos++;
> +	}

You forgot to initialize link_map_presence for the case when the default
link map is used. But even if you initialize it to 0, the following code
will return with -EINVAL since only 0xff is accepted. This causes a
disconnect, which is probably not what we want.

By the way, the 2021-04-14 draft I found for TID-to-link Mapping says
that ttlm->control is 16 bits and the link_map_presence byte is its
upper byte. It merely becomes reserved when the default link map is
used. Are we sure that this changed in the final specification?

Best regards

  Daniel
