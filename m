Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7EB30F95F
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 19:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785093909; cv=pass; b=Y+o7GJFWJ/bwrl3DyhRGW2HY8QAVawZsTre4NqesOZ8Q0WsxlMHOF6Z+eVGGHw/iNwJt5MM8rijdYp7qx2ax5RncodD1jptrjU2o/LmBBeq0hXHbFuoqh9Q7rSeQDek2aNPOAyY9cBEoAdsh6hP9664q8lBInTz8KfvTJNEpRK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785093909; c=relaxed/simple;
	bh=xji9I5cCWfyl8rCasHuYwdrQgv7IUf2NXmLBjKTVm1M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SQr42lCbJNLVE5gwD0v50aWX3JXFVMhHHuux8Id8UdXNA3/3PpNRARdvFa8fx/jmIZ6TQnrV5MLHRNgcHmENJvIAfcGCzy1PnqT7hxrCnhRqkEcPm98agQRwxyFavQPPatiArh5gk7ltw/M9sPwYTL88R86tlisofl17Hrni4BM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Br0NkoQj; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Br0NkoQj"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-69e0f4eb4ecso389225a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:25:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785093907; cv=none;
        d=google.com; s=arc-20260327;
        b=YZ/Cl4/eg8mPe9OhBdY9XeYUWvJly/m70/tSnPEeeAhFJivMGfXKK0owU4gLYTy/Dg
         QCiSgYRp8S1TLbeBb564BfS14kJr3wh+i1OHLm8t08Q/WE515Ib6CihrwnO0yly26u4J
         w7E2kgXlk6UMVfvyonfoianhhfqDNj/RCjW3wPt9Exi6ZthnA0UcU6TwRzbaEzVAAv9x
         yYCxJnM9MFJ/smBo4zyY0xSRX05wXu+mrqyDegvtVTHRUGWuc5onWICmzGfqa2cK0IvZ
         dOZOsj164EOSDUysBfqIh4wmmM50TrlJrvbl8My157y3f6GY4ooE39HxcV6pYqkM79OC
         GJ2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xji9I5cCWfyl8rCasHuYwdrQgv7IUf2NXmLBjKTVm1M=;
        fh=aKOTxJi4jyrNN3r/Yy2VFHZ2mojm9enz4CpKF2bOF+Y=;
        b=CnS+lYC8mc+onyIMwOwAGztEWknWRaNMHdO+t0Js3NCBoTumOrHAruMit3plzcjh+1
         vAxW+irRQo59S5GV4e7WMUkIHpWYRgkLMRSd8OX6sKz4gxAOpsraoMnaMDvBiFBo15+6
         r28NrlTOijuUeOe+t4Rn5RkhTgj0s0jH4UrEJ7nujKMzoR1qX0e194fQfUznoYFRdXdM
         h/9PS8FzA8yUDg8bwCBp0d4AM583iSIelNpcqtOsnP5KxxHcFvx8WUQ/LHPYAezmrVW5
         39tgMbuVGKSU7T5J+cVF4b8YWiv3Lq1Mi3+L2GMQjwjtKEjaXRmXr6YHHsgO0rc+wC4V
         6Iqw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785093907; x=1785698707; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xji9I5cCWfyl8rCasHuYwdrQgv7IUf2NXmLBjKTVm1M=;
        b=Br0NkoQjr/46E0E+O8oGh+bKxVKO067pSY7Q2EeqHgWJ/vS15zgJd0lVfZ4XadB8LC
         rNBV79mkusEC4yJlGVzvPwoNPPt1ArxSTtREe4y70htR/voMjErJNnbl1EdXvyTJufxo
         l4EwoLnH0S8ME59/hoAfCHZd8XZJKboYYOOtbS4uTXO4maWMWdPZ/a3YGbzHGCtBNwct
         Za9+lJDsaUNW27KeU0pZqaUDcFueXsFKOfNoES3Lc2hU7U497Doaj3CQ9JP3/aEzg2j4
         09ZANvu2aAJiBmp4jWx+fQFm7BE6+8l6lD4mucSAIi2/ebJ9CV8jAmKBwd2vadEHTK3W
         wxgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785093907; x=1785698707;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xji9I5cCWfyl8rCasHuYwdrQgv7IUf2NXmLBjKTVm1M=;
        b=hs+bb23nRcSBM/u6RLRvsed4jB9LxtMtCqu1+HFVraa7+DQ1Yq9U/FB7SPjBVS2ZRA
         ObWLGbQPNQXPl/p7VPeAcG79DAxwWxerV2XKtrW0GHBgp9lcZ9JL1aiorK/7ImFmTcTx
         UwlupGWAJsLdrLepji1TI/mYeLojTMRaiNrtv9wWAwfGEGWNEJuGYS8x5wMtrQbftdyG
         /ru9Wt3aIxkAvXZYubICCMSMJ2OTGFNiRk7Ss/Ljbgqg//z8he3sMihLa2G41fecuC6T
         53tR4TFC/mhCDGEdVIFJEmm5Qa3j+4quxFPmtjMoPpagFxE9yN8NjQMMO3x7p779X00x
         1RJA==
X-Gm-Message-State: AOJu0YziifNJNKk3P4zwhu/iPgboQoJVdvgyKY6LpwMGJuBcjJtVHq5R
	R+xz0CG2v5e8IVLfrW1PE0zw1MHmvejDeauV9oaej07jWrvXe4F8V4P4XbWruUvVIopjI/1srHe
	2RWm/yKqUN9fbgP0iqQ54GkaVpdl/f5qT6A==
X-Gm-Gg: AR+sD12Mz9pcTmTU54+8qDSXvkpCpV3ll1k2xFJE/2yhDtRMvqbPyw+KS3QMXNEIbO0
	RoSDsq387/Ccu8bBYRcxrboLWP/MaracdbQscX/PyGRkSqEMxAa3y3BurRMU8sv5iqkuo8UreeW
	4dJ7ePBVq8ArCPCxc/qgr6KEQPntEf4Z7ZvaTB2O0b3v4X3Mg7940VBQY52Zfo8kpx8SFmSTqp3
	9b2+E/78eiHejfwZ1m918scymJKG8AEOKKnVeiLQiwVmGJSz8+mjMhPu+xa34kzp1vVswandYUX
	UXNrhL09XYdtkJwa186m79LkCOXbhJnLHXBjkqBUAjHnRyKAL4mrBsod7EFD
X-Received: by 2002:a05:6402:234f:b0:698:81d7:b812 with SMTP id
 4fb4d7f45d1cf-69fc1160318mr1453646a12.3.1785093906641; Sun, 26 Jul 2026
 12:25:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260725014411.170340-1-bogdan.nicolae@gmail.com> <9ca181db-7bec-4f6c-9f42-4a66068af354@broadcom.com>
In-Reply-To: <9ca181db-7bec-4f6c-9f42-4a66068af354@broadcom.com>
From: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Date: Sun, 26 Jul 2026 14:21:17 -0500
X-Gm-Features: AUfX_mwNTwsOkY6qJ2cpR267Dt0F7D36P3SV6wvBKNyBko86SLQ_6Ni4ThCqsqM
Message-ID: <CA+ORkNTq5Wn079=D_W6J+k1kbJtL+A1mfDU1furVsB9j=sa_qg@mail.gmail.com>
Subject: Re: [PATCH v2] wifi: brcmfmac: cyw: set a unique cookie for mgmt tx
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, 
	brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sure, it sounds good. Thanks Arend.

Bogdan

On Sun, Jul 26, 2026 at 2:21=E2=80=AFPM Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> On 25/07/2026 03:44, Bogdan Nicolae wrote:
> > Set cookie using an increasing atomic counter. Avoids mismatches of com=
pletion
> > events later in brcmf_notify_mgmt_tx_status, where packet_id !=3D vif->=
mgmt_tx_id
> > is checked.
>
> Thanks for the split. I increased the scope and been looking in the
> cookie usage in the wireless subsystem. So I have a series lined up to
> change the cookie to an input parameter and have cfg80211 hand out the
> cookie value (it already has cfg80211_assign_cookie() function). This
> will also cover zero cookie fix here. So I would suggest to drop this
> patch and only let the PMKID patch go in.
>
> Regards,
> Arend
