Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA57523781
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 10:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788951478; cv=pass; b=RvHro6UYpNlDvEspUouiK5S3sv0loPOKubkPBpYLT0Tx/RELkwWEc1DJQjFe42kLH0e3lopQRXPbdlMvXrNewk6HQP89W0K3PshVmHdy4zT9NcXpgaoBfZOv4q1/skKxQsINqxgTTr8R6Wf2CS3Eo2Bbd/tpnB0Cj4+D6x2k/Ck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788951478; c=relaxed/simple;
	bh=+7UwM+I5OWAjsSSqIiKnDb25c70NPZkRKRgcbHM64vA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EVrF9aByugMELY1AdQDAdb4J1n+DRfliX8GdUqwjDgifSX9tZOBfYDAm3Y7InZLWrBxUedKeokLIMfz/m8D/P7oxwnX5eBZHqkS5Bqw38IuwjX9f73pXTkw6dufPnSVqsyl5MGTFYx7DNrxI15lWG0j8AH566yNdNdxKdh2HmPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=J2RinSdh; arc=pass smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="J2RinSdh"
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e50968489so29057d50.0
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 03:57:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788951475; cv=none;
        d=google.com; s=arc-20260327;
        b=sczS5g/+iq4mkDGu0BDrN3KUzog3eZ9aoFK0g4oXYJcfIrMzzvFb5B1Q0kmq1+asea
         DjpdwaK0YAQYnQM70zekZ+JgSDvaIWw3s14x/tOk4+ZaXGEO/HK4KOysK52X1tG09Nfs
         dan3PxmdFzkkyZTub3NH1/lJUylItS2lN1TIkeg34+iBq96v4hgAJDzxbIAYXz2lU8i8
         09bYutvUj2H9qDXU1AJDszjxSqtgLkrjDChEIFAWkBlE1+d/vWL527kg2jHXI7zcph6c
         E+VHBC0mDeZ60+KPNweZYtDP50YV+Ow7VqJab6iXagHYu+c/k93Lcz/bW9i4B5R6jJ0X
         UXiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+7UwM+I5OWAjsSSqIiKnDb25c70NPZkRKRgcbHM64vA=;
        fh=xXuWRZjaOxPT9gtWymVyi9hqy+Qik8CzPU79UHzNOMk=;
        b=dL6ExBfvh2rIQ7nlfF8x32BipVOD8trxIxWqILChpTk3Lo0z13YRXxyS2srW9t9ArT
         uX87lh1NKDvmQW+W82qtcnDHvsKytYDp7wmWxKWnsTA4MeHmIHuTjyx9Kq1c4hE68kwC
         gDpjT+26xIR3p7ufiJJw4Ibmp4063ayWBCf01h5twcMHfDLc9w3kied0S+wy+TKfCCB7
         VdUtEbDqC563PkQ0x3DsAzNCYB5/xLi3H6oydJd0gM+KPpYAmJI2CVc5kO+0Ut2RELx+
         2LiUJJtkkUGmPHbC9LKJvp/Yt+Shnklpi5n5lNGkclMS+UeZqdrMdLSVT/Xxu3YtLBO4
         9ZEg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788951475; x=1789556275; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+7UwM+I5OWAjsSSqIiKnDb25c70NPZkRKRgcbHM64vA=;
        b=J2RinSdhSVlM4dHjbNawbYSlcatHxDgQzuOAzDuVk69GojxPY7ebHUJV5zEevRxl5Q
         Hlqrx6tm1AvhynUQrITDntp45Bhb3bsjE8OTy79AP7KUnJYF6brCeRDpIdH3zK3DmSfY
         SPejIrikgRXQtnRoKfLOcSBH0dY8WbjVFEosGpsDR9etH4GzoTlp2O8GlTGKwMdTq8+u
         vn90qf41bmmwc2AS4RFIzeAbRx8MFJCFi+CL6ux7vwvm3l6XwjekQyy4FKGN0pOMb+Lo
         6zCijmw892v7a0wOyhpcuNSwfEcjg+U/Ffv7SgPHQnq60YwMSdOpgJ12EP0rXmIGmUwp
         jcHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788951475; x=1789556275;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+7UwM+I5OWAjsSSqIiKnDb25c70NPZkRKRgcbHM64vA=;
        b=rJ8NHCoqS7c++/8wFL1uLRZq7iIOacPpdHs6f8RBQRQ348jAaUR6yXkxp2pGw/XTpf
         iRyOre6+bDCYXmQ9U7XDaX+RxpBS62GZ3SBt2A2VWTG0dWyEeuJoQjl9lcQSwJLm0kq3
         SNZ+7mr7+1Ze+9d0mVxgoUdPwBK5Vyyuj+65hF6cuyQOlRo9YIBnWDfrSD9mgskLdIqT
         oQWmwxsqhyV/nNbTYfNpsz1jU71Zb6wm7YgTi6aWAsBHu4DrmVi5StdeJv7xVTr1VjxW
         P5CLlgKqxu03MyZMj8IvRts6V6lyGTYWe/foT6WEHCWzhPgXlflfYe3qdOZDNbWJ8a0M
         9asQ==
