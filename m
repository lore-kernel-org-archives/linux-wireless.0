Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED92282F08
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 06:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785046643; cv=none; b=J1vv7g0BzHH4b7aiq+c7aVfUxoDZflF6OyTjBGHy0rVaw+Mh7whvvIQM52aj6u7M+t1aTNd6qD9JXxCfE4yK1+/43K590+lPQG9PQYsFTf/q6k673yinH+Cph0I2he1+ZLx0daciZYtgGISQmAeqRUuJUzRncdnCWFA+pJ4T8OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785046643; c=relaxed/simple;
	bh=UmbjpzObP5waVp8I4ae3ONdwvkJm1f60CkHPAfjsl/E=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=DYi06vq6pAb1/FYP5XttfAwxAPIyCIAUxXpsktCiLNWvo3Rpb7q7n8o8zp49xU68TfGU/nVurh7J62QfJ5q1jTMM+XSjPpCFgInornIPzYFlg/oE6wDhKb/+JzwyZ7QQjhm4Vp0PI1DuhtaeARgLgS6DxR780PDiht6kw1p9Jjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UQHtE0n4; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UQHtE0n4"
Date: Sun, 26 Jul 2026 08:17:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785046638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UmbjpzObP5waVp8I4ae3ONdwvkJm1f60CkHPAfjsl/E=;
	b=UQHtE0n4y/hMbuff9us+qTJPIOKFiPVa8J39qLyIaUmkRm9NL7/RBipWjahJ2Phq9ZtOUh
	p7LnYLRI0tMNQ8EREUUqZxE26WnZPvhcTKyWRvb0XRZBdAditumspVF0aQTBGsgj2LApZW
	OR6/RM414cFQK2Jhh70z0V6xCluctUg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>, Bitterblue Smith <rtl8821cerfe2@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>, luka.gejak@linux.dev
Subject: =?US-ASCII?Q?RE=3A_=5BPATCH_13/19=5D_wifi=3A_rtw88=3A_sdio=3A_set_up?=
 =?US-ASCII?Q?_RX_aggregation_and_interrupts_for_RTL8723BS?=
In-Reply-To: <25a64bfc14c14c9ebe544d5d55bc8a45@realtek.com>
References: <20260724181858.192903-1-luka.gejak@linux.dev> <20260724183235.196908-1-luka.gejak@linux.dev> <8ded63af-64cf-484b-977b-e4458278f9c1@gmail.com> <25a64bfc14c14c9ebe544d5d55bc8a45@realtek.com>
Message-ID: <1EE071EB-219E-4C33-AC0B-D5562D6212AD@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On July 26, 2026 3:35:02 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=2Ecom> =
wrote:
>Bitterblue Smith <rtl8821cerfe2@gmail=2Ecom> wrote:
>> On 24/07/2026 21:32, luka=2Egejak@linux=2Edev wrote:
>> > From: Luka Gejak <luka=2Egejak@linux=2Edev>
>> >
>> > Enable the existing RX aggregation setup for this chip and select the
>> > larger DMA aggregation mode it needs=2E The RTL8723BS does not raise
>> > CPWM1, so leave that source out of its interrupt mask, and set the SD=
IO
>> > TX control bit the vendor driver uses to have transfers always
>> > recognised=2E
>> >
>> > Interrupt status is also acknowledged differently: write back only th=
e
>> > bits that are actually defined, and for this chip only those that are
>> > unmasked, rather than writing the raw status word back=2E Writing bac=
k
>> > undefined bits leaves the RTL8723BS raising a persistent interrupt af=
ter
>> > resume=2E Note that restricting the acknowledgment to defined bits
>> > applies to the other SDIO parts as well=2E
>>=20
>> Why does it apply to the others?
>
>Luka, could you answer Bitterblue's questions before sending v2?
>You might write the change in cover letter of v2, but it is very hard
>for reviewers to know if you did changes based on reviewers' opinions
>or you have different reasons=2E More, please give reviewers more time to
>discuss entirely=2E I don't know that I should reply your v1 or v2 or RFC=
?
>
>I admit that I have not yet reviewed your patches, but it gets harder
>to me since there are many versions=2E=20
>
>Ping-Ke
>

Understood, I am sorry about that=2E I will reply to individual emails=20
instead of sending new version from now on=2E Basically all his comments
were addressed in v2=2E Also how long should I wait, because I thought=20
it's the best if I send new version which is ~500 lines shorter so=20
there is less to review, but I will wait if you want, just tell me how
much? Right now latest version is v2=2E Do you want me to respond to=20
Bitterbind's individual emails now or do that for any new comments in=20
v2?
Best regards,
Luka Gejak
