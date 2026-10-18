Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D406392C20
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 10:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792321042; cv=pass; b=RlWW/tFQ3VX6INs8T3erfvRSJfsmZt0WYSxFgzCFfK9AhQTfCJDJc584n9NmeKSVH9uuupdAoDH02ptRpdaDxZPZedMphpC1AMd5+imN1mfcltyZ1iSQvOc9Qrkx74eXXunAfPkiwHHPpM3bynnEOUrR4S09mYIXCvyXicm88U4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792321042; c=relaxed/simple;
	bh=NoYKk+zfA2Vg0NFqER3/7jFPnk0Q80RgMfB5SuCFhbc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hWXXjyPAJn2wt+5AlzpxOdbYY5psJjs6tTsdVEADR++zTSbhO9BCk+bd2qsC6E57QEtKfwi3Yg99ZGVQWGZ7UpKj3pb1JvboPKTMTB4z/qL6re8+aCxhWdjixkqh+8TReGOAjTD0R9oHrj27uuMAM3LhZke8q1pxibDlSzI+Amw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZqBEQ6by; arc=pass smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZqBEQ6by"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-6711f05fb14so842444d50.2
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 03:57:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792321040; cv=none;
        d=google.com; s=arc-20260327;
        b=OHL7F9JHK+CWtE9Ja+pRiQqbktA+jBxjEtYYf2ueSzgFyIHpPwL+Vo4UtLNZEZv7FL
         eAeghpka1GV7VP5iJTh7Tit0XaN95EkV9AjKgHsdm1ZkHUg47dP1JNyhcrCreKc3dyT2
         52+Rh/gPNIc4oVEeqY9wpqPFtpI19LSauTkSNc4d+XnwHtV4Tq8HlrVrdsZ7VFJQXlfB
         fOWePOS2r3EG3A9BzKWlBEZIE74MTF+lEzjhLeYuBhYHD8uvj0NVnPeyxO8kqm9gJPQa
         jBE1yLFHZPF0xJzpBe7l+xwvrhS1SvL4OuLACdxHtHCFIArsWW4GHduE3QamM9zCriBW
         bS8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q42INxzKbcLL2mib11Z2FAWyf7Td8LLy4kQfAr2Vl58=;
        fh=qFSKJRt/Nod1jzo00eIa16b6/eAMFWOo+bns9yIRBXg=;
        b=MvLg8NdEoa0a97vX75BbWWsICzUhmCNWuA1L4bUT/qCPhwFWEcktEtVmy/0lNW5f/t
         xxwrcWclWjfN+cLwjj8cmROwAXzWoL9CA+V1O0AN+5+OPS5fM1BP1PxsZcugALAI4f2d
         2qxw3AdR4v/R7ChzaZ1rxmVgRZ/fSJ7bzXBQO9aHpyrNtsK6FuSrasJPg/fz9J91z5vI
         7wXZ+Syb1B+jQX4VgQfa6x1DZpqbwV7gqVSwtlaphkAOani8P+Vpjw7SI/bUPVYsa9sW
         xdK2XROk58VsEKBCGuL/a6tW5E+n/FrbBDIRvdSaFFYbEw7hi29d+dfripTtQvjhk+O+
         MnvA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792321040; x=1792925840; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q42INxzKbcLL2mib11Z2FAWyf7Td8LLy4kQfAr2Vl58=;
        b=ZqBEQ6by7ey3282eNR7dSX7yA2wjlaII9XMSKfs4HSSf/Nb56G4vSjEMy4nWZmOmz3
         pwwb7HKMC38Nj6Aoph8Oc7IYj2ayIl32vQl2zUbsTLklF7y+V4kYpY2xOuYkjb9HBj7S
         gU5M0Z6HZstSHTdLOvmTCLB2+Zeqqx9qTHTIsneYsmp30yD7Jf7w6umgpRjgBkntw1iT
         YBgsVqnA/pxKNZ6ugP8Vow7dXzEZBTSZDrJEtf4YhrQiEk0ZvkoPSGUYJJ6/UhvVLC+q
         9hWqGF3uJbThI0eXgh9t8Y7c4MhTGf20oakWOSASuQefPlG4dO96fdwsY+t0Gxw83hQf
         cOKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792321040; x=1792925840;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q42INxzKbcLL2mib11Z2FAWyf7Td8LLy4kQfAr2Vl58=;
        b=w+Lq+K6n82ee3bX8LjambTx2i1eX53D4/knvpLgaoX54jtHz9B7SaauoLG4TQnfQik
         YZDnbWwlkhsAMA/Oe97OS15aps9+KW1+/XU+2N6HH+6QXblBLWAv+EXQeo0iWz28aC8B
         lks8+7zRC820MUV8T4e/VaQFMeQVwpuUY2dMeJmLRmlKzePJtIK7GZyBySmFP9gkx+Ot
         LIRiYF43kaZ2jRvIwszZVoh4EEY4IUHbaZ9B7s/0i+Wl2Kwsjlk7bOCHR7RoXHsUMQD7
         YU2KkuIX+6cnCq3IwXYiaL8H9mJIKUWmfLUHC2oSdDD/BchLmnipiYi3N1Ny18+Rz+mb
         BSEw==
X-Gm-Message-State: AFq9FYKo4EZtC7KtRX/0qiW4UwrKHabxv2+LME67mQXt46iFwXzL/6Xm
	pe91FAcsp74bwyoirb+/gR0+8EzdsvpkrmvvGyJatDJ/tr6FL9dVBC/zVYP5livJDkJmW+TKJOB
	u3wkqE8XJ3mxw6Qr3GdIF+WU353ttpIU=
X-Gm-Gg: AYBFou1JUbjh3CX+9Nb6WL7v6ooYtIuMVJ/6eOTxunHj6sTvBYHsCsZqb5HMbo2MSjd
	WRjjy9T5/0B90acBXDwB0sYHnR5uXTJo3yonRxUraW06cKQb6B8VmdC7WUhF2dyOzzuLi5Ofqs6
	WNqaPimu+Kahhm8rOiQy2Ek9MtKTpxr00gnxA5bQTNMX21G/kzyXYGY9LVLCD9fRiK3rfl+JsGI
	+G7KGpd5Agby+bNhyxz2E79o6TWz6bxBEkMW7BOHDL1opu6D5iDIRR3r5aV3o6Oa1ZkLk+bI3KC
	TolZ5kFR2ZFa+/B7l/GHRalcB7tQqVqXJklHYhIQSHeBH2M5DCCaEJ/OnKbif0nB3Ldw3FE+6v1
	DS5zRyHPzNNG89X0gCkgcP9642cJfYU/kG4fvFNdYXyNQ
X-Received: by 2002:a05:690e:138f:b0:679:cc49:55dc with SMTP id
 956f58d0204a3-679cc496392mr1276885d50.92.1792321040069; Sun, 18 Oct 2026
 03:57:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260825135717.36369-1-kartikey406@gmail.com>
In-Reply-To: <20260825135717.36369-1-kartikey406@gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sun, 18 Oct 2026 16:27:08 +0530
X-Gm-Features: AclHuK8VgSJacpo0L0UN9QxBNGzCJb6Inw5_tPuhgVzMlP_LjGu1MvoOIZ-h0FQ
Message-ID: <CADhLXY7-NaijsaX-+5M555xf+inRXXF_DfDr9kh45B4tWTdtsg@mail.gmail.com>
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
