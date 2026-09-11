Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485E43EC82E
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 23:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789168363; cv=pass; b=aXtGo+dEE4HOmUi9L/ggzARhbEq9VBiSYD5hHTpZbWk0w8LQoCyRjILKFFBLvOFbqFtotfmD8Mr0U98BFJ0HHskR81vChKOGXKFeW+Ld8cgMyyujKJjmsFj7zpeOD+QlP6jxMkYKtfpEJJE+lADp/f+kuOHtlAdzwZO+p9MhgTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789168363; c=relaxed/simple;
	bh=U5b2EGQ0h1hGiuvcKNAxlYftbTygKbTmyhHzJL26viU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JlviW36PxNvEvR9mjuh1GYUI3zNHFz6QOxyoIxrA6qq6p13MkVRYJ632820wZbsMGIlPuXBhijmmoaqQTKEH8u/pQugMYEmaqgJsM9hs4FShEhCswnA/5O+JmhcLrQTTV+SvsN7eRlgap7BHG5HL8Kf05t5xm29exskOQn3epAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b=bDJBQdJM; arc=pass smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b="bDJBQdJM"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469d249c4so499564b3a.2
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 16:12:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789168359; cv=none;
        d=google.com; s=arc-20260327;
        b=BLKOO7EUIvN32t4wlnjU/2szbSNvjNovD+2k2YrNr8tFh0CYOBZr4/ixQVUdc8ATJW
         fNem7gkrsHhaDOchtfAuMUuwtbpdbhvJC90EyydurFpsRT6qCjehGePVEUOMZt3BBowN
         JgeUHxlrvIQOWAF8Ag3MNAzt2xNH5TqY6hahIX9CuM0H3HSAfX/GJOCk71rt+C91g16B
         ZLSA5wE3fmKrriAzWt2l2WHnaEjeTIOLpVvBwpn/xHm0/pvNIFov7ZM2a/bThCl9eqol
         bYDCEUQpyjcpDozZImKrZpv6RWO5lyOUK9cFtRYMvaCjSb8oY4AK+mutci7x3yhJ24Hn
         pQxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NVHoZLNQTSNiN6B8aYa+VAei/rQkC1SW8nQqoOBjgYM=;
        fh=mgYTLh34J75fnrkTDpY5FCwUQPGFqfRhaFLbltCjF1Q=;
        b=j0euW3H8q/65ja8O4qIu7Rc+8nrjvwTLXp2PeYtzK45KkhCqvuOygmdIC+cW0FZ/2S
         OdH050HzoJqYObLqYmdbMgrEgGb+HpztN37ytlg/Inmwg5EPKgUSTHjmuzLDKgPfluQ6
         9WO9tDnemIr2NvJcefrKsqQFn38skjijc/szvY1gs2A+nCuCH90s/1Ra144Ix7tvtmVr
         1PjJfvVZmSO7i/XMvNAP1uGprUXWAMWgqTVz1ADfGAVLjSJ0tjrwBjklRCnhWOsz4mFu
         kEYMbCX31U0AvyUJh0wIrO+ObKil82ZLZP68eSh9E4xD3aKcwG0+XHHUiznicCZRpG8k
         Xagw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1789168359; x=1789773159; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NVHoZLNQTSNiN6B8aYa+VAei/rQkC1SW8nQqoOBjgYM=;
        b=bDJBQdJMUqEJ50EiXOho9fklpxlxedv//KcHhF5I09IZPnWY0ZK77hZhgg63T4gPDR
         rNFqKhEtwDhvXpMUcyZizQbJpwdfhmhhFrfv3bZnaKdYCknLELNhRVakV/Yl8Mz4qFIE
         YsKakeem92K9QzyrTgL0a6/3jxSKN/yyO6RVE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789168359; x=1789773159;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NVHoZLNQTSNiN6B8aYa+VAei/rQkC1SW8nQqoOBjgYM=;
        b=KpI+SdVVCxQhVHXxVNBJ3/ekIfPgoeSJS3bn7NMEqLwIegXD5jq7Ap5gZfFAGW+q27
         MYGivVxpg4k07nUadnUxxwrjsOqR8Wodk3IfjZ1mfHE+T92+FYWc2hRDWidNxmlcB0hv
         2eeVfGLem7IPQHEZxrOLYzG8ITln4hQivwLLM+mq/mYwqrBwh6AbG9LDxN22EKrsuOOp
         frESpDtfg0s7nqZq4DsIxekDcHIYBf6mpoOAuxCNJ1c+P8vfp/nF1T/tBpskDilSZYak
         K+26PX5AkesheDFWNItzgJxnyj5vjcBqwZwlChhwmNDLb/PZ8ftCUqlqXkweVqkhebzM
         +TQQ==
