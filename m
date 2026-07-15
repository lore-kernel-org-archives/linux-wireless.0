Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6E227FB05
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 23:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784156429; cv=pass; b=hrs3P/akl0TSgN0H/xW2rJmXU0BDumugPQDWRKscwzI8rUnOq8GUaciDEGgnp8Ku8H2p9TkeD/FiDP7xv6cSuc3D3+9tWdEPyBLnqG3FDAunkoIfWL4sbmyRMob5wo0PQr/+jVV2nTUlzlOKSzb7ZPrHdIcJUZyKWt6qLqCzbbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784156429; c=relaxed/simple;
	bh=fiYOlFWMU4WKOC95vQ2TdtlOTdRO1GdeSfHMOyfJSrc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JTmSFhtRlz1/Og5YU5WIzFSRrJVUfgIOccWNzby6R0geptZvlHhUeoA0q7VjONNS5e7E4r0xusnW0BnlxSLBTkqp3O/wP76AnYIcbuR3h9DXt+xMA8kuTs46vtLY28aUH3/v+/BMnrIxpEXFw+g00ySPaw89Gysm0nTe35XYZXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pq1pfx6D; arc=pass smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pq1pfx6D"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-667b0ced2d3so7524642d50.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 16:00:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784156426; cv=none;
        d=google.com; s=arc-20260327;
        b=bUp9nnDMIhRC0JjTIsO9JF69rZ7NsAln8eVbFyaNwEbWBOznUgpYoGotX1DZ+xehL4
         klGPnlmydU0AR8vAK+mLo7AjTP0q4jbtuvM76reVhFW40J+Z3lZKVwfKNgOxvMgYFWb7
         bCHL6scWxMtOWI6Y7EaJNCGq3yq6ME5AomB5HNoS38h2nhXzPDdi3tlwy3xn6cySCdYI
         lP4aImmmjVhvolTJGFLpn8WJxRE50hXR6ngP50QKbzoJsfRIAzXZekaI32JqcneMGdYw
         4Bk8c97D4aChEBF7kwCpFOzGkyjOohIlk6TPi9rkV3wm9xfqi4up2BLPR5Tv2OxRNSgW
         sO/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0bIFAaCz/Ybe2Wc8at9yfOIMc7MyThjXtraPrvowyZQ=;
        fh=pdBFibnjt2oXMLxfVrFveR5m0f1WI/HWJWCY3hZPcNk=;
        b=YiqZwEYhI8V4SYbF3D56lc0r0+4Pb4YRRu8xqhHZn8BBdf+ODQqkdooYMWWVBn6mYy
         eh4UsGadIPUICVu0XzBblFf6euiDlPAFw2J2+uPme7CzQw3G0Tb2n1LuxyuOMSDI6wwi
         h1pK922naWAcx52QOknTWnMx6TmcRBQt32y3macK6n9HzQz3Lv84WHGcl6UM1PTc67Rz
         Gn9sJMcXtRkSmQrkjHF2CbHKzHGhMakArTfGYxaFWEkZtIH0cL2AFDtMDIzmbnGDzqTn
         4glPMFeZjWdtrpaqxy+lwdxLbsk/MuQl3CAsPHNm7+gFrOnBN0+f9KrcOOoTwGKdM/0h
         i2VA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784156426; x=1784761226; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0bIFAaCz/Ybe2Wc8at9yfOIMc7MyThjXtraPrvowyZQ=;
        b=Pq1pfx6Drjbm5+k7fANHqcz7JHZuy71LpSn2inGxiVlMOLf51cmto4bfzNiV0mw30I
         WxImLHmTbYVMGHM6ZX51kPGWKwYGPck3yPf2n1f7ANYejeyR4cXnvckFALRr/pNvBWTG
         1YMw4fJW8HbSMWEhDOkaN5JFJEiKngzo93dmuj/04+C9Ye2XGpjviEwMem+1gxaAmIMo
         02T5csdFv5cSbBwnZ1X8vIw6FLdg6jm0sNTriiGmgZ3R8NkEstTTCVJAuPP8kpZucxvg
         2r8kl5AHDNOPB9W8aeyTdaujs1H5s0HAqcgMA5gbTSqoH74zMt1yxv3T9KACQ+RAcnYh
         R7xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784156426; x=1784761226;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0bIFAaCz/Ybe2Wc8at9yfOIMc7MyThjXtraPrvowyZQ=;
        b=BjTHSB/oZwMwguMDmm9rFLcPNf5OV2UBo95xkv1/noqFwlOrccLMfsvGTqhMjZ8DKG
         YsSRzvAeqOMxchwgDbXUhQV5PC6i41W0Jcq+3su0BI4pi5xa1mUYKFpZ5+CFYcRvY1Dt
         0Pc/0kPp/mq3TWgOqyAwp7IbbT4yoVOUrLdQCnHh4R3K6gxSrkZONn1IoHPXdisEq8+O
         hZ7Kd7SQIA17WzP1Uo4SK7Kfd7GG3knqTv+iO7tfvCNaLT1dC1Gh9xbT/FND0/8yqljO
         5ldvTd8XqUHi05OdiyVm6wRFSMIZwnXt7FeuaVAhbTCnAulPKpfMWPNFWZb0duubKjgo
         +uEQ==
