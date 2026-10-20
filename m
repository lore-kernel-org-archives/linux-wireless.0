Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.103
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792533461;
	b=vLy6oEUm9f/epg9iUnLREMbEQhLKmNG4oWGexy8G+GOJ5aDcsYXn8aRJdZ3Stp/Gefvk
	 4D4l4Mhhrm5rpKpKdoqjY9gz2Aaw6WDD76gFm8wsdUeexH/+DU5kpg7C9Bf3TZgdKbP97
	 QeW2NuJ8J8fsJZIFecyqr4JksLCkgEx6fOBwsqDmgczG1FrV+84KaqSWeRJ5AaoEIVBjP
	 wReomgqy4spkNtzXB8QGQfIzzsivczDB8D48MuX3NfyDrYiztYIMcxXHB8UuT15jh0Abn
	 9M0yJgXA4fxCK3KLFEqoZM7yrxcZhGCUxR2WECvmHorGchiIOtXNqsI1D3M5w4VOWag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792533461;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=QK/YljhqoxIaQvyPSrRlCKIVyw6mUGuU9xXtkL4C7Ow=;
	b=bYFA8DtON1Zf/0AQcqLD5m7l5kkjIJwbnZJtAMFesLeDXocjaJnei90BwZfNGkmkAQfV
	 T7urbkVJsjS/ISaJV9JzZ2/PAZgMcj+Q7DjaH7PbB163QXQMGv8yXUyLcZAnIe9IHduqJ
	 k15MQOas9g3DwnvhfkXowuYvx0tUdQpT6iEmi6WG5YDRVN11qIQmbmgxsuyq22ymtoeus
	 x5GkRwUpIMy8FeEh2chfgyT0re9k1GfGdmiQxpxVUiw2MKlue/BUPh6FhF5MtntdffUC4
	 UeXEj7j1O/H1LdGeIHf3M/tC9XF4wC0xs98221eP+2Dl6rvKQuRXo+30qP+ec6MBL8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pm.me;
	spf=pass smtp.mailfrom=pm.me;
	dkim=pass header.d=pm.me header.i=@pm.me header.a=rsa-sha256 header.s=protonmail3 header.b=mD2I4jbw;
	arc=none smtp.remote-ip=185.70.43.103
Received: from mail-43103.protonmail.ch (mail-43103.protonmail.ch [185.70.43.103])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34FA606A31A;
	Tue, 20 Oct 2026 21:57:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F34FA606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pm.me header.i=@pm.me header.a=rsa-sha256 header.s=protonmail3 header.b=mD2I4jbw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1792533457; x=1792792657;
	bh=QK/YljhqoxIaQvyPSrRlCKIVyw6mUGuU9xXtkL4C7Ow=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=mD2I4jbwM1t2n0zEzBF58s3i4Yl9x031D0cRFJ22yO0dYhu9eGMXJejJiuPB7Sxdg
	 SItKeeMleUAQ2UDulZwBqDAnEviCud6SHDEqcR3VQUVfyTXZn4xVx3qnci/7StLixs
	 tXdYLLX7wYv01FdvQwZEP4//8zv7y/h9SMn3YNWbKmc1BTFMNOmAnxJiQ0ZpYkgCXL
	 CSNDgmpWbrg8hDEq2kTNis4Uwa9h6e4VsnXh76etbphLkBk2gIxm5GNCwFOwkmgoWk
	 xJ+UfkOOowW7EyCxPHCiGKuUOjsozkxGK6wDnfhdLl1xV/qnncYgpOyqO26o/+JVsn
	 vRP9ByPhtpgRw==
Date: Tue, 20 Oct 2026 21:57:32 +0000
To: Jeff Johnson <jjohnson@kernel.org>
From: Birk Skyum <birk.skyum@pm.me>
Cc: Baochen Qiang <baochen.qiang@oss.qualcomm.com>, Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>, linux-wireless@vger.kernel.org, ath12k@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: ath12k: don't count a vdev restart as a started vdev
Message-ID: <179253344933.341.13555520643136725760@pm.me>
In-Reply-To: <20261020213505.31624-1-birk.skyum@pm.me>
References: <20261020213505.31624-1-birk.skyum@pm.me>
Feedback-ID: 21326998:user:proton
X-Pm-Message-ID: 16f2dbbdf0422d27200edafa112b129d38041074
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 20, 2026 at 11:35:05PM +0200, Birk Skyum wrote:
> With this change the Yoga went through the AP's next switch of that
> link, from channel 128 to channel 36 at 80 MHz, without a single
> timeout, and the switch completed in under two seconds.

A few minutes after I sent this, the AP also widened the same link from
80 to 160 MHz on channel 36. That is a bandwidth-only change like the
one that started the timeouts without the patch, and with the patch
there were still no timeouts afterwards.

