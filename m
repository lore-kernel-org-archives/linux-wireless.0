Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD2234B437;
	Wed, 22 Jul 2026 06:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784702471; cv=none; b=uq5aizxWtTxKLLscZV15WARn9sWOrKY5X1O+VHMCZjMmFL7tN39XB2xKLcHuFZAsm1knLM0I1o7SfXKkFaDwBiFiSOaI+RJzYTTNg+C4mvhW9Qwaa1cofO29POX8xgCmJiOlrTeByjCHl4lt+czauNTC/go4y7PY0zr5ZxiwSJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784702471; c=relaxed/simple;
	bh=WSYe0La1gRuhpyNx4z9/mNcR0cTInkHLUzStLoxrmhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HL+flXd+MuzjxXAjtbEMjgSMUU2y9eIxjF2xiPlc59hL3BXQ2rTXlCy17ryMvKfeuKHgT8F/qSkw975C16sb8c8SZ0IuJ+R2T3RBWuqZVORlB2dAtRICvNoe7AaQF2L4hV/UzPsHl8bD0iS5gRTDPzp4NHE1Fx7u1AEQ8x70pgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=qFBMeaTq; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="qFBMeaTq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=WAHJwsvuNwWHxOZ2ym/PXilLLiyxaq+5NfqHmwiGlIM=; b=qFBMeaTqF5hK6TtOJkb3hFA0qj
	kxn2ab55F4hkCd86K2h5UfX9aKiGo3XCpj2Esouvo0znsA8fs4V6wkWZEg51zah3FPasodFN3KOGu
	kwbo5khuQNCjwH/dWHfiCmUYqHhd6jr4jU+aEOA3ZDldjl5AG4pwJMSbQ9g/lMj/1gcA=;
Received: from p5b015c4b.dip0.t-ipconnect.de ([91.1.92.75] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmQdU-0058IB-2S;
	Wed, 22 Jul 2026 08:40:56 +0200
Message-ID: <a0c1178f-86e5-4193-9d9c-767abbdee076@nbd.name>
Date: Wed, 22 Jul 2026 08:40:56 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 wireless] wifi: mt76: fix MAC address for non OF pcie
 cards
To: Klara Modin <klarasmodin@gmail.com>, Rosen Penev <rosenp@gmail.com>
Cc: linux-wireless@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>,
 Sean Wang <sean.wang@mediatek.com>, Matthias Brugger
 <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "open list:ARM/Mediatek SoC support" <linux-kernel@vger.kernel.org>,
 "moderated list:ARM/Mediatek SoC support"
 <linux-arm-kernel@lists.infradead.org>,
 "moderated list:ARM/Mediatek SoC support"
 <linux-mediatek@lists.infradead.org>
References: <20260706232857.807044-1-rosenp@gmail.com>
 <al_SAwiLmgT6D_tS@soda.int.kasm.eu>
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
In-Reply-To: <al_SAwiLmgT6D_tS@soda.int.kasm.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 21.07.26 22:22, Klara Modin wrote:
> On 2026-07-06 16:28:57 -0700, Rosen Penev wrote:
>> If seems the check for err is wrong as the proper macaddr gets written
>> to from the EEPROM itself. Meaning checking err from of_get_mac_address is
>> wrong as the proper macaddr has been written by this point.
>> 
>> Reported-by: Klara Modin <klarasmodin@gmail.com>
>> Closes: https://lore.kernel.org/all/ajRmlyx_AEGybykL@soda.int.kasm.eu/
>> Reported-by: Tobias Klausmann <klausman@schwarzvogel.de>
>> Closes:
>> https://lore.kernel.org/linux-wireless/30a90714-02d8-45f2-a7f1-4cfe0627d50b@skade.local/
>> Fixes: 31ee1582717e ("wifi: mt76: fix of_get_mac_address error handling")
>> Signed-off-by: Rosen Penev <rosenp@gmail.com>
>> Tested-by: Tobias Klausmann <klausman@schwarzvogel.de>
>> Tested-by: Klara Modin <klarasmodin@gmail.com>
>> ---
>>  v2: add extra tags and target wireless
>>  drivers/net/wireless/mediatek/mt76/eeprom.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/wireless/mediatek/mt76/eeprom.c
>> index b99d7452800f..afdb73661866 100644
>> --- a/drivers/net/wireless/mediatek/mt76/eeprom.c
>> +++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
>> @@ -181,7 +181,7 @@ mt76_eeprom_override(struct mt76_phy *phy)
>>  	if (err == -EPROBE_DEFER)
>>  		return err;
>>  
>> -	if (err) {
>> +	if (!is_valid_ether_addr(phy->macaddr)) {
>>  		eth_random_addr(phy->macaddr);
>>  		dev_info(dev->dev,
>>  			 "Invalid MAC address, using random address %pM\n",
>> -- 
>> 2.55.0
>> 
> 
> Ping. No one seems to have picked this up yet, but I suppose it is
> holiday season.
It's in the mt76-fixes pull request that I just sent.

- Felix
