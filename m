Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB1339281B
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 11:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788692781; cv=none; b=fwbpQXZMX/A4FM/Zb7/ERscLurKYGsNEfVSWx9PEuXtUXdm0i758V6vFGQ7Uv80xgx47P/Ja+iaNYjNFrfn1Lbsx1XcpHWUJJpHqib1nRytke/FDw0yEg4NWY9z5QBRs6vY3bZkid5K9PbEjrxj/1fsqnynk/XeNlo6nNIxfHgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788692781; c=relaxed/simple;
	bh=N/HRc843haF7GhRaeCjYuBNpl6Jx8wyMgtTtNTc+Uhw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V6bdoN3iwwS6DtYQPTL/6hpEO8Rnb07OTXZyCWc10nZCdiw0iID2IX74JM4GKcDKbTqBHXVqFZXYOLyNzVy4pAb6FzKknoqN9ZBdayi1xRrFO9LSuUEh924lwQ8E6esgz/tD1NvRPQ7fUyCZBOF7wWtAm2xWYhxYzdti17GCKzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZzXJjOiV; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZzXJjOiV"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4859245e493so715705f8f.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 04:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788692778; x=1789297578; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IEig/JE3WWqe5qqWFwj9jUgs0T7aqJalyU5R1FMFTAM=;
        b=ZzXJjOiVnD1/RDmYNJdXHg0IKoPSr9IAVbEb2SWyjkoFBQP5w1OL6ghfAv78/0LzNs
         T29OZRfBEgSDxVna8FPQ3oursF1y3iR8w5mMulSnfIkkiDLDUAFD7AC6F37zDCJlIAGu
         tijj++X9XnmGezcEGojSB4dJwVDLqHa+wL/Yla1v6Mq0VV4DqULPVn/K9Ws8OIRIprhQ
         QglaTuow2UZJussgEknZqrN2abIXghwKFt7Hls8TjQM/NmnZsYwTamkE6fo83HbnILCe
         10lWsNC7GBMgNrLzKa/cdDgpqvftBrutITQ5OUcfvS8bSJqw38c1mORXB5ZwwasEOlLr
         XTEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788692778; x=1789297578;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IEig/JE3WWqe5qqWFwj9jUgs0T7aqJalyU5R1FMFTAM=;
        b=XiCrcNoYTEyKhcmb+uxV7clEmmvVe73BYOUE6M92rQi4I86AHEI5UWOHAh5IskrwH2
         7CUx0XpKD3pL8JuXQJfWojO5lJI2U9PMHer2VVedXQyvCKiqYtc/cJrJu4X28zINzp/F
         z2wqI9wz/CPxuzBlNorLDiWNJiDD8/OKhxazJovDIRyRR3YOgsD8wIXoXIuszLiLZOqZ
         Dco8sPJo2F21fqgDbvDp6YYXRrfIm7fiOHYztElteXzmXMVNZHN+NINbIzP1OKze6ca9
         +MOVuQtp6SBYu5w0NWW+2HvQkBizk3i0bDVXRYACVYwYLh4vB8+vrnmpCuF/HiZgzeNH
         UDMw==
X-Forwarded-Encrypted: i=1; AKwUvBxoXplpWVJWhd6xi27nYAGMSXGkwEFEyUAwlLxEJqwOgOKcgsPQAxGdTTRSGzKcIJGSYsNOdNMEwaqtaZrpnw==@vger.kernel.org
X-Gm-Message-State: AFuF++mL1P8V+zslaxm+4ckXGu61HNWfyU0KRfUjMNgwJwkCfE6Agcai
	6U6ogD+KGFV1Y69i4crV30vWOA5El0sGZmcmDuG3izij3PWtf0vX7dd1
