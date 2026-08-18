Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9114477E3
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 09:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787047098; cv=pass; b=lmkGdatBWKsbvkoLKpG61oaLAT3FrHyucN9O3FxmH/DBQlPtUMMcsToxclQ058RbHqvRNndHAqkczLSz7qp2G/Krd5Mv5FzGicACjqAci6kbBwUbB3C/AQN75PGb94H5s+eSprpYkRwgxbM8YlR+EMK8T4ibFv9AkrDVkWwj2YA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787047098; c=relaxed/simple;
	bh=v7X5fOOgkMN7zwozDWTMmdpVAqvNyDVzElCQ5lmWHdo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GRkh64evusesck/H6LF4hYpr1nw4IcKaHXuFcmU2ZX3Yj61WbyxEjUHhtJenGCVrq542bBeDwkAzG1STp+vs3yGUtheoBkJReWQMv33yXqVzi18KxE81jqhk5W6Ky946vdpccNXXsx28G+3w28oL77lIkZmD7PVyOMXjlYEEqig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XTn1BIgF; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XTn1BIgF"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5aec6360133so3653525e87.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 02:58:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787047095; cv=none;
        d=google.com; s=arc-20260327;
        b=Pf2g07lYe0BcewLaPoLkLfWvCerCj5+AWCZ8uUGZP2O0PUqpmY2atRIzEZOpeHyknq
         s7EwBDmdF3tsIvG5JrlDTaCgvduK3ah+Wk6wMbZnFknZKTBRJahlUEGreikiar+TkCDn
         jqFcmC0S8I53FkmgYJ5ZosG6CiZxCHrYVqGoXfg/vOdlj4GBCdttf3pB+FYWlF1rO/dC
         k5HOh0oZMsnNmv0Er6kr2p/zijeA2PejD29BZBmSjtPRA1Morsjr5u8T+I0uvzVIDw5L
         WEaBfSLqX4p4qfGr1CvENgYeNYBhF5wQW2IjQyLi7+jWet+pBtbKa485PipN/8IKtgJH
         NIqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wB5u1mD3caKiv5VwodTINCWhAlYduQugf9/JTmV6yLg=;
        fh=/vG4OwYSxmSDgQF/eeRIwd9qOBhw9pLz7uJchUVvOR4=;
        b=SgTZex+C9hYgToFo+GSRXVQrfecgw7dKTslKpbN1el4oIQavI/RERCZAkqi4BaQR52
         9UCOz+LgadPxB0IgaDAigxF1odFRs4GO+yRJCdcm3V/wrMpaO9ZVegyYsdph4JYWN+mi
         27dY3tqKdRC77+r2M18rlDJMo0JT/Sa5k9PufRFYPvgFVtDXnOoi4FobsAKAu9NqRNSk
         c8B+k2mqvxR+k4J3jq9o1vZbCbQzDrF+JQ15jtIr9FvORuKSE2TSBb2oEH4JpiF2Ijdm
         ej1YgBkvveCEDqECjPNcTdHZcqij+gJMqBpuy1Fr61Mu9mjOQbvyHmQaD940NezRWh6I
         rJww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787047095; x=1787651895; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wB5u1mD3caKiv5VwodTINCWhAlYduQugf9/JTmV6yLg=;
        b=XTn1BIgFrgnNUBoTe47C0ZSHKKiP97okpPyS1BjPkb1qn+3DbdNtn6UvsTNpQPcwED
         PCR/IqGBZmSfV6SW6NiR42WxSnAx1kc++wDHZ20Mf3KeL05wHYDrMqlYtK/5pn00Ghju
         twFU2mwtnVNZqjCRU5I099xRuq+J+319Pa+CsrBrCJIk4rK+cQGFC3cIpSkw/9QZuv4Z
         oyTSdAsrcJLRK+vXKQlH1qMESygSNW8qTc/CTBlPcLfwQmdU3JsYplnEDRCmVtN9QS/t
         nx5+Y8WuJdgT9dy+xJA79XM+/q5oTae6Itv+GL1nYNUzdPUy3ZMu0Cc28eZXF75T2Npn
         z6Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787047095; x=1787651895;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wB5u1mD3caKiv5VwodTINCWhAlYduQugf9/JTmV6yLg=;
        b=mQ/J/0gKmxEfSulclprOp3vbL/e7ml5y2keOYUOpmak9MZSGN0Uz5kTdAiOJzXM+T3
         Ss6qKkG7kuczY4rDEC7TF5cgQmddw7CoaVCHlboNq/vrbY61HtDqTnm2gQTQ0yvPTrF3
         2WB/ByCN3chnpZALdshQHOhDJu6Is1s5N/cWYdxTIIL5lhIvu0lKCLVGeQettZ+q4aOB
         lgPc3FJ0dIwEInDQSJ/6bRC6JwTy5vLVn4JDRI7TNu1xZyX2/V1k47vXY2rDY1/IOqub
         i5aLxjraEM94WDhuLjJjhKXPck9FQeZIEU2TenzRWhm+PWTiC1ndGTiWv9GFf0LDhhOT
         bfmQ==
X-Forwarded-Encrypted: i=1; AHgh+RqQz28bPOfV1DtXOiorWYojgWtUoNFszpGyCKQOPu6WV0LcT/jsYtqh98zP6qUcNsklhdw/mv17J7uUP07ymw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFScmUf5TEuh6OdXg/IvurVkRHlUd+bb2iuDfdc6ASVZaOfVyl
	YeiBm2IYtwyNouSnPOgWfTzQNQJjePi7popx7EGZsG8cNlwTJA3oIpfJmmOEHz2ungQAwcMEnwZ
	zrvCxnvof2jj12eCQyBmnV7mH9L8LQ+s=
