Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3663EDAB8
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789541768; cv=pass; b=WPLTvD7Rqf4lM7cLGxOMPeaTFqzjNKaxxnLEnopRQu3VsD1mmn1Wh217JL/FNFNuEYnQAxSHnccIRG+N0MdiDHLGnhIVwoUn8XqtQrHbZLs4bI+kFENtsA/lgar8wfEA1TJioD2Vw3md04fkIyRP/YujYJ+1VqgBuCI8sLCclYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789541768; c=relaxed/simple;
	bh=NoE9nFRvmp4Ea/sSZ3r0K/eoMnt2p4WDblnCN36FMbk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pVwRvsTL0F1K7PVjICCF0nr8G+GlmVC3X1HxeHDphKABLLCnBTeurBkCp18JZYwBx+g40M20VDZPpI5O/mXpo3JFoShFX90ah4DmI8YR2J7NJyeNsxPXNz3Rmy32WoRAeEKMdfnpxHlHoxeVHVZLpvhxkRZJrSakAIgwTAx1yFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NnQlTS57; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oeXMEgY3; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NnQlTS57";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oeXMEgY3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789541765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OSGe38PhJmGSFK46iAJT77WdJWyV03W3gLiL5YZ41tI=;
	b=NnQlTS57GqVQZ9XP/BpVuvInB2NVBruiZPRVi7gckzGy5E666X0ufgjThv+WAGEHXTpNGx
	c9mAnKwzL/pSg0j3ExdF/dqhsb125mImJJjLL/hnw+XSplPeGaCrLaPvY8BaBNjo9WHJA2
	OIUXg1/f1o4u/0lsmgG8qoOsC7IapVM=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-jxxSCqGYMQ2Ot7-uAA8WBg-1; Wed, 16 Sep 2026 02:56:04 -0400
X-MC-Unique: jxxSCqGYMQ2Ot7-uAA8WBg-1
X-Mimecast-MFC-AGG-ID: jxxSCqGYMQ2Ot7-uAA8WBg_1789541764
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-8563c2a53dbso81081637b3.2
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 23:56:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789541764; cv=none;
        d=google.com; s=arc-20260327;
        b=pgIzGeBK7y56JtOzax4CBuY2vtxVRcIBzZcrfEKeEZ41UfGd41qsq6oTihfMNGTeT+
         NYmNu4MWCuT4q6VYN68t6O1/UYtq0AhwlP18zrp8ZxFgu3vwxdSXDC1sHnHJlITsgBpH
         Ja1q9BZfgrEPsus71L8Vxa3Bw0T2XRI9WuTkxJJ6sWj3WIQAwH+prck0bFzspr0QL9+p
         XzYLbJ/KYycqbaQJk+9Jb43OYdlFtCe6883kcdVbL82bJh6y1q/aC3cGS24gG7py/xsP
         eoYln1bUjXTrNLzVLePZTcLSCga+EL/mniTqFalhqq9+HN/SE8p2jGaAiAHIdc/jUg3b
         4f1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OSGe38PhJmGSFK46iAJT77WdJWyV03W3gLiL5YZ41tI=;
        fh=s+FiensXRFs7KXLHxCmUDO6nJhmvvBuLVERY11wOA9Q=;
        b=qcqSBecuzjqhUtcUvja3mDAnZJfqj1cicCkp+NV6BXWyuO7w9RuuseUVdUXrPsW9P9
         Ff18qE8vxTQx+s+9Ob/B4Ktc5vvIpcIZ8Q6UnjBLTCX1UU/GvaNfAM7b0rNzCFHVgS24
         6S0HvifPFnv0CGElWlhJcJNxWs6nAfdFrNWGV2jKqCh2wVplzVzAFxOQIaV5HYMp5+YV
         ju8+9h9f2UYm7NqpHf24DrdWpdt1H7wePSS3myymRH+yF+oBQCWcLJotGNZi58B7MQNE
         7zo2itHl7F5po/4oCVsEjnhyArVtaewhGIMoKOCZMHfrxM48gAz/aeJo+UvoSNqVssAF
         CpIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789541764; x=1790146564; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OSGe38PhJmGSFK46iAJT77WdJWyV03W3gLiL5YZ41tI=;
        b=oeXMEgY3lYoyPBurjzRTiTf4GunGAxst3Rn03wSP5untF9LPsMbV21WKleYIrHhJFu
         J2AYfa34U60WeW+6bcy/3luhpMvxN6QQYoQ4qITeTwFMbEA0fF/YJrdc7BzHtxPe6kkR
         5wB8R88nI3DHvzfwLFlzfJZMefFzl/p/CDV7898Q2KRKNxblZOAQEa4BAfHAVIPWW8R9
         YTbAkbZtBCbGiC+60AGBvjfAeouZ/03U45dyKgw3ZaN/mdlxNyeg/Pjiy/3MPVCOf9Uz
         114DTPDhZ6d7kbQU46mO8mit3U8Pwz5c9Gpi5Exz1uWK2ytNLFhi1aYBdhiFAlibVFiM
         x6ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789541764; x=1790146564;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OSGe38PhJmGSFK46iAJT77WdJWyV03W3gLiL5YZ41tI=;
        b=BxxSaMX88Tl0AfyEOPVvK4UoQ0m5uTcw3NVW1Ac0TF9JjJd46NtXzUqO5+bIn+V0ET
         UbiRpif4SqopIw29EwO2qzZY3OV1HOM4pkRZZMgIFMTq2V18/ezS2IO3xTAF3P4Fj6lY
         9213Q9dJ8Ma6j4P1uw+WgW9I2qNe6AqPfXsuaKIXBffw8+YhGaNB6QPetLfzMVZwBix1
         zmietPU216HyHlVZcoVIZmznz4Bl3XeW+TiuMIQGYjqzCVvn3yZmxMjbJ0yTDX2D/c6x
         HuA1WLlgMz2o0dWI/kIE8LRAcZB2xcac2JFUL5pTyYEtfNx/NDCJAlUzhCECN658M050
         B+5Q==
