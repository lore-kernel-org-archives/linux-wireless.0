Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3B33A4F59
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 03:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790134148; cv=pass; b=fs3pZEZnmzZJo3KEVpKhp6mpW2IJSiZlApUf64J0iLt8fxxvierbAgbyK6pOyzbvcOdlDQARpPm/hlpzyHAQtLEe7k9yesCE+1ya1gChoZ+16G0c03dUwSVJQnGOzD4fNXLl8IbG0bUd/1OaXmqbjk5yyJrXn4pUOnlwCbZiBWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790134148; c=relaxed/simple;
	bh=NoYKk+zfA2Vg0NFqER3/7jFPnk0Q80RgMfB5SuCFhbc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QJcHmC9zrXf+VvvUAbpLMxRY/BoDQ+RJlyTmy2PWbVLrcicqjPuNhkeJk1dQRpdAv9tLeaf4hvrvT1NN76WkrFRge4p0R23/3JJD/7U6fqU/mT6mxnqnJqHwxC1sWCoosdKw0N6YtvPCiU/+cu0+/lgbKk+ujbukm7oYurivtXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o3t09dmq; arc=pass smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o3t09dmq"
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4ab1b9f7so241491d50.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 20:29:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790134146; cv=none;
        d=google.com; s=arc-20260327;
        b=ZYTzI4g2E9tC0Zgc01jsBPPgBqvvSOOPp3b3QbhegdNao5nRr8oCgSJxMcBNSQOjTA
         mr80sjfTM7HDG0iKlEd3F0/JRD+9ZWWv/1wd8onhRuV4rKg0jrI4Os8OJ9TMqqTlft7P
         mTb9dBRL7LePjNfuQvDkE95d3xBtbJm9fApoNaGD/eN6gKPy57AWkqgMDvfChQFo+yL4
         xoXwfUCIs0dBR3q1Nr+bVLsx9bUjdMhGk8WCcgOZU9sa4sM9W61GihKHWUQVRy9M1mzr
         0hv5UXjE6UJf8tAD8U5kNWSRAI2r2YH3AeIEXLTrw/iQC2VEHmEU2vt69A23u9VPZ5ih
         7RAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q42INxzKbcLL2mib11Z2FAWyf7Td8LLy4kQfAr2Vl58=;
        fh=qFSKJRt/Nod1jzo00eIa16b6/eAMFWOo+bns9yIRBXg=;
        b=cUrGC+OLRxd1DcMsIgjLvPDPzcBT3CB5TP+//juQ88TpeIQtuk1y5sJl5do01G+5te
         z9eavaPlfIOqTlqZAhw5sL2nccWQ9oPtZconkPm6XwEufCQtBb83IQuu9/NP/h3PxrZ4
         KGFnzDDmzMsFvXJYGzDAtKHBUY4auNALg6HnqNrsaCXkvd95pN4kgLnyQ10mdEP9G2wm
         lKoVOC9stoOeypw40gA9xbhlV1pNMmhysHj50zuqe5p+T7MEb7vQgZd3OSov0NBKWvYx
         Rg9AtvVMJSB9dIuril1OKTLs6BSyT+zbRRuSk0CQ7/iyowZyrycna7QHKGLbd6RN2BoO
         zqCQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790134146; x=1790738946; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q42INxzKbcLL2mib11Z2FAWyf7Td8LLy4kQfAr2Vl58=;
        b=o3t09dmqDmJPwVRGd4s9tT509Uqp9vC6YpG7TdA5CI/SE5XBNntYxVPre8AijM1Pnk
         kURHPAEDzKpy6IotHxe1f/9d4/xVxl9gPKXjNqvPjU0FrTaA3ijcR5cmvyFzxmWNgMZo
         3/DpGCjbapsAAmzenWt2c2obBfwDgwyPXeBvZM0dThqlK2pdlFASvGNbbkf66/2SaKFy
         hSn7r7zFFcD2Yst0X+gyjM6uNAS2SwZzo2rbrZDS5/gzB4J1BRXidJX1uzqiAZZqC4lF
         9txaPTPgYeafLVpJPQiaG/OhgKCxABeubO0OUJYA+g88SyH8wGSadTLujQOzFZ58kfY9
         rcMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790134146; x=1790738946;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q42INxzKbcLL2mib11Z2FAWyf7Td8LLy4kQfAr2Vl58=;
        b=hNcgkZrUMM+nbq4to9/Kfr1TqSa9obCidbYdqBQ8gzCxGaQNvOspyrkctCssvYkM0N
         aInM9/v1obnMDV2LCeAgD/abT5FyA//3Pr0v3cnVl2dx/oNLG/phNMKnpZZ3j9zgHfmn
         HYMfUkpQOGVB6zWiD1nIpUvBHXxI55I0Z4A8aGMxwrAQKKJNNxyyeD0eS75c21C+DvpA
         uw4yVwByT1PsDRixmplfuWJOahuaMqiPiqY3zpUF87PFTZBAtv07o5CihDPnvVgJ5no0
         ou85TkQWI9YGHVSWwlcmxm0ciS+xNH//mPqWOZDafK9cr68cVvFQcAHWanFZUqQLgKMm
         NxRg==
X-Gm-Message-State: AFuF++kc/pwDqtLh43iaHUlcLDJq7ndeoKZwlZC00NZo8360acfmawvv
	WX0XuQG1ygTBte/3JccGSeE9Cg82oqQ0EynIkM7vPpR0lBDlqSjnv/C1xKgUyY8Ov6PxnD/1sr2
	Ii6sH/WaKWIOlbT5pphiq2Bu6fZtp/hE=
X-Gm-Gg: AYBFou1H1rlS2UEhtEDPe7PJiaFN1oZ9M1045hI1qqtbPTs0we7f2x5YOzdChw35Ykr
	CkK6ElPIrw4ZLml2UFoB+i0Q8QW+YDAY+oTmqqT8NBhKQ7s/iTyxIcT0WMQ8IzmBwgc777P+Lr+
	0zgBL5APK5SuLy8gugPS59bxDXcwBwYd+/TUT+l/bpCVlGzBXxzfaeva5jBOcjNbBKMgi922I/d
	lgIQc5WhCn5SxvEZuC6pFyvxCp5qDTFRMN50ocJvGXtbNqyi/3hfl1UCCmiw1OX4hZQ+AwUX2Ye
	NreLSi+PPo0cp/r4gk0TEcmnfaxdFAw2JvkhMNwrjCmKBYf0l4M0Lwju1hItfxoXruvI/tCA3JY
	8lpKhYeTP/Pvd3h1xNzwrzc9vXU9V02RJHVhpcggydEU=
X-Received: by 2002:a53:ac8c:0:b0:671:28c0:64fb with SMTP id
 956f58d0204a3-672d585d6eemr704698d50.12.1790134145777; Tue, 22 Sep 2026
 20:29:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260825135717.36369-1-kartikey406@gmail.com>
In-Reply-To: <20260825135717.36369-1-kartikey406@gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Wed, 23 Sep 2026 08:58:54 +0530
X-Gm-Features: AcwNN1X00fNegi2u2fWuLyHFqoda3BOM4DikBWd_t-lsQVZ762UdpZjDF9c8iLE
Message-ID: <CADhLXY5f=VTmp_rv6UHM3C44aeGokSRsMUjFUK+a7d4A2A_r1A@mail.gmail.com>
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
