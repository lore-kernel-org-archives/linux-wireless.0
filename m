Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1CA335575
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 19:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785092848; cv=none; b=WtgCsh9tATxcijanIpane93XUTHE+E9OrXMRevDB0Kk8H2OSB9QygqhmRcQDZWzKEyJwHyF7OV6sec9NqR7NzxtKLT30YSrQfh0i8BTRQKphi7KQJjhZWWVQSwt9VHu9Rj21biEigFPwe3zkwYmVZl0ll6pEUobda/8hHvNWXOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785092848; c=relaxed/simple;
	bh=aeR6qb99/go93Xe0zf/SY2jIefv0FIAp2SuMPVC3hfs=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=WOStqJ/TwTkKNSYXuAy0MbR6xtEUR+/jtXS3x9m+1JIsosaKi43tXT7ZuU9p8pACMv/LktyQJ+JYuCG6YcKMnMUolbo+mEu5seEfGHJQdPwCaC9DkmJOuaRsZpweRhvDSGNnwBycghd9u3qa6Hq9/F9jEyrFiTdzUWl4dDZO1C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai; spf=pass smtp.mailfrom=0sec.ai; dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b=mE+0/tAS; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0sec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b="mE+0/tAS"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4957eefd361so15312955e9.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0sec.ai; s=google; t=1785092843; x=1785697643; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aeR6qb99/go93Xe0zf/SY2jIefv0FIAp2SuMPVC3hfs=;
        b=mE+0/tASVYJZBf3tA+tjxne60SXy4niOo0WVuy8GT3XQGCOeQPjugx1UNcaPgSaa4O
         gtRF63SP4hIqOLnkSiff1Z3Opi/qSIOpfgxOvm+sufnyTknsURZsuz1aBf5g3lzdV0Ek
         UqKkZ4FvU4fXAZGXJcknkvBuua0ZBfhj2YUA+ahYoK8lICiuT6vvYBwz2gw57HGvIzRZ
         XkjwcCBifpiu86LOcUSwT0ShC2HxA+sHLkeqEa+889TD1m2L2wRmtWECdg6WeViF3Tf7
         HkNtgVd9uUs8j4AiSm9LyqzGiF3pJqo3MZqASb84CNov8hafuWJBKmyOg34mCgfIqQLc
         ugcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785092843; x=1785697643;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aeR6qb99/go93Xe0zf/SY2jIefv0FIAp2SuMPVC3hfs=;
        b=RYuifAR2HDLzoRHEFKVRuluKCUPT6zO63Y7TIVT74SB5TnavXWNjGqhjDAy8YCx/cJ
         7DfA9RIUySLLt7dDSbe1JL7+wbaR3Q/mG/pccqQpx56EdQMq+DbgOmZ6EfLyaM27NDl2
         pU3yOc/KitmvDIhXknyimSzI5fZ6Sd1i1yX5rq4kD91giA72nyD+uDoeWKOtiwzUmKAN
         c+GBnss8rziDtUBTmm9UznBgRRST1WrYa1wtF937nKMPsmyl4qmmVM7Nj6vGpDCcDK6Y
         Hhur6m3iRvt245dNXC1Lmma107tAUg6VNfCs8SFJ1y0n4VwSsB6SGdpJqd55YZ0YBkXP
         mcCA==
X-Forwarded-Encrypted: i=1; AHgh+Rp33h6Ntc2xrLv9a6RZyrqwbnlB5WYbHzqXHy0DOKMCdJhMDQ0DRfJhL4RrNpgV6Eu9M4Eq6c8BMRabdvj2dA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzrG36DKGRYK4HU+Zw8EWHL98iF0fDlb24k1ZUYNljSqRQXF/aS
	G9PqsYZAtykLrhMfVp0MEhI8wEWlC3a5rrRG/USPZPpWPn5DwbTNWdKhgb1wZqGlQmsv
X-Gm-Gg: AR+sD12ULxJYNahMgimLDG07beeCYv24JyOCvBDa1LEuOJ0nUVikvwfmrvUI1IraxGa
	opgFGaWlRIwAGA+8AtI4aIT5nyc9TnPKRTSVi8voak8QsaLR6p3RLN9TZdhmohfK5i5t7larNQi
	F6IPuDREQ/XOkrWg55e9KH92pAMZn132dFnQWhC8UOHsm+03azVSRkZI4gteiVLdikB68SVKgsl
	xcHxvZjhSFAU7QdFXh5Gdm8CTArnGfQ1Yw3KW8bTZ6co3I3MqogMlemYfuq+/J5HqduXAglkFnH
	307IQu8NI+7dup5shiiZG5b+Gjs5pHc3YS81Y1JiBCBokXFQDsTwET6rKtloKxXpncU1IGk8n2t
	7XKraR3kblCoSdf4kgWhFseZsD+60yXWWSfpWUUIc8itdhflXAbrmckvmWR9BVu5GlLGsM319CI
	Qj7ex1MqB1zJKd3oT30MJ+kaRByOuC0Ep/QYzESWPNTNsn+MH5pci5ISNFq6KImJuh2o+boYhkl
	YKv1E8hkznX3FCH3EKJ4tq+a/2QDqQs91Y=
X-Received: by 2002:a05:600c:8485:b0:495:6713:9aa3 with SMTP id 5b1f17b1804b1-496b57281d5mr75357285e9.30.1785092842714;
        Sun, 26 Jul 2026 12:07:22 -0700 (PDT)
Received: from peakbook-mini.tail8e484.ts.net ([178.197.222.64])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a6d7sm42226357f8f.2.2026.07.26.12.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 12:07:22 -0700 (PDT)
From: Doruk Tan Ozturk <doruk@0sec.ai>
To:
 Jeff Johnson <jeff.johnson@oss.qualcomm.com>, linux-wireless@vger.kernel.org
Cc: tristan@talencesecurity.com, vasanthakumar.thiagarajan@oss.qualcomm.com,
 stable@vger.kernel.org
Subject: Re: [PATCH] wifi: ath6kl: prevent assoc info length underflow
Date: Sun, 26 Jul 2026 21:07:21 +0200
Message-ID: <178509284111.44012.4392862410372916703@0sec.ai>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

hey Jeff, sorry I was prepping a different patch and sent this one by acciden=
t. please take the original one from July 13th. appreciate it!

-- Doruk
