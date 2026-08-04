Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E9E38DC65
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 12:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785845280; cv=pass; b=CSpwvBx5gAAr5YmyDO0X5hC1Zn2n1JLkSEEymxF3euHxalwABqI/shqlVOngdWK8EdLn/330TaehuHHmlLZ5DAT8l05mLGBzH7Q5UcLv40Uue2LveA8up/WOUjt18KqNtkbZ2AIFNX4TNvQ5UENsWQeNOChXgqmAscEqeri8A4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785845280; c=relaxed/simple;
	bh=iU2JhsyQTfX5/YWs07E2PUyMLuaKOwJY5Z2TGbtlyYk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=do/ehwAi7s6qgGWSwndgv3He1CsNjVdn+7i4MGKPq/GgSOoMzT4KCdJqRsDWWjd/g1mOq8NCd8TFs0sTDL6TTSRnBvUIkXI4pOnW1DK1ekPKxlg3CZK5B+HZUj/0iPBDfDzWV48QiBq1uEOeUZWz307NHBa6NH6uCwOUfYzxV84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HhfM0mwz; arc=pass smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HhfM0mwz"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e9f1f24cbcso828267a34.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 05:07:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785845275; cv=none;
        d=google.com; s=arc-20260327;
        b=enUYAlvCq3hR/takPQIgt1jey+5gGwg2fzxXNmats45oe7i2L9py+6f6b0GyfRKJfv
         wilWcdG1ozMazCcRWVRnHRuYYhb2z1r/FXZf6Sr121d/P7UeTUfp8Vo4IbrqJSix3cEM
         5RlHk4j0W8dirg4pqd+598smyL3xQiUk+RD0Cbe4D8sPWjKZn8eE4637oeX0OPX8JN4c
         s3oTTM18hP9ZDNPFz4EgVstARXP9u17USYAd+Ol54+1xQhUUro4Hb+fG3wXEub/hf3p5
         aanFG9GvlR7En4Pc2Ei35Reg896sdnJkZF4fN4W3eeho2alKk47fvgJb4FwrGssd5qV7
         PkBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=E/WQgZK+TkIY2qLL27HpcsDojys+/2vjkSDsZKAUw3M=;
        fh=H5xszCYfEOnQSGGoqoRuRq7jfO6SkR2eYAKwQaT+5+E=;
        b=IsWE7WlSu7u5aZQuyI5Y0IcA+8Zx0QCnJTWd/hJFV3XmqpnNTMotQT0lilqtS1wLxq
         zUo+/R5HL+Mq/XsFSLKdDLODRM2PHL3tvX9BSAiG6HeKFkV/Hb94aIPMr7wbc4X+vJUL
         V0FuU9FO6+H2bB4KMhRfEqzb2+zek0yC0xczimUJdw++KertP6bcVUiuAbI0CD4fJ/M5
         JYRmZjViKXd1gtxEh7W2IZXG0hnNS5OHujrIYefpzsWzMW5bwH3Grei2qJSiRounwCNh
         gjkEqIuaXnKNB9ihX66N5Ee8Iayio49KEcI+MC+Jxl1ERsOv9TpFh3e1lLE422LX1Bpo
         wmyA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785845275; x=1786450075; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E/WQgZK+TkIY2qLL27HpcsDojys+/2vjkSDsZKAUw3M=;
        b=HhfM0mwzxyX4DTfa05G75mQM0++NUJhERMUUgWTfvVnGkuM6AjwhCnXcmErRBjPg41
         QO62JLOZXU+WvFFXj0d+tP+3oiVlF56VtGBlFS4dTC8t6lQmk5owYLptgG7StBBAJ/ZB
         AzJKamJo8tmXSdXam5gEkFB+aiVChJwzdr8uos7/V26ECbQzgu7aqf2bp9ZfF3QZ+CWs
         xsnyMVNR8fQDGMUn81evr06qBUfMr5mCf3CknN/ON5qpLBQGMgkSu5zVkdQdGwVpHM1b
         IqcwUsBGZCx0utgIm6+YKk86zoMh1u3ZgUErGpHlX7tBd+tDKrExUd7oEqhHLft9sZR6
         lvWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785845275; x=1786450075;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E/WQgZK+TkIY2qLL27HpcsDojys+/2vjkSDsZKAUw3M=;
        b=Y94nwPavAswnDB+fESXvUmR1r095APJ+w8N8wQeij6Zs6gCOKmvCHWNsLtvyWxgJmn
         iawDMkfIfoKt0D2tynsCVkf7VCZMWskvk8zb38tI5O55TxNZQuZ6w0RpTLgYETGqYmry
         BHJM5/asLg9vJy1QEpCA67tQbxLiCL0jPoD2w/uhv6cNSdS+iBxuKawNXYSmJxEx64Yr
         4yP7jrqJI94wzvmycVblhtSLKFFO9gkgvDjBzjx4SDNy/MI6oTi1zanTZx/fMfjqxINs
         hnwtdYATQJrNH426fgRZRqKbe3HfiyzbVgkMoipsSEoz3ZTaxg5FWbMIuMOY7odXE1u0
         9DYA==
