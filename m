Received: from mta0.migadu.com (out-32.mta0.migadu.com [91.218.175.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A5647A87A
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 14:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789052185; cv=none; b=qh6KyrWv56kua/oKOJ3y9Hpq48AqOF2NAoUS8KDV2nHycymbNw5LWcUu70YHMx2ftDexX4+BEeRbsOl+7Z18eaX4kpL4GLRtLIvTikMtH2uAQ3Zn9Jxyoth7te71VbeDuWsOhXxngL2nvFBKd7j4BTroTZw7Iq6GvH6Bks/NwDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789052185; c=relaxed/simple;
	bh=fGoGldEWDvUQ/iRdAxfZ6H/H4+9sW1lky3abHszVxRI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=XZKzex+qtnRas5yijWcUow2ovU9F09jkT9d4OkwjjzCisMWRlFmbKKyS0zyHRaPnqR49ic2PDcAPX8Alaa5idqTtlDEXbKPwF75ItWWsItU++gS2c6AK9OeZ8XeMUiJiqrWlRbsWcTjOMkkBc0T/R1jrl0qQHy6VVb8x7NqAJdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wD23GC7O; arc=none smtp.client-ip=91.218.175.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wD23GC7O"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fGoGldEWDvUQ/iRdAxfZ6H/H4+9sW1lky3abHszVxRI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789052180; v=1; x=1789656980;
 b=wD23GC7O0ZBfu7nuSFWr9X00jdD1K2wWybipM/7tUmvMNKkDPKe31SvWL/oC8yOTPkkNGaM8
 nlCF/eK4DKvDlE7edTd1sG39u5UxAf/MSp88nsHdtx9513TYgEEnlTG4xaI2fIweZgICBZp5YQ4
 abd76cJC+pyh0SYs4asW41AY=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 251a0a0c0b667829;
	Thu, 10 Sep 2026 14:56:20 +0000
X-Mizu-Trace-ID: 251a0a0c0b667829
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 10 Sep 2026 16:56:19 +0200
Message-Id: <DLBQ2H40DC71.2Z3B32X9JQ17I@linux.dev>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH v11 4/7] wifi: rtw88: sdio: zero the padding added to a
 TX transfer
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Ping-Ke Shih" <pkshih@realtek.com>, "luka.gejak@linux.dev"
 <luka.gejak@linux.dev>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260909074556.55709-1-luka.gejak@linux.dev>
 <20260909074556.55709-5-luka.gejak@linux.dev>
 <d6507fd0447c4c09a9c80bb57dfef35c@realtek.com>
In-Reply-To: <d6507fd0447c4c09a9c80bb57dfef35c@realtek.com>

On Thu Sep 10, 2026 at 4:24 AM CEST, Ping-Ke Shih wrote:
> luka.gejak@linux.dev <luka.gejak@linux.dev> wrote:
>> From: Luka Gejak <luka.gejak@linux.dev>
>>=20
>> rtw_sdio_write_port() rounds the transfer up with sdio_align_size() and
>> then hands that length to sdio_memcpy_toio() while the skb still only
>> holds skb->len bytes. The difference, between one and 511 bytes, is read
>> from beyond the end of the frame and transmitted. Whether it stays
>> inside the skb's allocation depends on how much tailroom the skb happens
>> to have, so this is at best sending uninitialised memory over the air.
>>=20
>> Pad the skb up to the transfer size first. __skb_pad() zeroes the added
>> bytes, reallocates a cloned skb rather than writing into a buffer a
>> clone still shares, and leaves skb->len alone, so nothing else in the
>> transmit path has to change.
>
> With __skb_pad(), it might increase CPU usage.
> Could you roughly measure that?
>

Measured with the ftrace function profiler over a 30 second saturating
uplink transfer, 18.6 Mbit/s, four cores:

  function              hits      time(us)   share of one core
  rtw_sdio_write_port  48358      26839023        89.2%
  sdio_memcpy_toio     47855      11783994        39.2%
  __skb_pad            48344        616489         2.1%
  pskb_expand_head     47869        466036         1.6%

__skb_pad() is about 2% of one core with the link saturated. The whole
transfer takes 14.8% of the four cores against 0.77% idle, so the
padding is roughly 3.5% of the CPU the transfer already uses and 2.3%
of the driver's write path. On throughput it is about 6%, which is the
A/B in the commit message.

pskb_expand_head() runs on 99% of the calls, so nearly every frame takes
the reallocating path rather than the memset. That is three quarters of
the cost; without it the padding would be around 0.5% of one core. I
have not worked out yet whether the skb is cloned or short of tailroom.
If it is tailroom it is probably avoidable, and I can chase it as a
follow up.

I do not think this is a blocker. A few percent seems a fair price for
not putting uninitialised memory on the air.

One thing to decide, though. The commit message says the padding "costs
nothing observable", which is too strong given the numbers in that same
paragraph. Do you think it needs rewording? If so, would you be willing
to amend it yourself when applying? That seems better than a resend of
seven patches for one line.

>>=20
>> It must not free the skb on failure: rtw_sdio_write_data() frees the skb
>> itself and rtw_sdio_process_tx_queue() requeues it, so both callers
>> still own it and would double free.
>>=20
>> Found while reworking this path for the RTL8723BS. Measured on RTL8723BS
>> hardware, padding the transfer costs nothing observable: uplink is
>> 19.5 to 19.8 Mbit/s padded against 20.9 to 21.1 Mbit/s unpadded in an
>> interleaved A/B, with scans, reconnection and a UDP flood clean in both.
>> The other SDIO parts sharing this path are untested; I have only the
>> RTL8723BS.
>>=20
>> Fixes: 65371a3f14e7 ("wifi: rtw88: sdio: Add HCI implementation for SDIO=
 based chipsets")
>> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Thanks for the Acked-by tag, one both patches, I will send 2nd series for=
=20
the actual driver code after this prep series is merged to rtw-next.

Best regards,
Luka Gejak
