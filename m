Received: from mail-ua2-f12.google.com (mail-ua2-f12.google.com [74.125.226.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F21B48EBEF
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 21:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.226.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789595077; cv=pass; b=FDUWy+6Qd3BT2cUlhgZZXnY1h4g7BoK6PxxcEPbObx5FXQExhUoyedfViewJgy2yPp5JPawx+E2K08T/c2vfm5mf1yQYDbT6KOBsvWjl+8+7LrI/xWR6RdyNGeBAhxaIBbTO3y3NL8MNFd27CDHAEj48DaEIBmSQOvDNEFIpyLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789595077; c=relaxed/simple;
	bh=+TMWi8xF1c/GpLGSJWBDMGttEHh102/5Ofx0+5TAWdU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gVcz6vqoX0HCHMnJFRPAnmL1Eoa2aMeKKtGKdLM55EuN7cVlkTPGquu3yMDI/QMLWlzlsMjAbvn1T2KWcG/+GFVbYNIZH9PY8TGMlGVqbc2Dzzjr6qoMMzLRRZOfO01lxNtU4kDv6uR5SQyISD31Ku4x1dW24bcseqyyaRjcJJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PhRvxyDc; arc=pass smtp.client-ip=74.125.226.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PhRvxyDc"
Received: by mail-ua2-f12.google.com with SMTP id a1e0cc1a2514c-980b6159d30so52142241.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 14:44:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789595057; cv=none;
        d=google.com; s=arc-20260327;
        b=fRcX5ZlCQ8FihbrkMnuWrEeTU6xXoFakITQf312jLGBA5cnxrS3+gf90doEbwgqwnk
         W++iiDyZ3K95/681VcT7dRs22qGloXBtw4+rfKXZmQ3juNvc3VYBIn587Kfxbpu5xAMH
         xj0NzoLOqBBlYdDQPiiwwNrUoxLNiSbvV8a1OqE+xIBiMUayF10RzBc2bvrjETMpDEgj
         TCcAZyD8ySSLQo1wSAyriP9xRn6+TjFQvwgmh8aIqJYJlUVIge3Qo0TZ3H4JAepEvaLz
         HkmfAcBcwOh1pWrlWrrkxIcjUfBw2BcjPNIbITBTpBJ1m6O2/xbYZxMzcMeBiUT6rqpz
         XLcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+TMWi8xF1c/GpLGSJWBDMGttEHh102/5Ofx0+5TAWdU=;
        fh=DrJS3TdMXkyFFK+v/jGfH4VDF4SNxwT7EPiJ8/ogLRQ=;
        b=oezmXXHbcgzD6NHtr0ezccuYnPWsSRNrSbRZqn3SHt1BDr/N5a5sIMD+1Fj2+JA2oS
         X5ARUSfHDPQcuiRV34QBrFcuQ9ZBtqxFFedpbDM1ppXQW1QVvfRIOAPs36Pgw8JVHuyL
         1VONBe5EXWrt/9k7fMVrJ1c46mUu/ISy+iOFCxdJB/+zfvgTsb/caG44qX10wrv001Rz
         OAZ8/emrvDMNVj64qO/1ZJPKxSMqqYK4DIXV2Ky7L5CLFc/uxqHSTVj3TdFPWJ2tCtCz
         qoRXMqts5QdcCi9v2NUh9Lcd860lmPk93dAX1LmDv04CYiOPIGqIXjuKfNZhgleqkyzi
         Ig3Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789595057; x=1790199857; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+TMWi8xF1c/GpLGSJWBDMGttEHh102/5Ofx0+5TAWdU=;
        b=PhRvxyDcEKpo82rz7bjO1wDQ8uBdzgmqFw/6qMLJ6ysl579NXOSm57qPRzt39pD3oV
         RQb6cdMJNN/Ek0B5W2zGNfO0RqIoSKMqtIpUc7eAhIfyNHQGufGBDtCJwInLu+pX9hxn
         J9cpThCkU1tmfCxsOJRLdZFf8wYm3kRlo/yoPwYzsu2PbhjQqcSKR20KyEdhLP8618yJ
         5CmZfZeIm2+Na8mFl/ktZ3dXA1iPW6HhEYtD+ujAGpNgWXor7U3Ki4cMIqiM6LMBSHL9
         ktggN+6MCwK15bvCxc3iBeUikkFZwpbRMOG0Pyt60U5y0YJFcb8fm4EhJ+LQPrX9SbDv
         Tdmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789595057; x=1790199857;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+TMWi8xF1c/GpLGSJWBDMGttEHh102/5Ofx0+5TAWdU=;
        b=1G1+/woZKhCIhKuUkQO1UQr5jJOfZF8aM5XUgsSf3II8r7uImvK0DnkOkC/zIE8uJd
         T9JL4a0V6xaDf5V0eaBarUwGAJWmXh5xYhITiUgIXBcfMbnD8C3MD5aFfSN31rgeNe8g
         Q15C7eIbvXczKnwkHnIaKmSxF7xV/qbAviZe+e6VobeazD5748bZ6EEqewgPnBT3jOhG
         98ic4HsBO7RCvHsya1/wjPZLY+mox2jimkzsb8wy45hkdS4e1HnOQ8AfDbAMKFU8oluw
         lCsRDmWCymvX8AIvPo3DIK865AOv60j/6LMbxRT96mEpMHcTyiwIUxqcjVp2H75fPcjb
         06Ow==
X-Forwarded-Encrypted: i=1; AKwUvByDFybmDUeXyr1XQpYxASge5aDy8MTjfodJWYnxA8xTEtDO5Um4b+zklITVDu8NtG8/Kc2QfVQ1lzua5FbFTQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mJscLkKd+nmzZoSV3efRNeYum60o42VR4r4XNk9P7ZzYNDS1HG
	21yLs8ElYuMxlE1n3gpWcUpQSZRaZpmdLdwm/E0ZV6p1nXm1Gare4HzkJ812HGlBdb3zEzWRs4U
	TRC9zXmU2jGw3LpJyI05WkxBcmjlHGhogql//Jyk=
X-Gm-Gg: AYBFou3+LnSOpdA2Zkn+1HJjFOpW8G2wi9sl5DL0QYfJPLhoGDrmoDTknBe7iXC6eLT
	w2wQz3JgPukDrRC6Y4rBGSQdJcRL3REYZNx4XQqCAiHdyU08frBecCHLpVkc25oTl6tj2+wOaRG
	oaR3j5nlx7fNEKfq9XryL9UaR9FR3Ji/xcU4mUOV5zSlEbYqJU0Lt0G0cw+Bn8vidFfh855YSkd
	NFjgAExFhtAQ8d92+8AlJOUukKzJjd7/QTcIwl+h0Hlr4UlKqRTfU/Qg3WO/KX20zlBP8NSN5xu
	3TNIhsbJKamsFozhGUjrxwcb9JU1o5Oo7FAFvBxCMyMf3WzLqb2tTcGSVLWT2g4s2eBOmgfnp83
	0f2ddKwr2lbtnMF+NG26j
X-Received: by 2002:a05:6102:a85:b0:7a2:2a6b:e7b4 with SMTP id
 ada2fe7eead31-7a22a6be8efmr62586137.2.1789595055938; Wed, 16 Sep 2026
 14:44:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260915081910.4142719-1-morbo@google.com> <20260915081910.4142719-26-morbo@google.com>
 <202609151258.5FC01072@keescook> <20260916010945.GEaqnsWSZ-DTMyTO25@fat_crate.local>
In-Reply-To: <20260916010945.GEaqnsWSZ-DTMyTO25@fat_crate.local>
From: Bill Wendling <morbo@google.com>
Date: Wed, 16 Sep 2026 14:43:59 -0700
X-Gm-Features: AcwNN1XbboPOY3deKY79Gty15vkSErYIT9HTgeQdVXaDzFhBvm8_kiOA449bIqU
Message-ID: <CAGG=3QVZRCJ94+DOfSsSDhsrXVYf-ec01NZBy299nYiCAYfXKg@mail.gmail.com>
Subject: Re: [PATCH 25/28] EDAC/thunderx: Replace strlcat() with seq_buf
To: Borislav Petkov <bp@alien8.de>
Cc: Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	codemender-patching+linux@google.com, Russell King <linux@armlinux.org.uk>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Tony Luck <tony.luck@intel.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Matthew Brost <matthew.brost@intel.com>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, 
	Matthias Schwarzott <zzam@gentoo.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Arend van Spriel <arend.vanspriel@broadcom.com>, Rob Herring <robh@kernel.org>, 
	Saravana Kannan <saravanak@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, 
	Sylwester Nawrocki <s.nawrocki@samsung.com>, Peter Griffin <peter.griffin@linaro.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Linus Walleij <linusw@kernel.org>, 
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>, 
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, Jiri Pirko <jiri@resnulli.us>, 
	Simon Horman <horms@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Tom Talpey <tom@talpey.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Kanglong Wang <wangkanglong@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, 
	Qiang Ma <maqianga@uniontech.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Pengpeng Hou <pengpeng@iscas.ac.cn>, Ard Biesheuvel <ardb@kernel.org>, Breno Leitao <leitao@debian.org>, 
	Thorsten Blum <blum@kernel.org>, Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Lyude Paul <lyude@redhat.com>, 
	Ashutosh Desai <ashutoshdesai993@gmail.com>, Imre Deak <imre.deak@intel.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, Johan Hovold <johan@kernel.org>, 
	Johannes Berg <johannes.berg@intel.com>, 
	Miri Korenblit <miriam.rachel.korenblit@intel.com>, 
	Alexander Stein <alexander.stein@ew.tq-group.com>, 
	Cryolitia PukNgae <cryolitia@uniontech.com>, Jiaming Zhang <r772577952@gmail.com>, 
	Will Porter <mrwillporter@gmail.com>, Cen Zhang <zzzccc427@gmail.com>, 
	=?UTF-8?Q?C=C3=A1ssio_Gabriel?= <cassiogabrielcontato@gmail.com>, 
	Rong Zhang <i@rong.moe>, Arun Raghavan <arunr@valvesoftware.com>, 
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-edac@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, linux-input@vger.kernel.org, 
	linux-media@vger.kernel.org, intel-wired-lan@lists.osuosl.org, 
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org, 
	brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com, 
	devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
	linux-gpio@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-nfs@vger.kernel.org, devel@lists.orangefs.org, 
	linux-hardening@vger.kernel.org, linux-sound@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 6:11=E2=80=AFPM Borislav Petkov <bp@alien8.de> wrot=
e:
>
> On Tue, Sep 15, 2026 at 01:00:00PM -0700, Kees Cook wrote:
> > Seems like seq_buf would be better her? But yes, at the very least, thi=
s
> > needs to be scnprintf, not snprintf (or add the checks as you have
> > here).
> >
> > The rest of the seq_buf conversions look right.
>
> This driver has been an orphan for a while now (we just made it official)=
 so
> I'd prefer it if we don't do anything here.
>
I'll remove those changes from future emails.

> And yes, that mega CC list is just gross.
>
Apologies. :-(

-bw
