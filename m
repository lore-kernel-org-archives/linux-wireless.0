Received: from mail-yx1-f97.google.com (mail-yx1-f97.google.com [74.125.224.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7DC3C8731
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 08:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791275255; cv=none; b=llzN2QEZShTmiyj8uDkkcH+AlOUUvd+Uo5QNe6E5xbjTwtEpcIyh+U3ct/8+bYJ3mABYDdUINfR2ISwYRrGriidkMq5CflcOJEE3tHmjGtn5dZLJ3wY+v6TyTYxDeFXXKkRKQnsYIW3Na0DnuK4ECxvvk8c0zNDG5PHmBbJQGxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791275255; c=relaxed/simple;
	bh=AhTSB+hX8DW5/UqPj/kPlDv4TilOhsZezix19Q9Y0hU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cg1jJOvgihuhXFCqVMMtC7hvq9as7R2YsYANf5j6PBtcg6nxmbiGaN/ObViT8d4tIK/QKbpNM4xoXEdYfbwto/ua1uUCanMe0RIUc1gHnfQ7k2FFF77mn/noQJwglTDG42qzpbT0x1xcMcbthRwLUclI7I1o7t0oVUwwSBBQwY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=YWnPD1cK; arc=none smtp.client-ip=74.125.224.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YWnPD1cK"
Received: by mail-yx1-f97.google.com with SMTP id 956f58d0204a3-675676afc3cso442441d50.3
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 01:27:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791275252; x=1791880052;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=aO7ZMNOXH20rZFoB1a96CWPC5jLhbhIpE9Whu53E080=;
        b=0fRvxyVjeKi+MCUbXT8XbBwyiL9fdYcb4SrUC+3zBGn01MG5sd8qVx4MZKw0AaH9az
         rwPnBZ3BgtX1Sqh2wmfTi8pOLcIcF2fSfKYaCKMjntDThZ/i9J/PYAOCi+qzAUcpNOmz
         uSBqmbA+3OqF9/ztCEyUU7QvkuAiSHoGc9eiJOvehe8nw5z/npj2G58IqKdCVbMs2Cbg
         8V8vC5bmiOIkOPBb2tKIgOiJTi5ieCnWa4bWRE9TIrDXBppGSmcF4Fom5jF8EKDDTFVt
         KdAH5EXetxk6oyKumPrtfV1UmLgCo3Lw/79whlclNiKLbNKAPl57gyh3/F7NXTwX3rso
         lOyQ==
X-Gm-Message-State: AFq9FYKjJLKXnCdGXmKWdu0gWTTYw9YZA6GpG30ypnr0lESoK69up/kN
	RbRP6J8gyxS+b9F0CSfrsI67JNQrT+4+hA6eMW8KWiMbiR3DmFBZN9yB+1t4lscHBuZVnrrTyhH
	U9oiZZsv8hoVayvSkSzn9R8UjQxKStBWzPrgU4/PZ9TFcdgZk2Q9Gn6i54+kC/7t1gIY61O6Va3
	cnmuqDVmzNRAQkadIMHho0GWgsWETMHim09UZ1tfNtwLdSf9fXoAZ1xeV1HVbiEDo+Vcw3rbTc5
	wtc3YPY64UnlaTTJBzc9jF/nnFT
X-Gm-Gg: AYBFou0h+1HGLqju3lOpf4KIWqvBvzrxSktP7WW0zVeP7vBKMlflv6An734G9FD/4vU
	z/aHGunSgbLThZw8JQsNjyvCJnHU7ygNBpM0hGjdrLvohCbVU0TJM+d8Jd/pMgmNI2Dz+KjEEW7
	COZu7dBj6nIibKwL937zBruDv5fAjdy8lWGOCbKxccQ7iT90HC6GQzq2SIo7wSfFt4L3eO2N4K9
	Ydgd1a1foIf9s2m0/RyboG1X7rQpWpAX/MLgS9GjSu6QoQfmob9bIuoMIPfi9nR7Qw1DBRCnFoV
	rCFyTauBDoVAcXI/IAzyIYGPL85A8aO1HmmQgYC7NDm1NvYUGg+E/+3DJZ56+EsJcKkLLMscmFY
	PwGaHZAx+PeXD8GMLaNEOeodKBqjIYyiCNK4DN7ZDXQnK9XeblFa37kIx+Zy7onvbHyXQjCaQGg
	ub2886vi7D1YMd7KT/Rr+zLuX1zydlhsANdu73TEjvtw==
X-Received: by 2002:a05:690e:1486:b0:677:cb45:a45e with SMTP id 956f58d0204a3-678fcc4fab6mr299045d50.6.1791275252565;
        Tue, 06 Oct 2026 01:27:32 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-677c1ae9878sm1655338d50.7.2026.10.06.01.27.31
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 01:27:32 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3510562ef98so3410754eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 01:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791275250; x=1791880050; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aO7ZMNOXH20rZFoB1a96CWPC5jLhbhIpE9Whu53E080=;
        b=YWnPD1cKKv+BA9qxVUDRvhJ12vc39zoc3nN2jC2KGqTtbX3crNdvFDVFXuJuHyaZ+O
         CQtpD0ZDauOFIfP/CwEKHoxGLdMEgvN7n7qi6SZ3n+lMTIkHjF0vgiREXyPi320/R+OH
         xiuqZ/rh8pyH1DGqoQapZvMzn2kBEix92aqlE=
X-Received: by 2002:a05:7022:288:b0:143:4d12:396d with SMTP id a92af1059eb24-15ec7b02b1dmr978951c88.26.1791275250361;
        Tue, 06 Oct 2026 01:27:30 -0700 (PDT)
X-Received: by 2002:a05:7022:288:b0:143:4d12:396d with SMTP id a92af1059eb24-15ec7b02b1dmr978913c88.26.1791275249521;
        Tue, 06 Oct 2026 01:27:29 -0700 (PDT)
Received: from [10.176.3.41] ([192.19.176.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-15d83d6af11sm5335442c88.10.2026.10.06.01.27.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2026 01:27:28 -0700 (PDT)
Message-ID: <802a092a-314a-4f77-aa1d-134b3d020069@broadcom.com>
Date: Tue, 6 Oct 2026 10:27:27 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: brcmfmac: avoid sleeping tx locks in netpoll
 context
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: linux-wireless@vger.kernel.org,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, stable@vger.kernel.org
References: <20260930185417.61865-1-kmehltretter@gmail.com>
 <20261004122910.1392318-1-arend.vanspriel@broadcom.com>
 <asR1TaKQJlPFqEvR@gmail.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <asR1TaKQJlPFqEvR@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 06/10/2026 06:18, Karl Mehltretter wrote:
> On Sun, Oct 04, 2026 at 05:29:10AM +0100, Arend van Spriel wrote:
>> Is there an opportunity to reuse/refactor brcmf_sdio_prec_enq() rather than
>> adding a separate brcmf_sdio_prec_enq_irqoff() helper? For example, passing
>> a can_evict parameter:
>>
> 
> Thanks for the review!
> 
> Sharing the helper with a can_evict argument is cleaner.
> 
> One queue user does not hold txq_lock: brcmf_fws_bus_txq_cleanup()
> dequeues through brcmu_pktq_pdeq_match().
> 
> Lockdep instrumentation in fcmode=1 and 2 confirmed that cleanup enters
> without txq_lock.

This is an observation unrelated to the patch, right? You mentioned in 
the patch it only covers fcmode=0, right?

> I combined the helpers, but kept brcmu_pktq_penq() for normal calls.
Sure.

Regards,
Arend
