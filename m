Received: from mail-wr2-f18.google.com (mail-wr2-f18.google.com [74.125.225.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8574BE434
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 13:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.82
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773493; cv=none; b=BMDoh9SKrXQCRbP6jsVjLhyVZYHR7ytox+RDe1Um9NUKMiVDjvGx/XHU5WiWCyc8MqER5AziAkd8SbXBBetgFfHBhE9Kf6XIdZdx5cw0QWCT76D9k7JsP28QeKd9nr2KAy3gBJL9XMD9ydKw1EBypsnbsF1WimYq4eEjM+xXTmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773493; c=relaxed/simple;
	bh=oxZiTuR2Id+eSkbVoP8hkGx6rui7jsikVu42ZGlSRFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h/iEQz7vHVGj/4d6mqSvw3JK85pAzKR3dwfrIc/JcefLceGh3A+NVVGKlPgatjRITK4xR7DQMw/9883+UFFx6BosIBGKcJpSsHmrdmAwgV5loRlLxHrzOgCMS5vyh2q9gCj0rWLqdLseVFmf+Je2ED0YzunCo7Htc0mQ64Gn/44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com; spf=pass smtp.mailfrom=6wind.com; dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b=AwFW2UVF; arc=none smtp.client-ip=74.125.225.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=6wind.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="AwFW2UVF"
Received: by mail-wr2-f18.google.com with SMTP id ffacd0b85a97d-48435ae9ca4so599085f8f.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 06:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1790773482; x=1791378282; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:from:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cdMdvjWVLIDEVS1UUHPgTOR23ut4C2R+qU5zRynN6ZE=;
        b=AwFW2UVFDut0KXcQby5r755V4y+wkBed/xWk8s+Cmq1sIBMuJ88qlBDia90lktIt4m
         Cb5Lno14zl2pcc9//aY1+Q0sBoBrXTOIlSG/qVHo6NUyzR604zuemIJz8XjrqogvmHLf
         zV/gcQdpRTiGj6BnfzdWIps4wFphkDBQzMAL5aVAOsfuDJYGx8P4/cwypOsL2oY3vAL2
         qTkPcibOojxkncb0cSphmUSFLyeFAfarGwUcQnN0z3vcUsh3ntILlgS5bzQFBszq6ZLp
         3dJsCbggGUzDgqAkJ2PM8NIdt09mexIQuCzPGg9CJALW5QrvP5ypLuw18MWczKxiAM96
         PdIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790773482; x=1791378282;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:from:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cdMdvjWVLIDEVS1UUHPgTOR23ut4C2R+qU5zRynN6ZE=;
        b=EYI/20AQi0iiq4gEclmXmAjnS8zIuejI1uHlM+otglZqFUCRF/oyh4RA0Ogu6UBsF5
         yTeGoYMJyQtGpj8H7KvxJgGvtm2pww6UYofDAwkgVEvrQnSHKGj17xgf3M1+r9vZglWN
         +VAGuvkaP9gDSBmFXzxmwHCb4Tl6Rl8tQzuu4QIYdo4X+c2+Be0t/x92rX/6ZWkaM0Bj
         Byi4hw3RwiLV4385E6EPNqsBXffnVhYdhw7BH//Xt2vMf5uxoWtU74hG+0UBjzzgl9aA
         MMYEhbbToZFVYUSjMQVbic0jIkpPQ4hchBG/85OTmtD/7ZVksNSqKqJ6ILum+VkzQjUC
         AGvA==
X-Forwarded-Encrypted: i=1; AKwUvBzV394LfgmGVqGcCyKLWYK16rCeT0DGDz3lfLmncxbchltBomQJaEH6LBh1rugR+YzSKQmWlnZ5lvM59zpo/A==@vger.kernel.org
X-Gm-Message-State: AFq9FYKBGecQIhXs4I+21tKU2anrqbWTPrQiwpi8hxdJ8RM+Vl6LbRI0
	jT7ONNRkvVB+vKB6rZeL7z4YMxOnV5p3Fj77ttFOdwrjWP15DSCwuShvhXz30B0zWfE=
X-Gm-Gg: AYBFou318YoAqzL27jTlMv4RuyBv/3iw3Sc1qN4pHJBouM3mjkoMp4/tVy/Bl8vT7Zk
	SNeNDCnYU2GCtqJBzwEpnwHDizkQYz9nLfF84theigPdejPQVuvNHDEuAkO+/727Ygs7XRFJM8/
	Wd3RVXWuYRScDnv7nCkLG9P1arkgM9WCW3ldNW4XBOcdc2HDO18kLBAZe03miaO3KH6/RFvrI4K
	ardwQI/m5s2coJeQryZGU5DLNgW1X2xKkrmzV5Q0FoOuI+Nnw0v5xL10uU8KjWGLG+NUnwpzkSc
	+xSZXUt9KP8e3xw0brJjNv7eGFFLUpsAWKnMvmt8zyFm2oSSabg617JpYc29dBGrISxTTw8JTOI
	j0I/P24a4RjPWJqpbpcZU2JbEOR5X1go1QX4pSFF4SU83AVcsqlffPTtn/Q21bLCnptveZ2YoWg
	tt92FdHM1iP6BZ0SPYZMGOMkB8R3wPOWmsX9HntSC+TjuySiTf3AIIeeSEB3zg8lwULlNszRidP
	hQS9xR6MU8GIs/3qm+phNRPwZFWP9MPG7F4PRMhjfUhAlllVKw=
X-Received: by 2002:a5d:5d85:0:b0:487:8ba:8b4c with SMTP id ffacd0b85a97d-48b024297b0mr3902212f8f.1.1790773482052;
        Wed, 30 Sep 2026 06:04:42 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:ab7:2110:6a1d:efff:fe52:1959? ([2a01:e0a:ab7:2110:6a1d:efff:fe52:1959])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b029be7cesm3805401f8f.8.2026.09.30.06.04.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 06:04:41 -0700 (PDT)
Message-ID: <3019f327-1ea1-42f6-b133-597ca1cc524a@6wind.com>
Date: Wed, 30 Sep 2026 15:04:40 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v9 3/6] net: add a generation counter for dev->mc
 changes
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
References: <20260930112842.21323-1-sigefriedhyy@gmail.com>
 <20260930112842.21323-4-sigefriedhyy@gmail.com>
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Content-Language: en-US
Organization: 6WIND
In-Reply-To: <20260930112842.21323-4-sigefriedhyy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Le 30/09/2026 à 13:28, Yuyang Huang a écrit :
> A multi-part RTM_GETMULTICAST dump of dev->mc resumes by position, so
> entries added or removed between two dump rounds can be skipped or
> repeated. The IPv4 and IPv6 dumps report that with NLM_F_DUMP_INTR by
> stamping cb->seq from a per netns generation counter combined with
> dev_base_seq, see inet_base_seq().
> 
> Add the equivalent for the device multicast lists: a per netns counter
> bumped whenever an entry is added to or removed from any dev->mc. The
> list helpers do not know which device a list belongs to, so give
> netdev_hw_addr_list an owner, set for the lists of a device and NULL
> for snapshots and other standalone lists, and bump the counter of
> dev_net(owner) from the count helpers when the list is dev->mc. That
> covers the dev_mc_* helpers, both lists of a sync, the hardware sync
> helpers drivers call from their rx mode callbacks or their own workers
> and the reconciliation after an asynchronous rx mode update. It is
> atomic since the writers only hold the address lock of their own
> device.
> 
> Used by the following patch for the AF_PACKET multicast dump.
> 
> Signed-off-by: Yuyang Huang <sigefriedhyy@gmail.com>

Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
