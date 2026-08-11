Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE432D97A6
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 16:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786466328; cv=none; b=f5YBZ1UmiM5NDqXYmv47i0VqGtS4pZlFCqbsn13LEmpuoSFbXitv8Hez4cJM5H4nBEpJx9tP4s1oaUcbSTWZEMMrR93dUNt0Em553mXsb5ecQpEYlrFDsqf0LOiR3/NuWoWVk+CyPOR90iDnE6s7iweV1t9cORD1rQ40IaSAE1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786466328; c=relaxed/simple;
	bh=7eTrIl8UAPAo9488cONNNzU40liWUCBayfAvbP8UJFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u78PrYxRECpDSz6xq9cFrv8Lgded0saTHB0zYM+27M8yBSHOFU6s9sON0cOoDm2ytEWigTqZQqRGJ8SMTwmmyAsnWjpkEu/gvIzqRstkZx51kxgCCL5R/cF3LS8Mj01B8+veyqWvpEQeC2JV0Y5kfHhIDrI1WsNTo1rk3FDaIY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oQLTXBUJ; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oQLTXBUJ"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cf50c6f235so2133725ad.0
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 09:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786466327; x=1787071127; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e43X0BlS7+R+wrLWceH4HsNzseyZ9TyIqbPcJsFG5+w=;
        b=oQLTXBUJ36BXS3whq4Ajm6dFqOUpG/Zve4UCW2wXfYPQay6HnnLCVd/E0avhu6D2hT
         Trs22qU728mIlEpYUIRZFJ3J9Bn0QEwlYGxHANcgzApubjsK/UdR20pb2y7Rcz8IWQ6/
         1JHAK+/XxP9ptqzigzZNQbRpshQMuG0CYwRRtcXlavvyw+8uUP3QOJqIoDsrO+P3yAY7
         MrFucXjrt3+ZbNLNdvBqgVjCP3+BivOfTcNK+SvneANO/7FFkle9+HGU35xq8wYpf1a3
         UIVLPqq1weI/k7w1vXfX6z4DgU+Sx3chERObaGEImtzHRn/ji7vkCJsP3MQ8I4y5KOf+
         VDfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786466327; x=1787071127;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e43X0BlS7+R+wrLWceH4HsNzseyZ9TyIqbPcJsFG5+w=;
        b=Syy6KasELM9eUlrc8/uz4CQdLZZm1LziC5dqnzlVKTzii5lIQVnmPcLlE9317tp+Ig
         YxRhYgbofw4Ey2ZUb/e00ZLU8H41EgbdZq196bCjx7WsNL7yu6xgRSrJ4UoUg+ROTTln
         0Ub6LP1T4qisRhpYx5okH6Blm49HFjVMW0x/58bAb3Lr8abhUNk03aQyDw0/UT0aqCgZ
         NEsPl3Tc5klb2JwNJ5hPSkW5bdv/T69kE3efn77cM2IYYtPwRjJ5/SvMhrSYPk2mhOZB
         8HllaBXAyqrQ9kmiWmVZfUe9m0ATo+pTvDKxtKc7qqvXJ4YUm63ll+bANJzB5N7gkgUI
         TKJA==
X-Gm-Message-State: AOJu0Yz79bwgAcP6z7/l9oJuSDtgDT37uODAY4pLltmAP9r4gBUs3oBC
	unO6dqgqSIE9VRpu0KC77ueAgxWExedd5A7OGa0kxPNsYCGt4efgVF63
X-Gm-Gg: AR+sD12zw68DMLHG8+eHQbFCKfxob7BlgB4yJlpzI5nsnVis0e8Hm0T3vYuzejKkFQO
	TkWQGVJLF9dJoqrAPzIzdnHsY6DBnHTFEd9CfwhlpfFzWrSzZ9qP409h3uDZDQka9jamEYz9NyE
	WCfofodGhUYnDRhdOb66j7dXTAvRxOwetPLepUHkMfEHJwHrEdc2MC+vWAXVKdToHClSjRN16YM
	muW4PqJwAkhu/wrmkmB0ejwSBVheIFr04lWGJSQ1gsP/EhjgSE1olg/I7OuPoz7DppfogNmQ+Q6
	bidohrMT8bG6XRnXNvAtslsYIBo6qwRNB8C4Lfqf1pufujS1xn2tPPFjmBg0jTni8W1crZCsKKN
	7IMw6TqWm7NAgQE7f8HeQwXV8Il9zP0nEyhl5DfyICehBlVdmoteN+m+DkkDt49b3e8X+/WYxjT
	Qh13Gul+h3shNuQKL9akgWKRR66S0VS58riQ30gS49iHDB34GOyTzaGlFll/rJ6D/+9i0uYtvb+
	3qe9+Ge4WrpFuun5+q52LNN
X-Received: by 2002:a17:90b:5190:b0:38f:837e:fc5d with SMTP id 98e67ed59e1d1-392f463c186mr1588316a91.3.1786466326926;
        Tue, 11 Aug 2026 09:38:46 -0700 (PDT)
Received: from [10.100.120.121] ([152.193.78.90])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392f94d5cb7sm105185a91.15.2026.08.11.09.38.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 09:38:46 -0700 (PDT)
Message-ID: <219ac494-deb2-41f7-a762-7b5e666499e3@gmail.com>
Date: Tue, 11 Aug 2026 09:38:43 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: mac80211: defer AP-side FT key upload until
 association
To: andcov23@gmail.com, Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
 Kavita Kavita <kavita.kavita@oss.qualcomm.com>,
 Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>
References: <20260730161531.3535100-1-andcov23@gmail.com>
Content-Language: en-US
From: James Prestwood <prestwoj@gmail.com>
In-Reply-To: <20260730161531.3535100-1-andcov23@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrea,

On 7/30/26 9:14 AM, andcov23@gmail.com wrote:
> From: Andrea Covelli <andcov23@gmail.com>
>
> During an AP-side Fast Transition, hostapd may install the PTK after
> creating a station entry but before marking it associated. The ASSOC gate
> in ieee80211_add_key() rejects the request with -ENOENT, producing:
>
>    nl80211: kernel reports: key addition failed
>
> Userspace may retry after association, but this race can instead break
> the roam, particularly with PMF.

How does this present itself on the station when this happens? I'm 
curious because over the years I've seen strange behavior from basically 
all vendors of access points like:

- Mysterious association timeouts despite good RSSI/utilization.
- Denied FT associations with reason code 53
- Successful FT roams immediately followed by a deauth with reason code 
6, 7, or 9.

I know the above could be from any host of issues, but I'm mostly 
curious what the client sees with this specific FT key upload failure.

Thanks,

James