X-Gm-Message-State: AOJu0Yxl6RWxvYAHyLgAs4bV/5B+UzTV8THQQhuP7CKjbnZOWz/DgfgA
	ZsoOsEqlQsyheV2ESmxclEHDUt7W5xvc3tVkXKaZRVQEPzO82n0lwBeiaI3bcBAj8H07IfRb7ey
	0KWnKfzOtzWod30i4q5TzwxGPljx08EM=
X-Gm-Gg: AR+sD137QEOL7te8drEj+I02N8jF+VMar/1YLPFQHS5scK/HckISP1yyykfZAPYx6J7
	kraWos7ij6WpDyKU4+nN3GZQr+8+m3gP57qlmuCA22J3TSQjk4swR9keFud6jLeEX3OLSCJO7BD
	kvDAaiE1BSCooDsbfNz+HZQK4fz5pSgaze5KU//YzzDQ2f8wkGxrhNt2pKNKdUeDFUNe6wVDp8T
	qUwtO4pfqJii3fUCqJujaYdpqo8ZCxaZwrtYa/ZMk5sTmIZgcrCvjqIRLpfYasDF1uOzAiM4jh3
	crYcSbqayIOSHfpIsELYPKQf0vvIXxMWBqrwrbMqC3S6BXQ=
X-Received: by 2002:a9d:7095:0:b0:7e9:e288:5d45 with SMTP id
 46e09a7af769-7f1d23a7770mr1609087a34.18.1785845275576; Tue, 04 Aug 2026
 05:07:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260728002048.19351-1-mikhail.v.gavrilov@gmail.com>
 <013a295e-faf4-4930-a101-27cfbf252178@leemhuis.info> <CABXGCsOAK92WxxLyYVfVrdEdLwvZh0JK5RJHn7J0X0mtCD3bkQ@mail.gmail.com>
In-Reply-To: <CABXGCsOAK92WxxLyYVfVrdEdLwvZh0JK5RJHn7J0X0mtCD3bkQ@mail.gmail.com>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Tue, 4 Aug 2026 17:07:43 +0500
X-Gm-Features: AUfX_mzQRqwCX4ylsuL4wr6Nrj0aAhuzJnGtFoWZRvfm-XsaLbyT0PmqT8LLCF0
Message-ID: <CABXGCsMmee3nK2Uxty1SGxLjFNgXf_dhANfkbz-Z5V7E5sbPfQ@mail.gmail.com>
Subject: Re: [PATCH mt76] wifi: mt76: mt792x: drop redundant napi_disable() in
 unregister path
To: Thorsten Leemhuis <linux@leemhuis.info>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>, 
	Bert Karwatzki <spasswolf@web.de>, linux-kernel@vger.kernel.org, 
	Linux kernel regressions list <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 3:46=E2=80=AFPM Mikhail Gavrilov
<mikhail.v.gavrilov@gmail.com> wrote:
>
> For the bugzilla reporter: the revert should apply cleanly on top of
> current mainline, and I will follow up with the lore link once it is out.
>

On Tue, Aug 4, 2026 at 3:46 PM Mikhail Gavrilov wrote:
> For the bugzilla reporter: the revert should apply cleanly on top of
> current mainline, and I will follow up with the lore link once it is out.

Here it is:

  https://lore.kernel.org/all/20260804120004.523934-1-mikhail.v.gavrilov@gm=
ail.com/

Felix, could you mark the withdrawn patch as superseded in patchwork?
It is still sitting at "new" in your queue:

  old, do not apply:
https://patchwork.kernel.org/project/linux-wireless/patch/20260728002048.19=
351-1-mikhail.v.gavrilov@gmail.com/
  the revert:
https://patchwork.kernel.org/project/linux-wireless/patch/20260804120004.52=
3934-1-mikhail.v.gavrilov@gmail.com/

--=20
Thanks,
Mikhail
