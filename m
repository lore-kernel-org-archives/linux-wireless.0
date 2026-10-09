Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A371942C508
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 09:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791539857; cv=none; b=WVgP7X5l7d6GjxLuHGZCwGrqBhqcZTgk15fcsnOG0RXQd8e63xh79YHGYXa40W9ZjM4Ycy+HEutC8eddcXpNubJGoLlELR89B/npjpQruijgqKT/HbRA2MQwF9EElbD1bvonyaXDrjGx5tWBEPVMbPo+znqYzcAcESZV1oNVAxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791539857; c=relaxed/simple;
	bh=CZUowsiS7R3v4ktfIQO8p3SnSSmC+DnEiusOSgtwtAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CvBjoqMVZn3vbDt/I+Q7VSVVtbEixGMFYDgy9e+yZOEO7yktiOGtz7kDigK+QS/TPlQ7FdTqwjfxg64JB4/FgGT2yXTXDhifTQREccn2IOUvZLVRRRNMsudKLD0c6TuB75uQ/gBsvUtluCGgsJhvZTKiNgCdtKDVcS0yn+d8ug8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com; spf=pass smtp.mailfrom=6wind.com; dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b=O/ll95+S; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=6wind.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="O/ll95+S"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a16bc7ac85so1051365e9.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 02:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1791539855; x=1792144655; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:from:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jGNJK6cAv9yzUM3Gu9HFHfD/WcVYclzAOKq5nlTYmA8=;
        b=O/ll95+SfflFZAIxpt/1tMgMelVC8gKxMphm/OQMShzMCK/QlBOtkM9GypG6vl4/de
         aTlDNODTEaycVihPeb83cssSrY7kmUEOEBX8Lj/0HLi15lHQdI4xh2TEvkTDZrjDIwNM
         0QwkIWwTQ1HBHQ9Bq36dKeo0vjsVXdspFGgAViLguI46cJgtkll/KOtD4caWJqc1iaSJ
         8TEb66NC3V3lRwCUZolx3h9gS59mdTB3FEcoYLMt6z/TBJcM3cO2nQ9dYdNabCmRt0iF
         fRHjKouERBck5yp1MopHm3Y6RZRBuOwl/Eg+gARn3zZNjkNr7xfwWleC5eimTd3jkVM2
         Y/oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791539855; x=1792144655;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:from:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jGNJK6cAv9yzUM3Gu9HFHfD/WcVYclzAOKq5nlTYmA8=;
        b=CI9vjXaBL1X2rCCDILw1O5eyimX+zIefzBi48YPGvu2+KFwH4WizLM2XW25A+zQDlQ
         VB3BPg8a2o5NZOVhQHI8sEk2ccAbgCy7qDL0jZXVo8mOu6mHPFVeE2vhTdq7O3Ynbtuu
         C0DDHsHW/gIvzdDw/ylGRxZ/eKDLfr9ePKPbxSbPhq/VkzUqYsP2BCR0gStIaK4TM26L
         aam4FfgDjykj0zMFWE+on+9dKoq6mvOejNsWkLnYs5/GqAYI9ZgT90CZzJKQ3WbfWIId
         BVoumKoOjrYlncUn+iRWX8CqMMaz7HSaMOMRBSBczp143HvEM9dev1wJ22N3kOD2PLZa
         8D2Q==
X-Forwarded-Encrypted: i=1; AKwUvBye8R2MBPcKYq2l+o6PZHkG5iw0mCdQwZveHWkHN82WpH3sE/HCnGMfpdybhyMKMAUAkoc7NzjOH54N94w0VA==@vger.kernel.org
X-Gm-Message-State: AFuF++kTNVJkYQCU4oiHZWbxU3D93mV0t6Uvr7TDhqTdepJGp+LOe6sc
	T/mG14Cmt/irNUduilpcHCgLb26Kk4KcXHhJsvfnxq5Tt9M7Ooh0Q9wKchyLCOvbAXE=
