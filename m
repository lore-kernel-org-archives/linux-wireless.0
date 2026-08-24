Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCD044C4E2
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 16:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787588851; cv=none; b=K3nog9B9Jc3O5rrng08xBjLTzr1V4ivCCTiVaLufJbKIip8+/zP2tWzreoM3/w0unC8tA3g+lGvYPL72/24NNz18nvlYdKSr1JlBHqktWSyBTeQz3B7tTXHoWJH82Ev5sXBYjWeUopLmZdSfHwflfRVpXtUPmkA5QUeosratKRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787588851; c=relaxed/simple;
	bh=Ep3ck9N/jvs3cF44C0/VE95d2D8JsOMgRgb43GntNG4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=IcU3WjB/toAntHz7H7fuLGgYUKXTWKN6mUDBYGZJMktQhRYVZ9NOEa5SEoucA/p5TYe5vKXh9nlzyoWEFGo8/Zjea6+p0JZ5p9iSGfLjLHyKKyhabXajoWiTm2Slm87OJOxqBxZ2uElKE1IHQFHqR9xGNhIhZlACoKbkF5FZdR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UKgmfbEg; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UKgmfbEg"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4998590d392so13804015e9.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 09:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787588848; x=1788193648; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NRBwREyNEjsE/U4vHY2ORaIfvTLBS+g+rKCiKwXSNi0=;
        b=UKgmfbEgMHd6dzLZSndONE0z9Jelun5MbRorGUZz5pTsR/KNEhvbUsGh0LdLaSoO4+
         ahDUv5lcw1fXAWwq1OcjBWgbgKyOK+q84YIeHHzUxFuZqKIzmXnkp3dJ2QZFcupFG65z
         f4XUSii7oREGYfbQiDzWHRbw2J9YQTs6CMpdH2O7rNvuCX5bO6jk/n/EgLCuWF/08n6Q
         jlZ9JVE3Q+LNaBOXOM8PUEpTBgnRxgh//A6XVNipBg5g2Ac79C54hSF8LWKWf1SA/SWw
         DBPN0Vd014K6NTuvvlvsiFnR6PyV5bMZGTxbWu9k0dImN1nE4PYXYZSujhORJYDg21nE
         8Q4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787588848; x=1788193648;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NRBwREyNEjsE/U4vHY2ORaIfvTLBS+g+rKCiKwXSNi0=;
        b=UYdoRnvnL130lmRSdGBFCdJlgPUmz/xb/VQR/vJF6Uc8EmLZaaOi4wYRrC7FYefqzS
         1ZSoUAAfFs2xhpn1uz1hPUl96ZsrnmDV7chJP9vDXXeGe/uCyyj4rHlf7jJk9rN0MnTF
         4ZpS31d30ZtQhVTKmKz0A/dKTHR5bRyuzsrZkxW21FdVrHiRIk3fVQrsXiD7qxBtQlZu
         j2rZY9qLIUfjsDHhKeISLQ+beiajn2U0HvjaLWoyxU7PH59Op0bYBD9IHc+79zXumvRN
         ibUAhdIybbXUgrckpWlbwPxZ9y+f2wqYG5dZ8h7E/jgF20OYANWaaLUGjz1kry+bdTyp
         bDiQ==
X-Gm-Message-State: AFuF++l6+v8mUPUchqMYShtDUTvBUTC4yOhtYa+M5WtAidAAZH56ovRk
	AoSei/npDVP4ma9gDMS9SqNIXbjd11wo0Uvf9sD0kO3ChfiVVnKVICSU
