Received: from mta0.migadu.com (out-190.mta0.migadu.com [91.218.175.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF80C384CEC
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 15:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789055522; cv=none; b=pCHJyR+KrtG7mtP1BUCchoWYhgkkOJq/1lBux0ukKD6TYpx/yJey3JyTu9VnVjioLhYISBzxdpgwVNjpLW/IK2Ey72XU5nQnVrf6GlxCRfvVOA/CVJ9/ks76S7CK3laZ3gEBOV30tgaKSuJaSFQvx2fidCsJ2OWIsEMrdLKjvJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789055522; c=relaxed/simple;
	bh=4l8RcTxQx86XUUy4e/BXSOpcQXZho9nSHatN5fQ+aIk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=e9EKyanmGuBShpLM1IqfvsnXI9qsOyCOySAfyf/7PgGr41r432TWXYR9OXo9PBIn9bczPgSCXIwuftLszmKfOfGkW4SJvGEokAWTwFpv+JIs2rgoOa/NHnLXvJ6QrlTdJvwRb/jreO1JF9UNmglmV8SqR9KkFA8FytFPkW9Bdnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=saoAyadz; arc=none smtp.client-ip=91.218.175.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="saoAyadz"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4l8RcTxQx86XUUy4e/BXSOpcQXZho9nSHatN5fQ+aIk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789055517; v=1; x=1789660317;
 b=saoAyadzmlEj2D6zs1QULVjhNb38MZBYVykNgqUPInikkzF/OtoFa6EaN3SBg4uI9RWkumF1
 Ttb6xOlMtokvK8xW0Tw2VsgEOQ7rBILpQtYuKYdb3HIWz0ycHBSSxcxtznUxzs52Tyo1cZlleNg
 EkxFz4wNTvzZvfzeAtEQeeNo=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 372dbca48d95678d;
	Thu, 10 Sep 2026 15:51:57 +0000
X-Mizu-Trace-ID: 372dbca48d95678d
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 10 Sep 2026 17:51:54 +0200
Message-Id: <DLBR915C5L0S.1TEYXZ8LADNTH@linux.dev>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH v11 4/7] wifi: rtw88: sdio: zero the padding added to a
 TX transfer
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Luka Gejak" <luka.gejak@linux.dev>, "Ping-Ke Shih" <pkshih@realtek.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260909074556.55709-1-luka.gejak@linux.dev>
 <20260909074556.55709-5-luka.gejak@linux.dev>
 <d6507fd0447c4c09a9c80bb57dfef35c@realtek.com>
 <DLBQ2H40DC71.2Z3B32X9JQ17I@linux.dev>
In-Reply-To: <DLBQ2H40DC71.2Z3B32X9JQ17I@linux.dev>

On Thu Sep 10, 2026 at 4:56 PM CEST, Luka Gejak wrote:
> On Thu Sep 10, 2026 at 4:24 AM CEST, Ping-Ke Shih wrote:
>> luka.gejak@linux.dev <luka.gejak@linux.dev> wrote:
>>> From: Luka Gejak <luka.gejak@linux.dev>
>>>=20
>>> rtw_sdio_write_port() rounds the transfer up with sdio_align_size() and
>>> then hands that length to sdio_memcpy_toio() while the skb still only
>>> holds skb->len bytes. The difference, between one and 511 bytes, is rea=
d
>>> from beyond the end of the frame and transmitted. Whether it stays
>>> inside the skb's allocation depends on how much tailroom the skb happen=
s
>>> to have, so this is at best sending uninitialised memory over the air.
>>>=20
>>> Pad the skb up to the transfer size first. __skb_pad() zeroes the added
>>> bytes, reallocates a cloned skb rather than writing into a buffer a
>>> clone still shares, and leaves skb->len alone, so nothing else in the
>>> transmit path has to change.
>>
>> With __skb_pad(), it might increase CPU usage.
>> Could you roughly measure that?
>>
>
> Measured with the ftrace function profiler over a 30 second saturating
> uplink transfer, 18.6 Mbit/s, four cores:
>
>   function              hits      time(us)   share of one core
>   rtw_sdio_write_port  48358      26839023        89.2%
>   sdio_memcpy_toio     47855      11783994        39.2%
>   __skb_pad            48344        616489         2.1%
>   pskb_expand_head     47869        466036         1.6%
>
> __skb_pad() is about 2% of one core with the link saturated. The whole
> transfer takes 14.8% of the four cores against 0.77% idle, so the
> padding is roughly 3.5% of the CPU the transfer already uses and 2.3%
> of the driver's write path. On throughput it is about 6%, which is the
> A/B in the commit message.
>
> pskb_expand_head() runs on 99% of the calls, so nearly every frame takes
> the reallocating path rather than the memset. That is three quarters of
> the cost; without it the padding would be around 0.5% of one core. I
> have not worked out yet whether the skb is cloned or short of tailroom.
> If it is tailroom it is probably avoidable, and I can chase it as a
> follow up.
>
> I do not think this is a blocker. A few percent seems a fair price for
> not putting uninitialised memory on the air.
>
> One thing to decide, though. The commit message says the padding "costs
> nothing observable", which is too strong given the numbers in that same
> paragraph. Do you think it needs rewording? If so, would you be willing
> to amend it yourself when applying? That seems better than a resend of
> seven patches for one line.
>

Following up on the padding cost, since I said I would find out where it
goes.

It is tailroom, not cloning. Over 70000 padded frames, none were cloned:
frames average 1575 bytes and need about 471 bytes of padding, but arrive
with about 106 bytes of tailroom, so __skb_pad() reallocates on 98% of
them. mac80211 reserves IEEE80211_ENCRYPT_TAILROOM, 18 bytes, and offers
no way for a driver to ask for more on TX; extra_tx_headroom is headroom
and extra_beacon_tailroom is beacons only.

So I tried the other way round, a preallocated per-device buffer: copy
the frame plus the zeros into it and transfer from there, which avoids
the allocation. Interleaved A/B, 20 second uplink runs:

  mode         throughput   CPU (4 cores)   __skb_pad
  __skb_pad    18.6, 18.3      14.3, 15.0    444, 449 ms
  bounce       19.0, 19.8      13.8, 14.3        0 ms

That recovers most of it, roughly 2% of one core and 3 to 5% of
throughput.

I am not proposing it for this series. It is a workaround for the
missing tailroom knob, it costs a copy, and it is only clean where a
lock already serialises the transfer, which is true for this chip but
not for the generic path. If you would rather have it as a separate
patch later, or think the tailroom knob is worth raising with Johannes,
I am happy either way.

Best regards,
Luka Gejak

[...]
