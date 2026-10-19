Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED3C4E0B6C
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 11:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792408762; cv=none; b=L9yOUr1rT1oxN84uu0Br4880mCReXot+5Cb1hX5AbVEjxWESL3PcxEeq5PY2M3dEcKELxlZIkVhPv6s0pKGLV5wnVEi3dl7KYRDcw+uuFqvt9C2s7QuVZ4fxNv4n4jPzaSnNHsm7V2ooRt8mJq5L+hE8d10UPV6oMg7LRwA+PpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792408762; c=relaxed/simple;
	bh=0wYYm4Y2+8dNXMXPj10AzLPIs6v8UEuEBCpe4Zsa6Yw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uY9U2ctMf+SOSxn2Q8Oep6dtH0sFhBNa6vpAkQbeQSBeraFRtZw/ZfQqXff1btT91Vndcjqh75+0ZOsLuIPNXSuZGzefPr+ILlKmsrjQoz2FMeDUIIXSGHRF+jrY9Ap8X3zRYuT3Ub9muQutj0g2ErgpMeFLwFo0UAAOEKI5XOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dMHMdGgB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GLnjiXIg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dMHMdGgB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GLnjiXIg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792408759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0xSlFMVnKmDw/ldSbYNn+iTNtpWivGYYCAIoTzRKpx0=;
	b=dMHMdGgBBxbGlMAeX6m3G1fDVQOrXz0RZQ+CHzuJXKQF0OEYI/JBXN9c1UT12pyhCjIjWt
	pkKo2f7pSujB+UFGHTo57ZyA7kbrusrXKGPT7eK0K7VoBabz2wSTlputmHzL3dXTU9GqJt
	ZXo9IrWfD065VkAMANZabDp5iLrH1tU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-240-IozCD231NsCgePZuwzlnhw-1; Mon, 19 Oct 2026 11:19:18 +0000
X-MC-Unique: IozCD231NsCgePZuwzlnhw-1
X-Mimecast-MFC-AGG-ID: IozCD231NsCgePZuwzlnhw_1792408757
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48e17d30a79so481570f8f.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 04:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792408757; x=1793013557; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0xSlFMVnKmDw/ldSbYNn+iTNtpWivGYYCAIoTzRKpx0=;
        b=GLnjiXIgq9isTjwdqOZLsKhcpYeTMioOMxiB/4zjwopOq10x3RYgaYUG+cogE8DHl5
         0rHS5OuTo+2AGP0PP79aq7/EP6S0K3N4wkCrowT88822szlDgoFcvcW2E1YCgc9DqzG2
         NZ1N51yDL7wGaTn+jktKMs5wbY54aXEv1ZpRD4HlHcJV0Yg/r0AT1hKf2A5uDSsQ/tqg
         ODG0UuCbK/bZ8m5lcdc6lPSuHScZUZS1PQaOz16+nwVDEheu8zDm6qA6DNrwA2XSmU5v
         DsfL0mJY5tdNsPG2yL37I5moIDIWjrbwq+sJl90sWeaCHphFZo/AfxJ1mGkXOtSTpA47
         OPWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792408757; x=1793013557;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0xSlFMVnKmDw/ldSbYNn+iTNtpWivGYYCAIoTzRKpx0=;
        b=yY1eVtzzZZsjBOvcdVoT94f8j9JtPy8oqF3XBT7/GZes34mHaqYgquFFo31THfENT1
         PCCihdl4J0K83ltlH4h7pszy2/yEPy72T2gYjaiYnkn0clv/195WbqZDYofykzeib0nV
         7ScOCe8vXWrPWsnEIMu7aiL+g3mJ2Bk3to8al92GcgMBJ6caVjXeJ+f+1TMCInMf0V6r
         bnm8cukiYgiWyU/aovTd1F8XGNi/YG67WT3dejvqylcvaDOxyKXxR9NL4ItQ1NXVzkzd
         1tsFt7V+bqzgzfdGzwQQYi3c4R7i8rN+FV1OiwrpvcOfUkCaWEsy+9O40FYWftM5svoF
         9uvg==
X-Forwarded-Encrypted: i=1; AKwUvBxUYALBje3rxI2UI9m38sqUBAuwajlFrsN4r7fgmSV26/cLe1APUcp5PxBcIBIrhg2fhOZaneBk/jq9ru6SCg==@vger.kernel.org
X-Gm-Message-State: AFq9FYK6h0CL9jCkSmSgOAqNuuEaRSPGhpWQKPiLWi2yC+8hALZfrfAK
	Dom6ZmYLkqAmPFn2mOezNfJe2k/Y0EhZrS6/hWRL2XhNTY0nWoHVpQokh97uqD59MC6l3DiQhVR
	7Pqgjx0dSL6MZoLFlimBWoi6u3DdAN+4/5gMYvtL1Dq9tJBKicVEkOhLPOyohoSz+KsYS
