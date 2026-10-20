Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792489720;
	b=K9fbIOwnS3NjqGH1Q/McVX8+Hq8LX4LLkoEdwtNCejA9CsYLPMvRJn1V7v/zyt6m3eM7
	 e+ldLu/x7ITfZf1F3PO3hoFXTJph309S4nYV2CAZgaT3HO7m+eV9HA+9q8AwJL32J77sh
	 joRHRsnAvM4hwVIlbBrXoR4oH7aS4bHGx2eZGlWH/AUR00Nzqb/pk42gO4gvNpeIl/4ZR
	 2XFzOb9qZvHhx2rFQfBl2r/9YsDLmfZLn/G8eOU9Kb03UXCpWQJNGCQX6emGgw8ZSu+jT
	 CDlvnqrDtxnnExctBRdF+rDvhWCN0N0NVb+7eX9n2ClhGIt4vAdi3+wdAzdBvUKgTmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792489720;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=bemVMXXsJxZFuCmLzO06rVDAoN3lAwMbstGW8fkuTHg=;
	b=tBaeaYrM/CnqjTQwge8UwSp0tT0TKO/Bxnis4BgayNfhtQuuHxdQhYCs2YptMjBRAQBY
	 VHOe6lt1SevnIoi0X/xEC8G+E+VyfUiAAPKqo1kSKmSqVwebLex/bpNIsSGIfKO/5W9Ut
	 t0yZBvPGIGp/nA2i4nhK29csDIWuBvAZBbNagzk8l3dzCLfjkLiepmgsLWHzjbWJqGgjC
	 ghFQOb4PzDStcgqipze2wVrQAcdVihWnclpmG0nv2tHw99Ij0fJWOiLGuerRE1IazoQJZ
	 qv046dZwOxKpS65r0TFa7PCKsxj1Dq+CJVkycoaGKqnh7DRwhLJ5Ri96h1HbHryEI6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=pV65s0AO;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79401606A319;
	Tue, 20 Oct 2026 09:48:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79401606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=pV65s0AO
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bemVMXXsJxZFuCmLzO06rVDAoN3lAwMbstGW8fkuTHg=; b=pV65s0AOhAVdWcxxxpF0o2Fc0Y
	rhscq4sb3lPsp43FS4IKMVnFfNBtdKPJrtqyvqgX6bP098GpAZHaSj91Tgfsc2w1DnsKwblntbWno
	vWWVCMnwPXUflMLJqxb76O8uDQQeldrXARBHAEvsDQ7QQRg4U4BRg5kOkZGTtc531HkU=;
Received: from p54a4360c.dip0.t-ipconnect.de ([84.164.54.12] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xJ6SH-007dgK-1F;
	Tue, 20 Oct 2026 11:48:25 +0200
Message-ID: <6e7358fe-4070-4a88-b8da-77e2f9e9bdf8@nbd.name>
Date: Tue, 20 Oct 2026 11:48:24 +0200
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: mt76: mt7603: discard power-save loopbacks after
 wakeup
To: Cristian Papa <pcristian292@gmail.com>
Cc: lorenzo@kernel.org, ryder.lee@mediatek.com, shayne.chen@mediatek.com,
 sean.wang@mediatek.com, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261014062225.9238-1-pcristian292@gmail.com>
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
In-Reply-To: <20261014062225.9238-1-pcristian292@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14.10.26 08:22, Cristian Papa wrote:
> A station wakeup drains its power-save queue once, while frames
> redirected by the PSE can still be waiting on the MCU RX ring. Processing
> those loopbacks after the wakeup queues them for an already awake station
> and sets the driver's buffered indication again. The stale frames remain
> queued until another service period or sleep/wake transition drains them.
> 
> Check ps_sleeping under ps_lock before buffering a loopback, and publish
> the buffered indication under the same lock. The wakeup's state change
> and queue drain use that lock too, so late frames cannot repopulate the
> queue or leave a stale buffered indication after the wakeup.
> 
> Discard late frames rather than retransmitting their old sequence and
> packet numbers after newer traffic or a wakeup BAR. This loses the late
> frame; it does not recover delivery. Use the station's sleep state, not
> the temporary hardware PS bypass used during U-APSD service periods.
Why did you decide to drop them instead of pushing them to immediate tx?

- Felix