X-Forwarded-Encrypted: i=1; AHgh+RoPH1kSwt+7s1fiIFtJe+nskolMfStzYvcd89GFaEZ6oESugMhgM1NlAgBQhtVyftMA5LdsinPEzjFxOlSBiw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwkDeM8xoChPSjuO9VwLlBaTpRvmeCOoRpOJLq33OmseBUlSGO3
	Ps8HRKGwgN7YYvqtVwegHdDMWz8RuNIeKtUuCAF7GX7BX4Ptzl5DYvn7FIv80pQX5SoBPDjQmgF
	Bv6+O/kTniwMbFWNawfMT7iuRFqw2ANA=
X-Gm-Gg: AfdE7cmVZiplNS/k8Aqq8HQdMbNKlmPSqRYBWp5HSdRVgyqKvhACfhWh7EdDYtuR2KU
	WxKJsbD2cgSQxupfUrJGRhf2OL4Ds1wEmYziXF36l9kLrWEpoiE6TF+SXxoS+oSKf6s7LNgubSc
	OXbbB3YGeed/xEREsfPhrg9HqmLoOYUz73BHr44hAa0un6ht+9GnUrR5xGdIIg6Gm+9r4i80g8i
	bGoc6qMjfDopuRTCeCUpc/+v9UBfqmOeZ7GiMCVrIz9H/atIq8mPvNqX0RTmXi908cxtp9Cr8/q
	YuJsGr9uXBAH69C51A==
X-Received: by 2002:a05:690c:998e:b0:81e:51aa:ff79 with SMTP id
 00721157ae682-81ecf7eeef9mr36834447b3.18.1784156426262; Wed, 15 Jul 2026
 16:00:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715135711.34688-1-skyexpoc@gmail.com> <20260715162855.GB86836@francesco-nb>
In-Reply-To: <20260715162855.GB86836@francesco-nb>
From: =?UTF-8?B?SEUgV0VJ77yI44Ku44Kr44Kv77yJ?= <skyexpoc@gmail.com>
Date: Thu, 16 Jul 2026 08:00:14 +0900
X-Gm-Features: AUfX_mwd9Y9G5dTaVdj6oa-orBxOlinndhyG7NeWeGUxpDvqKgFPUGbaS-r6IGo
Message-ID: <CAOC0qyJQvgkGAL0VK-uevygnQpH8jVrt0x58PqOBA3d7EKVw3A@mail.gmail.com>
Subject: Re: [PATCH v2] wifi: mwifiex: bound uAP association event IEs to the
 event buffer
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Brian Norris <briannorris@chromium.org>, 
	Miri Korenblit <miriam.rachel.korenblit@intel.com>, Johannes Berg <johannes.berg@intel.com>, 
	Kees Cook <kees@kernel.org>, Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Where you able to test this? It looks ok, but you never know ...
>
> Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Thanks for the review and the tag. Honest answer: not on real
hardware. I don't have a mwifiex device, and the event is delivered by
the device firmware, so I could not drive EVENT_UAP_STA_ASSOC through
an actual association.

What I did verify: the driver builds on arm64 with W=3D1 and KASAN
enabled, no new warnings. And I checked the logic with an
AddressSanitizer userspace model of the exact arithmetic and the
cfg80211_find_ie() / for_each_element() walk. Without the patch it
faults with a heap-buffer-overflow READ one byte past the region that
stands in for the end of event_body. With this bound check applied to
the same model, the underflow and the over-claim that would run past
event_body[MAX_EVENT_SIZE] are rejected before the walk, so ASan is
clean.

A full in-kernel KASAN reproduction would need an emulated mwifiex
device (raw-gadget plus dummy_hcd for the USB case) to inject the
crafted event, which I have not set up. If anyone with the hardware
sees a uAP STA association, dumping event->len for a normal client
would also confirm that honest firmware stays well under the bound.

No change is requested, so I was not planning a respin; please tell me
if you would prefer one.

Francesco Dolcini <francesco@dolcini.it> =E4=BA=8E2026=E5=B9=B47=E6=9C=8816=
=E6=97=A5=E5=91=A8=E5=9B=9B 01:28=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Jul 15, 2026 at 10:57:11PM +0900, HE WEI (=E3=82=AE=E3=82=AB=E3=
=82=AF) wrote:
> > mwifiex_process_uap_event() handles EVENT_UAP_STA_ASSOC by exposing the
> > (re)association request IEs that the firmware copies into the event:
> >
> >       sinfo->assoc_req_ies =3D &event->data[len];
> >       len =3D (u8 *)sinfo->assoc_req_ies - (u8 *)&event->frame_control;
> >       sinfo->assoc_req_ies_len =3D le16_to_cpu(event->len) - (u16)len;
> >
> > event->len is supplied by the device firmware and is never validated,
> > and the subtraction is unchecked.  assoc_req_ies points into
> ...
>
> >
> > Fixes: e568634ae7ac ("mwifiex: add AP event handling framework")
> > Signed-off-by: HE WEI (=E3=82=AE=E3=82=AB=E3=82=AF) <skyexpoc@gmail.com=
>
>
> Where you able to test this? It looks ok, but you never know ...
>
> Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
>
