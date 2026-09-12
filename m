Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA27A3D3B3
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 01:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789175243; cv=pass; b=shTwgkRTO4LP7BbcIqjXkc7qb3+7ymDpHWPQu6+Rh5Fj+P29gCXDg+/ACbyZ1hjI1gSk8WitcrflC4dl5Gnfbno44RQE+ibA/OZzK2BCYwmjgI6uq34kFUcYKvIRtXA2wZP0ZmPJBySiCQffw6vLb4R5rW7YtUmoifHz/T3KBJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789175243; c=relaxed/simple;
	bh=NoYKk+zfA2Vg0NFqER3/7jFPnk0Q80RgMfB5SuCFhbc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KDpNuJhkEdPUoGY0huTvd2QSHqiW5wGEHxTiWDvLwo2ouqhkfRgJq0MARcqKfXrjbkMqQgeaPCGPdHhzLCO6Zr75qAaWm5yjK/UibpKNrEqsi60v4v1+8qJfFxUjVAzV/TeBQYRS3jvTPHoJ+lxdtf1ZAKMSbYDx8qx1+Mxf8tM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a6zkXI0S; arc=pass smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a6zkXI0S"
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4aa8e6bbso223880d50.0
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 18:07:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789175241; cv=none;
        d=google.com; s=arc-20260327;
        b=iqG40fFkciMLqP0/eVc/M2ZboKPOEiVGyY82yJ1A5twqpwB1G5/MmFWjRYIBaFssdr
         ViTOoh3DdKzeiH62iw1dJ+jQfXbAsLUMj6WOv7o5D+/izcFQTdJP2jcVxPxQgG/CfSSz
         D9JY2wHxjRVUJ7u5Wb4WJWZr56nZRqo/cHN0CFftu6V2fYU9NxjAN3uaoeAiaBIZByVZ
         gzlxdRPWypfWk7JnGBPsO7L6aVf54tQ8OA8jC3UX0jUmrB7UWsRGZZ2wtgwa8uAXbR8X
         vQK2qVA6BvrdxGk+LbRa2nH1fT/sFrHU3teZT28Z5kTc7OqSsZdX1IAdEowEryoX/DtK
         1BQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q42INxzKbcLL2mib11Z2FAWyf7Td8LLy4kQfAr2Vl58=;
        fh=qFSKJRt/Nod1jzo00eIa16b6/eAMFWOo+bns9yIRBXg=;
        b=SvZdeQs8ane5IpwaZ/9UAy5f2jykjdGCGCInAcRc6dqM6OFN0nO7qXMH+Ppq9nn8+v
         ciMP10U/KemtrItsolDy8hr3Ln03O9RYFn8Bo5gfw01+sSD+VdqSkLMTOfz+z2JGkbam
         r2w9eSeXNuiDjnkz4ux0XVpjndndV+S49zG2WAHYlAJpOArvBQ3NpPiCiVKRP8Qcq8Q5
         q01I7am1zoVg327Ql//4qrXSOr80KZ/Ih752+0GEz2g3fBUZDIOmm+rBWQWkTrArgVkG
         o5B6/64Gw6lWGVeI+paPNnBD95KogWvn/49j57qvvcHGdDPTZn6m6OB7NLZxH9NsQUOK
         h8ng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789175241; x=1789780041; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q42INxzKbcLL2mib11Z2FAWyf7Td8LLy4kQfAr2Vl58=;
        b=a6zkXI0SNfN1QS6lAoPF00bv/crDnGeMNIbvI9jct7xFnxe4aOI6lUebSCMHi7iAlU
         k+MWVzmQDfzqL6RgzAXkuY6sewlkjUBeEU2V06yReL+bVKrxkkLs9C/2Rnw6HqSql4F/
         MdlWroLqvrVVjJpdIYB3AxOaLkGJ2QfN9EPJ0he5OhU3vkQ9Zr/jCeY7qsueDkYwmatU
         l3r+mQLEZ8mEkHLI95BHmit5Hrm7TooKb0oo/H0GVgwyRElH1j/ZUnbvtl50/d+V0bkT
         xyDZKXz8UdH2+A2+J7PvPfL7NeHZwpsanhIKNLDTnbDCJftWtvuIiYYifz+iITb0GB8q
         UWYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789175241; x=1789780041;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q42INxzKbcLL2mib11Z2FAWyf7Td8LLy4kQfAr2Vl58=;
        b=NyBUBZq9ITxUxa+uSpaSPLFWgfvhewJ7SWVm7ZqJnAhNgdSe0YbLib8d1mP5AWgoFn
         mEEwv52Gytsdj/2013Yvba+AmHkf9LM3FRozL+Qutk1wdOdf0bnpTotBezCX2VLViT19
         eblNhOBWSTCjP92tlnNdhEm9PtzOJzYPXYVeoiE/PY2El/ZCdO5cxehl63tQatyCOQCG
         uEALbJhQrGDem5dPqsI8JYt3pJ2ymG0svGTkg+veUEms3Au8wKWzh95oQ3uWWIa5Nnt8
         OOV9pkNiN9A+FaKAlR1PDxbqiusoQAQhZ+0h1n8AuJHL8MRpUs8hhLbJ1EunyvL0siUG
         aXEQ==
