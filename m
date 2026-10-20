Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514662;
	b=4nPq9UYGJDXl27chBSv5VToxR5wLTioI9mbAmyKL9Zznvgo0x7/TZlkvWAuaZC+Suxra
	 kZkvydWogbg6o95ijlKgT4Zm3K6e3uV1FTvkH8RAwWGOtOyBKsw8NV/HB/HfLZKBeaZj4
	 sKf4trg+0KnVt/uqgJMValZl7jThBibNVhOzdVMkTo2WGqe9bex5lU/FtI5MOvOVa9lv8
	 0THD6GuDYHFXah1cV/F5lMStLS3rD322VenRy9g0RQoZfD6JzrbSPBR1ucjjSooY13ifO
	 KZh84uU4eHpE6ly9pnaRcUKdhOJwOIHWl4JlBqjCweE4oSbAc5EumqjYEGdjnpOhWcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514662;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=XLwvzlrUsD5o3ePpbK5ubMcqgWldw7icsY7i1tOGkEk=;
	b=dKWojtTGGFZOk1ttHHQ9LTvDpcLqJ2Hut5KYvNqqVabVWSqPuOjZFw/nT3ZG6HWSj5jv
	 mmG2rMylOorvgVQK5BRJIlZAhzZL+se2hzGn+Hz/49IZA0hKAw6HU5UQW7RuJdmsE0ibL
	 H71RymHRYEaAORXBIZ8HCUS/DqRXoJTV2zxEoqpsYnyyFI7uwFZvWlngTLZiC5pHQtqMi
	 bWpgrGggZUrnm6KmgFxL7AC+3FALYqbrV3KxrfJ7rwvz9NjjS5Jfl3zuVlkKozES9Uwf8
	 gFFta6aYpxbU9Zo1shAUJv/5O+3BzFkorgwJjbWfrrCzy4tUzEg39hszRf9M/RaHmKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=qr5s2evi;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB639606A319;
	Tue, 20 Oct 2026 16:44:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB639606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=qr5s2evi
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=XLwvzlrUsD5o3ePpbK5ubMcqgWldw7icsY7i1tOGkEk=; b=qr5s2evifiDaOVEQuWLwpmN5r5
	u6o672ilphM3wtXfhmwoVVfkCkZ9UqCwoEU5Ac6DcgbbbX2bKHDgT+tbblG3aD4ZZXT1CdjrYF15b
	EYUFKLR5dFN/R3n23qYVvh23KCpIMRzsSn873Z4oxiAudOb6zNcicqCgO3ZOmr1YHK8E=;
Received: from p54a4360c.dip0.t-ipconnect.de ([84.164.54.12] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xJCwf-007wTR-2P;
	Tue, 20 Oct 2026 18:44:13 +0200
Message-ID: <8e57a7f2-6495-4535-af99-9abf5bcaa1f9@nbd.name>
Date: Tue, 20 Oct 2026 18:44:13 +0200
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
References: <6e7358fe-4070-4a88-b8da-77e2f9e9bdf8@nbd.name>
 <20261020161545.9330-1-pcristian292@gmail.com>
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
In-Reply-To: <20261020161545.9330-1-pcristian292@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.10.26 18:15, Cristian Papa wrote:
> On 20.10.26 11:48, Felix Fietkau wrote:
>> On 14.10.26 08:22, Cristian Papa wrote:
>>> Discard late frames rather than retransmitting their old sequence and
>>> packet numbers after newer traffic or a wakeup BAR. This loses the late
>>> frame; it does not recover delivery. Use the station's sleep state, not
>>> the temporary hardware PS bypass used during U-APSD service periods.
>> Why did you decide to drop them instead of pushing them to immediate tx?
> 
> Hi Felix, thanks for looking at it.
> 
> Because the looped-back frame keeps the TXD it was first queued with.
> mt7603_mac_write_txwi() puts the 802.11 sequence number in the TXD with
> SN_VALID, and with a hardware key it also takes the PN from key->tx_pn at
> that point. mt7603_rx_loopback_skb() only rewrites Q_IDX, so a late frame
> pushed to immediate TX would go out with its original SN and PN.
> 
> On wakeup, mt7603_sta_ps() sends the psq ahead of the newer traffic, so
> the order holds there. A loopback that arrives after that drain is older
> than frames that may already have gone out with newer SN/PN. With CCMP the
> peer's replay check would drop it, in an aggregation session it can fall
> behind the window after the newer frames or the BAR, and on an open link
> it would arrive out of order. So I expected immediate TX to mostly spend
> airtime on a frame the peer discards.
> 
> I haven't measured how late these loopbacks arrive, though. One that
> arrives before the newer frames go out would still be delivered in order.
> If you'd rather push them to immediate TX, I can send a v2 that does that.
I'm not 100% sure which approach is the right one either way, I just 
wanted it considered.

Not rewriting SN and PN is intentional. If the frame with its SN was 
part of an active aggregation session, receiver side reordering should 
ensure that it arrives in the right order.

It all depends on whether the receiver has moved on and considers the 
frame lost, or if there is value in sending it to avoid the reorder 
timeout (which would cause some jitter). Either way, we should likely 
only allow immediate-tx if aggregation is enabled.

If you have some time, could you test, which variant works better?

Thanks,

- Felix
