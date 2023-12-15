Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801A825106
	for <linux-wireless@vger.kernel.org>; Fri, 15 Dec 2023 11:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="aTc0bpoy"
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
	t=1702639449; bh=a2nA+vcev0CWSencr25dbaYWw8AO+pxJHaityAKCPy8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=aTc0bpoym0O9xwelVZGqSrqOc+L1EJfO8H2h6sOZHNGrJJ4ywy9cXsK3CswIqDMF4
	 MBYOZxD9z5ppTjo/yF5TaOCspSlUzcuEIpAu8xQ4FlmqZKLTIQUhN5qlRtxUD+aAK+
	 PrR3M0Nx8HCxdsQMT25s9kxggdh3h9ly+hS0tBCPqAMRkJQo7CQ3dGMQx4OeWpSqty
	 03KIoImBfafhA/1vRlw5MD74ArC4FYJtCGKvfnCeC3PIeO01CzTs/I+w3ktf1xIe+f
	 JYCK+LL3hXth5cZW/IdK9ubM2h0lQ8PNR6AQFb9sHjiHbsMIxMVNW5vU5ngJMWWKkG
	 idUhZBsKP9Cuw==
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Kalle Valo <kvalo@kernel.org>, lvc-project@linuxtesting.org,
 linux-wireless@vger.kernel.org, Dmitry Antipov <dmantipov@yandex.ru>
Subject: Re: [PATCH] wifi: ath9k: fix LNA selection in ath_ant_try_scan()
In-Reply-To: <20231211172502.25202-1-dmantipov@yandex.ru>
References: <20231211172502.25202-1-dmantipov@yandex.ru>
Date: Fri, 15 Dec 2023 12:24:09 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87bkarzp2e.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Dmitry Antipov <dmantipov@yandex.ru> writes:

> In 'ath_ant_try_scan()', (most likely) the 2nd LNA's signal
> strength should be used in comparison against RSSI when
> selecting first LNA as the main one. Compile tested only.
>
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
