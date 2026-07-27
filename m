Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3079340928C
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 12:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785157185; cv=pass; b=WOfIV5xhFGXHmlGNtBw7d1M/42rByP71BbcFL/ZT6XetqgYLthF0WlJp94+04VR2cTeiPKQLdww2fDtEJLRCNwDxafotFwjJwnXEH3dff2VbQxjW6uBlV3nJgjH9STS4RQQDaJ7vf6DZt1WMzZpNKnqfO4y/Z7jXokXDWGBp/zk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785157185; c=relaxed/simple;
	bh=luUc9ZQFmCjynsr/029wplBmFfuONlqLQlNMir6ffmc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hrRCAVOMptIkZ+iIx8b892n3jyJSBThrHHykHcQi8Ypj8sgcwtrHzzXYbdRjK1fn67fRN0PKDG2N2+tFGjcArBKom9Rg0azdhFUA3HC7Do9MvrBrFMjP0VRRv/Y4T6rgMZx6j1QRTs3GKQ3kkV7erUQ0TjZC/Zqd4Onl4NNExbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jq+uwgTQ; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jq+uwgTQ"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-80dc4a68e4aso28072177b3.0
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 05:59:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785157182; cv=none;
        d=google.com; s=arc-20260327;
        b=UlO9szY3ZCbn4KqXVJkogOEZL7CQIViWp6sQSL0qDLYpJ8JW6rVOCQg7gfSOLfPYmr
         vuWN3FJ6R82IJsTo7V69z3UMtoT9h1xcMctjAqee716howjEHHliVE+Cs8JprSO9sJOv
         mr9n63+0OIZGV4bocZsuG81zJvDIrK65vtmH+oEfv7mxiin1mmvs/YlxXah38G9mvyuo
         R9mnuPdJq12L+Bb1BKuUiZ3juhhO+28s5fc5vnYjxNxS5AwCgiDKw9XK37bsdbdb2Xzq
         mmrRBsavrJ28iFdU2cFPolDGv3yUckzP8w+yHX8tee1J3gXTCqb1qVVrjU9b2wCFawz3
         LHRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ix29oOBbLOf7nlyiJN1FbRfyq7KaaHwmDtcPHELsDuI=;
        fh=CPzRhZMQIRDtdjIrAVUVMptr5Eys99xqvht5iSXBF2Q=;
        b=HsQOZU2cRYBWDoNx/KeJyt6kkRd4kbWbUV2ecOHGVAMI51nBhk4SwmZfAViRH8lF6a
         uuLm4DGvlsm2ECtToiAFtRgPM2U1vN8GDBrMpY2a/JB+1frFzSRnid5wPiUMzC6k1if9
         F4U3V/j/gdA39VAOaZ+yUnSK8FTDnlLcIgDvS99XpcBwn5vWNB3kpmpVEiZ6sjXmPis/
         G0pbEs85vg7ZU4GduoIjxQYK6uMRAtp8Tg8c4PeiIgkh75cEGl+8/Vz/FxtiMRq4Asfx
         X7E8SL6W5aIH9DZcM+3QahgFHLa8gaNe5n6+p6nagFiR3huhAlNd21qek2+MBcXsOL08
         9dkw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785157182; x=1785761982; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ix29oOBbLOf7nlyiJN1FbRfyq7KaaHwmDtcPHELsDuI=;
        b=Jq+uwgTQ0O1mmHxnBGxWcL+kdE/a9RtHdIP1tjT7Ei9n+xl4gDgXDSpklqMXUWUDZJ
         ac+GrumYYzSuNYK88A3/T4fkN6MG4wQqkhyc+crip1OV9Ijk+VP1IqgTH+CDfXD7MNfK
         izYR0QrNtnZH5422kCYtXpZUgaLbeTRubkLzot33FEHtm/0zOCL+zY/SYXVb/YZMHfi9
         1UT3syyMpKMiD5iEheioIjGtc40Mtnrnje0QPSkcU+JF6Fi7cbHX042hz4Kxs0mUOVq5
         ese1af/Z/IOALMSRWCj+UGhUzDc90HKs6jlW61M0+1P4+BJjqXHXw0K6Q6tEdTQomu6E
         hxMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785157182; x=1785761982;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ix29oOBbLOf7nlyiJN1FbRfyq7KaaHwmDtcPHELsDuI=;
        b=EsGo8xjnuvp4AoiW+U/PDuh8SsuZHtAhf8FG3aRi/uIi2KNQCDJaRQke+Is6KX8LcU
         9bC2go1fskdsXJrYHrv8rkRyjJdzAFPPfTkEOXBN9+N0bmapzE/34cifkmKzkz+OYoed
         dlAJBAJxc0azHTstFf6LbWxOUpHHAQs7pRgEDsdgGT0yCarNcwFXa9SCwd/3C7pwh7J7
         amrdcKLF4bHMn3rXhq8DoDArx+3cGYtg5GO0SaDmlwegxd9mIh+rPqBl86i9nhYR8B6D
         TRK8lAV3TQV52YE/RRG1WcJW9q3cu/l3rdDg4Sp1+W5Vemlbz9eMpfvAavynFX6StXbv
         CGvg==