X-Gm-Gg: AR+sD12FjE8EER4rrLbZt13deXrCrjTqT/Ey9Zhq+y7nkzuTV0H7DbuZWGL2viSCHMU
	YGMqrlDN5unoeH4cqpNqrVeOOZDQvmtl/VqQHBgM0QLtylgq5VbT30HGrxrwauon3zBJX7utKcJ
	h+NPjFjyFnhSRkBXuInyRjds+oxdAM39UKh2WO1EcNZZF+PbHrmg3Dmr+M35qofpT75x3Ei0tpO
	60WmbFgqNQ4qlc1tqHSHmf/AThLWn5LY9KSM3IaYUpH6iZXLdCzuzXYzVT5fkGNm9mczt24jUvj
	73CnJARFNmFYVFP9Ih2ThW/reiZnCjFl8eEaEShVaEXEf2o3lLK46mD0fZgeIuizcR6+0x9+m9l
	JOxS1SmJxU0SeDq2vbEmvThQYkg==
X-Received: by 2002:a05:6512:3d12:b0:5b3:c15:c688 with SMTP id
 2adb3069b0e04-5b470661ef1mr1563289e87.7.1787047094580; Tue, 18 Aug 2026
 02:58:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADOrJmbTyrGGkq+9OJDXCgTa2HvNo8BWxoE6yjafcrOq7WNamw@mail.gmail.com>
 <20260817215428.84740-1-gvalkov@gmail.com> <c10c5132-1bac-4bf7-acd5-1319ce072eaa@lunn.ch>
In-Reply-To: <c10c5132-1bac-4bf7-acd5-1319ce072eaa@lunn.ch>
From: George Valkov <gvalkov@gmail.com>
Date: Tue, 18 Aug 2026 12:58:03 +0300
X-Gm-Features: AcwNN1XJfTB43bmjv2TjXUd_fF7J3LtyinrySWzpxtBcHtKj_KY-OKWZu5UgGM4
Message-ID: <CADOrJmZpJo+MDZpaAC=cGv-i_ZZ0wNjWsMP-dttnE3aQPpHLMA@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] dt-bindings: net: wireless: add flag marvell,ignore-regulatory-hint
To: Andrew Lunn <andrew@lunn.ch>
Cc: briannorris@chromium.org, johannes@sipsolutions.net, krzk+dt@kernel.org, 
	francesco@dolcini.it, johannes.berg@intel.com, kees@kernel.org, 
	miriam.rachel.korenblit@intel.com, wenst@chromium.org, 
	rafael.beims@toradex.com, avraham.stern@intel.com, error27@gmail.com, 
	s.kerkmann@pengutronix.de, gregory.clement@bootlin.com, 
	sebastian.hesselbarth@gmail.com, robh@kernel.org, conor+dt@kernel.org, 
	Frank.Li@nxp.com, chunfan.chen@gmail.com, 
	linux-arm-kernel@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 18 Aug 2026 at 03:53, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +  marvell,ignore-regulatory-hint:
> > +    $ref: /schemas/types.yaml#/definitions/flag
> > +    description:
> > +      Ignore an incorrect regulatory hint from ROM,
> > +      so userspace can set the correct regulatory domain.
> > +
>
> Maybe this has been discussed in a previous version of this patch...
>
> What is Marvell specific here? I assume any vendor can mess up, and
> make a US only device, but ship it elsewhere.

I don't recall any previous discussion on that topic, other than the
use of a root flag in v3, which was objected to, because
marvell,ignore-regulatory-hint does not belong there. I assume this is
due to the marvell prefix. I guess we can have a generic flag?
Implementation instructions, along with good design patterns are
warmly welcomed.

I like the idea of implementing a standardised approach, which is
scalable to any platform or driver that needs this quirk. I would also
like to add this feature to mwlwifi (not part of Linux), because the
main radios (88W8964) on WRT3200ACM have a hard-coded region of 98
(non-standard EU, translated to FR because it's the most restrictive).
This way I can set my correct region: BG.

In theory it is possible for other vendors to make the same mess. I
think the chances are very low, because they would violate
regulations. The story with this Linksys router is special:
It was designed and marketed to be OpenWrt compatible. Likely because
open-source gives a lot of power they made sure the hands of all users
are well tied-up: all radios use proprietary firmware and are
locked-down to their certified region in ROM. They do not allow
anything related to regions to be set. A third radio 88W8887 using the
mwifiex driver was added with the sole purpose to monitor for radars:
this idea was later abandoned. I do not have any information about
this choice, but my educated guess is that using a US radio created a
conflict and they disabled support for this radio to avoid it.

openwrt-ai:
https://github.com/openwrt/openwrt/pull/24458#pullrequestreview-4956971863
TLDR: It suggests that the compatible string should be marvell,sd8887
instead of marvell,sd8897. The string it suggested is not documented
and would need more changes, which I hope to avoid. I prefer keeping
things simple. The string I used works and is documented.

Sashiko-bot complained that patch 2 adds a flag to the device-tree,
with no support in the driver. Patch 3 adds support in the driver. Let
me know if I should reorder them?

Greetings!

Georgi Valkov
