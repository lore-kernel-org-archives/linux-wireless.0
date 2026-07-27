Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924FF15E5BB
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 18:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785175928; cv=pass; b=nVq1k6tLvT9tpkMlBN+d6s31Yv4WdAXMkhRs+vUBQ5hZDY9oYkbKbKJyHJgy/CmqqzzK9C7hER/+JBA/TpmRl1PEwDpCdlyjtJX742j8W6JmItoeMX4EGoG44p4Te2j8aNaOkw7PLZr8w9k1q5hCfUG++YK6Fewbpl1moo9GGcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785175928; c=relaxed/simple;
	bh=ARWDZkHQrN1z0/1Ag6bqNTedPkCVHLHWD1STI3q1RJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L++etZ63lMA6C0LhwEJyGzJ2EDHup3yauSatqyzLcwAYMMRt8OGbP6V+1DMcLAbxtfvVqtr5tTjHMr/vBrbS9iPkr7kaVSWsm0aHl4ieZmiIQWo80Zxib9xtAjmXXZPUIEIwu7t0to8/Aoty1Sl+bkQpsqtnnwq8pv0IRPzK7cI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nNc3eMe+; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nNc3eMe+"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-81ec29f1d07so35731967b3.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 11:12:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785175924; cv=none;
        d=google.com; s=arc-20260327;
        b=hhYKeP2kDkhWiExtLyaiHNZcqgjTDw3Voe9K7I/ykdwgqwkcG00qKCg9useXRSmB97
         VOaRtBjzQ8Q0Ok9QB55qDs9+o6604b01duZ685QFvDMnIgKEt/Iip1mVckqjk9U2VxLM
         TieM6Wf+vEuOIRD1Hga6qJIikvYwQEaYSjOWehgk3ICpIdNZlmV/dCwtbROtcho91S11
         24491Oarar/CGhO3uyPMqL8oMjETBknt1M4OBkXXJNyh2pr2xWcknGvH8sYFyvVDSJUY
         uV3iidpiGaPqNnngpx3e9iQ3EWUL1D/qn+9HLe1Ffuhswg5fjnao8y8X16+5F8MO7zL3
         vuxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XCh0/imz+IkcuVKGhvGaQ+5ECipoL9S8Q2JCCP0zXPA=;
        fh=EyRC49qtZyK5q2FbYr/xpfmHfL08Fd6wbmnBSjPDnP4=;
        b=E+H0uSgusrAX0DfBsh5k56tghRiJH6e1YsVSb8GwfGSMkVdG8c4OtPd109IFYTHHvc
         NyxwOZdK895SyghFFNgmqh3EVO5U856O61Cf+Jk2dyHlRYs3jMPLotM9qC8SI3dgc9bF
         bRdL3it+3oHO/te16/ZsOjfW/UH7c6F2vX9rXMWXc1/+kBba62WGpl1Cv1n7yMequpFp
         HD5HJWmE8fGW+VFD1ZC6WFMWKAtqv9Gw7HMwEzR9npA9Sxh2MGquTxYgKAtrNbGnZhuU
         ZnUEa9+XTvi684KeohIg6t7a9ExDzbRWZcgnoWjZvHX99Ayln7+OOHmehegNkN33XCvx
         qCHg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785175924; x=1785780724; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XCh0/imz+IkcuVKGhvGaQ+5ECipoL9S8Q2JCCP0zXPA=;
        b=nNc3eMe+8ZDD6Ddm+2UsyjyDEOZTPrpzUnejEDOfSoXklOaWHoojpudmUYsxmcT9ki
         /4kYahDE2+uuXlf8wHLFK8fGxE0AD/V7+yg3NiIgirRQWyIi+yuarIQZsRX53QAnIOxA
         zdKzNEj1dzCGe+0PGkcgJqO/nE3AW9saSp8V1a1PqxrGScIDFH1V75twL7vJRbly/SMv
         o+FdGT741wAfQg8OXlAtqm/KaFfgGXeg+Vx0IAvPTS5FGnt64dgEUuP44KyHTJzXQVdS
         E1RaPPUL5y4iMQExzZKkQv9EH+jx0JSvfgoQYlpzi6yCVPHqjSiLiG2CHacMcu+kdNZy
         PaOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785175924; x=1785780724;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XCh0/imz+IkcuVKGhvGaQ+5ECipoL9S8Q2JCCP0zXPA=;
        b=ZVEiblviPN+HF74CDjszLPSQaQ0+lXk6sI6uTMpXU6ZMw8KBCfL/nMiRE7nHTk9rLS
         VkkjrkRcgVFJBD1ed8OBCmdu74WAessJMsY62qTgHbglwsi64FTFsboJPMd2mNTMfCWs
         MF0QzyPf1/bnqDRwbBvw7Cw8toqNbhyImkh+3blPW0pVY9oBznQ4AsvxSefWChnH51Ix
         ymSy5fLkgMdfL7Pp/NkPaMJ+RRS/vQY8iPXKewIMn6PHKOD4q5b2r9keIQGQWmJPH7PB
         L0cO7dYVGdGnKtgtOkl0u3PgKTqIAN6f9joRSTPZdEfE8WC38qVzd3xdsoV7+sSOGovw
         +lqQ==
