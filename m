Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793114258;
	b=QteZEGKevG0g/xI9BIrrMg0n6OiF7oVmZUOJ7SAyf6+IHM/VOk+sjRyyNp+8KO5nllmc
	 ozuT8ikxOxGHVJt7sSowY5xDWzW1DZ/i1WxzDtwuAh4ZAhGErQH4IFWsQBzczk1iHY2hk
	 G2SVT0jTQQLHTyGnNzH633kOxh5WE5J+H8y4/ykunk7X2hh9qcAYozSzQ2mpE44WPWa2T
	 Z7+ylgOS5uvBRCOgk/CrZOjuRPMppk14WqsX06jJ/xOP2GDpgZN5Sowxw/zYXy9R4haj0
	 LEmBqyURqDcyvs6rKHj9BEyv/dTXkO1o17g+A2ITzrZA6N9kFqUHJayVXRbxo+8X2AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793114258;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=4fPSmeJPob6CVQOVOnIxBPwTG4caUOiCHI77RzlPcAA=;
	b=yxqIGQe0EnG4tmGsySM2+/YTAVglY9cXJKfETuijulqu5GkQn8ZMvfENzIclAn81Ci9/
	 dBlKNyjY4orSke6EE6fFg/ieuyuJCA+uqhRhejfaF04ju9H6CegDEozD2Lwgez5Rr/zsO
	 mjxdJHX21JjTCvJl7vA9DY12ICnwXbN+1LdlJCXCFUAQ4Fvr5HPED/Sysy9p9J71bF083
	 T3WLJKmi6/weQ2Z82Qis7hlTdpxq22yQSbZSqcjIit0rOBC2Coy4kBmk2rAXjYK9EWfAz
	 C1t7Z0ceOTGmLCVPFi5L6t+uBFUf4i9eCYzvoC4oGXE61FboNnw03D0EVOSZs6Eb6hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mind.be;
	spf=pass smtp.mailfrom=essensium.com;
	dkim=pass header.d=mind.be header.i=@mind.be header.a=rsa-sha256 header.s=google header.b=UbiC98Iv;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1A5606A31F
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 15:17:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF1A5606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mind.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=essensium.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mind.be header.i=@mind.be header.a=rsa-sha256 header.s=google header.b=UbiC98Iv
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48441a2ba1bso2795482f8f.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 08:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google; t=1793114255; x=1793719055; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4fPSmeJPob6CVQOVOnIxBPwTG4caUOiCHI77RzlPcAA=;
        b=UbiC98Iv3XBYZInxTfdt7Pfn0eJ6Rxua5HUBB9BR3ixO9z5kJSw5EHf+xuWuBceubP
         FpF31s6vkkHK3Bteovz+jxU4YBHJlZiG39dlHH7PFIAmTOR++DkAvePvgvHWsK3foFkD
         NsuJuvvJlRThh0RHOgnSRdZl7FetFZBCbNulh4q6KMF5YvGpi+qL7O/tFD8XNp3IuSlk
         OOTC3krzSkPjRT0NgM2Pha94ALhNiXmgBBin7mgcMfpAf0MDZhA9BbPfqlhd6X4uizHR
         i5MucWmmGakGexEk/703F7Q0oAKWJOZrp6v9ho2VBU5dxo69haFP1/R14NRp8QBw8qwu
         Omxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793114255; x=1793719055;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4fPSmeJPob6CVQOVOnIxBPwTG4caUOiCHI77RzlPcAA=;
        b=uLImF1zdaHAdWBEZwe2RIbaBkZ3fzErN4jXNyKAi49rEAgynfW/u8b+fZbhx6TNPx0
         L6mDHryjVwvjW8WT0P8n75jhY5UEE2dBP8hsyLjj0vEewf9MjwCLEZd74nKtYnTTYA6T
         fMX3eZgJwGrvp8vpi8nJadFfKsWXgGu9d0VmhKZOmBks3lwKifUw+ahei3OD4D5oimng
         INskf8dlOqIr9xYdiXsEmYDh2kKU5+wYl12wSu9frEv2+7vqUCjCtZ1NshqLHUmpUgWn
         WhArapn2nYf92uNXVDD/yNzBMZECqiLGTH77bJ2hhUFuHg0GdGg81z+XJwkAfeDVLPrx
         G+jg==
X-Gm-Message-State: AFq9FYIAt9rkcEsq9YxkEAAMRuPx1xFkb2K8jEalxu9Ma0RlMtL4n9bS
	Q6sq3Ar9rxBKQoqpatlBn5zd39xOnfP2vHlH3PH5bp/pYFRwObR7HYJdcvkRrxJJRiE=
X-Gm-Gg: AYBFou0J9m8ZbCKU7aw+1AlaqyetbHPgg8GFz8xS1pAIJn0ViZSkhUzneTeye+UPMXk
	H/I6wpmi2+i3LlRXiJIqhzi3jTqMj+B/+hxZVVZCh3a9ihr6cggas9hhLnk0kEp5owX9L2WGyHH
	KdBaGy6QmTRSdmoyDWDbn7jjDmwwYxW4nOxXE6R3K9A5+ovxjar6TV4AOYRowK+BBFyrPpEbYH7
	/Oexz7VRgt33gBRNSsXhzAlyPXosA3EvoAOh/aF9y+JhZEX9crypfz4olPtSh58lTrEuRtofIKy
	FMHnd+LNZysZMQBa2M0HPw4D0c6/29uYZxsxARoHYnh6rsFT5oUx55lKB5m5I77VitCvtHDTAlV
	bUTvLCLiKozX6d6daCeek9bgF6lp0Yg9Fa1s2OclLWGfOFSjuHJ9tJxDZJqA8g0diiookCSn0H7
	dT49paeACqVYQunP2csHTfzONJPXRY7LEoF10qganJlY5FKDYEsKFzICLPxZl87e1te+vKDEL/r
	LxxdpsJaEgFh55jfDkBYfja6ujQwtOeinOtkaIjgv4HjfulXSbbIFf1jie0NFwZ
X-Received: by 2002:a05:6000:4b1e:b0:48e:3647:c35d with SMTP id ffacd0b85a97d-48e3eb88579mr19935434f8f.21.1793114254868;
        Tue, 27 Oct 2026 08:17:34 -0700 (PDT)
Received: from [192.168.178.32] ([212.233.51.18])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb846sm23528822f8f.25.2026.10.27.08.17.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2026 08:17:34 -0700 (PDT)
Message-ID: <3e485487-45d9-4078-abc9-b06515e4f5ce@mind.be>
Date: Tue, 27 Oct 2026 16:17:34 +0100
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
Subject: Re: [PATCH wireless v2] wifi: mac80211: limit assoc mode by AP when
 there is no auth data
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, miriam.rachel.korenblit@intel.com
References: <94c01af4b987ae7b04aab040d2683edc3262c35e.camel@sipsolutions.net>
 <20261022143943.1045238-1-raphael.melotte@mind.be>
Content-Language: en-US
From: =?UTF-8?B?UmFwaGHDq2wgTcOpbG90dGU=?= <raphael.melotte@mind.be>
In-Reply-To: <20261022143943.1045238-1-raphael.melotte@mind.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

While I initially discovered the bug with iwd, I was also able to 
reproduce it with wpa_supplicant (in a different scenario: FT over the DS).

I submitted a new hwsim test in hostap to illustrate the bug:
https://lists.infradead.org/pipermail/hostap/2026-October/045885.html