X-Gm-Gg: AR+sD11oMxGFopXyDU06cJjMIEHfJ+GvJUrYdFZiAh00gq9llRnZkP0iXo9vMhDFtd9
	kutdTHq5Ki7oKvDnMtdbU4qhOiFIc23vaajbOhvbzHLCjWlKPRnv3sgI1Ju16hsDMWmwYvf4Lqh
	Ed7Lsvur6kLuprMQx9RYM2xZY3Sc3RfQKLx81iVQszZdJKcUgTgcDiqnpcEyIF3l/kr4T3B9O8i
	adq12EcKDq4H3mq2XlBvX/3Kocb8YvrppLX/eYluL0WIoFZr574sWFQddblzbrbwXxp/6IclSMl
	3Z/Ma7Cjpu4nAh/5Su86DPRpvAJJ1NdNP2MWiDKe+TwTSJPie1FjynUhV2Gem0JXfb1M0oJFxEQ
	rsyGi9fKfGhNUYZMbbp6Xh1itZrPy531NigOyKpxVbPpY1iTIkyvrFqjQ0R9CUWKtb+hFnhQesz
	Rsh9R5Uv/+kqhRDHTTUHV6NL9GKDd24GwQcrZ9NyzH2bCYlLDb72MKPfCyc6uMIq7yM0mrLtYXa
	cUZtl4=
X-Received: by 2002:a05:600c:1554:b0:496:c06b:9fb4 with SMTP id 5b1f17b1804b1-499b844b578mr334114595e9.14.1787588848204;
        Mon, 24 Aug 2026 09:27:28 -0700 (PDT)
Received: from localhost (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499d63771c2sm1195245e9.15.2026.08.24.09.27.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2026 09:27:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 24 Aug 2026 18:27:27 +0200
Message-Id: <DKXBCZMEWM32.3EAAMGWAWQTMG@gmail.com>
Cc: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com>
Subject: Re: [PATCH] wifi: mac80211: mesh: free pending CSA settings on
 interface stop
From: "Nicolas Escande" <nico.escande@gmail.com>
To: "Deepanshu Kartikey" <kartikey406@gmail.com>,
 <johannes@sipsolutions.net>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260824054611.29728-1-kartikey406@gmail.com>
In-Reply-To: <20260824054611.29728-1-kartikey406@gmail.com>

On Mon Aug 24, 2026 at 7:46 AM CEST, Deepanshu Kartikey wrote:
> ifmsh->csa is allocated in ieee80211_mesh_csa_beacon() and normally
> freed in ieee80211_mesh_finish_csa() once the channel switch
> completes. If the mesh interface is stopped while a channel switch
> is still in progress, ifmsh->csa is never freed, leaking the
> mesh_csa_settings object.
>
> Free it in ieee80211_stop_mesh(), the same way ifmsh->beacon is
> already handled there.
>
> Reported-by: syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Df5752cd6b94fe38be666
> Tested-by: syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  net/mac80211/mesh.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index d4507e4e6ec1..d3fb4478a366 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -1201,7 +1201,8 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_da=
ta *sdata)
>  	struct ieee80211_local *local =3D sdata->local;
>  	struct ieee80211_if_mesh *ifmsh =3D &sdata->u.mesh;
>  	struct beacon_data *bcn;
> -
> +	struct mesh_csa_settings *csa;
> +
>  	netif_carrier_off(sdata->dev);
> =20
>  	/* flush STAs and mpaths on this iface */
> @@ -1222,6 +1223,13 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_d=
ata *sdata)
>  	RCU_INIT_POINTER(ifmsh->beacon, NULL);
>  	kfree_rcu(bcn, rcu_head);
> =20
> +	/* free any pending, unfinished channel switch */
> +	csa =3D sdata_dereference(ifmsh->csa, sdata);
> +	if (csa) {
> +		RCU_INIT_POINTER(ifmsh->csa, NULL);
> +		kfree_rcu(csa, rcu_head);
> +	}
> +
Why not really handling it like the beacon data and just remove the if ?

	csa =3D sdata_dereference(ifmsh->csa, sdata);
	RCU_INIT_POINTER(ifmsh->csa, NULL);
	kfree_rcu(csa, rcu_head);

Should do the same:
	- RCU_INIT_POINTER() will not take too much time
	- kfree_rcu() already does a null check

>  	/* free all potentially still buffered group-addressed frames */
>  	local->total_ps_buffered -=3D skb_queue_len(&ifmsh->ps.bc_buf);
>  	skb_queue_purge(&ifmsh->ps.bc_buf);

Thanks
