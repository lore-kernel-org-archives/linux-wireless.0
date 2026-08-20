Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5626E23EA83
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 06:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787208190; cv=pass; b=pZSrngYKkkmVYR66rcL3PtQ0mL0lJfc3ueyAUVhKNuCnc8qCB0yC2EL6E/EJEf398eHq8PkwYTgiJAv210XD9T23Hxraq+ubXRkWcLRzYZzLzmYBt2/ufFhq70rxkPp5Wz3KKRN29X5DAm0nWopgmaxvtFbzuCLUIGFJUQ/3V/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787208190; c=relaxed/simple;
	bh=KfruKuf3bq97mGd1z4GYf0eUtHQK8orEQIL/xa/xHO4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e4CHikYMXnlGDlyDobA+un6mUfnkn6Q8lVBJCquvmMI6R7h+OxcWDs/t20oSeQL7tNaBZldfCMZ83n7gDuogLV42gfTyCwGbOEcK2gU3LSirQqCUX4YgIB1kdovwHmAQzB+vPGPSpREAAv6SHKIKCdAR4xZlXrKCBfSqamnutVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Tuml5VvA; arc=pass smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Tuml5VvA"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-66cc8f452d7so341690d50.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 23:43:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787208187; cv=none;
        d=google.com; s=arc-20260327;
        b=oeQaxomlOtlJ5NffD1DhHPH8fCxjwzPKOH9LzBPR6u9BpFIqqU5xrW970QJ3Z/j7wk
         8SNMW7exwiktJ+fwfiI0K+zHLcYtqbSKh2kzJMaf+fjWuEGygP5qGHeqcux97VMFAN+G
         eaObgSQ78P+O5LAR23QO+KB89pbGjsKmwYegATDSZf913iMF03K+7Lkd+PZc+JmgIWku
         GsSl9F6YyaGC3gJwxCkRLdzZM8C+75mW+rfcDhMewDhVyOtgrjX8yKvFn+hPpSeBtZnx
         rASh1PSfLJfTya+TF+9iga+LNDTzK5mEk4rLmSAV2nQnPGBvzzaJ2lhhMo6ihLqY+w2z
         3LZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5DS3txWmnShWeOSkYZcCOb4QBbjc4rEfH1Wqk5hfTNM=;
        fh=hT4rAGt1lP9/88aBkWwryMB4UUzz6jJ6uEce1Fe39pQ=;
        b=Ua+sGv+iCg/BCbMTj/JTtRE3o7qLJraD9r2KwM5ZsSTlOJQH9WtfKX/AXmJz4EMJdu
         YTDFahoUA0Tbya17URCjb1/6JUZMmrmz0F2NtdvnoG5Qi8g6wcMkaDvOixdEPM1fvKMh
         +WBoYK5nHAZE1EvrNV8PuJZOQu0e6Sw8ynMDwyM4XJVepS1SzQmKAKsRC25uS6cOnEpU
         VnzDl34MAZLhpuTn8XlOcGGhP6ITtnCazex3Vi2GjG6oddweVcn6LqUt8qh6Bneu1ZC6
         f7RnOOkmonjyhOOwll3y66r78LRNtr7WkZRuTwoNsE0SRu57d+ZgFIOYmeKDI46XU/Tb
         QRqw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1787208187; x=1787812987; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5DS3txWmnShWeOSkYZcCOb4QBbjc4rEfH1Wqk5hfTNM=;
        b=Tuml5VvAkg0vtzDR7gQRKiTkdFzTbCyo++ZzrWv2tPqDzIn/VZmIAzls4ww8kbBjr1
         gBZZm0eosQqTupPf7Ne0IoH+v9wyGqvHXjwurr98hqqFDcoiz1om5xVcv7E0VUAynroK
         4BOcRbDBdjzFXQRStUJZoIyKi5R5esFpE+Hd4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787208187; x=1787812987;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5DS3txWmnShWeOSkYZcCOb4QBbjc4rEfH1Wqk5hfTNM=;
        b=lYnkbqk6+3k9dt84dcY2Zqi9ejefQtf3DkQQY7Tq8njkUxFI6bpWdEkj/nPKsdXARs
         hOKkqPACLiTV43zU2HSsAjrcmVwoq18/1uLu/XVH2LIUCdGvbKYugNc1sLKW6tNYkcOr
         qu5LnxROzrh721Y4uJS9y7Dey53arhyDm4KjUamILCNG16tjIUjQS65B6q8dBEq4dzSW
         TL0zRqgvg07EwVu4ksxdKI2ahAJVciuoJFYJIJIXdBNzBjeepE+1JGCklDyTbm+YBqIL
         WeLjYteNE6MS61QspQqZCxkjIv01xeIKuKx3KU0BssF/qry1rkuX4+/xinKnDfbq9Jk2
         aDLQ==