X-Forwarded-Encrypted: i=1; AKwUvByklksh9BLlaRrE/rQgZOppKK5P8DDcH92CDpbZ7Eh2XmgGy319d/91K16x+oVxbannxopj8l5SqKPsYoYKpg==@vger.kernel.org
X-Gm-Message-State: AFuF++m8NiRfZTghEK+zV3kV4uDIYoQn7mkI3xJqVl60bxzstKdYMH5p
	WRJeFVBFB+aY+Hp3fZ1VFTkCH1gRFkJ5lTY1iCnoJ3/5OvOvXX8bTVBSRNpBbeWSp+nTbuAHKCl
	GNgO75aDhzla2ag9lsVpEPPGYAv8M0JgLSMo7E3u5
X-Gm-Gg: AYBFou2eDCub3MHMpBJ59hL/HWO7YS25NK3AL1UN4nmeoArhhT7FZvEoHVRxQe1jj+u
	geNvFesx+o+0LqOO0g1hDHfZT5Tv06ztRNRZbIlNNXoHagkloorCzva+yppHgC5L3e3e7UPkidD
	31rs64LlmcMl9VMz0qTMMp9GP7/aYVq00p9OrOUOe5gh+TKFNRg5wD5e5AI+MPMcpgVmDs4LwK+
	C4TIsIyNdue342RDAZOQgMYTGJgbFK3QWUlivqiyPv9Ynzt3y/0qWMpgKBh2y95dCt4kfJiB8jK
	q67cM5XVb2J3GEkiigSPlEpr9V1fCwK/wd5wx80Z29VXXpnIG7ONDkqvOnoOJ9RdDeCXJagP1dA
	ZuvJGf/YV3iqnJazTRtU+Ez68F+o6lJvwqw==
X-Received: by 2002:a05:6a00:7541:b0:86c:b39b:66e4 with SMTP id
 d2e1a72fcca58-86cb39b6a6bmr818636b3a.18.1789168359596; Fri, 11 Sep 2026
 16:12:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <QDISC-1L5H.v1.20260903184552@mojatatu.com> <CANn89iKFVvFaNcZyGOxmyPbpc6ax49ZqwMWDeBAsH5dav-y-SA@mail.gmail.com>
 <CAM0EoMn5M__WHkniZLw8GNtHpTresTC2dQuL6brmAzUXH1YUKw@mail.gmail.com>
In-Reply-To: <CAM0EoMn5M__WHkniZLw8GNtHpTresTC2dQuL6brmAzUXH1YUKw@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Fri, 11 Sep 2026 19:12:28 -0400
X-Gm-Features: AcwNN1VxwBhgJyQS3MJEPkDfRRZ_FKlaOla_PtSbjvxx1Fh58EDgtZfXE8iGhas
Message-ID: <CAM0EoMkzo3s7QTLm=w4RkyAbKat3iVZ89dPtPeQoFRvqigs_4Q@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net/sched: codel: bound the dropping loop per
 dequeue call
To: Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, stable@vger.kernel.org, 
	Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Victor Nogueira <victor@mojatatu.com>, Johannes Berg <johannes@sipsolutions.net>, 
	linux-wireless@vger.kernel.org, Vega <vega@nebusec.ai>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 4, 2026 at 4:31=E2=80=AFAM Jamal Hadi Salim <jhs@mojatatu.com> =
wrote:
>
> On Thu, Sep 3, 2026 at 8:35=E2=80=AFPM Eric Dumazet <edumazet@google.com>=
 wrote:
> >
> > On Thu, Sep 3, 2026 at 10:56=E2=80=AFPM Jamal Hadi Salim <jhs@mojatatu.=
com> wrote:
> > >
> > > The CoDel control law schedules the next drop one interval/sqrt(count=
)
> > > after the previous drop, using the configured interval
> > > (codel_params.interval). For very small intervals the scheduled step
> > > rounds down to zero, so the dropping loop in codel_dequeue() never
> > > advances and drains the entire backlog under the qdisc lock in one
> > > call - an unprivileged user can trigger a soft lockup this way.
> > >
> >
> > ...
> >
> > >  static bool codel_should_drop(const struct sk_buff *skb,
> > > @@ -156,6 +161,7 @@ static struct sk_buff *codel_dequeue(void *ctx,
> > >         struct sk_buff *skb =3D dequeue_func(vars, ctx);
> > >         codel_time_t now;
> > >         bool drop;
> > > +       unsigned int drops =3D 0;
> >
> > SGTM, note that this line breaks RCT.
> >
>
> Grrr.. it was in my brain to fix it, but my fingers didnt get the command=
 ;->
> If needed, I will send a v2.

Should i resend this? sashiko-nipa never reviewed and other one found no is=
sues.

cheers,
jamal
> > Reviewed-by: Eric Dumazet <edumazet@google.com>
>
> Thanks for the review - struggled a bit with this one and wasnt 100%
> sure it was the right approach.
> cheers,
> jamal
