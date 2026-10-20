Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792480313;
	b=3aNof1iM2ohWcnvwI5v4JBm531EbgMUH6N/fwMNhVSVkGpiCwIMOPTRZ+lxH4/ucwK67
	 v2hUgMAW62MdERX0ki58Qof2WEUobiM9yWfGFAf8M1oKVHJUjgiW+C3Ta4FEiqM52zqcE
	 x7UEnUD0u2x2+KyPx6gSOHMAdJT3aLO+qYZUZ/uvJSSoZ0pXWK2BOoHVu6DypE87IugcX
	 k0v7NcRMb5fmng2xweJQzk9Lr+v0eLMO8pgqHpzqnNzkdnS4UYGnMtGlW7Q4sky95iRJD
	 4LkPq5hYDCGzN4bsPRKIvtM5Xbcgd9MHZvJXacSA2EXbXnP4lgyPnioQ/y+Z42vNycQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792480313;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=M2ZWtK3jwBgT6W5EC/9V6YJ1MiOaCmKaMmxzxQcJy6w=;
	b=wiyEir1Y2C/jd6Zcz8Sa7mmgydysGpZMeWLc+03sJYufBSLXgL/XHDcg+Gr0Tw2/JCLY
	 7g3FfdozpEBZDJs7ORyHFf6xilR2MyONR6S5gMDkgbtsmpFN7WJudrZtjtmeY+/5rTmpK
	 JuV9weCv2vMtfZk2jquwkss1YF2TjsgWA1Sx90cSHGcOoroCUzLLwJibiFuKI80S4wGQI
	 hM8uCM9ciUHcOsKNy5Uv1Z2FAQVjKJO0wj3qo4X/+kzykdySE4f/zY3L8JTjvyusamE0T
	 MsAPng/CrWRKZcnjNoQkFv/SJRPFyjrjK5VsljsVqnM1nbWnDd9yMdKc85vpr5o09tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZMFIILis;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=BHbNTFKs;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2543F606A31F
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 07:11:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2543F606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZMFIILis;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=BHbNTFKs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792480312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M2ZWtK3jwBgT6W5EC/9V6YJ1MiOaCmKaMmxzxQcJy6w=;
	b=ZMFIILisXxbHfX2gh0Cx0tZnNu+4yWZyoIdR/OWYF9sz/IhKXWmxLIvJpQItwoI/kvwz9E
	nqqehDinx0+/24g2W0VrNuDq4zWAIPNbSAFzQoZHofzuVXgNU4MnJuTJhSe1pNw27tnoSr
	IcONupeAb8JRsqpkwhToVn2CHh+ZF04=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-DopvdZqsMeSL5E5WKxkCJg-1; Tue, 20 Oct 2026 07:11:50 +0000
X-MC-Unique: DopvdZqsMeSL5E5WKxkCJg-1
X-Mimecast-MFC-AGG-ID: DopvdZqsMeSL5E5WKxkCJg_1792480309
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a1d7663a4dso27333515e9.2
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 00:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792480309; x=1793085109; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M2ZWtK3jwBgT6W5EC/9V6YJ1MiOaCmKaMmxzxQcJy6w=;
        b=BHbNTFKsh42I6HOzczviJo9Wq3FzNsVcB1QyFFsfEfuVJM3l0YyLx30ipFFUq0pYcP
         oViRx5rnMxEax7dNqJFLzpC1XkRmEIvJ0Zbef5ha9gRUHUchI6WlzHyXf8uqUlsIzjGG
         emQeGqVwfVuhLiD8NJMbrdst0RGwca9Jcd6GFUCEhzZVOGNoPSQR6sd0t/uDM8IVzIOi
         gBticp6Yc8zrk5ykaKcFSC8aY9YKX91uWE/SsayZiwbuouT+AtD95PUfCj7fBkRXIOeK
         b606ggHgtnVMAD4IZNmJRRll9gfqGUuZ0sFLvN9vTizxTOlBR7TNcy8yiRqPAH4DRzDr
         0dUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792480309; x=1793085109;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M2ZWtK3jwBgT6W5EC/9V6YJ1MiOaCmKaMmxzxQcJy6w=;
        b=WmvrJBRLSo6uLtWcyZKq2Aoe9ct3UBQwPd8eQvT/ftx9o2ZUKHfhCJku7p4B+Gd6tf
         KjEoCtLHJOZRM8mM/bx1lBVbbvUIEDqsei9IhueMINTSC2lRexUytvqnF/yoPDaI6qpy
         QJUrSghaDLFaASKcZLTyOTh8mHXDnUJEagrq4CtDhiKfcaWv3Um1A7D+YGQvJ4QCDztl
         cla0O/iaMoWtIX4AcDGdgTFm6/I6CiqywOIFZqUP3w5DtEQAa8WuF/K1yrsdhWDtecoX
         DviBYjW0vdw97rdYN99WnbVsFSrgip3P8CXujc2U/fcOu5Ke3EU1xU1bUzIJtd7pTITF
         o7Og==
