Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=129.217.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793954309;
	b=2S/STJPdPbFkV6u0UlVPVFj9YICDK3z4DC5eG+LQ1/cgDtwfhcpg9Ofs8t4LoOzQ8EFF
	 i9Z2/VHg0v+2VcOC2QyPfNxobKeFPrs1qCIZC3zHCsLGOT9bq3nxYmxdmGl+q63aZKVCD
	 RZAsOGSICTQYOdEw5Fc2Atjf9A7jeJlxsIM4MZHgHzmvzfMrSUNthF/NDrOPr8q2aYNov
	 /BmjpQXYvlJ4GcJCqeDcdeAq6FVpBWI4dYH8BHg+CaiWQnNab8FAhpp4JLxGxAn3dC/wc
	 RoBsTcojRr0Kt1z2jGL4Bg/WxuUsmdKWLAepBvxIpZ7YSQup2RCAHPQ99tiNRJnIQQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793954309;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=WxiAEH59zWzvePp1S0UYbaDiwSZ/r/CKhdUBRbozokg=;
	b=LxDzTtshO3JeS4Eq7l+GazzXBzfPnKfk+R/3b2Iot/v3EN3HPBpDtbWhJLwEO7gTDLDr
	 Xn2+FO7JBS1ZDiwJm4G/A/aV+ELFry4UavJMb9ynJ/UWwYCaV78cLkKWUepROVsf/wcuj
	 PAt8adfaeXSuGOsx1a/Gw43vc4fuiH0mSEgVJ2ja2xUPwvnmLBKnrbB1LLI5EtaWQxDQ2
	 gpdH9l3zAnMnJnhVIlZ+ZPN5UcAaVpCD2bXZHijEDXJPN2irpk0L+x10qoBwqIpcjCYn7
	 vzN9BcBuIG5T6pewwid1WEVAyLc5d0P+gF/jgNd1feqikUaWg6ZGlqcUajGX7JcYqog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tu-dortmund.de;
	spf=pass smtp.mailfrom=tu-dortmund.de;
	dkim=pass header.d=tu-dortmund.de header.i=@tu-dortmund.de header.a=rsa-sha256 header.s=unimail header.b=YS5WlOtm;
	arc=none smtp.remote-ip=129.217.128.51
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1520E606A328
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 08:38:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1520E606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.a=rsa-sha256 header.s=unimail header.b=YS5WlOtm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tu-dortmund.de;
	s=unimail; t=1793954302;
	bh=WxiAEH59zWzvePp1S0UYbaDiwSZ/r/CKhdUBRbozokg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YS5WlOtmVdQ8IcpcsU3PkoOykgjQCNxvuH2VLRbqVPHRHJfqrYPpWaqbkFkYxf+/k
	 GPzX5Vy5AsFH4ia4CqfloyBeaKwMfOLSy6SDSSzdbhQJ1eeash7AdJmYq0odM5g7mZ
	 nhSz4WV6MtfAodOfQX5lEjqHVaSvPTeiKJW6YaF4=
Received: from [129.217.186.254] ([129.217.186.254])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.19.0.2/8.19.0.2) with ESMTPSA id 6A68cMXt001879
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 6 Nov 2026 09:38:22 +0100 (CET)
Message-ID: <68595675-9f20-4c05-8982-e102f1d72fda@tu-dortmund.de>
Date: Fri, 6 Nov 2026 09:38:22 +0100
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
Subject: Re: [PATCH wireless-next] wifi: mac80211: mesh: notify driver of peer
 capability changes
To: Florian Maurer <fmaurer@disroot.org>
Cc: linux-wireless@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
References: <20261101130636.1867958-1-fmaurer@disroot.org>
 <26af137a-e2f4-4b96-b72c-1e95ffa9dddf@tu-dortmund.de>
 <4d72ef2c4f12595c629b8ddcd46f6f7b379bb576.camel@disroot.org>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <4d72ef2c4f12595c629b8ddcd46f6f7b379bb576.camel@disroot.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/26 01:52, Florian Maurer wrote:
> Hi Simon,
> 
> On Sun, 2026-11-01 at 16:24 +0100, Simon Schippers wrote:
>> On 11/1/26 14:06, Florian Maurer wrote:
>>> This touches the same FIXME as Simon's RFC [1], but addresses a
>>> different case: a peer whose capabilities change between peerings.
>>> It does not change anything for an established peer, so it does not
>>> help when a peer comes back with the same capabilities.
>>
>> Thanks for your work! I think I ran into a similar issue while
>> experimenting with changing bandwidth live via iw. Your change looks
>> good to me.
> 
> Thanks, would you be willing to add a Reviewed-by on the patch?
> 

I don't feel experienced enough to give a Reviewed-by, but I'm happy
to ack it:

Acked-by: Simon Schippers <simon.schippers@tu-dortmund.de>

>> My patch is more of an (ugly) workaround calling
>> rate_control_rate_init() on every beacon, which fixed my case of a
>> peer that temporarily went out of range and came back with the wrong
>> MCS still selected.
>> I'd still like to find a proper fix for that case. I'm not sure
>> whether this is the right place for it, or whether it belongs in the
>> rate control algorithm itself.
> 
> From reading the code, rate_control_rate_init() returns early when
> there is no rate control algorithm in the host. Your RFC mentions
> ath10k, which picks its rates in firmware, so I don't see how your
> current workaround could change anything there. I haven't tested this
> on ath10k though, so I may be missing something.
> 
> Regards
> Florian

The code changed in the meantime. On 6.18, which I tested with,
rate_control_rate_init() still calls ieee80211_sta_init_nss() before
the early return [1]. Whether that explains what I saw on the hardware,
I'd have to dig deeper.

[1] https://elixir.bootlin.com/linux/v6.18.55/source/net/mac80211/rate.c#L41

Thanks,
Simon