X-Gm-Message-State: AFuF++ltFrn6HiUNpLYrV1zZrmDgvVrdSSlAPGFeO8rdPTVjb4zD61wG
	MTObaS18tjv43RmNLZ+bXPAoAuX0n+CqROrsSMP+FJ6GyZoVs3FaOI5/AAVbi55e9b8ZDVwHL0y
	5MFGu93lzhW/HWsFk4a0St7NlDhilw3tuuw==
X-Gm-Gg: AYBFou2thisLddzNw2ScTvf8XLlO+1cbHgr0Ov4GrhHBxkAsLSB9VXYHFZkCGMdXSk1
	gmYm3dJuWMP1aSw5bKqOneU3R7JDh3h2neFBQHR2whRp/mdAqOR6LNCNAjXfmdo3l0ErtarLJaW
	nP8stee6/50Pl+RqDfQcnz65dpV6rJA4Jb9Pp1D4tAHl7zFsSGjEazWXJNevqzxxZr1yVaCyEv2
	h9s4V+vgjahin4I3IrgWPOxv4oEIkughVG7lnzpSuSG8HcawrxnP182cBdJ3ZlYzwhHkgEPj/Wk
	jZTrLCWMylos3/tL7QmcCQZDihUsBpZBwQ03T2ruj5q84Ws1OyVFRnj4Wz4IAnYhr2G6RAIWtwR
	kZ0hmHdBl8kJp0X4uJnd1rPiNoExlquoJ5wToNZCn0mXM
X-Received: by 2002:a05:690e:1186:b0:671:251e:a5b with SMTP id
 956f58d0204a3-671251e0df0mr1500697d50.35.1789175240898; Fri, 11 Sep 2026
 18:07:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260825135717.36369-1-kartikey406@gmail.com>
In-Reply-To: <20260825135717.36369-1-kartikey406@gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sat, 12 Sep 2026 06:37:08 +0530
X-Gm-Features: AcwNN1UJeXmdb9KknDcsthyIhOBUktSAlTf54RExh80U6BxToohI0BSU73dFvtI
Message-ID: <CADhLXY4H1NMSQQyHjT55hyEmhoEh6mq3n2w2obKdn2NRVWrfuQ@mail.gmail.com>
Subject: Re: [PATCH v2] wifi: mac80211: mesh: free pending CSA settings on
 interface stop
To: johannes@sipsolutions.net, nico.escande@gmail.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2026 at 7:27=E2=80=AFPM Deepanshu Kartikey
<kartikey406@gmail.com> wrote:
>
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
>         struct ieee80211_local *local =3D sdata->local;
>         struct ieee80211_if_mesh *ifmsh =3D &sdata->u.mesh;
>         struct beacon_data *bcn;
> +       struct mesh_csa_settings *csa;
>
>         netif_carrier_off(sdata->dev);
>
> @@ -1222,6 +1223,11 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_d=
ata *sdata)
>         RCU_INIT_POINTER(ifmsh->beacon, NULL);
>         kfree_rcu(bcn, rcu_head);
>
> +       /* free any pending, unfinished channel switch */
> +       csa =3D sdata_dereference(ifmsh->csa, sdata);
> +       RCU_INIT_POINTER(ifmsh->csa, NULL);
> +       kfree_rcu(csa, rcu_head);
> +
>         /* free all potentially still buffered group-addressed frames */
>         local->total_ps_buffered -=3D skb_queue_len(&ifmsh->ps.bc_buf);
>         skb_queue_purge(&ifmsh->ps.bc_buf);
> --
> 2.34.1
>

Gentle Reminder. Please let me know the status of this patch.

Thanks

Deepanshu
