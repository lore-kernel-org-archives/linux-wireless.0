Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DF13FADFB
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 19:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785006260; cv=pass; b=h7GGSNBaFU52ybPzoxLPX1VuUIH+/2wg+btQ0uBKDT173c+eNgbcn9tvsxYNuLgo/EglbNLG8sqGGToOxaSsFv1vymIgVzzGlC70Xc/lnSf554aLpeKwpgjWzgwklI/SjxQlvxQ/fkzo33s+mTBzQ5fVa9H5jd1ZZfSkHr+8nFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785006260; c=relaxed/simple;
	bh=qwQwbP341/2bZNekgfUgSX9yOTMMPEMUIow+WHBmQIo=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=izO2EuYVaDelyETfssgQJUn/nY5nejbZWruyhVORIjrpS884khOOrQNfYwUCVTLPnBx5Ng9520rwakPHeIuDRt4ns2FVkxodse6iw5hmpaFj1IcpRvs3xTCyrMA4EEs58KVICqDKkU/IbkLkMW7o0Fje2CEWum3hV15Em4Du3Vw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai; spf=pass smtp.mailfrom=0sec.ai; dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b=PDOy5Pvf; arc=pass smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0sec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b="PDOy5Pvf"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cc97653887so17596075ad.1
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 12:04:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785006258; cv=none;
        d=google.com; s=arc-20260327;
        b=dDpezarlBNh1wVl1cPmzaZYuJPz/tLex1DVyWmAjY3TpDWTj4r+49Z76cU3qwVI7fi
         iDi4pHCHmxGcsEAM53OZQh9XTy+u8Ex3ekWSng3oA9pxrfl7prFXf9Xy2Tpo4xJofaHz
         bwYutmADdPW0rJWSLAMeSm57hnM7iDVMF76I8c5JP96aq9zBNNT9kcfUEnUEY3tW77cz
         3Qhinucf/mpsjwFAdN/dt04SSLz9MKJm8zfk/S1UM44BdxHdg+DV+ipH6G7mwof+dr8A
         25L384Q1RswdCRIo4/CD+fE2q409bCYdRAJmr0Fg3/HoGL6lhEqiVT3NYlXoHtYnrRTu
         aTFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:dkim-signature;
        bh=qwQwbP341/2bZNekgfUgSX9yOTMMPEMUIow+WHBmQIo=;
        fh=qLiCoVw0xzM8FvpTjsJ6soQzMHAGliquRJLdk8JiKYQ=;
        b=p8J7ydEO3FKCKlSfHw2dB+K6VWQYl5lA5ScwjhMjlHBfdPBw7XQMgW7W95wV2wSefE
         o5VNezuuKEVsaULRyY/8y9hi3pYDzfZbELovgSTT49GQPi/N5Udhy7NyXw//vtQuggta
         RLj2ZWSL8uXI1ysvqxAauWauM+Gi0C7ePl14qfdAkFucC5dUlVWHG69Tt8Ib/CtwGkx4
         13BNCGaTDh06kUot8czKIwaT4QsJs0WtUZXvYISUZMfqqgONWUdvmv3aQN1is4jJutCi
         IffNv1W74EszK767WgMgx992k9mXCq0BiYwJYA35IsHs8/wLFYOjT/z1OYB7zgEPV7G7
         iX8Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0sec.ai; s=google; t=1785006258; x=1785611058; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qwQwbP341/2bZNekgfUgSX9yOTMMPEMUIow+WHBmQIo=;
        b=PDOy5PvfPgwtXK9SdVB7wcrhuN77jTm9+SL7vJ3S3ueWHCLimJ8yW3K7H92qTtKWwJ
         44cBspyExjobDUbQrb5b9B9qOqPKX9z06AdM8lkHKSVXF5GlF8hZ1gGjUs1CkA6WyK1H
         QjIRSIYnyTDIpElm4/I1xr0sxzMhSLqTXezhHsvTzH95qUzWZqNYo+X9YvB0KmqH+REe
         9sxozs26V3i8NwvkZyLzbqOoEJFiQwPbag5J/zcUCi3a8ZUSd36Cb4TM2zNtrmU/1MlH
         pILStcpFHX5pOnIsEESR1lOtUbiZGfonIcXSbqPsyMziR5lyMR6oE9wBsv+aTXCBZ7LW
         xujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785006258; x=1785611058;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qwQwbP341/2bZNekgfUgSX9yOTMMPEMUIow+WHBmQIo=;
        b=C0Gt4Uyf3d7YRgv71NWFzHdh6WbyWeQcVX/PTOhJaAsoFt9jCWaCIM57yN5nkiFR0g
         rVpw1rZZOQ8s8qaAaEGANKS5/MOQ/0oNSJ0PtrS32qELXa4Yxu1acyk7bgRCDeYlYmYn
         1bVMkPjwoaeYhzlUAlAW6Dv1o5oUrU1ddSdKNa/lt08pJoXquS3iel0KNd4J34JiLUfE
         hJzy53ILM+Z7wfHhW5u2GacYhRlTV4Zh8oyXU54usF71CMAfEprVJ6plCAAORlq754Wb
         ni5OHPRaGDPfCJef8p+GL68k2TKTC6CZkmKTMde3CEcvzt3i2fuww3Qq8Vd7NccFclJk
         4+XQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp8JoZr5luXupCl1MUUbpxlDvULEMU7YqP071LNuBm0f0+D8ut2q+UPqzkZ4yT6JH40FufkLdojXEZUgBLP1A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw53mGBlYAmwUnjFgE6Zfo3ibDdWI+nYD9iSfk8J/7tYVy/Qv+0
	j+BE8LoF3s0lmcJ608qzKZyfkEuacIbyGKCOwNqJXsUNezpuWLI88I/aFtvTcwjyOnLn5etnjlQ
	Fu7O6uck1nz9GKLI4oSx8g0L0ghBQASmEiF7IxtEPxRw=
