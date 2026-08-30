Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270BE3A0E97
	for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 13:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788095927; cv=none; b=c27+t/2X/pJ71mTaFg4TiYGDjl6YFdIVH7TyafbNIBXHZQ7oV5YZBKHXj/Gx732iQp5rhycVG+ipFkcm0YCtvjg59pctx5Pc1i4DYqxfKfYMJBcEajT5lSQflfyK9hsRNF1XiebBlHnuljBROQ01oyqYusPabN5WlAlNx43e3q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788095927; c=relaxed/simple;
	bh=qBHIwDeiQEIBYyURVISfTNgqJO6g4s4gfNsWGb45fPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pytOQoDk9AaNHAahzzLOQlzIrMOHyZcYEKP7yR7rkVjkVLEl+M+PDdyGtHY+9AMM2AbzLuFHM7le7oh3q1sCHJBChna90ZaxIUF4gU5ScBT9LQW5ms++i329/Mhxqig3XvPkkWOAvaILvo+SJW7VLn3+oTOFofQydDvlij+AePY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hrQhkbnS; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hrQhkbnS"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4957eefd361so20418665e9.1
        for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 06:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788095924; x=1788700724; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H/Kmja44MrCin3uu01MUT+M7SclhFHnUPiS6/jA9PRg=;
        b=hrQhkbnStEDSPB1IM3OmtIRlcj+8vXDmXiGs94wnqftgtiSRKY7y/q+wgClm2lmAPB
         yOCTzSNn8Y+V7NKOcRQ6r9wJETn/toB5cg2kIfTFAdtpijf9weBZ7Q0tBTsiuYmcDQQl
         JKiuu1rrgosfYPasL9SpoAJLpIFsD+GnXAAieJp/6RSalmPaQaGUA6rrnDkFJqG0S3vU
         i1UEIAneIL0468phAEOrKUix5yZ5aFg2s10Q/NVzoB6YTbiMMBpPWxwjdIg/rHkhrHJv
         DBrHD/UWVk+KxXTDksm923GsZfHHMHxAUUyJItQZ8tO7ePyH3xJZA4ke+iCDPDU977kn
         OK9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788095924; x=1788700724;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H/Kmja44MrCin3uu01MUT+M7SclhFHnUPiS6/jA9PRg=;
        b=NNQwazD2cpbTwHe3ROlLZXqxf7kQ+hFyxcno6P4LHWBjPraxXZujjBTSnqQPickup+
         MBEW9IiXhU9kuQKtZJWuC/FlirCDAWQuelXbTnfri2s4jnpweZMiDc8Qi43j/V3f6KI6
         NCZrCoUl9TkvIZgLR/uJiQnA1oxucuUS/pDaL5+bUE2VkTPXUyQGjA1y3o7gJsiE7+By
         KrgjgjQTecaxRaOsF9qys23Glu/x9QW7pXpLkhbhPZW2jzXYsd8Gh4maGR+kfCb1ZnzP
         c1khRHEz27cRoG/DlllDa2TEs/Sqvry9PTgrZ/epkQes1R6fwy8hFj0nZS9SRANmFIfm
         p2TA==
X-Gm-Message-State: AFuF++lilKKAqtHR0+QUEgCoXq3Hlq//joP/eC0MUiCuDtegx/8Pk7/I
	YEPleNZ3pRoYfLwHqCXU4IlzquKvyjRBmzlzxBGyPlRWlOcq2oOY0o+R
