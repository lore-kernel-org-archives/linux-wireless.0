Received: from mta1.migadu.com (out-115.mta1.migadu.com [95.215.58.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3F847254C
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 08:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788941057; cv=none; b=BkaLoBdkDq81rC9aRzDO7aBvBYcTQdHZ7BmE6uF3x1OUFv3AzaA//aGh7NmdLbajXBcdo8RwbD4cO9ylBx6Wc5vsn3ZzkN9BZDat25mboBjqqYFBvUzzRppXyLvRO4sMhx+l6gSr8mj6dg+xbrKJtAIoiXpAaN0ewElVtCp/nyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788941057; c=relaxed/simple;
	bh=+YiOtvNoviFmAPJd0SLV7hxpA81Vvnm9DBR69G3110A=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=SDDQzl01LjZovgvfz9KDGpBYnb61Ea06jniXPzWVWggyXFoi5VZY+xLqjxOY6FInr1uhVA2mhBonwi4gF5sZRUc7RDo+OQ94Lgk2YvLCyHsheYOWiICBVMmGHI5j6dafKuguLkqNEj53VEBT+oTYjpHpfqOVGEffP6+I0uQ3Jcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OR9TT0Lr; arc=none smtp.client-ip=95.215.58.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OR9TT0Lr"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+YiOtvNoviFmAPJd0SLV7hxpA81Vvnm9DBR69G3110A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788941052; v=1; x=1789545852;
 b=OR9TT0LrglFG+LedIuUpLFw1MnNl+A8UKjBrZ246gkJRYe+FMU/PEWhwVs4PXXZfeDWrd0af
 QUO5T1INPseLsfZATWM3tyf2O7iHu2uAmT4HIiry0ZddLalHE4KHYbpVCmJp9jXOHgAq1EM5R0J
 eBuUgCxYOpakNPG3kNHfzS6M=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2b3856b792638ef0;
	Wed, 09 Sep 2026 08:04:12 +0000
X-Mizu-Trace-ID: 2b3856b792638ef0
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 09 Sep 2026 10:04:07 +0200
Message-Id: <DLAMOBQS6117.2OQCR1L2707BO@linux.dev>
To: "Ping-Ke Shih" <pkshih@realtek.com>, "Luka Gejak"
 <luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
 <linux-wireless@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, "Bitterblue Smith"
 <rtl8821cerfe2@gmail.com>, "Peter Robinson" <pbrobinson@gmail.com>, "Hans
 de Goede" <johannes.goede@oss.qualcomm.com>
Subject: Re: [PATCH v9 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
From: "Luka Gejak" <luka.gejak@linux.dev>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260831061144.18631-1-luka.gejak@linux.dev>
 <20260831061144.18631-5-luka.gejak@linux.dev>
 <d4a8b1203ee0402483269a31ad4d6dd2@realtek.com>
 <DL9Y9KGJKWIT.26GHPWWWG0WFV@linux.dev>
 <6a59823f69d140b1a6c44d475f5b93bd@realtek.com>
In-Reply-To: <6a59823f69d140b1a6c44d475f5b93bd@realtek.com>

On Wed Sep 9, 2026 at 7:36 AM CEST, Ping-Ke Shih wrote:
>
> Luka Gejak <luka.gejak@linux.dev> wrote:
>>
[...]
>> On Sun Sep 6, 2026 at 4:22 AM CEST, Ping-Ke Shih wrote:
>>>
[...]
> Will/should you add this in v10 or v11 before your patch 4/6?
>
> As your v10 didn't get ran by NIPA because of [1], you can send v10 with
> RESEND or just send v11 (including the additional one).
>
> (To answer the ordering point question below.) I prefer to have the patch
> in advance, for two reasons. One is to backport easier, and another is to
> clear to know it is existing problem.
>
> [1] https://lore.kernel.org/linux-wireless/fe0d8a3c2951c051b321902582eaf9=
5f230a754d.camel@sipsolutions.net/T/#u
>

I have decided to send v11, with the fix as patch 4, ahead of the accountin=
g
patch. Your two reasons are better than mine, so I have dropped the plan to=
=20
send it afterwards.

It is not gated on anything, so it does change behaviour for the other
five SDIO parts: the padding they send is zeroed now, and a transmit can
fail with -ENOMEM if the skb has to be reallocated. That is called out in
the Scope section rather than buried in the changelog.

One consequence worth flagging. The back-pressure patch stopped retrying
-ENOMEM in v10, because with no padding in the series nothing could
return it. It is reachable again now, so the retry is back. Without it a
stopped access category has nothing left to kick it. That patch is
therefore code identical to what you acked in v9; only its comments
differ, so I have carried your Acked-by.

[...]

> In v10, the beginning of rtw_sdio_write_port_8723bs() and
> rtw_sdio_write_port_generic become the similar. And
> I think ' txsize =3D round_up(skb->len, 4);' is not necessary to
> rtw_sdio_write_port_8723bs() because it is 512-byte aligned.
>
> Therefore, you can do the same thing in rtw_sdio_write_port() and then
> call=20
>     rtw_sdio_write_port_8723bs()
> or
>     rtw_sdio_write_port_generic()
> by condition.=20
>

Done. rtw_sdio_write_port() works out the transfer address and the
aligned size and passes both down, and the padding stays there too, so it
runs once for both paths and outside the credit mutex.

I kept the separate length in the RTL8723BS path, though, and I think it
is needed. It is not the transfer size, it feeds the page accounting:
rtw_sdio_check_free_txpg() and DIV_ROUND_UP(txsize, page_size), with a
128 byte page. The chip charges pages by the frame length rather than by
the padded transfer, which is what the vendor driver does, and the two
differ just above a block boundary:

  frame   pages by length   pages by padded size
   513          5                   8
  1025          9                  12

So using the aligned size there would charge up to three pages per frame
that the chip never took. There is a comment on the line now saying why.

[...]

> Will this be needed by the additional patch
>
>    "wifi: rtw88: sdio: zero the padding added to a TX transfer"?
>

Yes, with pad_size declared at the top, computed unconditionally, and teste=
d
with if (pad_size > 0).

[...]

> I will check this by v11, because I'd like you can have v11 with
>
>   1. "wifi: rtw88: sdio: zero the padding added to a TX transfer"
>   2. move the same beginning of rtw_sdio_write_port_8723bs()
>      and rtw_sdio_write_port_generic() to rtw_sdio_write_port()
>
> Is it okay to you?

Both are in v11, so yes.

>
> Ping-Ke

Best regards,
Luka Gejak
