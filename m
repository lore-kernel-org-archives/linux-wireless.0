Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57ABC3A5E77
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 20:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787691210; cv=none; b=FtWjOFXeFtSlV9SYp9x0ogX1rD1VEcpUEde3iUy5trMo7VlwihnDq7OIsxJWou9Q/PtwfePmKZnVtbbxKZMSqxtI0JXGcIFEe2TFpdsEiCq1XYrxVzOC6IZMmtw0cA8RRkn64y2/dMYd92jT0Z57jmu4Eix3ukiFaJ/jgHH2A7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787691210; c=relaxed/simple;
	bh=HeLBt3vyzk2euvESNdrNKNlILU0rvme6eL4KRRI4Enc=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=qRK1FB0nyRnxnrHOyuGCTFPj7DXkLPcyCse08XmzNEZ3zuPdG4gh6N6G+UIz1n1VqOlHE2O9dSk1m5AjPD6ZH5RmLVPbjboIB98hfex7XRQOuRE2m8h7BxScMLVTtF7q5JDjMVbNuXxDlMTirw2MOy3Rwm6uJ9w+TiACOt3jVIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dyl4qJYh; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dyl4qJYh"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so1531215e9.2
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 13:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787691207; x=1788296007; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Kjf/UdalwA7l1dnOuHpFTNl1skWmKIYwF3atUm1mnIg=;
        b=dyl4qJYh4uQu4iKoyGHh8Ic3qJoIAkDJlaPTgk41woLAQ6UEVzHkuTMYz/0Fsk77fb
         0E51voXG6HaHfiVCU8KtRhf4xoJhc+rL48hrUEMc7FJgL8S4IwSmu2QRTvIZF63mUZEt
         Pj+OVDCaYlx7MHfoKaS6F2/l+I8/PHiy+Mr4OZ0wyi13fkOOO/o8d3qgyq8m0rDrUemR
         z9yGsH3qYXGoKbgaCgTWsTvGTQggoNW5jZGwuKLruxe5EqRRSjTiTW5HVejsz6Zt7/tR
         QzDzrmCjiUlhgi+aHK0lsylhwAgm0tke7jvOlqJJZzkv3w4fzVcvgS9atftDzkVpTRTd
         czMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787691207; x=1788296007;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kjf/UdalwA7l1dnOuHpFTNl1skWmKIYwF3atUm1mnIg=;
        b=AySa6CSocq7+3PzVVoXqzV26+rI1OVO8tNzItmwJJEDvPre/PuiE5lgAFPsS/xd09/
         SyvGEyKmZsp4+nRbgjxnrt92ynl2xtWMrv1NdDz8KLQefvFyTO0T+/GnV9SbsfUjZpld
         Lp1etSCs2b7cWf9eI+GqRZ8gXBct0VAbMKwNCWnKNYarfN8qHhWWvtZBzClgFLQRcJTN
         gh9ys07eVCMZ9/UfqCFmb6LTCAb4XAqYM0qEteK+o3Oxd/YKKjUNBcPEmwFC1eLzOalJ
         31Je32U8EvXK6dXQhJ7mJ/z6xKCRryuLcSZ72dBi9jdmZFqZaAQpo7dWwjBv4q+VPwvT
         Q+yg==
X-Gm-Message-State: AFuF++km8tccGCXQ01qgcg6G56vK+b1hdB9hgvQVloZLJIeQZwtWCa3Q
	bv4/dVntt50I9eDMoQQwN9d8jGuTh6A8X72Fda9d7RP4JBVLLnrIKo6J
X-Gm-Gg: AR+sD12QxobWvkhCHrQXLUelnd9bxf+QFPclKYaBG2Y0nA91ANe3pNnEVsI/wuBYsEe
	VY0C72pFNlvYwFbzrQmjS6YPi9NLBX0CyOBQbr4OSYs9JwUmbOjbgoKNDJBMMtKDwihocLTJAwR
	NFngKlH2/8TJETRRAj2e01LpclkwvmHbVbnlnzQ5HbLQyofEkNuZLzkks0EvTLeRP6rctDjiGY9
	sgsVDuCZ5bt54Oeqv2YPhKrNzkbV2lH7t9PuWEMxmyPT6JPPdc68Joo75s6fkSrR2R8tcNCBS1U
	0QUsiqkvkLNuSvlqT3UChrSApbuGbGJHnNb0clBC2aWme/KrHVPizAhoZ+eubIIolR/9EyJcTGN
	XKg86RMESgYucwdgv73gGNJ2B3rFxcuXvzbMSfWJcyusY51qKhJgTmxHYG91y4sXrOusqWqGcVz
	A9ScVb1xFi97pnYdpNeCrYz415l/cO/RETx0FAZZEE9rR99jJItRaSeqKbs6dshWqLgfhWJ4Euu
	BQjbCUIff2ox8NumA==
X-Received: by 2002:a05:600d:4448:10b0:499:60bf:c6f7 with SMTP id 5b1f17b1804b1-499dc823bf7mr13089345e9.13.1787691207268;
        Tue, 25 Aug 2026 13:53:27 -0700 (PDT)
Received: from localhost (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499dcad25ffsm4419585e9.9.2026.08.25.13.53.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 13:53:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Aug 2026 22:53:26 +0200
Message-Id: <DKYBN6NP5C9O.2G7X3PSMOKQ7F@gmail.com>
To: "Deepanshu Kartikey" <kartikey406@gmail.com>,
 <johannes@sipsolutions.net>, <nico.escande@gmail.com>
Cc: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com>
Subject: Re: [PATCH v2] wifi: mac80211: mesh: free pending CSA settings on
 interface stop
From: "Nicolas Escande" <nico.escande@gmail.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260825135717.36369-1-kartikey406@gmail.com>
In-Reply-To: <20260825135717.36369-1-kartikey406@gmail.com>

On Tue Aug 25, 2026 at 3:57 PM CEST, Deepanshu Kartikey wrote:
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
> Link: https://lore.kernel.org/all/20260824054611.29728-1-kartikey406@gmai=
l.com/T/ [v1]
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
> v2: drop unnecessary NULL check around csa, kfree_rcu() already
>     handles a NULL pointer (Nicolas Escande)
> ---
>  net/mac80211/mesh.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index d4507e4e6ec1..48015dcb7add 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -1201,6 +1201,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_da=
ta *sdata)
>  	struct ieee80211_local *local =3D sdata->local;
>  	struct ieee80211_if_mesh *ifmsh =3D &sdata->u.mesh;
>  	struct beacon_data *bcn;
> +	struct mesh_csa_settings *csa;
> =20
>  	netif_carrier_off(sdata->dev);
> =20
> @@ -1222,6 +1223,11 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_d=
ata *sdata)
>  	RCU_INIT_POINTER(ifmsh->beacon, NULL);
>  	kfree_rcu(bcn, rcu_head);
> =20
> +	/* free any pending, unfinished channel switch */
> +	csa =3D sdata_dereference(ifmsh->csa, sdata);
> +	RCU_INIT_POINTER(ifmsh->csa, NULL);
> +	kfree_rcu(csa, rcu_head);
> +
>  	/* free all potentially still buffered group-addressed frames */
>  	local->total_ps_buffered -=3D skb_queue_len(&ifmsh->ps.bc_buf);
>  	skb_queue_purge(&ifmsh->ps.bc_buf);

Reviewed-by: Nicolas Escande <nico.escande@gmail.com>
