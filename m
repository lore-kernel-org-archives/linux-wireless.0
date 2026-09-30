Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD0751AFCE
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 14:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790777361; cv=none; b=oF2iav0QowJXKdg6wxUNjFZgzR/KLSKZvRvnTJosPf9l5PCvACL1ND18ECQCxSguvGRSz+ih3BoG5aOAjt82IMgilisqb4iAXVifLMMmlX6A1BKBlWYzzhaQLELCHlg5lrH/eHDFxp6YaIjN5gu+AVqjXol4kQZheLJRm7OZ/GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790777361; c=relaxed/simple;
	bh=BN8qNZrn5KUe47KrPph76MRZuWYXHDzUb9aSvc4F6Tw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SFsxe/JkZkjtFAF6lu126biBZRV1NE44k3JQljXj02iLBDn8EWiXrVkVFUAclDBd0QsWPef7ex7VAmcS9DP35zVQzocD/LtFj1eyi++LDSCKxUY4+Uw3Cd9DrH6bFSn/tonidGz9TCl3VrQ1hHcx7BfvbxpGY7ucqi5RH2c63Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com; spf=pass smtp.mailfrom=6wind.com; dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b=BusD2SQM; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=6wind.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="BusD2SQM"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843af75de5so636150f8f.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1790777339; x=1791382139; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:from:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tdG34iKbPg/dwz5nj8mIvaNch6v4ZkxNF8npErR5dgw=;
        b=BusD2SQMeNc9qIwPavPHiOm5OZWZJV90oDDI/3iC5w1Nd0OUfddlgAhdKoB/0O3aHL
         geVMedIw7bU58L8CMt54+jF7iW8pqbUcmTxvrXDrGMFBb16mEGtxG4teFELoOapcFfLp
         bMxVW2Mg8N/M+t2vcQybJEhlIqus9xRCQKJVr0bu9qgZPY0uc+5ZQ8jO2h4AWGVDUPE7
         8iBVT/CCxZ9Th8+YeiFUZJufc27/PvZR6oq51kmJl5f3ez0lnDor1UmOlPsh4hHW2Ly5
         IhZ127CjZqiUc5xhm8xHrN2nvS4bmyoy8RO+C0HNRBXuxim08CVrZ8nunlzddNnGbfxH
         jYSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790777339; x=1791382139;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:from:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tdG34iKbPg/dwz5nj8mIvaNch6v4ZkxNF8npErR5dgw=;
        b=fn6XCb1Z2UpXIxSy2nPRg+Y75GJo9wNi9CQQlrRBJubBEz9DQk5IdvJAhLuGfmFN3z
         7yJzZMM6ZU6TtxHZVygpxKZsw/kvGY2WlJbUTl/JvWGi5dxEvIOpr5BqazOh9qY9VazL
         CEllVHN+jI1AU64fDQcLEVESL75scO7C8PStZmOSOSoq+bo2rAHkWtek6bvyFjAX0PFg
         A9OGLhUJaXCrBzvYgsAIce8Vb9NkqEwgMRtm5+9aoiRLnTW2cHjhMR7LnYlbn1dIKdY1
         omjLBKsJ2jmbRGIXtj+AIcyp9+XresSdMSSnrJmELZXTbSerZfHLtR5+77GtWNwfiJ31
         LT/A==
X-Forwarded-Encrypted: i=1; AKwUvBzg9AOqPCd9tFdfaS1nttmPfWou3Tp9+fKquE1qFuq291X/KZvHplMpBMmthVEnHotEt7O1d5V0oHO8A/2AJw==@vger.kernel.org
X-Gm-Message-State: AFuF++nVCFiKbnY/Ng8hgZsu+35w97u8h6OoK93BwHOCr3csgybuK35W
	ZmFNNAuaUphL2/mn8dCLvmtKFl5S+x/Y/b72kacF+I49DGtkZwRq9UVY2h75bVjYeuU=
X-Gm-Gg: AYBFou18Cmiwq++kKpX9n9zP4ygKP0pfqBBzi/W5Q99yXjL82d1P6QNsuD+HBCMDw0m
	IYJMSD2MR88Mh2QA8HR2TJYHfouuZjOOYp7BMScbuVaQbR38r+7vtnw4pFp9qqrSmueFSycjTEK
	5s7u4dgu/cw2jU4fQtISF2uBMmmsXp9vqo86CLx3keNIZICDbuf1vSHM+Y2+D+civVbk4WlaPjk
	0+NuuJWID0b5fDG3/Bbb2qyg0Rp59p8nOYG2ixLosa9Z4kD55sZYKj9Q7p1sORpNoJTIgsG0v4x
	dJ6HUrmpgXt4HxH/oLWOEqltVwdXRedoFVzGNQmVpBmzxOHAKGUcX7wvPTzWz1R1VPSLeBl6s40
	vs5EieSdACyXkNxj9qzGt2SDgdj6hGLiH1jrQtAVFaq2F/zT/p8U38IUIh1tPCH77Kbj/a8Z2mR
	OfOgyuEWwkXLQpIJOlDVft+rSrWdvTqLQoo1LPQrxrO8ePqh9k2Qp1lmtiPEj1O9A8I97sSa1gu
	nBbZzajtCdT4byN50uHrDquY6dfhOXEj913erNeN3Gria1bjcw=
X-Received: by 2002:a05:600c:628b:b0:49e:6683:d227 with SMTP id 5b1f17b1804b1-4a01ab4dde1mr25863645e9.0.1790777339323;
        Wed, 30 Sep 2026 07:08:59 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:ab7:2110:6a1d:efff:fe52:1959? ([2a01:e0a:ab7:2110:6a1d:efff:fe52:1959])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01e64c322sm2327035e9.4.2026.09.30.07.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 07:08:58 -0700 (PDT)
Message-ID: <7d8f1378-d5a6-4a87-82cd-98eb794f85f2@6wind.com>
Date: Wed, 30 Sep 2026 16:08:57 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v9 2/6] net: change netdev_hw_addr_list count
 through helpers
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
 <20260930112842.21323-3-sigefriedhyy@gmail.com>
 <235a33c2-7138-4815-820d-793568757d95@6wind.com>
 <CA+7S2v+VaVYksOpuUKzo+DoWZ97M_XKvnMr8cCcgwTkrOxsvEw@mail.gmail.com>
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Content-Language: en-US
Organization: 6WIND
In-Reply-To: <CA+7S2v+VaVYksOpuUKzo+DoWZ97M_XKvnMr8cCcgwTkrOxsvEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Le 30/09/2026 à 15:43, Yuyang Huang a écrit :
>> If you respin a version, you can use netdev_hw_addr_list_count() in
>> __hw_addr_list_snapshot() also.
> 
> Thanks, will do if there is a v10.
Thanks. FYI, please don't top post:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst#n336
