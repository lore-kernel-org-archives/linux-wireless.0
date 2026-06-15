Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F343EBF15
	for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2026 13:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781528796; cv=none; b=BJDd6mirW4EwcqVugDjfIeOZwz9s0IyOcFth5+M+M7K+VEsIlc5OmDcUlj1xivUGy8tFlu0n3QV84fmCGGZyKrZrGQJRPQmgSIo0x0Axj6PKkCVKvu1UhL6RwVtw8sWzwpnBb+ZvAAy2jTj7at9wcqkJQk/dgYw6+UxXnMiIlpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781528796; c=relaxed/simple;
	bh=Iw06VSTSd13id9KhZoBja5SU9senPz0GmL/KsFWNhgg=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jGrzlzbNmuAPWDiQSJgsYF8GhNwvYVOnzJ9Zl5nPAWUVSOtsR7gWQZ596fpdJGe9pNWNBt6yi41XpqgNCKlir2o80wf7gb0bNTCmcyT6Bzd80EPOdePYCfUnXWVNwXy3cfJiXBCycSOjP6YnUo+Ga3vTcEb6BhZtmhUFbRgX7Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=grHea4+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="grHea4+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683551F00A3D
	for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2026 13:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781528795;
	bh=Iw06VSTSd13id9KhZoBja5SU9senPz0GmL/KsFWNhgg=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=grHea4+O3St7FBU0cs2OI9uzNPZgGZPxcObx9I+gJxmajatBm4NosYYUeDhu3B7mh
	 SThH3AYk1Iq/pLqVzviUgtscm34PjekuBu94uAES8FaHxsrVzgBqLuvEKIeNoF9Kbh
	 otjHGfPuoDhbEY4e9b2+EmZzT/2pmISeY4bN6AENECIMU/RbkHETWgQe7Mt45sa3w5
	 EKOKQb62G5t5fa5MtT0oIRMbeCccKrPyS4qthZ4/emPMKYT1p2Evf8lzfZwh1NnKJq
	 Li/wtDWeDwFddzd9PLU9wMocFWDV5MZm5MHApJWD7EvqwooPMeQaWiGyhLYJhFGM+j
	 7ISY9CaW5ZLug==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5ad0abf1f7bso2503977e87.3
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2026 06:06:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8LVq8j1C/Y3XuwuWiEoxv+u5iZSYb0h56KLri3ybW+DO+D9vafZhxNlJqV6rWbi/wKkxeTnFKcGnUmQNnsug==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhmkHxoPRieWv48dxU5+AbJdam+utAwAsQ0ZjSlpWnFFMwUor3
	z2NbcXT+K6UHY5ZQEFyUt9cHy3cU5kV2bG+EOYdtinHvaDu8FlFSTZpEwyRsokGOBhzxzt8Rl3j
	f6ezJkWhUigG5hsaTHHT84iMuu/kyYj+5MOLi3KlWsA==
X-Received: by 2002:a05:6512:8016:10b0:5aa:62d3:3833 with SMTP id
 2adb3069b0e04-5ad2db2c528mr2887597e87.5.1781528794189; Mon, 15 Jun 2026
 06:06:34 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 15 Jun 2026 06:06:32 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 15 Jun 2026 06:06:32 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <CAFEp6-0oxBEdfH-fqhdM18pt4JewLwrMOON9qpQgLFh8KS0hDg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260612-block-as-nvmem-v5-0-95e0b30fff90@oss.qualcomm.com>
 <20260612-block-as-nvmem-v5-5-95e0b30fff90@oss.qualcomm.com>
 <CAMRc=McQkLnz2OS2RREAbcrsp47cL-W3bCduq8LwPBBUcVNyJw@mail.gmail.com>
 <CAFEp6-0qsqhcwnSjm3=bG21jsCktzn5-L5sk2pNTZcGuVXaiNA@mail.gmail.com> <CAFEp6-0oxBEdfH-fqhdM18pt4JewLwrMOON9qpQgLFh8KS0hDg@mail.gmail.com>
Date: Mon, 15 Jun 2026 06:06:32 -0700
X-Gmail-Original-Message-ID: <CAMRc=Mc6rMwXvo+phxhjioFWwi_kN+yMiEjVwU6Zvu0bgfEaeQ@mail.gmail.com>
X-Gm-Features: AVVi8CcYELXBpxe6-PKRsGQxMXLfew6V8MDcv_4EHem5JqYjvyy5fE7tXsAHiMU
Message-ID: <CAMRc=Mc6rMwXvo+phxhjioFWwi_kN+yMiEjVwU6Zvu0bgfEaeQ@mail.gmail.com>
Subject: Re: [PATCH v5 5/9] block: implement NVMEM provider
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Bartosz Golaszewski <brgl@kernel.org>, linux-mmc@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-wireless@vger.kernel.org, 
	ath10k@lists.infradead.org, linux-bluetooth@vger.kernel.org, 
	netdev@vger.kernel.org, daniel@makrotopia.org, Ulf Hansson <ulfh@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeff Johnson <jjohnson@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, 
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>, Balakrishna Godavarthi <quic_bgodavar@quicinc.com>, 
	Rocky Liao <quic_rjliao@quicinc.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Srinivas Kandagatla <srini@kernel.org>, Andrew Lunn <andrew@lunn.ch>, 
	Heiner Kallweit <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	Saravana Kannan <saravanak@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Jun 2026 11:33:22 +0200, Loic Poulain
<loic.poulain@oss.qualcomm.com> said:
> On Mon, Jun 15, 2026 at 11:28=E2=80=AFAM Loic Poulain
> <loic.poulain@oss.qualcomm.com> wrote:
>>
>
> Also we cannot safely return -EPROBE_DEFER from add_disk_final()
> either. The NVMEM registration point is late in the sequence, too much
> has already happened to easily unwind. The easiest is that the NVMEM
> simply won't be available if registration fails, which looks
> acceptable?
>

I'd argue that it's a problem with subsystem code then as unwinding should
work fine no matter the point in the sequence when it's initiated but I gue=
ss
this isn't really an issue in your patches.

I suppose we shouldn't typically run into probe deferral here so I'm fine j=
ust
ignoring the return value.

Bart
