Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9159C4582E8
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 21:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790803653; cv=none; b=H91tDzCBFpyMlp1UN+aet9EGA/UunyVTFSmDqTviDBFYA1qHYLAFo4eX/9tquUVSEnj6o0ujB5l9TGavr3g0I9bly4fCLzyUxWhVirVwwdaMkvy9X1GHkXfVOYMzmT7aPuQdsiHVI6vR7gBW/qQ2/SfAYOQlfV5qLBr5y3TVuL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790803653; c=relaxed/simple;
	bh=GL2o4FVLqBPGPIRDnXslh1vUMxGYOsJ4oCsKqxuh3/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WNXalvqV3jfQGle/HghtAirdEBhHaDOYIyVo4XwsHummZzXstGjkX2CSdtBQAKIxFSXdoVQiMLF6XzDNwmx8rSW27Av/6LeIy6VpWUisMphBVMXJD1DOs8kAYNVLM546W9WEjTaPha/AXJuhmBeuMjvwJa1NopFkAJ4xxHV/Mak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qAUXYcU1; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qAUXYcU1"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48afe3b2383so1018812f8f.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 14:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790803650; x=1791408450; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z7KfyD0VkItlqoFBW9ZQYHXnAAPT1pC1HgM3q8QCFUs=;
        b=qAUXYcU1nTV8RMn9Y9gbign8OoxSdZ2JAl+7ru/m43UjeGxoNVikEyYRlrao+F1E3A
         7ZJP7iwI+naJ5ZK6dkmZHkiENaoeQiaCywBUH4QuOqV0dLmTM29r15YPQ1qQSyGhzgfS
         9lzSqKU5PVfDSrNt96eC3ywEcYjMLoNCbUZPf/RdMWAz4RVeM/Yp6dVmHGtU8gKP0EPs
         BPj+jJLZ89PWYhhrgcW1aWzsWfRf6v6y2NKwHi5rW2/1X5WwoMfFSD00r8MgpseY6SBc
         fewFLZ/UFig7p4uZ5NaqozbS9okovz4MnL3j5jIZe/0uugZvo8Rgujbn9RuQvDTij6JJ
         7dPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790803650; x=1791408450;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z7KfyD0VkItlqoFBW9ZQYHXnAAPT1pC1HgM3q8QCFUs=;
        b=dlrtVwCqsxMLXyvyQbvIWd+aQX04tS43B25GOtPoT7nAz+ul5RQRQDccCAl3dsKySB
         9P6Mp4z9wJv/d1oKZ19ycPuc0EJ4KsUwCkNdhxk4x5omwo1qap9iDogr4AQAgmO29IXS
         FaATlm0Uzqmtc7T4Yo/pOYhyItU3eUrs6uTng+vZlJXoPML/H2BzHdrraxJHLcLxL9yH
         aYRpG2SYI+3ufQcJBE3HYVz65ZjLIF3OFco4rjKiK9jJkSfEvZC4Bj7Ssja1nMaR/nbY
         Om89s0rmG1LQ7728BQfO8aVOimzKC7NzEIJ51nsPuwnWOc59OQm6MJkWIwwwJnJfyTrK
         ZM2Q==
X-Gm-Message-State: AFq9FYJaAe+FVCGVGheKEihrT+zk3xdLnAc49jM9ioOtwhHa+8xKu9AM
	JLgbJ8SOc2farPzWH4owpiNtRVLRKrylVP+NWquewz7/xCC1qtwd3wDt
X-Gm-Gg: AYBFou2OagLaFlKVaMWPCE1FcUb8jA++/cJKqGo1QGh9/6uv5J5JU7UdKs3wc0xXV0s
	UNPDIn0Z5PwNNe2zVU5noFgXhxyW1Oraj9x3+VDFT5k8yopDs+ZlVN05TZ/eUkxpUjm5+MT3pEU
	oaC+dZm6EwOuwH1JjfmwblcT3/umCeA19DMKRSO962B2Bo4w2yML67pGSocLfxod18wsZgRL2sw
	T/wM33mkXi4nM8rsiEkuZMajItsScOuiZWBxdmxyHYaKF2Qycnu23NLX+HEtSISbChqt7rZfby+
	vBc4uZfc7+VZsC1JMp7jYX2TsHqnurp6fe91RQX2P48RHdsjv6IrApkhUs16QFzo4pHhkHeO56l
	qHn+crEWNiU9eRX6kwfWoX3QUQiVKT/nniHTwfHxPszgZ35UsvA/ltM691oFf3Wq2HIrtTYfnWN
	1xvu2iIc5HlshSBYWKCzH11G/chZIHu2zUxGaV7R746GHfLlLiME35PZOkBoHHVpsaOnRah9lgt
	Btz9kw=
X-Received: by 2002:a05:6000:310d:b0:485:8c16:a32d with SMTP id ffacd0b85a97d-48b0250afc2mr4988687f8f.34.1790803649614;
        Wed, 30 Sep 2026 14:27:29 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b0691cdbesm1606033f8f.24.2026.09.30.14.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 14:27:29 -0700 (PDT)
Message-ID: <a6ea2df9-b2c9-4417-ade4-f3947f36d139@gmail.com>
Date: Thu, 1 Oct 2026 00:27:26 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 rtw-next 2/7] wifi: rtw88: assign the RCR per chip in
 rtw_core_init
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260930091604.52891-1-luka.gejak@linux.dev>
 <20260930091604.52891-3-luka.gejak@linux.dev>
 <d398a8dd-a182-4e69-8f5e-12a820594093@gmail.com>
 <3c53130d1d4738a9b3173806264fc1d0b5682072@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <3c53130d1d4738a9b3173806264fc1d0b5682072@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/09/2026 23:36, Luka Gejak wrote:
> September 30, 2026 at 20:03, "Bitterblue Smith" <rtl8821cerfe2@gmail.com mailto:rtl8821cerfe2@gmail.com?to=%22Bitterblue%20Smith%22%20%3Crtl8821cerfe2%40gmail.com%3E > wrote:
> 
> 
>>
>> On 30/09/2026 12:15, Luka Gejak wrote:
>>
>>>
>>> The receive control word is the same for every chip today. The generic
>>>  default is written in rtw_core_init(), so a chip that needs a different
>>>  value has to overwrite it afterwards, in its own init path, far away
>>>  from where the default is decided.
>>>
>> I still don't understand why RTL8723B(S) would need a different value.
>>
> 
> Because 0x700060ce is what the vendor driver leaves in REG_RCR for this
> chip, and it is what rtw8723x_mac_init() already writes for it. I have
> both from tracing this card: a register dump at the end of
> rtl8723bs_hal_init prints RCR=0x700060ce, and the same dump in rtw88
> matched it field for field.
> 
> The default is a different filter. It sets BIT_PKTCTL_DLEN, which the
> 8723B vendor HAL and rtlwifi's rtl8723be never set, and it clears
> BIT_AMF, BIT_CBSSID_DATA and BIT_CBSSID_BCN, which the vendor value
> sets. Four bits in total.
> 

It will work fine...

> That value does not survive rtw_core_start(), which writes REG_RCR from
> hal.rcr after power_on. The field is what keeps it. BIT_APP_FCS is the only
> bit added on top, because rtw88 advertises RX_INCLUDES_FCS.
> 
> Best regards,
> Luka Gejak

