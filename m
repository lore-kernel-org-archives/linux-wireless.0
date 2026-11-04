Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.145.95.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793793865;
	b=Cx0l2qEo0kJRwTPL58Sd3I3YquLlWHvUjkYcNijdGc+oHpUbSOjKL+uWT5UijjcaAbWt
	 UQSyKfegpJBSPfCK4QUV4ElOhEBz23BjqkH78VbfJsH2z2IyFyiVW2zOptOeWz5IQkT/g
	 /UOTNPYimepfxPsubxHWUz1/ZBv/wrIzaXaZTkhCWxdDv42oC2jMo/6tbprMp3NIYchS9
	 b5Vlky0Daw6J93zfU/G/B0JC03ATfdVasjAJbrPgiUC6oubPL3EpJ9+f7ok0jGl6lxSiS
	 abk4JRb7DL7HCz8ELV9pP330HBEDJFQfVQTMrj0aL0DfENsIZBOUkerY43ObeihrG/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793793865;
	h=DMARC-Filter:From:To:Cc:Subject:In-Reply-To:References:Date:
	 X-Clacks-Overhead:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=6LhVpHuQuNnLZdsiMRfy+IJqKRCJX8Bucw7BXFp09ZU=;
	b=jUKCUfVdLUR3TzXFyJ8opn0uhmk+MNI38l4uD2vA6rY/rFmQgHSBfwVDo9ohCFSoHsUL
	 WsWLpy83P6MFNioMwinH+dZObab1zs6qgqhnjaF8cXB9P8czWmSSUxk0XaZ9xSWTSeTxb
	 z0SzADg2EDQKdIOtzumCt2va7wOY6Kl1Y79mqJWG7hFCHsU3/HXOxit3DGTt+AdXsvmpX
	 TVCfoIW7JrSPLnyRl6C3wtqwQFFTUNpVImAeW6M83cphAAkorlXErDp6bxhTXt1IwjR3V
	 S5072Y/iEygHv7Ec+s9WrQB+0jN83fiVI1Gg52oohI0JwoLe57+0zwvBDRl/H8BRtjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=toke.dk;
	spf=pass smtp.mailfrom=toke.dk;
	arc=none smtp.remote-ip=45.145.95.4
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B16D606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 12:04:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B16D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH wireless-next] wifi: ath9k: uninline
 ar9003_paprd_create_curve() helpers
In-Reply-To: <20261103164331.d661e4447139.I759358de0d74f858b9410a5db6918cd7e12dd877@changeid>
References: <20261103164331.d661e4447139.I759358de0d74f858b9410a5db6918cd7e12dd877@changeid>
Date: Wed, 04 Nov 2026 13:04:14 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87pkwkpzup.fsf@toke.dk>
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

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> ar9003_paprd_create_curve() calls the two helpers, but
> if they get inlined the stack can exceed 1k with clang,
> causing warnings/errors. Mark the two helpers to not be
> inlined due to stack ("noinline_for_stack") to fix that.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