X-Forwarded-Encrypted: i=1; AKwUvBzDdXlZMp1mEUctA8nwgGarbwzXyFkVQqq8ndBsfzWlVAr57KQtrcf5eEKWc3Z8e3EvmM/JyIJjzoT8/Ho5DA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJz3dmU6rF++c7fc31Wr9y6shdHCNPY6UpiXZTK0K0YFE38Y9QX
	Ae4ELxRMehVo2q9WqM/cDlp6pQTgCjsK2XLTZXfpRyFNwVbqOMgfvtnduJw6NtuXfgTDpaOAt/l
	M4qFwBAN5fcGuKR5E196+GT/0c2foMSmdEVINgDDdeKOwc/evPwmZmJdNlxcXG5GkRPnh
X-Gm-Gg: AYBFou1n7qLxCrgyz73uoX7IoiZ6hv79M1JBSmiZW52GyWesPoKn+D0THdifBU0+M9o
	RUFwXOlj7JbAsY9uVGGvIpXPY+8kB+Jt+hp/JafejuDesGIYzHrsRwed2P18aceK4oYSTB9pls0
	arEV09CV2R6HUSU69h8pkDl0DEeZElFtOkSBJVSTSqC3WdWlyzUd3ufACt0tF0Ld7tnLrCzln7z
	XXNLb4gEF1M6zlWM3ZbfzTWCGVv2rl5r8axN39A0Qttl63syRuzRxo9WeY8ViT6c7xKLObtF9i7
	02NR5IAlOx4bZS1AjYI7evQESvhrJ/roEvY7HDYjOI0FIra+QvYAynJRbmt/STnlN6eNVYr5pfV
	wRRdqppbWiYbetbDohXLWbgacO/Zko9gxz/ovl/RA8M0alI61it6FWBiT/XuGB+jWkyZFE0N+ig
	==
X-Received: by 2002:a05:600c:3e05:b0:4a1:71ab:63ba with SMTP id 5b1f17b1804b1-4a1d763625emr205330615e9.29.1792480307728;
        Tue, 20 Oct 2026 00:11:47 -0700 (PDT)
X-Received: by 2002:a05:600c:3e05:b0:4a1:71ab:63ba with SMTP id 5b1f17b1804b1-4a1d763625emr205329845e9.29.1792480307327;
        Tue, 20 Oct 2026 00:11:47 -0700 (PDT)
Received: from [192.168.188.234] (ip232-47-231-195.pool-bba.aruba.it. [195.231.47.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1dc952d63sm331515125e9.2.2026.10.20.00.11.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 00:11:46 -0700 (PDT)
Message-ID: <976d815d-a9ec-4fa0-9b16-8e55695706c2@redhat.com>
Date: Tue, 20 Oct 2026 09:11:45 +0200
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
Subject: Re: [PATCH net-next v11 3/6] net: add a generation counter for
 dev->mc changes
To: Yuyang Huang <sigefriedhyy@gmail.com>
Cc: netdev-bot+sashiko@kernel.org, ajay.kathat@microchip.com,
 aleksandr.loktionov@intel.com, andrew+netdev@lunn.ch,
 claudiu.beznea@tuxon.dev, davem@davemloft.net, dsahern@kernel.org,
 donald.hunter@gmail.com, edumazet@google.com, idosch@nvidia.com,
 jacob.e.keller@intel.com, kuba@kernel.org, johannes@sipsolutions.net,
 kees@kernel.org, kory.maincent@bootlin.com, kuniyu@google.com,
 nicolas.dichtel@6wind.com, nickgarlis@gmail.com, sd@queasysnail.net,
 shuah@kernel.org, horms@kernel.org, sdf.kernel@gmail.com,
 vadim.fedorenko@linux.dev, willemb@google.com, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org
References: <20261012011707.3378-4-sigefriedhyy@gmail.com>
 <179185709988.434549.15422498299449004512@kernel.org>
 <CA+7S2v+LHUWXQMD-cYPEzT5-f3Qhw_vz+LEssQH_A_oqDKtnnA@mail.gmail.com>
 <8dcd9564-e9a3-4b00-93b8-3cb023d68047@redhat.com>
 <CA+7S2v+rWYvz9xKPEeM6=3HPz3o7TbX2uRfRKk95f9Y60HnEiA@mail.gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <CA+7S2v+rWYvz9xKPEeM6=3HPz3o7TbX2uRfRKk95f9Y60HnEiA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/19/26 13:35, Yuyang Huang wrote:
> On Mon, Oct 19, 2026 at 8:19 PM Paolo Abeni <pabeni@redhat.com> wrote:
>>
>> I agree this is not a blocker, but I think it would be nice if you could
>> follow-up on this one.
>>
>> The solution proposed by the LLM LGTM.
>>
>> Same here.
>>
>> Also, still speaking of possible follow-up,  I think it would be nice if
>> you could change the addr list lifecycle to RCU (no idea of how much
>> complex would be that).
>>
> 
> Thanks for the review. Since we're already at v12 I'd rather not respin
> just for these, but I agree both are worth fixing, so I'll handle them as
> follow ups.
> 
> The first one is a simple fix, so if v13 ends up being needed
> for other reasons I'll fold it in there, otherwise I'll send it as a
> separate patch.
> 
> The RCU conversion needs more thought and will probably
> cause quite a bit of churn, so I'll try it if there's a v13, and if it
> gets too messy. I'll post it separately later.
To clarify: every I mentioned in my previous email was about possible
follow-ups - not to be included here.

My understanding is that there is sort of a pending/implicit question
from Jakub on v9: why are you doing this? is does it solve some
specific scaling problem or is 'nl is nicer" thing?

/P

