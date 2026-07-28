Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755DD2F5474
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 17:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785260235; cv=pass; b=Q1NfrNzwi7VOl7b1pFk8jDy5w7ZDDGDFcZ94b64gE2pjw2O+WV2Y41dmV9HfM3BnRq5PxVT6j5YSjahhX9XgCnLy4wTxIJeM25lnpCD7RNw8clGACSqspt+yHOXY6IEztttcCNyB2+F1N7oW6QBAcGxT5FiSLnkOxoPlVkmk9ec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785260235; c=relaxed/simple;
	bh=n4SeH2j4c+s9t1W9U8G+NcjqcavC2MO5go9TxY2AwiY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WxRbdASweV0ILak3Br9VcSfkfcK2LlOvWdD9KBi+u3wrx+ro8x5Ci9ITVbOywjmv+xKj1Bj2YlkhKhIOXdbO7ic8FN0TcxgwBsXrpI8KMF3plF86PVZnRMO5xp+mT5XoOu9zBowCHC1nd3Mj4gQQJOkB1xPUPvttriQxoQ6qANQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g4Y8E1bn; arc=pass smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g4Y8E1bn"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e6b5737bb2so126230a34.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 10:37:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785260233; cv=none;
        d=google.com; s=arc-20260327;
        b=fvGkxL6GaO+/G3BtqhYd6ya8VrYsxX9p9zl9MbI5+e8IRC7y2Z+lEgjh5Rao8omX9D
         ewMMLfi9zoAYVFSUb26JOczVr7HM92ZURsBa6GGYAmac0JUqXXP00F1Q3jIy8iibuV7J
         1C4FeTIFGRBq6EkiCzTrHU0JoIlHMFK6FdDMS0kHhQaP2TUTogrGzl4ZFpFFGmqjcVyo
         EAg4kYqn+EpfgFJGb/ZZosjdf1C+coBGjh6pDmKtdXT+L3ZIKSUTkeoWOS4XwB0FZ8Nr
         eXa8HvQGfDFAhl9g8ITqhlEFRsaNILK2S+vSL7DcZHP6+4GDXAZ6RzMHYHfCWT+ZJl2x
         7LTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n4SeH2j4c+s9t1W9U8G+NcjqcavC2MO5go9TxY2AwiY=;
        fh=m2s5Sxk7ZcGhOegChSMc9MwZuAnE3Hjcf8LOEaSRp9U=;
        b=nY2DBgAF7a4oT9PbyJEO+Y1caIqGihCa8rSOkbDg2BevS5Oka0hlzw4cC2VChd22+/
         YomoZv50qCTZHLB5YEMK8LXPx2dpCJdXZI4RiacFZbTqlF1efH1HHRrssp65r6m8F3W1
         OAzTmRLBjs42Jo5bSMslDPAUDdeCnXOL62RfUHIJHEz/z9PfuVFarZRHocj5+n7HjDtG
         kHWAoEQq5YBnT57lFOTywupCiqgnsJU+yDmp4BsLCPY2l0q/qE2qXbZzTq8MfQdpQOuM
         PVzneNVUTyZ0D1djVx+uiUtakAeHScRXT3d+/zD3UBquf+NqBJ2T+Q0W8jJUIpl9zLt3
         DCwQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785260233; x=1785865033; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n4SeH2j4c+s9t1W9U8G+NcjqcavC2MO5go9TxY2AwiY=;
        b=g4Y8E1bngXdkm4vJ6gAOjkjXDQhllHEZ8gFU/yiXhPhtg3EeABLzybgxDg+eHqgXxy
         IKhpToTle/Rw4QQ2+VxXEcjuv4es+6PdT2BZ9P1Zf5ya13jZBXeYcbDXmAJsAQylCVMv
         TF4FeNdGu6fYY1HLza45Y3fbzIJd7q4p3qjCTCLlAQ4SDC27t/sSgjpyDLuDn/iZFhbb
         8rpsG88TYxufALFCbj+3wuV9rtYrmClqIbC6/iXqmxtonM5QEbUvfT86Pcefjb6lU1C2
         kg/70HFRSxGlP1Iq5cO0d1DWJo7ZwVOx0LlFzMlECWzvhz0IT1qo4DPhkXvcl+p3XTew
         upAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785260233; x=1785865033;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n4SeH2j4c+s9t1W9U8G+NcjqcavC2MO5go9TxY2AwiY=;
        b=aN4KuLpMhKSmdURhFsnYTi5NMms8qHITlMdtE9kLLsV6yqMagM8Ir9mzX79f13+8NJ
         JpehtWRJbSuhFHu0zX8/MJPQIuk/BwP1vBCzMuRraZGp1neaKz1IPsAmcXg6qNh6wJPJ
         45RCPliGlUSG4r3OqK5vXZrZ1g1vdl9KzWHJPrycuC1reozZ66tB11E0WtnOUHZABrJo
         b610KwZBFQSb0beoheAxt/Di9yReaYDGrIKj4w6ehfklUIpjGzSjkXC3ZboThL5TpFrM
         rJPi1lPsPA6JzurBXDOZ174SgLRA2wNoftCFcCXHUd+yr4nnwY//Cg8Hg/iZ1LV5FZkT
         E3pw==
X-Gm-Message-State: AOJu0Ywq5bgLXraT2C22VHFsy1YcJg8Cxa1JeTdhQVSpB2q4OjkFPwUf
	3z+kNMQ2qWMK0eUvCVExCtOA1u1AvJD+CG2UZ9tK3x9AEBjx0f1ieAx2axL5YihorG1/77qNwRq
	5P5E+x+5JPUwIF2b+U4eqig6IDGfDD78=
X-Gm-Gg: AR+sD13rHeHpjwc876rmarhJzHy+v0m17SLOgUoi8A52nkbs7ZfKYnx+c/2TGNoCzoH
	6aMFIy3euT8q/1qOcV6xJVOaLHByoZkhJcLBy+XZM9cC5a+3LRXd2kcl13P8N+/FkWxEdKPZRcz
	5cVGWCRQQ3f3nuozI/PItjmK7kAr+TemKqZvFaijoJhQJkHGWT+G4nD03OH3f5FRuxG/4P2n4dh
	L2Su38qFsJQjW10mInJ3aegF11QE0/iDMjsZIh/Z+YgVL0MKZcYA82Lq3knos4E
X-Received: by 2002:a05:6830:6b0e:b0:7d9:7201:1acf with SMTP id
 46e09a7af769-7effef00b81mr2437112a34.5.1785260233222; Tue, 28 Jul 2026
 10:37:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260728002048.19351-1-mikhail.v.gavrilov@gmail.com> <ae8f803765f06e0ea1968397338129bdd9766c4f.camel@web.de>
In-Reply-To: <ae8f803765f06e0ea1968397338129bdd9766c4f.camel@web.de>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Tue, 28 Jul 2026 22:37:01 +0500
X-Gm-Features: AUfX_mwrb9xtq3CRTkG7ei9xWyeYiU32lMmY__U3DBtFzMwbV5LYbgSCuVPzS6A
Message-ID: <CABXGCsN_iNPPEf2UWYWS3Q2LLi=PbmDHVrcSVf7EFKna8f5PXg@mail.gmail.com>
Subject: Re: [PATCH mt76] wifi: mt76: mt792x: drop redundant napi_disable() in
 unregister path
To: Bert Karwatzki <spasswolf@web.de>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 5:49=E2=80=AFPM Bert Karwatzki <spasswolf@web.de> w=
rote:
>
> I tested this patch applied to next-20260727 with mt7925 and
> rebooting works fine again.
>
> Tested-By: Bert Karwatzki <spasswolf@web.de>


Thanks for testing!

Repeating the trailer in canonical spelling so that tooling picks it up:

Tested-by: Bert Karwatzki <spasswolf@web.de>

--=20
Thanks,
Mikhail
