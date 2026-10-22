Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792679616;
	b=fFmJilZru8/5dfaJIgdbucxA1bz3gIFA1ZEG4yazSpvK8E5Uf2UIIT/ha9UMCTpO1wCq
	 B8RpBpFEqYZCz3WybeOZAVq/py9Fuv6lxZatwHZv+jok7LuZcdZIb4dJC25vbMO4eaWkK
	 RJTrtuZj2hmxVEEDh83FOCZbfgu8HS61aEe2vDhSPhslpTClvhK/x5pXSO3p2SOMkYJvd
	 1ZVxcJOBYk2jf+14zw4t7OVQb1YcKzuKQ1zIZwRNMFIJmdcJma7YkeRsbKLmhNzmauweK
	 lS7CbuipnUAABoZkuRCSuPz9KuBM3dxuH1AV8PsiONH9KSrwDzj39VWIL9nYDDojo8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792679616;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=9Vq4wXSA0UWayfeoZjl2Hy2bF+0/Jmb6zUZbFNGbIE4=;
	b=MeUOPDs8nWS16ELuuHiZfLOFLArgh5eivRk6ygH8VmwmveT1fM/lggi0nFnGtbErIxju
	 xpTS32AsKH3aY6TMBWj+PVOuxGIlCgvgJNRaNRchpHGvA5Q9zY233bx3sf3TNP9+ZEibW
	 IdNukO9FwVLFKK4SL3BRsKOJNNPfLaQ7HYqZo+M1H8pYehOHVZO/G6s5GWWIwjkREhCQR
	 hnkfqyhcuUId2PJJnOdb4g5bRlXf+tye7gJQYh3+tc4y14utqfwwzr1sjOfHMwhlZ+gTV
	 fUHvXrPA7xU3ZgVPqn1Sp8k2q5/6ByLtsoETYxzB398uVu/YlaM3Uq8zU3cqet3M48g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mind.be;
	spf=pass smtp.mailfrom=essensium.com;
	dkim=pass header.d=mind.be header.i=@mind.be header.a=rsa-sha256 header.s=google header.b=QhWPGsKS;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3249D606A319
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 14:33:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3249D606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mind.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=essensium.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mind.be header.i=@mind.be header.a=rsa-sha256 header.s=google header.b=QhWPGsKS
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48e0d1c095dso1312702f8f.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 07:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google; t=1792679612; x=1793284412; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9Vq4wXSA0UWayfeoZjl2Hy2bF+0/Jmb6zUZbFNGbIE4=;
        b=QhWPGsKSSj1RLNFDVFXmx76ar7zaTjYCVla1i2AGcFrGwpd5Z4vXTyQKnWPuKVEuqB
         xqijNl7IgYoRRrZCa4He4Y7k1kNTUMTkRXkdShLtfu8XNJ5RVyq2i4qzoKNV4O1p4gTb
         ZbAJXjBWRBl/BrLfElrv8JnEQUFdTcLCiwkbbtEJukLGTCgR4LZXc9fVuFAA92dFHvvO
         PTA64S1gESaakBHufcj6I/Y3uTSBcQuOPf/U9nNY1JhBHkuPECd+Fep42p+T7inAzjqr
         fZyFT74qz4HoDMUeADiknMimELsxCDKxwcm/NQKYMwPweWbcGlmYr6okEO7G0X9f3iik
         yYzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792679612; x=1793284412;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9Vq4wXSA0UWayfeoZjl2Hy2bF+0/Jmb6zUZbFNGbIE4=;
        b=NBl0M+aDWvejPqTzi8IcvSoSE8MgwWq9fmQWJKk6aNhxAzsHO/AvwDG3bhHLs6MUdE
         sOjSJzp4DeckI9KEF3zQS6czV5MC2Xhxufz7pCpl5VeP4q2auxV/BkpE1dn848yCNYtw
         ytYTJeA4aY3t9kwb349P4JaTH9bdD/ZUE3Lg7NlIFPM6gP+CRHXqGnufNmbG2hG2/Ci7
         dv8OWeEEePJP0NhVbKZsi56SBvCjpN7P2iL8qbb9HxrVQsRrGtVREZqAoao04nmCeDv6
         IBx81wIO9tLnn0L2ARsAURWDllaYL7cpsoPsEYJ6ml05xdlu4M73TzjKfFGZ+mm9Jq+n
         zeVg==
X-Gm-Message-State: AFq9FYIPRyKtE/nL0TxqJ+Pi60KawW4WJGoTt8t3yucVtELi3LwYnnY5
	+dnlvwjzDcwu3+lMtVihAo9rKSQFAHW0JvK5TCl+r4bVgAg/v7GJ5SwK4NAQW9HiJeg=
X-Gm-Gg: AYBFou1T4DAEwdJIntnaSoVL8mMkVWws65+sXv1yGnp+wikT5qEwczymIxkF0ba5E6w
	SKyktEjGjLlQusNxV119FlXYKFG5tVauAXgeBF1dfat6r+211OlaJZAYjSsqQwoxcw2K4sb7QZz
	2QBmqtkuNYRQy65T6H4VO/mKa5/7C0Rt4IOmMdVQH39K5GbMdI+XzkEZcoLXppH/6sMTDrJIX6W
	hqpM300Q9u/1GAmi1MDJKP1uBq1vPDb3gqNOPuqvYzQdPpzzocqt04rcdODof3n9cGyZMUJotPA
	XXWir9t9eE3NG3sMfVP7kWbdBdEl+ERPhQosnY2glsscC+panuI1PGCdrZ9vf1rXHCeftLYetRn
	6HBAbiQU4qexuewhTaP/+hVjqQF/4M3jNPQKbImVDgA3LI4zm66mWqM5bdh0TT1kb8LsOCnPQnx
	yv/iF3ywwIFFDDRMYsbUiY2odPw4hl5zxfCZpIR7d9j7V0qByCBNW1lb61Op3s+a03KuGjX1Wki
	0cfoa0NWLe1ANLBNEBW3306wt5LZsoMb+BgPSHZGgPTend6WBr+1FT/pdrD5iwOMeWAvkNJrcAq
	gHmFCQ==
X-Received: by 2002:a05:6000:2312:b0:48c:77ad:d52d with SMTP id ffacd0b85a97d-48e264dcfe5mr11761670f8f.43.1792679612332;
        Thu, 22 Oct 2026 07:33:32 -0700 (PDT)
Received: from [10.140.0.3] ([212.233.51.18])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25828cd1sm12556666f8f.22.2026.10.22.07.33.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 07:33:31 -0700 (PDT)
Message-ID: <43df178f-0395-480f-a38d-89cf19f7fcff@mind.be>
Date: Thu, 22 Oct 2026 16:33:31 +0200
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
Subject: Re: [PATCH wireless] wifi: mac80211: get AP HT/VHT data for assoc
 request after mode is known
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
 Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
References: <20261021202020.640739-1-raphael.melotte@mind.be>
 <94c01af4b987ae7b04aab040d2683edc3262c35e.camel@sipsolutions.net>
Content-Language: en-US
From: =?UTF-8?B?UmFwaGHDq2wgTcOpbG90dGU=?= <raphael.melotte@mind.be>
In-Reply-To: <94c01af4b987ae7b04aab040d2683edc3262c35e.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Johannes,

Thanks for your feedback.

On 10/22/26 11:38 AM, Johannes Berg wrote:
> 
> I can't really follow any of this well, and it's a huge code move with
> questionable design decisions (like returning bogus zero values), so no,
> you need to come back with a better patch.
> 

The problem I'm trying to solve is for a 5Ghz HT STA with FT enabled using iwd, when it tries to roam to a legacy-only AP.
Starting from 7d8b02592d52 ("wifi: mac80211: obtain AP HT/VHT data for assoc request"), every time a legacy-only AP is the roaming candidate, we fail to associate with it because of the -EINVAL returned by ieee80211_mgd_get_ap_ht_vht_capa().

I'm not sure what the best way to fix it would be, but the cause seems to be that we have no auth_data, conn.mode is then limited only by our own capabilities and ieee80211_mgd_get_ap_ht_vht_capa() runs before ieee80211_determine_chan_mode() has limited it according to the AP capabilities.

I think one other possible way to fix it would be to call `ieee80211_prep_channel()` before `ieee80211_mgd_get_ap_ht_vht_capa()` so that we lower the mode early, but I'm not sure if it's really appropriate.
It's harder to reason about without seeing the code, so I'll send a v2 with this approach to be clear about what I mean.

If you have any feedback on this second approach or any suggestion on a better way to fix it please let me know.


Kind regards,

Raphaël

