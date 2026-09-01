Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001D82F5324
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 11:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788261521; cv=none; b=PMjnh1WCeJAWBcsMeJy52HAjv8Zb2+CpGAWXH3jvH+hwlJxUiwGsxZfccO7kAEMKbMTZo3IbsuHuzvB5RIFQnlWTxc/cM4CiLqncsEbh1aKJldZD3iwujtMybkZl2NAKHjldsaHGz/BMHmpqEgsJIOfTxhEv+H63k4diEfUYkg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788261521; c=relaxed/simple;
	bh=fvIWSL6YkHcJVCQ5SThWtPGcHr6g++pogdng+9sct+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fPoWDP91aCNiz1FUe+mwEjbvZt7Ce+HM4Sh//C8N8XN/gs6RiMpXuYo+Bx2H8mUAEGgnWL8JLvZgkT7cHitCPpCZJ3KFvv3pIxCHxt94mFY/0lv3lSzSN/eMg97/ktblSq2c1zECwwxfu69URGG0r/sl2Jm2BqUS85GwjD9gSAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=Y6F+iXd/; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Y6F+iXd/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=rgmL92h5XLCrFWaqnhiuVXrBTMLsaLg5UegKNjUl3C8=; b=Y6F+iXd/aMi/2XiJJxTfHlVB+R
	9kTdl0GAU9jg4oMUwCVRDntnEW4c04rj8v1aw5+hVa6SDkqMLYGfPZy0kQZmvatYZ41ZsKwVHmSiQ
	kZ7ls/B/VFWJSYR0Wv8eFHLBtJE69qpEcfj6IS869+SNl4tuVjF0ZEuJrX0PaJP4yWeY=;
Received: from p54a43140.dip0.t-ipconnect.de ([84.164.49.64] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x1MVc-00CHLW-0t;
	Tue, 01 Sep 2026 13:18:32 +0200
Message-ID: <840a505b-bff8-4e57-9bb6-892a42b9aad2@nbd.name>
Date: Tue, 1 Sep 2026 13:18:31 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: mt76: mt7996: use spin_lock_irqsave for reg_lock
To: Valera Kozlov <valera.kozlov19@gmail.com>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>, Sean Wang
 <sean.wang@mediatek.com>, linux-wireless@vger.kernel.org
References: <20260824062301.270-1-valera.kozlov19@gmail.com>
Content-Language: en-US
From: Felix Fietkau <nbd@nbd.name>
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
In-Reply-To: <20260824062301.270-1-valera.kozlov19@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.08.26 08:23, Valera Kozlov wrote:
> mt7996_rr()/wr()/rmw() and mt7996_memcpy_fromio() take dev->reg_lock
> via spin_lock_bh() when accessing remapped registers. This is not
> safe against hard-IRQ context, which can lead to race conditions and
> kernel panics on some platforms.
> 
> MediaTek's own vendor tree independently found and fixed this same
> issue, reporting it as causing AP panics via Asynchronous SError
> Interrupt during normal WiFi operation:
> https://github.com/mediatek/mtk-openwrt-feeds/commit/3edfc0cbf7dc666a0b051b54f51634d6ff2a3be6
> 
> Switch to spin_lock_irqsave()/spin_unlock_irqrestore() to make the
> locking safe against hard-IRQ context.
> 
> Signed-off-by: Valera Kozlov <valera.kozlov19@gmail.com>
When you send mt76 patches to this list, they should be against the mt76 
or mt76-fixes branch of my wireless tree at
https://github.com/nbd168/wireless

- Felix