X-Gm-Gg: AR+sD13T/cuvyqEuPS6M8PFAN5+lpetWGOpsaJF6IUH7jCDgtY2+uZCCsilXR9mXJB6
	K8g5uiyvX3/IWXo4nSV/9VY8X27ZiTI9sQMT95Ao9f83FJ5H/Ca1HTolYBNb+rGLgpUaXUfqDBz
	Evn77eeBRsuxC6X8rJNkFVHWo39cVmSaV6RTySj12dfe8JXSq5d+29dJ3fbbZRxuB5KMr4A31Xd
	PH6LKJEFXBHef9zBCqWXGW/ktkOzYc9yvjcxkhIPFonJd3JGogzaXxUG8tqANlYl4nQhCSDwrab
	y5Wmx1uwRcfJG5b5xt8hvsYD58CJ+mEvn3wgmTR0/P6/fgI3q9TFqX/Yhw==
X-Received: by 2002:a17:902:ce84:b0:2cf:7d44:e14f with SMTP id
 d9443c01a7336-2cfde8669b2mr32553095ad.26.1785006258440; Sat, 25 Jul 2026
 12:04:18 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 25 Jul 2026 12:04:18 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 25 Jul 2026 13:38:36 -0500
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260723145111.GA236955@francesco-nb>
References: <20260709100800.7026-1-doruk@0sec.ai> <20260715185543.14478-1-doruk@0sec.ai>
 <20260723145111.GA236955@francesco-nb>
From: "Doruk (0sec)" <doruk@0sec.ai>
Date: Sat, 25 Jul 2026 12:04:18 -0700
X-Gm-Features: AUfX_mxks0bVv51B7wFCAaXX5vk8iDj3Pumnc3-ZbqlNRSLgRAT5gQP9nhcLjR4
Message-ID: <CAPdMp1rFFgKdq+PQiAwVga6bbCsuzmR_eGM9+LjKhDr3cnQ9Sg@mail.gmail.com>
Subject: Re: [PATCH v2] wifi: mwifiex: validate HT/VHT capability and
 operation IE lengths
To: francesco@dolcini.it
Cc: briannorris@chromium.org, kees@kernel.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yes, for bounds. cfg80211_find_ie() parses the IE stream and returns
NULL if an IE header plus its declared length does not fit in ies_len.
The len field is still on-air, attacker-controlled input, but it is
bounded by that parser.

The check is therefore only a minimum-size test before the fixed
cap_info read; it is not relying on len as a trustworthy value beyond
the parsed IE bounds. I=E2=80=99ll make that explicit in the v3 commit
message.

Thanks,
Doruk
