Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BB13D6673
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 09:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791539459; cv=none; b=ASwdCBTKMkvlEt6abTMaQgw+xKFw1PzIXc+2iJ/b5CdmqQazUOdIrENPPigqtdHb+ens4ulM9LYCesXj9X5jq4kJXYf8YlIN83ojNcLHMzHiKgo4qB8IHbF4bT/8yfgYB0XKetS0yOzXNpv7a4d9laucRuUzwZqENwq8yc3+Juc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791539459; c=relaxed/simple;
	bh=Yz6wuPAWR3FnxaZD/Hsy6uS1+1e7lH+YUjWeAZdItXM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XMMsfBbyopu5cU367D4iRTTabhCMdouGiZZwkHJAMiUk52bZNCYqPoJ9o0YHrFxjnrx7USaCPHLcGSQDd2AS/4OKXgacrzKb5iAqQhT3r7ZgF517FybsK0tTL+Xo3X6EUXvh1mV0yyeLCyrf9znWVYvxEv7ZYCA49+x1E+DYz/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com; spf=pass smtp.mailfrom=6wind.com; dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b=HJOGT9n/; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=6wind.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="HJOGT9n/"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49d04e4a943so1775835e9.2
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 02:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1791539455; x=1792144255; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:from:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mkuIOGDPXPuT/7Tp+eZvAIWGyivfRf31PISNCWLWipU=;
        b=HJOGT9n/exi7W6Ub/a7/97Ih7XhdRTGSAzdhav22oypY2OoixR7XQGTM58UD6zaq4+
         QrUneJt1T2XlDLlvNl4oMavkpIkcdQBK4atg47nGl1y5xl17xKxJUf0ITs6t8AP2YODh
         9emns+a+2aRnOQgamI4y/qh001sX0OMmtGYuokvfFh+ZHPY/122jQo6Qnh0BL2h8WFOb
         D5a9OX/de3ZP6u0nd0ZLF0H9dOCTQQQtGMc/D5mfVBUhi6R2onzjhKHQIokNHEcoZkTO
         69neR0pTzLXIXqNWuSKgX4vkeRCeUJb7zkLvZkMOR8eIbqhlM4D9qoWYonx36r8d3VSe
         B0TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791539455; x=1792144255;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:from:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mkuIOGDPXPuT/7Tp+eZvAIWGyivfRf31PISNCWLWipU=;
        b=TfSEoTiALGh0ko0BHgy0PO+81O7SBzEzK8Q9dAm3jGHApeKYSrJ9qbaDXPl+vdqyiu
         WW7ur9z0jXDorLMWfJ/1vFciafpwM7z83iwXIReTOkKBKeupfBpWPMQ1IpZxXkyR/lnY
         iRtizQNeiTlVJ1AEQXJ1vMpKqP+BuwJSaOKnceuIJCefg7sZM6pksaZ4LkNjvm/1YH5i
         WqEygRbDWgBPk6Ilz++YGI98BFWv4bfakFAmTlsQAqv7f178g1zIFFqtrvdEDsNsCsnN
         n+7C2N7luqEXPpC9byZJa2Z2Hs/pv3OZ8vs5r8jRds9R67/c4R11rM3oj2AdciFEs42Z
         Gcmw==
X-Forwarded-Encrypted: i=1; AKwUvBxAB8mA14Vd75LvpohxL+2FePOKC0/ymGP4XtJZnSzt7gTACwr+rgnLqre97T1rb6HWQ1QIRkfAqJOmOPBcgA==@vger.kernel.org
X-Gm-Message-State: AFuF++nOLYOOdfbdMfU0FMo5wEpw5etEfoPK3qgLQ7nK+tvwPCEcP6Cl
	yASh/kRIatmrBLYXY/yyKnHOpMrnEAbnPVn1lHw7AsCzDOjNkIK7Wb0lNoBtWtnrsUw=