X-Gm-Gg: AYBFou07zy2+pLoMXaXzmbwIX53eGkB8QguJZ3cohG52b3mDIlan9S6gji0DGf4i2rS
	tHmjcKWT1xT0jmCF/xeUdpI96TlzismW6Xnllri0mmS7Vl1dm69rm+32UZaWPlxEO8DrqN6NcDC
	aS1qUa0xGc2V4WUKe7UhjxZO2blI0vEwZBMNzYW8WumaFI9VWGmNO12Ih3ojofS2txgjIcIWMgL
	xc7CiXnEpkbzkXsRrN/JnFVjLVAqOa7qlrLypkgQMrbTp/SJnDU+PWOb1bq3+UoNDiKHdD/LhBJ
	C2ZJ0UwybhD24aFRGbmsDAYLkDMJNe4yesDfzOW4xsgUAe47Nt/8XZido9PTwLifoQN2D0r7Der
	Eb8RCq04dhb5NdbOmPI2GpZn4q9BfBnManfJLPanAfsQUXd/26xlPk6pJXN3F0Lo0GOp7dI4/rg
	GWMoEgPgBjVE2aVc24tPqDmNPy78c4IXa7rDfTCFFed7X2F1xM2PYazkQPaO82br/UeUTAfW9+t
	DDoEAXZOkWBFhZAI9v6J4dAeuJ6vwmio9f7tZDj0IVJAAOAf3vRzMwtNkYfb5BwXwM=
X-Received: by 2002:a05:6000:2282:b0:485:8a47:5b82 with SMTP id ffacd0b85a97d-4858a475d65mr16888274f8f.31.1788692778352;
        Sun, 06 Sep 2026 04:06:18 -0700 (PDT)
Received: from shift.daheim (p200300d5ff3cee0050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff3c:ee00:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885bf3f0sm22605582f8f.33.2026.09.06.04.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 04:06:16 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift with esmtp (Exim 4.100)
	(envelope-from <chunkeey@gmail.com>)
	id 1x3AhT-000000007rj-0XAD;
	Sun, 06 Sep 2026 13:06:15 +0200
Message-ID: <bdca394f-0371-45ad-bfee-b044444ad724@gmail.com>
Date: Sun, 6 Sep 2026 13:06:15 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: p54: fix incorrect frame length check in
 p54_find_ie()
To: Wang Yan <wangyan01@kylinos.cn>
Cc: johannes.berg@intel.com, zilin@seu.edu.cn, linville@tuxdriver.com,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260903081200.267514-1-wangyan01@kylinos.cn>
Content-Language: de-DE
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20260903081200.267514-1-wangyan01@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/3/26 10:12 AM, Wang Yan wrote:
> In p54_find_ie(), mgmt is a pointer to struct ieee80211_mgmt, so
> sizeof(mgmt) evaluates to the size of the pointer rather than the size
> of the management frame header.
> 
> Use sizeof(*mgmt) instead so that the skb length is compared against
> the actual size of the management frame header.
> 
> Fixes: 0ac0d6cedf61 ("p54: Move mac80211 glue code")

It's older than that. I traced it back to:
Fixes: e5ea92a7528d ("p54: AP & Ad-hoc testing")

> Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
> ---
>   drivers/net/wireless/intersil/p54/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
> index 57a62108cbc3..d3e1776174f9 100644
> --- a/drivers/net/wireless/intersil/p54/main.c
> +++ b/drivers/net/wireless/intersil/p54/main.c
> @@ -76,7 +76,7 @@ u8 *p54_find_ie(struct sk_buff *skb, u8 ie)
>   	struct ieee80211_mgmt *mgmt = (void *)skb->data;
>   	u8 *pos, *end;
>   
> -	if (skb->len <= sizeof(mgmt))
> +	if (skb->len <= sizeof(*mgmt))
>   		return NULL;

In theory this check is actually superfluous. Reason being the rest of the code of this function:

|        pos = (u8 *)mgmt->u.beacon.variable;
|        end = skb->data + skb->len;
|        while (pos < end) {
|                if (pos + 2 + pos[1] > end)
|                        return NULL;
|
|                if (pos[0] == ie)
|                        return pos;
|
|                pos += 2 + pos[1];
|        }
|        return NULL;

The check in the while loop and the checks within the while loop make sure that
no "pos" is returned unless the IE is still within skb->len.

But true, it should have been *mgmt and not mgmt.
So:
Acked-by: Christian Lamparter <chunkeey@gmail.com>

That said, if you want to respin and remove this check, I would also ack it.