X-Gm-Gg: AYBFou1BhWjrAn8z8/LO0Il5qv/26t9yE0nNTtojgvZ2v82qB0XAovs1TAsC7O8jh2A
	YLrFZvyRmd0/uFVq2h/3r6xGt2oNsjW95o57MmRgiPX/V7rLPUVkHQLwkdRYKjCKtzS3eQA14mn
	V766eRy+FHVF4F7PnQwmFXg99a/n9oQvRbfurrFTbTZbpxGiwttgk8p4MkBV4WkhsaO016rmbLl
	qom1Ll5YQYCqzY315HICZWiUM+9GGqErsw3/w/61uL53742n1C3BtOjA4MvpJj4UCmxYTq7mikM
	CfFrKepHbtq2w6MHVdfGXdwE8x6D2xCug1re6aHbQuO+UstM1xEeBhxSiTKVQI+IMqCKn9le0E6
	DWSVwWwdg+4Ni7MApAOoS7vFAfvt6K4LssONSZt2qfJmvX+NQm0jf/XiZaO6wcxxsykRHTPZuhI
	QwUqj1SqNf1wI5xgnh5yhaXDNxQhgB8XTn7h5gXA9sW6aXDtWRhGZqsLiXKGNCaUh3/au/Kvxsr
	UC57NhzxSH4W7hGmAWNMKu703q0NdN5B39lB8W2WVH1BhwVrDg=
X-Received: by 2002:a05:600c:4ecc:b0:4a1:7dcf:be1f with SMTP id 5b1f17b1804b1-4a18e476022mr25383075e9.1.1791539854893;
        Fri, 09 Oct 2026 02:57:34 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:ab7:2110:6a1d:efff:fe52:1959? ([2a01:e0a:ab7:2110:6a1d:efff:fe52:1959])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18e49792bsm59188805e9.4.2026.10.09.02.57.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 02:57:34 -0700 (PDT)
Message-ID: <9c5e6623-ccd3-4570-a5d0-313e09f9bb62@6wind.com>
Date: Fri, 9 Oct 2026 11:57:33 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v10 4/6] net: add AF_PACKET multicast dumps
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
 <20261007115821.11332-5-sigefriedhyy@gmail.com>
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Content-Language: en-US
Organization: 6WIND
In-Reply-To: <20261007115821.11332-5-sigefriedhyy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Le 07/10/2026 à 13:58, Yuyang Huang a écrit :
> RTM_GETMULTICAST dumps IPv4 and IPv6 multicast group memberships, but
> the device multicast list (dev->mc) is only available through
> /proc/net/dev_mcast, so "ip maddr show" still has to parse procfs for
> its link-layer entries.
> 
> Handle RTM_GETMULTICAST dumps with ifa_family set to AF_PACKET next to
> the dev->mc helpers in dev_addr_lists.c and report every entry of
> dev->mc in the existing ifaddrmsg format:
> 
>   - IFA_MULTICAST carries the raw link-layer address
>   - IFA_MC_USERS carries the entry reference count
>   - IFA_F_GLOBAL in IFA_FLAGS reports netdev_hw_addr::global_use, set
>     by dev_mc_add_global() (SIOCADDMULTI) and dev_mc_add_excl()
>     ("bridge fdb add ... self"), i.e. entries added explicitly rather
>     than by a protocol join. This is the static column of
>     /proc/net/dev_mcast
>   - ifa_scope is RT_SCOPE_LINK
> 
> This covers every column of /proc/net/dev_mcast. AF_PACKET is the
> family iproute2 already uses for link-layer addresses ("ip -0").
> 
> The default FDB dump also walks dev->mc, but only for Ethernet devices
> and only if the driver uses it, vxlan for example does not, and it has
> no users count or global_use bit. Extending it would change "bridge fdb
> show" output and add NDA_* attributes.
> 
> Requests are always validated, there are no legacy users: prefixlen,
> flags and scope must be zero, ifa_index selects one device and
> IFA_TARGET_NETNSID is the only attribute accepted. The dump runs under
> RCU and netif_addr_lock_bh() without RTNL. After each round cb->seq is
> set from the dev->mc generation counter and dev_base_seq and checked
> like rtnl_dump_ifinfo() does, so an entry added or removed since the
> previous round sets NLM_F_DUMP_INTR.
> 
> Signed-off-by: Yuyang Huang <sigefriedhyy@gmail.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
