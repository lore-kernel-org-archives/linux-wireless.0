Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792490301;
	b=oTm6nKXkLWVfpIzvMwul1TOhn0WX7MwxCgfi2i1hyafDxoTOi7QW+i7H3sqR+eL34u7x
	 iKAgCTKvE7tXfF1oNDcJxsygu7F9nHltxevoQk2zS6Z7buRAW9FxevwQWHSDuiJqSv2JL
	 /kjW8Y3Hct0t1QcDYsIkU0Q9m52oGxGUx8VcsE3mijzaskRoipUcoyv6u22oFYIZRHksP
	 AsKlkUWIZ9sKLI/nIU7kdJc/rBY2X2UyC+TbbLrawl4x+3gBzyjNBlkI3S5SGiNhFG8pW
	 XmbMksELsDn479nQOBqfarNQC1SJGm9JUnYZfPWQ0NZpL2VcPB5W1dNkqa6cjbqiMkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792490301;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=FZ+e7VietCmciPEeHI2D5lul/8HEEkrSf/7Z8+LJ4Pk=;
	b=vdMW9RHeGJ1arZmj1s0o94AIa2wA7gHfZb5DD1eGaSTC+zJ0k5kffep3dZqcOLrY7sI7
	 olu7saOm3vNNCI9lsyDJPruKOR7B0Wg1MTXn39lQxyefJnESx3NPgmaeG2VizxnO9MIvc
	 hkjubr8IAcmWaSve91UH3hHqJhT3t85TPKRWFe6iWsjZcfjL6BcFRSS8NfligGblQ2XMj
	 Sf+zvw2Iu+Lziiy/xyWeAioYog1j9qv7VQ2Jk+CkzSHki8RoS8aTbJjwkbVXqUEm8PATu
	 1CUsag/pi4LwFP/Oh9VsMLAmoZ4UKRGFslEAOoJQxkO1TWB1v1/4S06XgiE0b/kaZvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=Fj6HASuU;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC418606A319;
	Tue, 20 Oct 2026 09:58:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC418606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=Fj6HASuU
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=FZ+e7VietCmciPEeHI2D5lul/8HEEkrSf/7Z8+LJ4Pk=; b=Fj6HASuUMTB4CHj1BTQtRuI7m3
	IygqrTwTR0vgnbGQ97Jy4/LUG/68/5ZrRRW/mC66QPv5CoMf9jEuuUztGWxhDQDqyKMA+7CBrmMfi
	9HkFv3ipRb93/2B3vM3v76mcDhUwusuwZLt+a5PjO7DfEkBvdD+VMXG0n/UqFJatBMik=;
Received: from p54a4360c.dip0.t-ipconnect.de ([84.164.54.12] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xJ6bh-007dyq-0V;
	Tue, 20 Oct 2026 11:58:09 +0200
Message-ID: <7aeeaf3b-7a06-4e06-b5d1-94b97fd081ae@nbd.name>
Date: Tue, 20 Oct 2026 11:58:08 +0200
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
Subject: Re: [PATCH] wifi: mt76: mt7996: stop radios after add failure
To: Jiale Yao <yaojiale02@163.com>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>,
 Sean Wang <sean.wang@mediatek.com>, Matthias Brugger
 <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
References: <20261019013146.1488644-1-yaojiale02@163.com>
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
In-Reply-To: <20261019013146.1488644-1-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19.10.26 03:31, Jiale Yao wrote:
> A multi-radio interface can start one radio before starting a later
> radio fails. add_interface returns without stopping the radios started
> by that failed request. mt7996_run can also leave firmware radio state
> enabled when setup fails after radio enablement.
> 
> Disable a radio when mt7996_run fails and track radios newly started by
> add_interface so they and their monitor state are rolled back on a later
> failure.
> 
> Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
This does not apply properly. Please rebase and resend.

Thanks,

- Felix