X-Forwarded-Encrypted: i=1; AHgh+RoO+hy84J4okiC9/Py2mafj8XJZHXwX/Tm1MlwwNv9bJBUar4PHkA5qY5PNxjexKM17N8oXVs/qGgrkemABjg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvBbt4uAy6HSUekguiWJdVL2FtTFzncSvLqbw+K8qeDd+BAfaz
	3a6AVaByTEH8LneqGnDGNKKBqg5P5vmKYFdBZFLvWM/RiawAHwXblrS0kFIdxCclIe3kkJMm8ZM
	iXZP2FiOcvvlGn7EXfobAcBkcqGCKSkw=
X-Gm-Gg: AR+sD13LSfz0MkrRT+d0seW0wdXLJvETY3L+G61Fj7aPbgcDlXP3S2M9tWUt76MYsMy
	agV2yqIao1/fn54m6M9ffkNTboQGdeUcrN6xYXUCV0TYwxoWQK/RMPRpI8OM3bPz1rjqgIR9JKk
	f7wgN6yfvPW5/MewfdG6l4YIdXlK7yuBPVNq7xOFp8H0rkNYLh6lFSjRi3LnIUkIMlm8oWWC6Yq
	LlgF0zVu67Xh+CH1GLWZJqUhEXBdmOFqzLk30Nlx2+bHpUNV7iaiAfA4qlpSxesuulHLg==
X-Received: by 2002:a05:690c:6f02:b0:81e:97e2:2210 with SMTP id
 00721157ae682-81f69ebac17mr31274727b3.69.1785157182142; Mon, 27 Jul 2026
 05:59:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723184538.3888637-1-ekffu200098@gmail.com> <adcfc6f2-3309-4496-8331-1ae31e85d363@sirena.org.uk>
In-Reply-To: <adcfc6f2-3309-4496-8331-1ae31e85d363@sirena.org.uk>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Mon, 27 Jul 2026 21:59:30 +0900
X-Gm-Features: AUfX_mxOitBR08KsPWHGWKTOhvBmlqBsOevQYdsbBN1kI3uyZROYcZJFQfRk1pk
Message-ID: <CABFDxMEmB=5UZx6RZgFNZyB5sg-+e2hgx_T1QjV0JzqP+auTFQ@mail.gmail.com>
Subject: Re: [PATCH 00/36] treewide: remove conditional returns with no effect
To: Mark Brown <broonie@kernel.org>
Cc: Julia.Lawall@inria.fr, Alex Deucher <alexander.deucher@amd.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Andrew Lunn <andrew@lunn.ch>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>, Borislav Petkov <bp@alien8.de>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Daniel Lezcano <daniel.lezcano@kernel.org>, David Airlie <airlied@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, 
	Eric Dumazet <edumazet@google.com>, Florian Westphal <fw@strlen.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Hans de Goede <hansg@kernel.org>, 
	Hans Verkuil <hverkuil@kernel.org>, Heikki Krogerus <heikki.krogerus@linux.intel.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Jakub Kicinski <kuba@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Jani Nikula <jani.nikula@linux.intel.com>, Jaroslav Kysela <perex@perex.cz>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Johan Hovold <johan@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Julian Anastasov <ja@ssi.bg>, 
	Leon Romanovsky <leon@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Linus Walleij <linusw@kernel.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Sakai <msakai@redhat.com>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Maxime Ripard <mripard@kernel.org>, 
	Michael Turquette <mturquette@baylibre.com>, Mike Rapoport <rppt@kernel.org>, 
	Miri Korenblit <miriam.rachel.korenblit@intel.com>, Nicolas Palix <nicolas.palix@imag.fr>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Paolo Abeni <pabeni@redhat.com>, 
	Ping-Ke Shih <pkshih@realtek.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Sebastian Reichel <sre@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Simona Vetter <simona@ffwll.ch>, Simon Horman <horms@verge.net.au>, Stephen Boyd <sboyd@kernel.org>, 
	Steve French <sfrench@samba.org>, Takashi Iwai <tiwai@suse.com>, Thomas Renninger <trenn@suse.com>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Tony Luck <tony.luck@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, Vadim Fedorenko <vadim.fedorenko@linux.dev>, 
	Vinod Koul <vkoul@kernel.org>, Will Deacon <will@kernel.org>, 
	Yazen Ghannam <Yazen.Ghannam@amd.com>, cocci@inria.fr, amd-gfx@lists.freedesktop.org, 
	dmaengine@vger.kernel.org, dm-devel@lists.linux.dev, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-edac@vger.kernel.org, 
	linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org, 
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-rdma@vger.kernel.org, linux-rtc@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, lvs-devel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	nouveau@lists.freedesktop.org, platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 27, 2026 at 9:12=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
>
> On Fri, Jul 24, 2026 at 03:45:02AM +0900, Sang-Heon Jeon wrote:
>
> > All patches are independent and can be applied separately, but for
> > everyone's convenience, it would be nice if they were merged through
> > a single tree.
>
> Please don't do this, it does not make anything more convenient - it
> results in huge CC lists and makes it more difficult to work out who
> will actually apply things.  If there's no dependencies just send to
> each subsystem independently.

Thanks for letting me know. I'll keep that in mind. In v2, I will send
the cleanup patches to each subsystem independently.

Best Regards,
Sang-Heon Jeon