X-Gm-Gg: AYBFou0Pe5BUD5HBcpGA+QvV/GRb9L6B2BdhpsJlwXFsxx6pgyRHr58HjEINjw8iWH0
	nrYR8rLrGeS0450BTbEqwOk7ochnrMD0K2bfNiZqMkYeKtpMpFrsUKxeVenoAQ54aP5gNj21Q4O
	7CRk2RT1oclSc/06Ntss4D6EX5YUzxu8n3ptfQrMyYedIztAy2XrsbeMDXBVAC1fDvZq/9sn75v
	tdO9VkZeneFsZ1V8QG6YNIcQ86KIOWhpfjvdwRUymVcxnKHbihw6gVHo4ecIxwrXWE95SCEDhRq
	ogqW+KTeSfxaK41ZMzhzZpKxqBPNfl7yHH5KSjkX3gUEEVfNMkUUNV34TqPMHlHTBOrubU9ebc4
	y2Ui0Sq4xQHMoQ4BmoxEWAPjAtsT5qIuo1ymjSZBKaS1xwhXaVPr7+Kbx4GuW+yxStnB3BUoGbe
	v5ANdHst7o63aepuphI4lsrha7b8nwFd0WtgZbK1mr0HvFG8Ku+YN8ab0z7Jyu+nUUMfop/ZfIB
	dclydJxMQlv60Pg0CDUtCgVXTFxOBTaFIHgWFBFIano9E4xR/4=
X-Received: by 2002:a05:600c:4e45:b0:4a0:13d8:cd0c with SMTP id 5b1f17b1804b1-4a18e47e330mr25254745e9.2.1791539455518;
        Fri, 09 Oct 2026 02:50:55 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:ab7:2110:6a1d:efff:fe52:1959? ([2a01:e0a:ab7:2110:6a1d:efff:fe52:1959])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bea1021sm44280795e9.10.2026.10.09.02.50.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 02:50:55 -0700 (PDT)
Message-ID: <5d0a21f2-0a7c-4c66-a3c8-e4290dfc0e13@6wind.com>
Date: Fri, 9 Oct 2026 11:50:54 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v10 3/6] net: add a generation counter for
 dev->mc changes
To: Yuyang Huang <sigefriedhyy@gmail.com>
Cc: Ajay Singh <ajay.kathat@microchip.com>,
 Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>,
 Claudiu Beznea <claudiu.beznea@tuxon.dev>,
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Donald Hunter <donald.hunter@gmail.com>, Eric Dumazet <edumazet@google.com>,
 Ido Schimmel <idosch@nvidia.com>, Jacob Keller <jacob.e.keller@intel.com>,
 Jakub Kicinski <kuba@kernel.org>, Johannes Berg <johannes@sipsolutions.net>,
 Kees Cook <kees@kernel.org>, Kory Maincent <kory.maincent@bootlin.com>,
 Kuniyuki Iwashima <kuniyu@google.com>,
 Nikolaos Gkarlis <nickgarlis@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
 Sabrina Dubroca <sd@queasysnail.net>, Shuah Khan <shuah@kernel.org>,
 Simon Horman <horms@kernel.org>, Stanislav Fomichev <sdf.kernel@gmail.com>,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>,
 Willem de Bruijn <willemb@google.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org
References: <20261007115821.11332-1-sigefriedhyy@gmail.com>
 <20261007115821.11332-4-sigefriedhyy@gmail.com>
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Content-Language: en-US
Organization: 6WIND
In-Reply-To: <20261007115821.11332-4-sigefriedhyy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Le 07/10/2026 à 13:58, Yuyang Huang a écrit :
> A multi-part RTM_GETMULTICAST dump of dev->mc resumes by position, so
> entries added or removed between two dump rounds can be skipped or
> repeated. The IPv4 and IPv6 dumps report that with NLM_F_DUMP_INTR by
> stamping cb->seq from a per netns generation counter combined with
> dev_base_seq, see inet_base_seq().
> 
> Add the equivalent for the device multicast lists: a per netns counter
> bumped whenever an entry is added to or removed from any dev->mc. The
> list helpers do not know which device a list belongs to, so give
> netdev_hw_addr_list an mc_dev pointer, set for dev->mc only, and bump
> the counter of dev_net(mc_dev) from the count helpers. That covers the
> dev_mc_* helpers, both lists of a sync, the hardware sync helpers
> drivers call from their rx mode callbacks or their own workers and the
> reconciliation after an asynchronous rx mode update. It is atomic
> since the writers only hold the address lock of their own device.
> 
> Used by the following patch for the AF_PACKET multicast dump.
> 
> Signed-off-by: Yuyang Huang <sigefriedhyy@gmail.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
