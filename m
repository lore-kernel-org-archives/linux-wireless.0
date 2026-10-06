Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014D91E9B3D
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 15:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791301228; cv=none; b=DHaXTwkV4xpPcRzIHj0H+Nkj98IzJNty1Wdz+W060KyvLERV12HL+GGA5HZXNc0WcYxtD6oGvP6WcGf0OiMqnklJNLOmpklwUW3JQnIk1YC5GP2iI7gk8K5M3pPUu6Ctr82L/GxHstVBGwNEC+kHX2IW9gdTnyUqN1gOXTna/4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791301228; c=relaxed/simple;
	bh=dTILSIf+qTFIf8yhAaAnpeUUHKo/uvJl4hjKFtG8LJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pZC+viF+TB+z1oePfsoCaOIPjNaFdVwhhCuXTjjunsLQIq1CkaZBQx4aR4zu/g4IawtQ7RHT2Bb0xXUT6yFSH25jcxutm25q8znQN1La0IQgI4mD0jIgLbiR8tfxePw/YN8tL5aSHLY2sAb6Hw9fA0CeiW10cRqsyxlTsmdn+eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=lGT0EV1h; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="lGT0EV1h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=rxl3tZbFF5iOdiovHswFmJJfkFXMsEGerLI8jCvxhiQ=; b=lGT0EV1hgifFh5K9NRNV//HE/r
	W03paMPd7YZTaZ+iTx2dVHn5J6amgAZOW14lCzfllKIazqgOEnDT4ycQ6ya55SgL9iQQWmtHCyFJZ
	G7fDDwHCGvsAAjDwi41AzJVTaW3ItBt28ryDEW0HahQ76vd+LBFv/HThvVQjAddQb694=;
Received: from p54a434bb.dip0.t-ipconnect.de ([84.164.52.187] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xE7H5-00H1SN-32;
	Tue, 06 Oct 2026 17:40:15 +0200
Message-ID: <8a070d0a-177f-41a3-bddf-0f8b06e82baa@nbd.name>
Date: Tue, 6 Oct 2026 17:40:15 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: mt76: mt7928: only do CLC hw type sanity check on
 MT7925
To: JB Tsai <jb.tsai@mediatek.com>, lorenzo@kernel.org
Cc: linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
 Sean.Wang@mediatek.com, Quan.Zhou@mediatek.com, Ryder.Lee@mediatek.com,
 litien.chang@mediatek.com, Charlie-cy.Wu@mediatek.com
References: <20260909055750.929102-1-jb.tsai@mediatek.com>
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
In-Reply-To: <20260909055750.929102-1-jb.tsai@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09.09.26 07:57, JB Tsai wrote:
> From: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>
> 
> mt7925_load_clc() is shared by MT7925, MT7927 and MT7928 (0x7935 is
> folded into 0x7928 in pci.c). The hw type sanity check it does on every
> CLC region is MT7925-specific twice over: the encap bits live at
> efuse offset MT_EE_HW_TYPE (0xa71) in the MT7925 layout, and only
> MT7925 CLC blobs carry that hw type in their t0/t2 header. On
> MT7927/MT7928 the driver therefore reads a byte that means nothing on
> those parts and compares it against a header field that was never
> populated, so a mismatch silently skips every CLC region and leaves
> phy->clc[] empty - no country/regd table gets installed at all.
> 
> Gate both the efuse read and the two header checks on is_mt7925(), so
> MT7927/MT7928 accept the CLC regions from their own firmware as-is.
> No functional change for MT7925: PCIe still reads 0xa71 and filters by
> encap type, USB still runs with hw_encap = 0 as before.
> 
> Fixes: 356b39285559 ("wifi: mt76: connac3: refactor CLC header type validation logic")
Patch doesn't apply, and I can't find the commit mentioned above.

- Felix
