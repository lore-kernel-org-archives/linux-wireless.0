Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793528969;
	b=U8dq9964SWozgkNSUeJl0fL3eR+HRF7hT/Byv606F5sqMPUkeOcgkpuP1pyVz+9rA55/
	 0fDmLxVGIe/kpnDiCFI6sYePF9gDoJRivde5rtG3hfHDcXMECq9ETQp2Z5VNZI72gJdXb
	 MEoFCk3fTAvDp+jw64BWPo7YGnCv0pidD9eafr31OA47Bk8miylQJ+SOg4Bx7n8+VbuCM
	 54pLyGIHlKGEuMOn9Vrk+sSE9ySkDlM5KFWXylVDHB3g3xfMLZzx/XcSyA7MntnaK1/2+
	 x4780ZtcuSr0POsDvXIJopTf4mzYLhelkPSk62pKjPaMmIYStQ9BNlsD/s6iyiP1T7g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793528969;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=3ClwihzO0TiWBPtA0MrYkrwVxXMlD37sC2xaLzq+UYk=;
	b=42spcwI0RaUqbiqVyhA6ed6WZktFMgThnhsxanAPgHjHA9VYF14I7jmgPJQvJ0TA+a09
	 mwcFsDSm0hIVBkXAxZYy6BquFpE3VJIgoyKbEbjj5YrD0NJ/jwh36sondzPjEmQL09PrV
	 vm6Rx5HZGtkWwaAeCceNEulbiJlooni8HsfoOlngS/H9clV2W2Uy3mbC7i6sJ471QsIkQ
	 rlyG6xQRarpUV4C1X2Wwsi1d1DgI+AQoMuiWDnNGUEs1w6hfupYSKUtGEF3OcD00bm0jV
	 FizC7ygdkgVLg40kFtc7MMVpvgasno4QgP1DLCKuepJtf6SgnlQ9dQpGUkkTvbIdZmw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=acio.nl;
	spf=none smtp.mailfrom=acio.nl;
	dkim=pass header.d=acio-nl.20260707.gappssmtp.com header.i=@acio-nl.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=TWn7HxNR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8099E606A324
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 10:29:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8099E606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=acio.nl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=acio.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acio-nl.20260707.gappssmtp.com header.i=@acio-nl.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=TWn7HxNR
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b3dd83e779so3642748a12.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 02:29:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793528965; cv=none;
        d=google.com; s=arc-20260327;
        b=iyv33qgOf+5CYlOZof38tUp9RbaOt2JhzCTJJtdQ9jXVTqZgvej9oy8lBAAVxS1Gx0
         MLPZ6QBpNeh5X0CEN5Acp5H7GwzgEFgHA205+o/c7XvlygL7oauGS769OaPppOc/kjLR
         Q7HwcS4T/0H1CuZj1Yu8VjjkVdu46dISFEji6kx5zmgX/QziZD6KK7qzglDsOsQ0HkPZ
         Ub+tWqCs/BjhHRdX56eeDwqxoVe3qY/2CamaLjRJIYkgFLmGX2sMZhGeYQ0Q8qp4lt7h
         57xi1XZbMHuuVVRdy+AKC8CwFhkum3+NnSU39BYgQxX34P3MfcuDn9I1XKZf4c6Yxgni
         7Wew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3ClwihzO0TiWBPtA0MrYkrwVxXMlD37sC2xaLzq+UYk=;
        fh=zFCB9yj6tbPtiNOgT9n/qK9LnQKfgtX1AWhCxXtoerY=;
        b=SJMDhCofZYUUShKw33vq27rw9IC++kFHFie7BIrtt6QbYG4gdV1oAWKVZBujpkLbc8
         lSTQO4wK7w839wMe8FYwP1Z1tUCUqHVIYUFRR0Coef+zKiN7JUcug1OdZFcMSYR8+cHT
         RbsN8xhulw1IF8UEZVaRC/ZWAEOVv/PUGzkjCrTEuoiZfUPl6uiuse63XJABK8x366Hs
         6d7nv5Z5b3tMAj1g7Vbd02+0TPMXgUlOws77LPVe18msjndOOXa5ohkQiGXp82LYLUPR
         2kfGElPg2cxu2gqcdx5pXDqy5qjNi7BF2PLgR5on9lkkpTgoqzlXvw56N3eREjpXA6yU
         sPmQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=acio-nl.20260707.gappssmtp.com; s=20260707; t=1793528965; x=1794133765; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3ClwihzO0TiWBPtA0MrYkrwVxXMlD37sC2xaLzq+UYk=;
        b=TWn7HxNR3Q6ojebJ180eI4ZhM57S4m40gHAj+2Ijt1ekqsM27x4VOAu8PQwHkzRiAG
         mPGD9b8YUuyFJCwvZ/HSSkoaE8EndEQIFbiuv6e+HaHcq9JZa3wWNFZL4BTCKPOh7WrE
         x0sfUkHkpcCDcPyYpBnzt5ISPMo/yucSEREg8hTKuuSE5UFRs4JGnPFuelRqlqqBZ8hr
         l43wW0LNXgF3L/Ou+xJctkqGN9oHmmf5rquGIssKZE7abJZ410i/TLOST2pREE3jQ7wA
         /qKA5kZbENpRSIql6v69Es+eP+P4DirZoip9K7N1FpljEPLmqJFqH7qZGYYYLmztvkAB
         BDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793528965; x=1794133765;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3ClwihzO0TiWBPtA0MrYkrwVxXMlD37sC2xaLzq+UYk=;
        b=pcnQgAj6YlGUwEZtKrIp10PBV+mpQmU6+y+MA+wuJUhM7xLf+JO62Za8JtODAFKWbn
         ybBLgXPEM+/6t8vEu5lwXXoqUfH/MxkdTaqHUCoBRwOG0/ziGin14kZOoHWIyniFtV4Z
         vXr1tF3/u160VgYwySsa8THvb9se/3Axw8riGwGwv6dOA+dn8pTIB8K45EXnuaiPFfXw
         bGfhCa488pJ3YoGfHXZdsrxlerB2sLl/NYV3r2k3/blWaRDQF8lOnZH2JrWw/QhZIVyu
         rims5ME7/vSUTGGplMPtCRJHG1MhMJfQ802Fc1ENh+PFHWOhx+a/ZRrWEBfQmGK9uLGA
         qJDg==