X-Forwarded-Encrypted: i=1; AKwUvByzeI1HGgPbFFdWgOY7CBasKO4dosPweFYbVyznzWG4yWoSnDpQwqjF/C/CnKqRvClVL7qaqhpFLdBIg69fIw==@vger.kernel.org
X-Gm-Message-State: AFuF++lyz/HBmlBAMqIuNXf4KgdnhDkkR/fHjAxmItpNCoxmPM4j0XM+
	q/EyVIwTEmnzH+12AHgRB0HLi06VQ5qCFcaQUrl/uebdgzAt4EaAbwYhYu05sue03CF/1ozjWPg
	iQBenPwAFS/0zgzEzWieFZfNbMQQpZgSEPnJ6kEVUlxjAOEEeMB6lirzcho41SI5N+NJ+K8Ezgv
	aziFH2C/aCiwC3isApA+qThAttm2b6OzXXsYza51I4Lgs=
X-Gm-Gg: AYBFou0qdHghkqnp9sx8xU17mW30Lnd7FonE2NbrVLK0pPe//QzEVB2wSdL4B/GkvV/
	mMJeULIObhzx8qNBTyrHTgyGo6wSxaI/2vvf4vZKK3/mWdqxLxiYA/PeLJIlFs9jxJqA7FOzy5c
	bnAy0SoAvMustjVSdYcSvV+8fhr1Jpy+A7uLtvvkLeQhv3AJHNGrRm8Q==
X-Received: by 2002:a05:690c:f05:b0:873:5c6b:a303 with SMTP id 00721157ae682-892287f189fmr4701777b3.49.1789541763821;
        Tue, 15 Sep 2026 23:56:03 -0700 (PDT)
X-Received: by 2002:a05:690c:f05:b0:873:5c6b:a303 with SMTP id
 00721157ae682-892287f189fmr4701707b3.49.1789541763437; Tue, 15 Sep 2026
 23:56:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260914-fix-ath10k-dangling-v1-1-15c5089682b1@redhat.com> <aql_xwEy5POcVmyU@google.com>
In-Reply-To: <aql_xwEy5POcVmyU@google.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 16 Sep 2026 08:55:52 +0200
X-Gm-Features: AcwNN1W5FaZULdrsdUU_R6G0qyPldCKGYGglzM9AHIv81gsd1ujgPjiFMobViKg
Message-ID: <CADSE00JiEr+k3ykLq+D9C-WxAcPpzXdF3uJnv_P47G1V_-jeNQ@mail.gmail.com>
Subject: Re: [PATCH] ath10k: clear QMI if failed during init
To: Brian Norris <briannorris@chromium.org>
Cc: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Govind Singh <govinds@codeaurora.org>, 
	Niklas Cassel <niklas.cassel@linaro.org>, linux-wireless@vger.kernel.org, 
	ath10k@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 7:26=E2=80=AFPM Brian Norris <briannorris@chromium.=
org> wrote:
>
> On Mon, Sep 14, 2026 at 03:05:19PM +0200, Albert Esteve wrote:
> > A failed ath10k_qmi_init() left a dangling
> > pointer (ar_snoc->qmi) in the cleanup path.
> > Clear the pointer on the way out for hygiene
> > and consistency with deinit().
> >
> > Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 cli=
ent")
>
> It's all going away (probe failure / removal) if we get here anyway, so
> this hardly qualifies as a "fix". In fact, in a cursory check of the
> driver, it seems the NULL-ability of the ar_snoc->qmi field is totally
> irrelevant to this driver -- it never is actually checked.

Yes, I agree...

>
> I suppose you can still call it "hygiene" though, and it's probably
> reasonable to do the same here as we do in deinit().

... that's why I phrased the patch body that way. I hesitated about
using the Fixes tag here. I can send a follow-up removing the tag if
you'd prefer.

BR,
Albert

>
> > Signed-off-by: Albert Esteve <aesteve@redhat.com>
>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
>
> > ---
> >  drivers/net/wireless/ath/ath10k/qmi.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wirele=
ss/ath/ath10k/qmi.c
> > index 0d74548a5f34..08a64f737fb4 100644
> > --- a/drivers/net/wireless/ath/ath10k/qmi.c
> > +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> > @@ -1128,6 +1128,7 @@ int ath10k_qmi_init(struct ath10k *ar, u32 msa_si=
ze)
> >
> >  err:
> >       kfree(qmi);
> > +     ar_snoc->qmi =3D NULL;
> >       return ret;
> >  }
> >
> >
> > ---
> > base-commit: bc35965f6940a9bf834d54187b6088b8eb09206d
> > change-id: 20260914-fix-ath10k-dangling-15676d427cbb
> >
> > Best regards,
> > --
> > Albert Esteve <aesteve@redhat.com>
> >
>

