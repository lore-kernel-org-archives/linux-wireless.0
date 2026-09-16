Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEF43B38B1
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 13:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789567065; cv=none; b=V5smKV8soex2355dceprHyBEYkPj1a7urPxUBiCWUEaIkq1xDJ7OmHlJLeSHI1FK9c0x70o/p1qrSfaMuo04vTwrcoK94sd4XxxxLCFsahxomKOBtCryr6gJRXzH6iG40lPsSWJdkRLW9/TC//xIiMzzR+cNF3T151xHiOYDKvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789567065; c=relaxed/simple;
	bh=Qi49dcxv6G47dt+F1rTDH1wxK4eSM04gDsZO25dLybc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pasQOen/LxnTK+tRk1i8eZxb40xhWRH5EYP3I/JUujfjgc4T91bHRLn9i7I7grfG0KTR4UQbctdSs07r0Ox12tICxU59wT6eA1G3lRLybN5E/dIgGS5U+Kp9ahfg0cLtlNeqqFxlKOOpp+PdBT/ARTptjgckMk4SxrSdXTUtQHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=P37ia/Xl; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="P37ia/Xl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=peXEpVKJqUJ9DsVizih8stiMIWBzu8tOnlPygA906nc=; b=P37ia/Xlxf7yvGr4EQpHGot7e/
	7owxXctCmfoVYtS/vKPDy0yBYTP1a/HlcrK4VvyRS6GxFFmMIpsgie+zP9qIHqf5ZNC6i3ZOw536N
	+IMht9sdG/Xn1tUovc6eu4sqKskH/oBqxq1ZVhdgVYKW0ajROYzNzpi8j68ig+CI+a+E=;
Received: from [2a01:599:102:54a5:349e:9e41:91dc:77b5] (helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x6q8n-004yEq-1Q;
	Wed, 16 Sep 2026 15:57:37 +0200
Message-ID: <6dd72dec-0b37-43f9-b205-dc68bf5ce69b@nbd.name>
Date: Wed, 16 Sep 2026 15:57:36 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] wifi: mt76: mt7996: use spin_lock_irqsave for
 reg_lock
To: Valera Kozlov <valera.kozlov19@gmail.com>, linux-wireless@vger.kernel.org
References: <20260901194338.110-1-valera.kozlov19@gmail.com>
From: Felix Fietkau <nbd@nbd.name>
Content-Language: en-US
Autocrypt: addr=nbd@nbd.name; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCeMncXpbbWNT2AtoAYICrKyX5R3iMAoMhw
 cL98efvrjdstUfTCP2pfetyN
In-Reply-To: <20260901194338.110-1-valera.kozlov19@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01.09.26 21:43, Valera Kozlov wrote:
> mt7996_rr()/wr()/rmw() and mt7996_memcpy_fromio() take dev->reg_lock
> via spin_lock_bh() when accessing remapped registers. This is not
> safe against hard-IRQ context, which can lead to race conditions and
> kernel panics on some platforms.

What hard-IRQ context is accessing registers? I think it would be better 
to fix that instead of imposing the irqsave cost on all register access.

> MediaTek's own vendor tree independently found and fixed this same
> issue, reporting it as causing AP panics via Asynchronous SError
> Interrupt during normal WiFi operation:
> https://github.com/mediatek/mtk-openwrt-feeds/commit/3edfc0cbf7dc666a0b051b54f51634d6ff2a3be6

I only get 404 on that link.

- Felix