X-Gm-Gg: AYBFou3qj1DPdSjncy8XAsd9GyTk1rbSrSXIhwX8YgT9VgkMXbkBdaAnCof07NuaYym
	hKgkDU+vw36sxKFDiPfOkrqm56d7XCrJu3UIm9buTlc5qUTSS8tEDPha9qxX0tBm1RLJzZZHfPb
	ivTnzPpSq7zANJZzphzlEMYOeeayAHT+zre4VeqjhtbsM8W1E8+QeHsC0XvB5Z1i8sLGO/q9C38
	ytd6v6k4WfVF42j9Keb7t5Bqg8OI/ytdLqA4/tDxSU/Hlvazbjb1VRLRqlV00By1lU9kG3Djzhx
	D58djQQtzdnzcV2yzcObaZNKjjNEDC4heHofQMFGQ6f0cBfU4EkeUbuJZ/AAruQkXlsD7qhxgAn
	qXk8J+cGfnKRS18QnnE6wBQUlEfT+MKkkllAYumk4Hsl494uhVZ2+sp1QAmjiFpmD22Wmc/1rzw
	==
X-Received: by 2002:a05:600c:8a97:b0:4a1:d061:1d3b with SMTP id 5b1f17b1804b1-4a1d75fe17cmr117125455e9.8.1792408756702;
        Mon, 19 Oct 2026 04:19:16 -0700 (PDT)
X-Received: by 2002:a05:600c:8a97:b0:4a1:d061:1d3b with SMTP id 5b1f17b1804b1-4a1d75fe17cmr117124855e9.8.1792408756224;
        Mon, 19 Oct 2026 04:19:16 -0700 (PDT)
Received: from [192.168.188.234] (ip232-47-231-195.pool-bba.aruba.it. [195.231.47.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1e3ebb3aasm193231875e9.0.2026.10.19.04.19.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 04:19:15 -0700 (PDT)
Message-ID: <8dcd9564-e9a3-4b00-93b8-3cb023d68047@redhat.com>
Date: Mon, 19 Oct 2026 13:19:13 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v11 3/6] net: add a generation counter for
 dev->mc changes
To: Yuyang Huang <sigefriedhyy@gmail.com>, netdev-bot+sashiko@kernel.org
Cc: ajay.kathat@microchip.com, aleksandr.loktionov@intel.com,
 andrew+netdev@lunn.ch, claudiu.beznea@tuxon.dev, davem@davemloft.net,
 dsahern@kernel.org, donald.hunter@gmail.com, edumazet@google.com,
 idosch@nvidia.com, jacob.e.keller@intel.com, kuba@kernel.org,
 johannes@sipsolutions.net, kees@kernel.org, kory.maincent@bootlin.com,
 kuniyu@google.com, nicolas.dichtel@6wind.com, nickgarlis@gmail.com,
 sd@queasysnail.net, shuah@kernel.org, horms@kernel.org,
 sdf.kernel@gmail.com, vadim.fedorenko@linux.dev, willemb@google.com,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20261012011707.3378-4-sigefriedhyy@gmail.com>
 <179185709988.434549.15422498299449004512@kernel.org>
 <CA+7S2v+LHUWXQMD-cYPEzT5-f3Qhw_vz+LEssQH_A_oqDKtnnA@mail.gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <CA+7S2v+LHUWXQMD-cYPEzT5-f3Qhw_vz+LEssQH_A_oqDKtnnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/13/26 12:25, Yuyang Huang wrote:
>> - [Low] The commit message misdescribes the precedent it copies.
> 
> Looks like a nit, will adjust it if need new revision.
> 
>> - [Low] The patch adds an 8-byte 'struct net_device *mc_dev' to every
>>    struct netdev_hw_addr_list (include/linux/netdevice.h:253), but only…
> 
> It seems to me this issue by itself doesn't deserve a revision. Will
> fix it if new revision is required.

I agree this is not a blocker, but I think it would be nice if you could
follow-up on this one.

The solution proposed by the LLM LGTM.

> 
>> - [Low] __hw_addr_changed() (net/core/dev_addr_lists.c:22-26) reads the
>>    device netns with plain dev_net(list->mc_dev).
> 
> This was raised on earlier versions. Every dev->mc writer already
> reads dev_net() under only the address lock, so this adds no new race.

Same here.

Also, still speaking of possible follow-up,  I think it would be nice if
you could change the addr list lifecycle to RCU (no idea of how much
complex would be that).

Thanks,

Paolo

