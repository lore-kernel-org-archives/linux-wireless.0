Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEBF3659E0;
	Fri, 13 Mar 2026 07:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773385967; cv=none; b=PRfdDD33SGxPeQJK386wi+0xr/d0u/yLAvrNqojOqYJk0Txn3C9pdOH90ZbbJ++k2+K9hdgv3rL897xjyGHTzQi9T0iVjP/gOS9dU15smCoYUENnTGLMz0yjpdWZqpRBvxyq8kUnZzlZ0j4Cpq4Z1N4tkdBCFTo/ydFiCxEOaVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773385967; c=relaxed/simple;
	bh=OhLfeHTAadTVuXB1MC45XSgW0SYGaOnJQ/Lz3vnYClM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XviBAFtDYhhdLDTT2680dXWczz2gsN4eg3usvpW9YuONC394PDM6U6sCfrnrj7fz+Uu2qmp95RBEfSE1KXq6WB4NP+YMyxO50+0rjiKhlMQPOhxUP2oyASHi+E7dpz0Wet/Ti/Kummhv1ZwRUvwDztxDiGCu5PBvZd5xBSEVpuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=kC7YnIan; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="kC7YnIan"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=llOWcWbfVoHqUkpws6uG45xBYs8atVA0Jk2++iH0g0Y=;
	t=1773385966; x=1774595566; b=kC7YnIancwtGCNpFcpYejqaeWLktZ/flRWQ/i1FPQpSA6mk
	UwJpW5/VlEPO1PS+cKbcSbz8grmyibqj4jxbZl30+FpeKk5wIGO7HjaJsObaJifAXWNtV36f3UM88
	Q1TxkKUFDXZ3LVEN0q4K/jZ47UuLRjGcZCcnhts8onPDMvBjeFpzKx7dE5ns43IMJUMGfcFkee0JT
	NdNTxq48HfTxsIQm8EJJTc8raqZy0I48eKCbjQYXzJ6opX05NpsX+sHqMgLuI05v4ZxH80vYnrTmF
	YokSXPAa8WIxN026UGveVGIWh5zyf3UZWu/cjmyplB2Qd0KvL2nOSCA+3yvwSsZQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1w0whK-0000000Gmph-290j;
	Fri, 13 Mar 2026 08:12:38 +0100
Message-ID: <b1c14b931bf62b114ca44c18f2724a601efa76f5.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: fix WARN_ON_ONCE in ieee80211_tdls_oper
From: Johannes Berg <johannes@sipsolutions.net>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+56b6a844a4ea74487b7b@syzkaller.appspotmail.com
Date: Fri, 13 Mar 2026 08:12:37 +0100
In-Reply-To: <20260310160013.515096-1-kartikey406@gmail.com> (sfid-20260310_170025_576156_E5C4B1FB)
References: <20260310160013.515096-1-kartikey406@gmail.com>
	 (sfid-20260310_170025_576156_E5C4B1FB)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2026-03-10 at 21:30 +0530, Deepanshu Kartikey wrote:
> =20
> -		WARN_ON_ONCE(is_zero_ether_addr(sdata->u.mgd.tdls_peer) ||
> -			     !ether_addr_equal(sdata->u.mgd.tdls_peer, peer));
> +		if (is_zero_ether_addr(sdata->u.mgd.tdls_peer) ||
> +		    !ether_addr_equal(sdata->u.mgd.tdls_peer, peer))
> +			return -ENOLINK;
>=20

I think that check needs to be earlier, otherwise side effects happen
(TDLS_PEER_AUTH flag).

Also, I'm a bit confused, how is it possible the sta_info_get() worked,
but there's no TDLS? Maybe really what it needs is

                sta =3D sta_info_get(sdata, peer);
-               if (!sta)
+               if (!sta || !sta->sta.tdls)
                        return -ENOLINK;

instead?

johannes