X-Gm-Message-State: AFq9FYI1jijYrojnM+nJmBYxF19KRS2AKfyFDMdXtSNPf/azQaO2OKX1
	fcOys9SxE7j/84JKjk6ko5X24izHcpWWbOUoC2OzX0LWtyWqSogQfGsEDrxzad8PnKU7odmPQ+g
	J8WzNd5WIPVenr8Mx9kAjDndmDOZ7syDvW/fRKe4inCKz3waW4REkxOBt
X-Gm-Gg: AYBFou1LvCVp9U03ruWRUlobOrAxbZPpUjR1byhBVVloITFZk7lBVAt/oaLwJGDoVN9
	V9Ws8XS2yyRK+NHaM5Nv29Io7e1cC8zF3cZDRXOGPfqPNl2Bud9V1I23xhFSMiW6NF6bUch6R1b
	OZzzKKOKnCht3UbXa+cMhYEmH/0aLiC3YDzlkd3AE7UmACl8ITMAJy7Yxbb39Mo7M2HsYkXyJQz
	BJIIZoYye3MtuDDx6gNEX5kcgrmZymJ8AFghLLzm5zvCF8U0L/p/jAgTMlG1OiFFvcU6YQ6ivoi
	UlSLjgl7dlQi0uFzLNYXXXLHZu2URwWXqagXdbusQQyQGeunh8wgQ8SyonStMNuyfOUc5LqM//r
	WnCLE0lzSs8v4zP720InvURi2zAxIPffWK8AqMtE=
X-Received: by 2002:a05:6402:a6d1:10b0:6b4:91bb:88ec with SMTP id
 4fb4d7f45d1cf-6b4d4d6f5e9mr3300196a12.35.1793528965160; Sun, 01 Nov 2026
 02:29:25 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261020130019.137170-1-spam@acio.nl> <1ca81a8669be41a6924ad0c5e042fcdc@realtek.com>
 <CAJKtVVb8XedNH4Dcfbe2--CdtWM45JYWVA=2arTEW37Er-e8NA@mail.gmail.com> <7a673decd1f6461b8f0149b98623b5cb@realtek.com>
In-Reply-To: <7a673decd1f6461b8f0149b98623b5cb@realtek.com>
From: "V. S." <spam@acio.nl>
Date: Sun, 1 Nov 2026 11:29:14 +0100
X-Gm-Features: AclHuK8S95GigXvrCCaC5kekL_YHyaNm2KUMrQ4yKC3XA8V_AevDSE8rzHcU_J0
Message-ID: <CAJKtVVakoZ2tJDiLtBbRChKpZbfNPMDLR-O-0V0Kj83RzPFCpA@mail.gmail.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: do BIP in software when not in
 station mode
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ping-Ke Shih <pkshih@realtek.com> wrote:
> Could you provide your full name? I'd Cc (with Cc or Reported-by tag) you=
 in
> my format patch. Maybe also include the github link:
>
> https://github.com/morrownr/rtw89/pull/135

My full name is Vincent Schurink. YOu can the following tags:

Reported-by: Vincent Schurink <spam@acio.nl>
Tested-by: Vincent Schurink <spam@acio.nl>
Link: https://github.com/morrownr/rtw89/pull/135

The original bug report is this issue:
https://github.com/morrownr/rtw89/issues/114

> I plan to check the key flag to decide if it is necessary to increase PN.

Thank you. For AES-CMAC with IEEE80211_KEY_FLAG_GENERATE_MMIE,
mac80211 writes the IPN into the MMIE in
ieee80211_crypto_aes_cmac_encrypt(). I can test the next version on
the same device if you need someone to test that.

On Sun, Nov 1, 2026 at 3:36=E2=80=AFAM Ping-Ke Shih <pkshih@realtek.com> wr=
ote:
>
> V. S. <spam@acio.nl> wrote:
> > Ping-Ke Shih <pkshih@realtek.com> wrote:
> >
> > Tested-by: V schurink <spam@acio.nl>
>
> Could you provide your full name? I'd Cc (with Cc or Reported-by tag) you=
 in
> my format patch. Maybe also include the github link:
>
> https://github.com/morrownr/rtw89/pull/135
>
> >
> > One note: mac80211 increments key->tx_pn when it writes the IPN into
> > the MMIE, and rtw89_core_tx_update_sec_key() increments it again for
> > sec_seq. Thus, the PN increases by 2 for each frame. This did not
> > cause a problem in my test. I do not know which value the hardware
> > uses for the MIC.
>
> As commit 79a6c9a4f3c4 ("rtw89: support hardware generate security header=
"),
> which introduces chip->hw_sec_hdr for newer chips supporting hardware
> security header, the key flag IEEE80211_KEY_FLAG_GENERATE_IV is unset, so
> driver increases the PN.
>
> I plan to check the key flag to decide if it is necessary to increase PN.
>
> Ping-Ke
>