X-Forwarded-Encrypted: i=1; AKwUvBw1q9578QTy53ock8VoymCJ115pz83uxur2elSKRoVvi7RH0GPUEBefm/Fs6dTnymReM+0xFGCr0fRkuPuxkw==@vger.kernel.org
X-Gm-Message-State: AFuF++mwH7UfUL1QcFzwkWyDspLtnlZ6PcwHQZQQndcUyxLNNDP5L1kn
	t0qQP8VLha1Dxr1NfemNzD2ZyhBErWJfuCZaYsjLsUwpCrLacw5mkrI7UZAEePc0OivruwKASk9
	lX03/rI7sTnGS5GcJu0ihuVtZb/vld5TnrSEZutFP
X-Gm-Gg: AYBFou2Lzm3ip3sGWDLwLfmeQj5wrI7tW0AK2/7n1NwIc+nVb3MNGWCpoC3f3JOkbfy
	Wc/clGdDz6Lhx+ORNZ5Rzq/AZJvYSU587tdpRdHknVW9wrn0mEh0YGEiVfib09o9oUAv2lPCh/g
	BzPU7srfac/fbgEMNLf57+wwukkfObLLFpCZRIJSoG8PimnY7kXtyNkhXiBR8uhtKo355QIwhuj
	ljUPW3OeQa48gUvsif0pfiWb97S8/uw826TlhOlPMoMi3rehbFHo5kvwgTxcyFTr7SUxrD2fQ+1
	f5IcaAETD4+mU82Ri+4NFrWzU/Sav3hj1bQd3frUpJMv8l77TLkQPqOyVLAqwonOX76w0kZQqzg
	iLcje36mmvkO97RS5avB7XF+8wqd1ieZx1SC/dQuJKlp+UAY6Sn/aZ2xEzgXIOdxx/LuVxFseni
	wN/5vWIfzQj7PWIluSrnzRsJwDeDj1h0+AdufZRQb8GL82zXR4RD4huo0Zj60KEGyOdZ6aaoW9d
	krGdJLQhwjN3bDC8RqZgsGbkQWqE/93kZ3houmCC8pSNWmcynH1WF2d9Q==
X-Received: by 2002:a05:690e:4505:20b0:66f:bccd:37ce with SMTP id
 956f58d0204a3-67110108e7emr16273d50.48.1788951475292; Wed, 09 Sep 2026
 03:57:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260908144155.756569-1-julius@bairaktaris.de> <87bja6g0eu.fsf@toke.dk>
In-Reply-To: <87bja6g0eu.fsf@toke.dk>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Wed, 9 Sep 2026 10:57:19 +0000
X-Gm-Features: AcwNN1URtKyPLWxL8AxRCvE00fK2lwtmuBMLpLb7GLb9csaxF12oEBNRGQbBqvo
Message-ID: <CAC1t37+8HQPupSQqYZ-025UdMtDCnqqDWty4xqoiGqkw=yvVDA@mail.gmail.com>
Subject: Re: [PATCH v2] wifi: mac80211: don't reset the TXQ scheduling round number
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: johannes@sipsolutions.net, nbd@nbd.name, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the review!

Am Mi., 9. Sept. 2026 um 10:54 Uhr schrieb Toke H=C3=B8iland-J=C3=B8rgensen
<toke@toke.dk>:
>
> Julius Bairaktaris <julius@bairaktaris.de> writes:
>
> > A round is ended when ieee80211_next_txq() meets a txq whose remembered
> > round number is the current one, meaning it has gone full circle.
> >
> > When the AC exceeds the airtime limit, ieee80211_txq_schedule_start()
> > sets the round number to 0 to close the round. The next open round is
> > 1. A txq from an earlier round 1 still remembers the "1", so the next
> > round stops on it and serves nothing.
> >
> > Fix: use a separate open/closed flag and let the round number keep
> > counting.
> >
> > Testing: ~4200 skipped selections per 20s without the fix and 20
> > skipped selections per 20s with the fix on ath11k (with my AQL series
> > applied) at BE 500/1000.
> >
> > Fixes: 8e4bac067105 ("wifi: mac80211: add a per-PHY AQL limit to improv=
e fairness")
> > Assisted-by: Claude:claude-opus-5
> > Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
>
> Seems reasonable:
>
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
