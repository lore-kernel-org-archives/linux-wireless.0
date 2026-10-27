Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793126638;
	b=IVra/A6rK81HBabNAsLkSrGAIzdJaBxWfjUyaUrAOwDJaOxfdB5cZ7yU8H3GbI2Ny2U+
	 s49LjAUOnBIHSorZIqbNTUaxER9YeRSyVREUAAT5YVQwZyuWc/O4pEsxsONUCN9f/E0IY
	 L6d6la66worJqqTDGyJSBPCIWB7M/ACbhnP74R64WnKRlr0SxLq6Oy2tSO1jOed9WhcJF
	 zYsZuQM5UC9AoEyADvBPfhedcovV3NlINaiLHZTOpv4saTD9pgT5p4aex4yITA3ppZ61o
	 zbCZ5ugAzZngeWTBO0bbw9v4IFenl8NHzvVxqPMh9B0s7ZGPYWoCA34pG71e2YBTqQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793126638;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 Content-Language:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=mgdYMJyAkUlwT7RfESxpZUFd0c3Pn7YULHqUey2cwFc=;
	b=2P5LhmnCSJtUjb5OjcGfDdGahEclo5IB6kn7m6vr7gW3IBnQvLnhVBbsTAx5ENMloXJj
	 lJO/hiSa2QHpPQiIDGKavkhl0UqZ1AXQH/uG/sU004oob+B1yiq2/0dOAMwprzL9nglCN
	 Eso6b0+0S12BknZf+vg6g1fcBkc7J22SW69aVixvpeuSLI3BCM7xTzopwpht5pBYD2Cwl
	 NsV3Vg/OjivNoPVZKEUnF973Kwer2WjeSPo3viskKgr0idLS11Wh2N/zwJ190neZQk06i
	 m3Q/k1CRmCu892e28Li9aqzIFfcvHJlHhTNyU7akCZ3sx5hSWLTQSxoe0epn7tmOiVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qPwm5oar;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DE1606A321
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:43:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84DE1606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qPwm5oar
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48c4d870d54so117232f8f.2
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 11:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793126637; x=1793731437; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mgdYMJyAkUlwT7RfESxpZUFd0c3Pn7YULHqUey2cwFc=;
        b=qPwm5oar98PCQlwDOw9kJrG8AWB47g668VVfH+h+9LwHytAQ4tJkuRB1WoUoh1KZGg
         QJIAqVpw8pKBMv8ou7w8bbLf3+tPI6i4XpYPd4LDLbCvTspp+mVvpwvEhVWUc+kp/cJy
         H8tH2zi54+V7YyyFeTS2VFXZGNzHomQ6ZIQMT80lDlwJc0Rbahoj+UOcVArQISa2okM8
         XWk49/mw2j0AHpY1/wfZAhClWQAI0/2gZjHmoC0yT6jBdS4biWBm6L3B7MtNvVsQehwG
         SmTcbK3nM5EnmblQPBcABDqycE0BWHzrZw4udwEyjMkfPy7KTKahaH9J0UqnYab/Movg
         6AFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793126637; x=1793731437;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mgdYMJyAkUlwT7RfESxpZUFd0c3Pn7YULHqUey2cwFc=;
        b=s8BNG57crU7AmWJTxu3XEQrYaM1dWwsbJqL8K+vTnfPjG3gWwUrxjRHGTqF1q3Nd1f
         mBsYIqT5qq5QOjN1UjPZldwfAulvGGRV7waO+ImxP6OCJSSkHD3Wo5PfJ2GgioGyx5hb
         U2a1uR3guGLhUOKqK4aTXlq3YReXO0qtzXKp0VIET5NLjplzjxd47UUy9RQC3WuBPkjW
         zunv9vFX6OZ1HbixtN3z+gAQGnCRjLBHXunF2v0qXPusFqQi4YSe2w75gz50/ZEoEMFD
         2jFEpjzfyU7ujgdZwEX+/U2EMuVFM8IexgqF3MGuDvTipWR6WUI6jXLMRCyZMXqpxy+z
         jPkA==
X-Forwarded-Encrypted: i=1; AKwUvBzLYP0FNoZcLoexDTbaACCaR2tcfNgZ9OoEFvy2TAYrpnFWny1rx0gBz1UnRpciewuQditSxJCeiU/CRZwvyg==@vger.kernel.org
X-Gm-Message-State: AFq9FYK96V/wY7Fi918z1ypG5zQzk79vpWmNzPsC3vXYWuIqXmTTb73p
	Y1PdQAS6PRrtM/OFQIy7tBdKUk8XK+qD47Y0a01d0oBMX9umgpZ/n4vc
