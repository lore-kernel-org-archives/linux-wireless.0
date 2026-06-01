Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9E13750DB;
	Mon,  1 Jun 2026 12:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780315767; cv=none; b=atwYAezvOiHcjDSE1HsTSEFsYLxUvrNlVcw2boi86KZ4zNfR+GV9QlidSeye7INzT4Vl58wB12Ax9uFoOZI25y+u5aDl72Y/4kcv+NsgZSlSmCRkxT7Lg1AmWO+L+t49aweyysfDeKfZD4jWxhn7Vr/ynU1n+5p049NZn2NkPm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780315767; c=relaxed/simple;
	bh=hLPG/54QCvQ3SeVNvRK7HejTb36mQ/N5uUjoNREjbUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pbn47Dq510RLD2WaqvnrkJQjgKNzV8hTb4x3n6HEFNTgQLZ5KWJdn7a1Af1I+K7wmVJUPzmqBtpJ5MIqjPVRHhRPadFl+acLQcCrqy/vtvq8HEp8AncFBUYXTaZVp0egWA356LIsyCnNWjpfqkRx94KToEw/TVhYJlb62mKASqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=CdaAcBgw; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="CdaAcBgw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DRyUFBv2XaY0azYCRWvAw2BmMROHRiJQM5iOAaN1NXs=; b=CdaAcBgwM1UMoq3B/U4/q3/Ufa
	T5Yn3bnwf45EMCwPEKKqv3S6+UIsm51XnN33zwSlGrUtEuqCASwJgSlA010A7ghzgeQazKC86KXWh
	QkHhXcB3IZBIT26inKj6KJjq0qUQyAV3e4m+lXACNusk95UgCt5b+yBh3s2To2Q07Doo=;
Received: from p5b015753.dip0.t-ipconnect.de ([91.1.87.83] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wU1SD-0059DS-0g;
	Mon, 01 Jun 2026 14:09:13 +0200
Message-ID: <fadec8b5-c3c0-41b6-a1d0-b31c4ae19fb0@nbd.name>
Date: Mon, 1 Jun 2026 14:09:12 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mt76] wifi: mt76: mt7915: configure noise floor reporting
 on reset
To: David Bauer <mail@david-bauer.net>, Lorenzo Bianconi
 <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>,
 Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
References: <20260516144944.2574053-1-mail@david-bauer.net>
 <a83c9aca-da9e-4a5e-a364-382910388a68@nbd.name>
 <370e76e3-1d41-469b-8e50-8ace6b5622d2@david-bauer.net>
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
In-Reply-To: <370e76e3-1d41-469b-8e50-8ace6b5622d2@david-bauer.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27.05.26 19:05, David Bauer wrote:
> Hi Felix,
> 
> On 5/27/26 15:56, Felix Fietkau wrote:
>> On 16.05.26 16:49, David Bauer wrote:
>>> When performing a full system recovery of the MCU on a dual-phy
>>> platform, band 0 (usually 2.4GHz) stops reading correct noise floor
>>> data.
>>>
>>> This is due to noise floor reporting only being configured correctly
>>> for the second device PHY.
>>>
>>> Configure the respective registers correctly after restarting the MCU
>>> firmware to fix reported noise-floor values.
>>>
>>> Signed-off-by: David Bauer <mail@david-bauer.net>
>> Have you considered clearing MT76_STATE_RUNNING in mt7915_mac_restart instead?
> 
> The call to mt7915_run is guarded by MT76_STATE_RUNNING being set per-phy.
> 
> I think this is to not start the second PHY in case it was never started due to
> it not being present. We could in theory remove this check for the primary PHY
> and clear the flag prior calling mt7915_run.
> 
> This seems a bit more hacky to me. Alternatively I can also refactor the entire
> mechanism to make it easier to understand and resolve this indirection in the
> process.
My suggestion would be to do this:
start_main = test_and_clear_bit(MT76_STATE_RUNNING, &dev->mphy.state);
start_ext = ext_phy &&
             test_and_clear_bit(MT76_STATE_RUNNING, &ext_phy->state);

Then using those as conditions for calling mt7915_run in 
mt7915_mac_restart.

That way the special case in mt7915_run disappears and the behavior 
becomes easier to follow.

- Felix