X-Forwarded-Encrypted: i=1; AHgh+RqP7HhNa7ZGmDyv3jDG3OptOpCOxBNOEATrjrqKhGPBqxu7i07m5THLW+8Efzk2ikyBHPGvY7Fp3rmUNCqytA==@vger.kernel.org
X-Gm-Message-State: AFuF++lnOKmQDdljS8E+sevbpsQRMKZH4Ai9Ig2oiNmmBI6E0QQQf+UL
	OIkhTPaTGKhDG9YtgijjVe+FAK6Yk7S6QNZmNhWj+woGDXCqv+idMQwYxUbvNdESE6YOALK2HJA
	s+eF8y/svYANAvOhGu87+OOCwLYTArlx7SwVgUkyD
X-Gm-Gg: AR+sD10W7ll3diTCEMgothRcQpXPvwFtC7Yg/5kFNhR10Q+cVF1D61VP50sdXjKhjUN
	8ozE2CtVQdShKCk+OcJJWCi3Cza1fzGmcEbU98G5k7PbXTF77WI5N304okVMgF+UzxBL20YVNwa
	fVteWqgixXnW28RTUMf24/+OLbJAAGUnSZkgmpjXYtdXxeDF3f7NMx9uJlNnWQdVxzY6kUUJdQK
	wdhUWllznhmcA8U8q8t1qFAm6tSvXxJo/Zi39xoX/GaxqwxUVU5tL0MDRIwbW6VXrOQumziDXts
	iq58GnWYP6SsHxGRL54c9Q/JA12j7tpspurMPnVpbW8Wxxb/IfMgokCFFqNRrJo3UvmlPsbIf5o
	=
X-Received: by 2002:a05:690e:161b:b0:667:debe:494f with SMTP id
 956f58d0204a3-66ccb6baa16mr2792320d50.44.1787208187320; Wed, 19 Aug 2026
 23:43:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADOrJmbTyrGGkq+9OJDXCgTa2HvNo8BWxoE6yjafcrOq7WNamw@mail.gmail.com>
 <20260817215428.84740-1-gvalkov@gmail.com> <20260819-generous-nickel-dalmatian-b6bb08@quoll>
 <CADOrJmYfBe3ADun_kFjFSH6YOSTX7Vu3UsFsL57yuRdaQ=eJCA@mail.gmail.com> <e554c007-67e3-4fbf-b85e-5de02f649e83@kernel.org>
In-Reply-To: <e554c007-67e3-4fbf-b85e-5de02f649e83@kernel.org>
From: Chen-Yu Tsai <wenst@chromium.org>
Date: Thu, 20 Aug 2026 14:42:56 +0800
X-Gm-Features: AcwNN1VnLR1aHYarg7cpxijdC4GmIDA-AAePy3yNd-kTz7zpQyFEH66e6jDxZZE
Message-ID: <CAGXv+5H7AhZgZ06r9KO3HLZ9Cymkai+Cv9SgVTuSC1PjgGf8hg@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] dt-bindings: net: wireless: add flag marvell,ignore-regulatory-hint
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: George Valkov <gvalkov@gmail.com>, briannorris@chromium.org, johannes@sipsolutions.net, 
	andrew@lunn.ch, krzk+dt@kernel.org, francesco@dolcini.it, 
	johannes.berg@intel.com, kees@kernel.org, miriam.rachel.korenblit@intel.com, 
	rafael.beims@toradex.com, avraham.stern@intel.com, error27@gmail.com, 
	s.kerkmann@pengutronix.de, gregory.clement@bootlin.com, 
	sebastian.hesselbarth@gmail.com, robh@kernel.org, conor+dt@kernel.org, 
	Frank.Li@nxp.com, chunfan.chen@gmail.com, 
	linux-arm-kernel@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2026 at 8:27=E2=80=AFPM Krzysztof Kozlowski <krzk@kernel.or=
