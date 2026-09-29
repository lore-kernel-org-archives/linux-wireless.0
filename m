Received: from mail-pj2-f34.google.com (mail-pj2-f34.google.com [74.125.227.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05E34BFE7B
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 17:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.162
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790702362; cv=pass; b=Eb0Yx4c6EJ13x6GgebYNVpO4TyuD2NOBebWPL0TIUYuLHgA9bKzNHv5OZgsonNyft80/57FhhB7ILVVgPjqo3SyoMUG09aflN5YXsclSWInw/MgyQjVzYGZLltD4nDoCUEHRt0MxF8LWWZThpowfvTIW+nwP3e64AwEtynkJIL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790702362; c=relaxed/simple;
	bh=XLoH+W4btvpwkIbumWh1h9mdDqao5jnwEcNs8ugGZcI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CkIJcqvwAxqdwOug0h1QIynYZYdhE5AfIq3xXyHoSyA1xSpEHaMfiFjcS0G6LKpvkgp4KfM9qgPEC+GeMUxxR0Zs+9PeWeuV/wrAevQLVJMfxbLy+/jpBTDlxn1DPrLS6xsMU0xG5cCdU1E34RHrJutCHyBqcqq4qRslOMB6YNg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=hVF0yGL4; arc=pass smtp.client-ip=74.125.227.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="hVF0yGL4"
Received: by mail-pj2-f34.google.com with SMTP id d9443c01a7336-2d747eb79f7so20280525ad.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 10:19:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790702360; cv=none;
        d=google.com; s=arc-20260327;
        b=Ejgn16/M/igDOKevYPOuCmy70QCtJLWJlSbR36NxpHWQ+4igeMCnAPcKSg0OcEw0cv
         Z2hSMfK1b2tumVQfqkOGUMfbQtzeta39sDrQFrJqRpiZwouTS/4yr/gwvaXozarzd0dX
         7jHZPtUM6a8Fr3/8OsRjoc8Dx5qsxRt+lroT/vs/7FmZnYddn3vOTjRwQ7jn2hFKQn+8
         bpIpt+Rk+L7He9iiofGA354CCkt3iTpByTvMeZbFAAN1ME8XqzLXJgtcNoziC7hKQPr6
         ItmdP/4h2EgPFNhyj8dhsvEp/WcZF6wQUtt8cDzVIenHZrMo2pAMw1VPZ9Qa3akvtRXn
         H8aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XLoH+W4btvpwkIbumWh1h9mdDqao5jnwEcNs8ugGZcI=;
        fh=jMBOGRNDofb0/C8q6B7nAj+m1hUoweogyGlmsgjE8bg=;
        b=nKswihlXWKLgI7eVoef/9Sceis7kqv/yyI4NTnlXv1dKKc1OTaMC8WpLRLA9+pRm4C
         7QilQeO/i2+LxK21ZRCSJVZ5uGYNoxmOtGBQGjihSW8YWkV4WohVH692hNauCtC2WSKd
         U6n7oFMsB13mzWHyzQHJTxcXZdD6wd5pGDr5mvMUhJzqcuwXx8I3MRcCJxot8e/olBlv
         nCNylLz7j07fCkXcBuA/2mnWLp84QVnC+j1X0ktRvQHYUFWv4cZ20Kd0OKiWSt1qFNj6
         pedeA4WC1e3hFEmLv3tS5JDKk+Pzx8Hhw5jt5XwN0+C/+YNAdVw2HF0UGHe9cMkjF0Jn
         5Z9A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1790702360; x=1791307160; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XLoH+W4btvpwkIbumWh1h9mdDqao5jnwEcNs8ugGZcI=;
        b=hVF0yGL4prYdXN8XMDa/Cw8CcLbVOt1isdWvIdPjK0HTaEhhTwGZ6GkNNkGAWq6FxC
         XF2gfXtUcjBBWi26BYCXqtlCTRKOiWUuEZkB39cZdod6SHv7ntz1JjO9+kms/CeTepZJ
         mhgSmDia3pRWsOIkGgrdpQuu+ufy0sGQkvdO/AaSGEZYWeUOLn8PHKsVSjTTVTMOTe0e
         +eH3bJG2OZlQhoBrRvscy7Z5XMwCJKYPhl785GGc3q+ddaeBfnICCWGX9mnm7MB4ZdNz
         DgTo6dTwiM/8uoPTeOJ1cema2N64LMvrcest3C/WDUdkyx4ZKs8YzfWvUcgXg+RrwCTU
         0jeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790702360; x=1791307160;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XLoH+W4btvpwkIbumWh1h9mdDqao5jnwEcNs8ugGZcI=;
        b=uMWU7KMkYqQzuH8p+1dEhyrzQmEfwu5+HgMDwXwsy316LuJbuXMe3t0qDjg34yfFTK
         74pJPD+IokUDt1XaIOyLNoXjwih5yCHd6UWbwT7oMiQXiHfKZqfr40Iaij6wjN6oeKN8
         o8BP3pfqmcsn6PjH9+3HprSFzscgHJwg5UYnkQ4476wcHdfVElbWz4yDzyEalCob3wK/
         hyINnz0iR4Wp192a1yCIyV9vhNso2yHDntDOSnEpzl5hOxP4pOcbmecv0aCdeCL46j8Y
         vjl2GkHcJzquL0YJv5YI3OOKOwcrejC3KHJujkk78xY922YsyqWreeoSPjsLGZzRec9g
         TVQQ==
X-Forwarded-Encrypted: i=1; AKwUvBz9BK67MWljJ/dANMVI/Bv5vK+UFP2px/AbTYn2JDlGrhUti/mIFqcEdt1/VzBCao5tIA8Jv6OscIO0buLZeA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIaQpmrtR7KmjdH/rdG9SwwflUVe+exABrOslUkzsZ7lUGSoUu8
	XaMH+NnzcmwrG5XvGQTiNAzfsxaGlnIh7oM3G/xdlhTerCPsnJchlRzhL5xgMw4tqPlG8AmUT6j
	48aDofz7o4+QvkcCLr+XY7x+5Eo0JSYHsJD/qKGr8uA==
X-Gm-Gg: AYBFou0HceeSxQGhvg7A14flNIoBYKVqBJhot237jbezuoOKsT7Z6ipZ21/sdoQs/v3
	6QK7F3TML9MnkLzuTK23GORy79X2hJwG76FISqoxs6lnN2oBCzbc677oeTUJFT/2D8JMx/F0Hfu
	cek29N8jDSaBwVGSo8c0lC9KEecqEdLvjJKpiF3x/RONlpFhwYwI6nPyqe52JGbx+oLaWh3y5/s
	h47F6kTy5CGs84SKajOyYam11kGdghA9DgGNb+A4wXguzNSgCmak3nAVtoGEgHG48TQuwX2sYg8
	AJMjrY307uWEtAzVoxALg79x2kUKGbpIFlLsn4y9saLphcwQ9/sATfufhE3QBBfDGUe4jKAE6AI
	mwkfIQ+x+f3U0lSVbbEse8N+zaabid8u66nw=
X-Received: by 2002:a17:902:f541:b0:2dd:c0ff:e72b with SMTP id
 d9443c01a7336-2df7dff6a98mr129292205ad.61.1790702360116; Tue, 29 Sep 2026
 10:19:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260922-qrtr-multi-ep-v3-0-c00831e88957@oss.qualcomm.com>
 <20260922-qrtr-multi-ep-v3-2-c00831e88957@oss.qualcomm.com>
 <7aed969d-0868-4c9c-967e-7766dbba427e@oss.qualcomm.com> <13BFC5B0-77E6-48F2-B857-37686EA1DB2C@holtmann.org>
 <05e539f8-bb7c-4038-8a83-8ab0d1a5b917@app.fastmail.com>
In-Reply-To: <05e539f8-bb7c-4038-8a83-8ab0d1a5b917@app.fastmail.com>
From: Robert Marko <robert.marko@sartura.hr>
Date: Tue, 29 Sep 2026 19:19:09 +0200
X-Gm-Features: AclHuK-ToRBMZLSrRMx2mcPZtu0EDHFcdsd8teCC6hGeRk6_RwlD5j4V__Nj-zA
Message-ID: <CA+HBbNGS7sVROVN3mywPJEcRKn_+FzzxkijN4Uqv0CMLP-CEJA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] net: qrtr: Assign unique node id for MHI endpoints
To: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
Cc: Marcel Holtmann <marcel@holtmann.org>, Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>, 
	Manivannan Sadhasivam <mani@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, linux-arm-msm@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
	ath12k@lists.infradead.org, Bjorn Andersson <andersson@kernel.org>, 
	Chris Lew <christopher.lew@oss.qualcomm.com>, 
	Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>, Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2026 at 7:17=E2=80=AFPM Juha-Matti Tilli
<juha-matti.tilli@iki.fi> wrote:
>
> On Tue, Sep 29, 2026, at 20:05, Marcel Holtmann wrote:
> > >> +#define QRTR_NODE_HOST_BASE 0x10000u
> > >
> > > Can it be exposed with include/uapi/linux/qrtr.h also. There are user=
 space clients like modem manager
> > > which need to calculate modified node id to distinguish same service =
from multi modem over mhi.
> > > This is same as wlan use case.
> >
> > did anybody actually looked at the proposal that Denis and I came up wi=
th. It was exactly addressing this properly.
> >
> > It seems you guys came up with some hot fix and want to run with it. Af=
ter month and month of silence and not bothering to review the proposal, yo=
u are trying to push your thing?
> >
> > If you don=E2=80=99t support userspace, your proposal is broken. Plain =
and simple.
>
> I'm still willing to submit a new version of that patchset originally by
> Denis, if the kernel devs so decide that it's the way. For example, the
> "radix tree of radix trees" approach could be replaced with a hash
> table.
>
> There was also some criticism about a layering violation in storing the
> endpoint id to mhi controller. However, maybe that could be reduced by
> providing a correct abstraction around it, so that other code doesn't
> touch the mhi controller structure directly.
>
> Other criticism for that patchset by Denis was its overt complexity.
> Yes, it has more lines of code changed.
>
> This dual-card setup needs to be handled somehow, either by Denis's
> patchset or by Manivannan's patchset.

I second this, as in OpenWrt we have used a hack that worked only with
QCN9074 via its MHI debug
register in order to support boards that use AHB+PCI radios.

Regards,
Robert
>
> BR, Juha-Matti
>


--=20
Robert Marko
Staff Embedded Linux Engineer
Sartura d.d.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr
