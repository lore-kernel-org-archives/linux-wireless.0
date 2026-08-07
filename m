Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2763637F72E
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 19:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786132198; cv=pass; b=OUt08VI1e00+1p+aNYoASrjE2i8DC52XgxTIANC1avJA1h6uy5isS/lbPrIc6Cu9beyip/F5IjVmtjjneTfdMG4E3dPNIlR05Erc92fjdRVD2n8FkfsF4qpnRlHL2/WrUqXCqzht65d0DKsmTNDIvjGHbuxBB7hImSiBFPHQK5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786132198; c=relaxed/simple;
	bh=VKMWcXMVP7UvVkz7QMUJ2T15eWcXIS/K48F8fvZe+IQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SMKdkuCcyEWUYTEkxuYEfQH/W3G8QmoboIhiD5mBaUyZZbDC5S2sPHOlKkELosBLJFMCw2GQKlOd/fk4Iy72bQ3/7PpuHuyJ8mm28nKds8vrepNeOjqRL5g3no5V10QuSwSxdRmc6KW+2g30HVx9D8NP7/l5LuO6R+y8uNExKNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lULXP3Ki; arc=pass smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lULXP3Ki"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b011edaf7dso4037363e87.2
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 12:49:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786132192; cv=none;
        d=google.com; s=arc-20260327;
        b=rhC3ZTdAwJPexl7wHPjfvd+Kxw4NJF6hyNlqqYqTL+QXraRxhPOEdSmpfdEv9Zrlpw
         y7esuwndsprpgHbBzfYKntMpx9R8J1lQS+2X9UMtLJcRX75HGhpmddORbJgCY8MC1Yw7
         pfQDwvZD/VFbgfHkYYgnXKgIA3ECYQlTPz6/pLkaN3HO0WubodxmZIlaBTIs//nw0ceG
         NmNaFwtKVUZMFuIJhDEKqu4UJQfHVWxwuK4T3LkYHyyv/vIgp6TxlJADSX4b4GKr+KL/
         sQO/cfZCt4aiuzXzPZAuT+YQIhdcjoqVLhO95E0gTBclggBXKFfuPjGLe77DRPygLeVi
         /0CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SxyKUAmrI0LwYfrXT8fRXwyn/HyoaEU+MOGavpvLNWE=;
        fh=8NOW5t+049nMt8NischTZCH7nN4tOtlMdH4j7cIDOkM=;
        b=m8xFyHQ6ii5j3PVJydZCxbZKImAKu2ffDXIf5d0EByO8WmsQLAkzrIhk//tqDoCDdW
         kgpQl2sVgCTnkJcqf7OO3YlLNEjMpXr4HyrcXHXNDqg5u8llRMqL/jUMvzhChHEygcUK
         ohyxA4Bpf9LqsJYYKmoDyXKTyAPregXmWmiKAtgtmZPq/DOPrwnhGaRJJnNqm1o6Yuex
         L36uIS2GqqP9K6qLXGe9FDUrk4pVPLkStxSQULLLJpuE1+B08P/Wt5fOYRlchoCyPaFL
         I5m2OoZWKRTVxkXljd2SMVZpVPM7FcWc/PG8zsDlqA3Pg+Ydgw6nJwMFnjYf/s8Z2MBc
         ja+w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786132192; x=1786736992; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SxyKUAmrI0LwYfrXT8fRXwyn/HyoaEU+MOGavpvLNWE=;
        b=lULXP3Ki1idUu+/iFZj8OMV+hV2dQlCvoOa7t42xuD6zUz2XEse/CwVbmD+Vr3s027
         IhvkDtkIOoNyIfkI8Wzo7msLCjWh+U6mK20vSVyPeLY7qJsUdv9FYmhmoyD4JwmXhoqp
         dThggtbFZ0M5Aqanx9GmfXYwNLaFO3JgRJD0/WA3D2a+p7waCC3/mS78jqttH4Uy744C
         qEJwsvg8M8D4BFv6wkdN5J6qYIREMoNx+AvzuxwceBF/jYRq5YyEAFb03cmXF3Oo0MNf
         xnD3bcA3bqTBDGvcgUFa+279dKJm/YOn2ILq/z63YyxtTNamgbgSyghG5V8/82pO53A+
         I7Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786132192; x=1786736992;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SxyKUAmrI0LwYfrXT8fRXwyn/HyoaEU+MOGavpvLNWE=;
        b=rfYBOR/TPaZe80J3+4hWhM9JFu4+zHGh0ZE6+PRkeS/KZl4PGXOrEzDx4GHFX9Hvjq
         3Ub2AdFTLRMElcHhji4/b9hA6D/bOxmzW1kjdxQN+QTasc1sLuzW6z/k/5ywn8DxX9wR
         TGL4qtyJImj6O8ZPKEzQzHfB1nAEB410h51C7s5k124cQKJFtRFZj8quKAkHI2GG7Bc4
         Qzn7iiGEtSOsVuAsutsZj0GBj6nvKSHDpBoIwQdxhARKKhiQx2Soudl4HNSjrVWR1lc8
         Cw9oJGf3Xd7NfNEU0dzGu9P4tkZBQDqNnn9qzddOWZpKl+yfPfdb2tviPU9DRzq4EQZI
         YMVw==
X-Forwarded-Encrypted: i=1; AHgh+RpDGzfnHftVflAhvDzIKylfpNIVepMU1ilEG4+xLFPOXr9JHTPuroRsQ4lyDDXWKXI81VI+tBiqJXG8H0gyEg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzCWYW4Wvavwz+yIUskxb4CimiyRwz84X7yT5eqE0jFjEbNrbHN
	PpPP3T5Edx85cyxuE97Dm1zGDcWhgpIlIDZfj/MFhQyrBkhUVDlzzs1WZmJh/pRJ19pfPKMk3GQ
	4HYsmzHXvt/CqcsFgF/YcyaptmxUjBgU=
X-Gm-Gg: AR+sD11NWcnmD5NknJz9Xq2X9fU+uLT6xSsGr1RGX5d8/UyMLQRGf7fIxgi3E72jppR
	8PctM1US9juwOuGgliVkbxgWWJ0L+TLcjA/bnDfIsu2p8Hl2E6vTo2fkK5/E8o9K0mK5euOn6ut
	GqkxodwZZu4bKqqJZyMz59lwmNR2PQkSrWqf1UnyXURheZ6aR8ZSoQZIryqwO2CamtCkag3d0qw
	To+NK/03zcCUMEhxK2s+d9rDRhBinCxjrCm2LpXGhegOyp9ZdhQrTtJs9voS5CInwtqRZ9udfZq
	QZIZr8QFu+2hRKgaAWq0tIhiYF0lS1pn5ryvkvkbqh6EvPzCpW9d9Mv4Q9Im0E4Gva0cJs5dTwT
	6EkLZrwZTF5uYkVD7VZ5qvFjNtQ==
X-Received: by 2002:a05:6512:3c92:b0:5ae:d80f:c77c with SMTP id
 2adb3069b0e04-5b2f4cc45ffmr3489843e87.30.1786132192296; Fri, 07 Aug 2026
 12:49:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <anWWr80yAcOQaVVS@nxpwireless-Inspiron-14-Plus-7440>
 <20260807182124.41572-1-gvalkov@gmail.com> <9cf8e6ee9c4c655e685708bc5660429074b18326.camel@sipsolutions.net>
In-Reply-To: <9cf8e6ee9c4c655e685708bc5660429074b18326.camel@sipsolutions.net>
From: George Valkov <gvalkov@gmail.com>
Date: Fri, 7 Aug 2026 22:49:40 +0300
X-Gm-Features: AUfX_mxRBT9-U8Aa_GHxuMmHTk-qUbjASbhV_06GViPmHzIDoVy768Olpa7FjGk
Message-ID: <CADOrJmbhdWhqRj_TSKYEgb_TrbJUpkQeYTGDb_93WSDdeaJPpQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] wifi: mwifiex: ignore ROM regulatory hint on WRT3200ACM/WRT32x
To: Johannes Berg <johannes@sipsolutions.net>, sashiko-bot@kernel.org
Cc: briannorris@chromium.org, andrew@lunn.ch, chunfan.chen@gmail.com, 
	francesco@dolcini.it, kees@kernel.org, miriam.rachel.korenblit@intel.com, 
	wenst@chromium.org, rafael.beims@toradex.com, avraham.stern@intel.com, 
	peddolla.reddy@oss.qualcomm.com, error27@gmail.com, s.kerkmann@pengutronix.de, 
	gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello Johannes, and thank you for your quick reply!

> You're supposed to always update bindings first, no?
To me the logical order is to implement the feature in the driver and
then enable it in each board which needs it. For Linux just WRT3200ACM.
A separate patch for WRT32x should be sent to OpenWrt.

Please let me know if I should reverse the order.


Hello Sashiko AI,
Yes, I intentionally implemented the flag as a root node.
This way the new device-tree property can be reused for the
other radios, which use mwlwifi, and also require this fix.

It would be inefficient and impractical to define a separate
device-tree property for each radio, where it is actually the
board that is affected, so it should be a per-board setting.

Also my attempts to use per device nodes or the parent always
return false so they are not usable.

I do not understand the part about dependence on CONFIG_OF.
of_property_read_bool() returns false when the flag is not
defined. This preserves the original behaviour as if it is
set to false, so the feature is disabled.
External radios which do not implement support for this flag
are not affected.

v2 of this PR used of_machine_is_compatible, but there was an
objection that this adds platform code to the driver.

How can I add binding documentation and where?

On Fri, 7 Aug 2026 at 21:39, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Fri, 2026-08-07 at 21:21 +0300, Georgi Valkov wrote:
> >
> > +                             /* Allow platforms to ignore an incorrect
> > +                              * regulatory hint from ROM, so userspace
> > +                              * can set the correct regulatory domain.
> > +                              */
> >                               if (country_code &&
> > +                                 !of_property_read_bool(of_root,
> > +                                                        "marvell,ignore-regulatory-hint") &&
> >                                   regulatory_hint(wiphy, country_code))
>
> You're supposed to always update bindings first, no?
>
> johannes
