Received: from smtp.smtpout.orange.fr (smtp-13.smtpout.orange.fr [80.12.242.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C974F168498;
	Wed, 21 Aug 2024 11:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724239835; cv=none; b=reNYk/CnYn2ygXWxw6BCE0dACZprHdBIOTKYjHDf+PSJtQQMMeK+1UCxxNJlKryQ++GPzRkGj0TJWE9I8CQ7Ij2IMQBL91ES57QvS4H/Auqa9Q2yvJVCiBzeFw6ioRylOLLzz3QlWJlWPJClW2vhtLb4ard5MXhst3f3RzMm0Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724239835; c=relaxed/simple;
	bh=NnNvsxyWcRj3O1A7fNzZ9XFqOT38NMcRo/mHN+7t0Xc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PH8LYFIsb69z72YUvoe7hBwbfNAJivLW9Al/uQVw0aebk8ehPGKtemP2ima44oc0GpM249pMIeCO3rjiIN8bxb++XmSTwG7Dd+ac4tr/AWSPCfOIOTX7qyP4PhGxV69Ncpg2NDteTsb+zEgpd4xTBGCzqQSgnuy7lCE8S+InK6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=pIB7siZR; arc=none smtp.client-ip=80.12.242.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="pIB7siZR"
Received: from [192.168.1.37] ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id ghnVs26uaZ40aghnVsZF43; Wed, 21 Aug 2024 11:38:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1724233115;
	bh=Wdrcu38FW2G18isblm4VJFaWrtnjTfc4dm7+9ibbplw=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=pIB7siZRuTxLQ3YemXleH3+QSe0QcFJa8iCeyoYuz+gHG+xu1DtMZgNV2CmSxEAMb
	 KPbnJp9nzrm63csL8EGo7aCWke0PSFtJikOj8qTbOFFiJ41B0NpeKlMwL7YxyGBw9W
	 3Li3wo0ugLC9FlU3OmqT1z/btCv5gb78ykKEC0EL7gb79hBU9lswaj8LIJ5dNpAfnk
	 HGK4AWyKWYOah6TNgiP4VhRufVFNI79KIpbEIS44ZOsMf/DjKxvBzuyBrJA9oniq2L
	 EDg66qzCzEvg3pA0+1ZqOLvuLH+PAbz5vOhoAQstUDW1Mo6A4Dr+ceanOge92jcpMu
	 hxtPJXCaP+TMA==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Wed, 21 Aug 2024 11:38:35 +0200
X-ME-IP: 90.11.132.44
Message-ID: <8316e533-241a-49ef-aac1-07ff01bf489f@wanadoo.fr>
Date: Wed, 21 Aug 2024 11:38:31 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] net: wireless: Use kmemdup_array instead of kmemdup
 for multiple allocation
To: Yu Jiaoliang <yujiaoliang@vivo.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com
References: <20240821072410.4065645-1-yujiaoliang@vivo.com>
Content-Language: en-US, fr-FR
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20240821072410.4065645-1-yujiaoliang@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 21/08/2024 à 09:24, Yu Jiaoliang a écrit :
> Let the kememdup_array() take care about multiplication and possible
> overflows.
> 
> Signed-off-by: Yu Jiaoliang <yujiaoliang@vivo.com>
> ---
>   net/wireless/util.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 9a7c3adc8a3b..6cf19dda5d2a 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -2435,8 +2435,8 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
>   		if (params->num_different_channels > c->num_different_channels)
>   			continue;
>   
> -		limits = kmemdup(c->limits, sizeof(limits[0]) * c->n_limits,
> -				 GFP_KERNEL);
> +		limits = kmemdup_array(c->limits, c->n_limits, sizeof(limits[0]),

Maybe sizeof(*limits) would be a more usual pattern?

CJ

> +				       GFP_KERNEL);
>   		if (!limits)
>   			return -ENOMEM;
>   