X-Forwarded-Encrypted: i=1; AHgh+Rojzkc9tzV19Yu0rJDLMgy8B8DSJk+3i3EwqISw383aXhq2r0SA/J+qoqWiP2hh6ModRFqW04UbO+RoaeAF3w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyVxIsouWQcKH58vCeys+nnWPz8Aol2kcP9u0IYN44QRWx/cHfj
	PYpa2ezaEbM0yUPAr5RMCVWsl0I7T/EN4KWDnzSCLFFxnT+ZuGxnWSPKbqTIljoFak+nXQRZ9vX
	Bn0SKSJ8KjCEe2fV/dMaGYDKg5JRes3T5rLYcAGtxvA==
X-Gm-Gg: AR+sD11IElw2HOTuO/5iy3Q9FDgEdfD0fyQrIV4Uu1Bjk2ejGkm+Yl+ZfkPHYIOsRmD
	mK3Y6TKjoT00gumXll5JyfuGB4c5L9g5GAi4f52oNauWPFmOcNj+kavXTo+b5oL0eFNwow62I1Z
	rNUbT0c2Q7Q1UlXz9it/s16zb+xy9tIcQyhmSIn4hneslSvKPe6WgGufcm+smsIApd+yoV0z9Y0
	+/GaVqXDSkuvqe6KQEed4tG02eq4icmyvd/7+hav58SuedH9OF1/bqTfOUwrFGNabkPcjfITv5A
	eW6I5vuJLiEKNjVhHWIF2RPpbDJeyS0NHVeTFWXorA==
X-Received: by 2002:a05:690c:3681:b0:7b2:1bf1:8016 with SMTP id
 00721157ae682-81f93930c80mr2697527b3.2.1785175924462; Mon, 27 Jul 2026
 11:12:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260726133851.1382095-1-ekffu200098@gmail.com> <da1aa515-58cd-454b-9f18-314732d45913@oss.qualcomm.com>
In-Reply-To: <da1aa515-58cd-454b-9f18-314732d45913@oss.qualcomm.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Tue, 28 Jul 2026 03:11:53 +0900
X-Gm-Features: AUfX_mwYEeKTjPAwobt28Qw9iPfdjUAGLbybM2HXhw33l5bInRZzC6WEhWFlIrc
Message-ID: <CABFDxMF60HxufruO0s1pM0UAGcCwKPME_sobxagrT5876NUCug@mail.gmail.com>
Subject: Re: [PATCH ath-next v2] wifi: ath6kl: remove conditional return with
 no effect
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 12:38=E2=80=AFAM Jeff Johnson
<jeff.johnson@oss.qualcomm.com> wrote:
>
> On 7/26/2026 6:34 AM, Sang-Heon Jeon wrote:
> > Both branches of the check return the same value, so the check has
> > no effect. Remove it and return the value directly.
> >
> > This is the result of running the Coccinelle script from
> > scripts/coccinelle/misc/cond_return_no_effect.cocci.
> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> > As suggested by Ping-Ke, the wifi patch of the treewide v1 series [1]
> > is split per driver and posted separately. You can find the Coccinelle
> > script in v1 [1].
> >
> > ---
> > Changes from v1 [1]
> > - Split the wifi patch per driver
> > - Change base to ath/for-next
> > - Filter only ath6kl changes
> >
> > [1] https://lore.kernel.org/all/20260723184538.3888637-1-ekffu200098@gm=
ail.com/
> > ---
> >
> >  drivers/net/wireless/ath/ath6kl/init.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wirel=
ess/ath/ath6kl/init.c
> > index 782209dcb782..61fa10d88714 100644
> > --- a/drivers/net/wireless/ath/ath6kl/init.c
> > +++ b/drivers/net/wireless/ath/ath6kl/init.c
> > @@ -1566,11 +1566,7 @@ static int ath6kl_init_upload(struct ath6kl *ar)
> >
> >       address =3D MBOX_BASE_ADDRESS + LOCAL_SCRATCH_ADDRESS;
> >       param =3D options | 0x20;
> > -     status =3D ath6kl_bmi_reg_write(ar, address, param);
> > -     if (status)
> > -             return status;
> > -
> > -     return status;
>
> this make the last call inconsistent with the other calls in this functio=
n.
>
> my preference would be to change the last line to return 0 instead

Nice way to get both consistency and explicitness. I'll address it in v3.

Thanks for the review :)

> > +     return ath6kl_bmi_reg_write(ar, address, param);
> >  }
> >
> >  int ath6kl_init_hw_params(struct ath6kl *ar)
>

Best Regards,
Sang-Heon Jeon