g> wrote:
>
> On 19/08/2026 13:42, George Valkov wrote:
> > On Wed, 19 Aug 2026 at 12:42, Krzysztof Kozlowski <krzk@kernel.org> wro=
te:
> >>
> >> On Tue, Aug 18, 2026 at 12:54:26AM +0300, Georgi Valkov wrote:
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/net/wireless/marvell,s=
d8787.yaml b/Documentation/devicetree/bindings/net/wireless/marvell,sd8787.=
yaml
> >>> index 930b700b73d0..5f235cb9f3e5 100644
> >>> --- a/Documentation/devicetree/bindings/net/wireless/marvell,sd8787.y=
aml
> >>> +++ b/Documentation/devicetree/bindings/net/wireless/marvell,sd8787.y=
aml
> >>> @@ -59,6 +59,12 @@ properties:
> >>>      description: Calibration data for sub-band 3 in the 5GHz band.
> >>>      maxItems: 502
> >>>
> >>> +  marvell,ignore-regulatory-hint:
> >>> +    $ref: /schemas/types.yaml#/definitions/flag
> >>> +    description:
> >>> +      Ignore an incorrect regulatory hint from ROM,
> >>> +      so userspace can set the correct regulatory domain.
> >>> +
> >>
> >> Same comments, so you just ignored entire feedback?
> >
> > Do you mean this feedback? I already replied to it:
> >>> Anyway, property looks like SW choice. You must describe hardware
> >>> instead.
> >>
> >> I am sorry, I do not understand what you want me to do?
> >> Can you please send a diff or a clear description suitable for people
> >> who have way less experience than you?
> >
> >
> >> Again: you need to describe the hardware, in commit msg, in property
> >> name and in description. You cannot tell SW what to do, that's not the
> >> purpose of bindings.
> >
> > I still don't understand what I should do?
> > Can you please show me an example of the changes you want?
> > Else I'm likely to make a wrong guess and implement it. That obviously
> > won't help.
> >
> > The commit message already describes the issue with WRT3200ACM and WRT3=
2x.
> >
> > About the description, do you want me to do something like this?
> >     description:
> >       Ignore an incorrect regulatory hint from ROM,
> >       so userspace can set the correct regulatory domain.
> > +    WRT3200ACM and WRT32x are known to need this.
> >
> > About the property name or flag, do you want me to add a separate flag
> > for each affected hardware device?
> > - wrt3200acm,ignore-regulatory-hint
> > - wrt3200x,ignore-regulatory-hint
> > - the list may grow if someone decides to add other devices
> > - and the driver will need to support all of them
> > - that doesn't make sense, because it isn't scalable
>
> You need to describe the actual problem in the hardware or firmware, and
> then name the property and description accordingly. "Ignore regulatory
> hint" is clear instruction to the OS what it should do - ignore the
> wireless-regdb package/instruction etc.

You probably have it backwards. The driver is taking the hint from the
hardware ROM, which is fixed and thus wrong once someone carries the
device to a different country. I.e. it is a quirk saying the _hardware_
region should not be used.

Whether one should override the certified settings, or be able to do that,
is a whole different discussion.


ChenYu

> >
> >> How did you fix the threading problem I mentioned in v3?
> >
> > How can I fix a threading problem?
> > I don't really know what the correct thing to do is, once I forgot to a=
dd
> > a version tag in v4. So I just added v5 in my next submission.
> > I'm new to sending mails using git. So far I've learned that I can do t=
his:
> > git send-email --thread --in-reply-to=3D<Message-ID> =E2=80=A6
> > and I use the last Message-ID.
>
> Do not attach (thread) your patchsets to some other threads (unrelated
> or older versions). This buries them deep in the mailbox and might
> interfere with applying entire sets. See also:
> https://elixir.bootlin.com/linux/v6.16-rc2/source/Documentation/process/s=
ubmitting-patches.rst#L830
>
> Look how correct thread looks like for v37:
> https://lore.kernel.org/linux-devicetree/20260819-imx-se-if-v37-0-5ef5de9=
ff1dc@nxp.com/#r
>
> Look at this v5 thread - it is one huge chain:
> https://lore.kernel.org/linux-devicetree/20260817215428.84740-1-gvalkov@g=
mail.com/#r
>
>
> Best regards,
> Krzysztof
