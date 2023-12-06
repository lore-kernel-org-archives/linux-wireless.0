Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="upHrR79U"
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D452D18D
	for <linux-wireless@vger.kernel.org>; Wed,  6 Dec 2023 14:52:42 -0800 (PST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
	t=1701903160; bh=DczOegt1+I90oTxtgqgKOl5ZDtesbrsjx0yi+MFHP4w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=upHrR79UXAAIfnW8H2OGD+SXGNkVNOcLdv2Pn708Pf1X2hi9SeX0m0/du/9Avatdj
	 m7OHomMIcA1rnDR6S+0fmceOxvPPwhxBXmoURWm7g1oLTnVdnJG1EpMkcvnQ38hNWp
	 DtnumeHZ26pRzvAViR4pQQQdpQsYAxUvW3pEvGdDfbxsTs8Ro1IhjDsMw82/iqDE1C
	 H5y4QTV7qCBBmu+Rye5IXCLHK6W8a71sODE/Di0qpyE8cZ+uoAUhbe1ZeF2NvvI6dk
	 /0mvxGWQpnFGi4HB/WLqe2Aa9Hpb9AGyHFU9ZwyyqhZlgSUp8G6WXlVDh3bPpJuvxx
	 mGCroeL2WvgQQ==
To: Dmitry Antipov <dmantipov@yandex.ru>, Johannes Berg
 <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Dmitry Antipov <dmantipov@yandex.ru>
Subject: Re: [PATCH] wifi: mac80211: cleanup airtime arithmetic with
 ieee80211_sta_keep_active()
In-Reply-To: <20231206060935.612241-1-dmantipov@yandex.ru>
References: <20231206060935.612241-1-dmantipov@yandex.ru>
Date: Wed, 06 Dec 2023 23:52:39 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87v89bkkp4.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Dmitry Antipov <dmantipov@yandex.ru> writes:

> Prefer native jiffies-wide 'unsigned long' for the 'last_active' field of
> 'struct airtime_info' and introduce 'ieee80211_sta_keep_active()' for air=
time
> check in 'ieee80211_txq_keep_active()' and 'ieee80211_sta_register_airtim=
e()'.
>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Sure, this seems like a reasonable cleanup!

Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
