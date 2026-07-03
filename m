Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8292B284693;
	Fri,  3 Jul 2026 15:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094042; cv=none; b=f018ewWgFVah4/LmoFY3teoMGvgSY4A5s1v3OGonlZNEgaobirFjVoFGVO7VHMGDOSUEAnz7insn7kjS1TEPl6/yvFtvH6C3Lutn6bkmSPoPmayHTuZKhTqcyflmUDSreVh3b/3AAcEqS9Z38AbfIA8o9kG9PwOjcL17kkQwKfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094042; c=relaxed/simple;
	bh=Of8gfuZu8JfiIBm5rvtKyJ4G8zZfQugnFUCpCnsoayE=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=ghleqKBREP4VQAwrIY7BfD/p5qkZQbW0SAlWo98n8ElVcPoqS4pvXMAj+PdnNcP835S3LcKmUUE+JWgzreYMQ2lZNHRARV46W6cCPGZQrr1zkvMBzG7L6w6nkM+SZ33y0kME2s7CIvABhWxkB8+ldUFH/ObeYASEQjXjS9NB0MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=J20FN6nd; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="J20FN6nd"
Received: from mail.ispras.ru (unknown [83.149.199.84])
	by mail.ispras.ru (Postfix) with ESMTPSA id B7B0145F8F39;
	Fri,  3 Jul 2026 15:53:50 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru B7B0145F8F39
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1783094030;
	bh=yiEe+navOVVj7opNjdZBuUaJUmWlRkigvM+U4LnLObQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=J20FN6ndz9fLlhFoGHVv/OS+DEzDoIYrum01qjj3/x/YiLx9v1z4g1ytWnEc9ZZTX
	 rKI9JqlGXMhZDsBiGVLJWgGEIq3fSAfI+JkWfwosOC5+Vsb+lCxmKybnWpsKdHgdPq
	 9NzN+TA+y/Oc8KodkDDgWBlgdXOMsaGUbQ6S3+ss=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 03 Jul 2026 18:53:50 +0300
From: d.morgun@ispras.ru
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
Subject: Re: [PATCH rtw-next v3] wifi: rtw89: check return values in
 rtw89_ops_start_ap()
In-Reply-To: <d58f1e279a0944529669a1e49d96cac6@realtek.com>
References: <20260629094452.8709-1-d.morgun@ispras.ru>
 <d58f1e279a0944529669a1e49d96cac6@realtek.com>
Message-ID: <6754361d578f7418fe85e1aec8a6b618@ispras.ru>
X-Sender: d.morgun@ispras.ru
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

Sorry for the confusion. The v3 suffix was added by mistake during local 
iterations of the patch.

There is no public v1/v2 in the mailing list history. This is the first 
version submitted upstream.

I will resend as v1 if needed.

Best regards,
Dmitry

Ping-Ke Shih писал(а) 2026-06-30 03:27:
> Dmitry Morgun <d.morgun@ispras.ru> wrote:
>> Subject: [PATCH rtw-next v3] wifi: rtw89: check return values in 
>> rtw89_ops_start_ap()
> 
> Patch is fine. But I don't remember why this is v3. Can you point out
> v1 and v2?
> 
>> Several functions called in rtw89_ops_start_ap() may fail to allocate
>> skb or fail to send H2C command to firmware, returning -ENOMEM or an
>> error code. Their return values are ignored, so subsequent commands
>> are executed with incorrect state.
>> 
>> Check the return values and propagate errors.
>> 
>> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>> 
>> Fixes: a52e4f2ce0f5 ("wifi: rtw89: implement ieee80211_ops::start_ap 
>> and stop_ap")
>> Signed-off-by: Dmitry Morgun <d.morgun@ispras.ru>
> 
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