X-Gm-Gg: AR+sD11J30tSFxoHkvYzxCr9swQ8/mF6xUM0vRBSq5N9Vgz11o7mvgdrf39vBsEoPGe
	0WpCw7T71e01Epis+sCPVPKjGpJQ9n4EG2Y8PpWlYTnJZbO4inX1buvwIzK77qscCUGiQjnNOse
	1AMjtVgi6pZ6l3tN+hO/gJJt4vy9sh3Qx/8TD29ZhHcGz/5QB93W6Fps37yIlmn8srHDMRnXjjc
	Qwx5KA9xA7pKZIHFi4zpxsOTOHgc6vrNl49B7T3n7DgqR+1qp8lXcjM2bUXRxB0mT7IvuvVMV02
	92+LIb9cwbiAoAj6VvSSpccEX0RZCb8I9tLSZTOC0XKcgwc2cvR5I+BIK1R9Ztp3up+h2RcCEsl
	7B8z+YtfpFNxjTb7tPUbDMpzLO4FMxsIQeQBoDU1l+wSeAFAK/6xHPjwKNlQHn07nJk1oiLJF5v
	qU8pGB9QZY48zHM8T8g4Kr5q1VgYsM/PPib0ufX1GRypqCO1WRsQVPFp6+Mn9xt56dgrLbRKjn/
	4qFewymiHSPGla6iiqmWir9SyKoj5PC5LjnKgdUnsY94T+WJG1ZJWXj417S+hoXkJE=
X-Received: by 2002:a05:600c:1549:b0:49c:d294:41e5 with SMTP id 5b1f17b1804b1-49cd294439fmr70006155e9.8.1788095924236;
        Sun, 30 Aug 2026 06:18:44 -0700 (PDT)
Received: from shift.daheim (p200300d5ff3cee0050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff3c:ee00:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482fbb20793sm15828052f8f.17.2026.08.30.06.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 06:18:43 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift.daheim with esmtp (Exim 4.100)
	(envelope-from <chunkeey@gmail.com>)
	id 1x0fPs-00000001Jux-0dBu;
	Sun, 30 Aug 2026 15:18:43 +0200
Message-ID: <c94fe1ab-fd2e-465c-b307-012ce15c6d5b@gmail.com>
Date: Sun, 30 Aug 2026 15:18:42 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] wifi: p54: require a full exp_if record in
 PDR_INTERFACE_LIST
To: Shengzhuo Wei <me@cherr.cc>, "John W. Linville" <linville@tuxdriver.com>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260827-p54-pda-validation-v1-0-bdc2b0675056@cherr.cc>
 <20260827-p54-pda-validation-v1-2-bdc2b0675056@cherr.cc>
Content-Language: de-DE
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20260827-p54-pda-validation-v1-2-bdc2b0675056@cherr.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
On 8/26/26 7:07 PM, Shengzhuo Wei wrote:
> The PDR_INTERFACE_LIST loop only checks that the record start is within
> the entry before reading an entire struct exp_if from it. A truncated
> trailing record makes the if_id/variant reads cross the entry boundary
> into the heap beyond the EEPROM buffer (verified with a KASAN
> reproducer of the loop). The variant also feeds the synth front-end
> selection, so this is not only a leak.
> 
> Advance only while a full record still fits in the entry.
> 
> Fixes: eff1a59c48e3 ("[P54]: add mac80211-based driver for prism54 softmac hardware")
> Cc: stable@vger.kernel.org
> Assisted-by: GLM:5.3
> Signed-off-by: Shengzhuo Wei <me@cherr.cc>

Hmm, sure.

Acked-by: Christian Lamparter <chunkeey@gmail.com>

> ---
>   drivers/net/wireless/intersil/p54/eeprom.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intersil/p54/eeprom.c b/drivers/net/wireless/intersil/p54/eeprom.c
> index 968ce9a411358e0e6b83117b1a077becc3207090..472edecf55772893afdf8be3020e6baaf80097a5 100644
> --- a/drivers/net/wireless/intersil/p54/eeprom.c
> +++ b/drivers/net/wireless/intersil/p54/eeprom.c
> @@ -817,7 +817,8 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
>   			break;
>   		case PDR_INTERFACE_LIST:
>   			tmp = entry->data;
> -			while ((u8 *)tmp < entry->data + data_len) {
> +			while ((u8 *)tmp + sizeof(struct exp_if) <=
> +			       entry->data + data_len) {
>   				struct exp_if *exp_if = tmp;
>   				if (exp_if->if_id == cpu_to_le16(IF_ID_ISL39000))
>   					synth = le16_to_cpu(exp_if->variant);
> 