X-Gm-Gg: AYBFou3fjx0i1aK5Ts6bEce7Ru9WZFKewhO4xFg2BV/lNwKieGpU23cb6UaAxZgmwsy
	6QDYkGvpLW/O61A4EY8lISCzDkx3zdBJJ7NAZzPYH0CfuEXGwBpHj50WS7db5BQvqu1KUEqazKR
	I3EOWOzSTKi8mnOYYteRY0rdCm+goscYqI/86p+tsJ7E6TVxq0U2ui/zT5SAbzCM/0txkbywTzT
	DyFAn7hDwqQ/weXZ+DzYBi+HAUi5T7cbJgxXtVZRKXEtUEtrytLWda2GNSDntcwg+KMXb8dIm7q
	dgUVG2kjzvwu/Nugq22RkUM67G9eN1drebmp2vucP9cmRQiN2BqoR/KiIjePuYHX8mVnFXmqjEC
	x6C7RoL0ZtXbVgG2d5wDFG9WzpIsABqtwyZO/oG5ZB4ifsMA+5tazAgv9sTyVNsxlHtUbHF0wgr
	b2HCYoyGrbSB4DMoAhgpUtkA9j6f+7kngDMtZCFVfGjlOGL3oF/gJ5KmLUfWuWeoK9mC864oxIA
	fjTy8S0ftTXv0xI08V4R7uMwGzzqddZmJL3xm9LmqIE1wO8XMyLKDb2K8RhKi2zIHdDyztLecG4
	OuXgdVqXaXVKpnKLY7EKRV2GRvvNRjgqugmt9JxeMntoCYbPJg==
X-Received: by 2002:a5d:4e46:0:b0:48d:f36e:fbcb with SMTP id ffacd0b85a97d-48e5d58f60cmr502427f8f.14.1793126636649;
        Tue, 27 Oct 2026 11:43:56 -0700 (PDT)
Received: from shift (p200300d5ff07190050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff07:1900:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecde7c3sm25746227f8f.51.2026.10.27.11.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 11:43:56 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift.daheim with esmtp (Exim 4.100.1)
	(envelope-from <chunkeey@gmail.com>)
	id 1xLm9K-000000002yU-1lce;
	Tue, 27 Oct 2026 19:43:55 +0100
Message-ID: <c5f62e31-4e10-4200-b0bc-a737a3a7c161@gmail.com>
Date: Tue, 27 Oct 2026 19:43:55 +0100
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
Subject: Re: [PATCH v2 wireless 1/3] wifi: carl9170: replace open-coded IE
 search with cfg80211_find_ie()
Content-Language: de-DE
To: Tristan Madani <tristmd@gmail.com>,
 Johannes Berg <johannes@sipsolutions.net>, Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 tristan@talencesecurity.com
References: <20261026223202.2089824-1-tristan@talencesecurity.com>
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20261026223202.2089824-1-tristan@talencesecurity.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/26/26 11:32 PM, Tristan Madani wrote:
> carl9170_find_ie() open-codes the IE search that cfg80211_find_ie()
> already provides.  Replace the hand-rolled function with
> cfg80211_find_ie() at the single call site.
> 
> Fixes: a84fab3cbfdc4 ("carl9170: 802.11 rx/tx processing and usb backend")
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>

Sure!

Acked-by: Christian Lamparter <chunkeey@gmail.com>

> ---
>   drivers/net/wireless/ath/carl9170/rx.c | 27 ++++++--------------------
>   1 file changed, 6 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
> index fbe46a5e4e415..9db6ac9d6d3c0 100644
> --- a/drivers/net/wireless/ath/carl9170/rx.c
> +++ b/drivers/net/wireless/ath/carl9170/rx.c
 > [...]> @@ -541,7 +523,10 @@ static void carl9170_ps_beacon(struct ar9170 *ar, void *data, unsigned int len)
>   
>   	ar->ps.last_beacon = jiffies;
>   
> -	tim = carl9170_find_ie(data, len - FCS_LEN, WLAN_EID_TIM);
> +	tim = cfg80211_find_ie(WLAN_EID_TIM, mgmt->u.beacon.variable,
> +			       (len - FCS_LEN) -
> +			       offsetof(struct ieee80211_mgmt,
> +					u.beacon.variable));

nit:
If there ever will be a v3. You could consider that the 80 characters per line
is not a strict rule.

This is straight out of "Documentation/process/maintainer-tip.rst:
"The 80 character rule is not a strict rule, so please use common sense when
breaking lines. Especially format strings should never be broken up."

my 2¢:
	tim = cfg80211_find_ie(WLAN_EID_TIM, mgmt->u.beacon.variable,
			       len - FCS_LEN - offsetof(struct ieee80211_mgmt, u.beacon.variable));

Cheers,
Christian
