Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6DA3B994A
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 11:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788695955; cv=none; b=BP6QFdt2MnV2IjVqaJglfyFMVTndX2qSPwgf9m406nNcwO35XvcJI5YbvBfP+Nq4sdNUxIwIrA7/xrEPMmbVfhCMuKjdLeV/6QNuNXAJyj2qKT42WXtn7TVKGGMsP3fGh+PRMbQgerTYgVJM/ZTG5jtzQ8nh1lA/id652KdkMEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788695955; c=relaxed/simple;
	bh=jz5LgxvtzxcctV6IH5maABcFEi4JbrhAW5XDbGYdhpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9tDtqCwhiHv7GRdMxc0MGZYupmzCKX6A3nxhTNxnvLx5MrOS6H+qgEfD7CFR/xAI4jlK8H9mAUGK4tvyeA0clwwxCiSj9uBpyZHGo/cthyBS09ux8Y3i0yKBlmZcU363z8Ah+a5FZmuvvbczS93ap/4SfpSyogGoRJi1U2cdVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PmUrL1xb; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PmUrL1xb"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b14d1f9315so2327371e87.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 04:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788695951; x=1789300751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g4mHo3F8s/8e+ESznlznShaPsnkOnnMwdoOs5mVuQUg=;
        b=PmUrL1xb3vwV7dkfJ6Oh6+xt3Rv21b8Sygz3wBkc1ms+a0HLTAPml7AAZF0AcJV1fK
         llbOe6EYPk2L4ekOgyyk9vft8w0kUeMNbrnbpcjsnRLpqS5tOKDmGWbv0U1KoIVba1XM
         qnsbdF33lPFCwmUUI+lOMkjegqtU77/k+bi2s2QFxkFZ3MaOcZ088+c2dvTABTRpCOgu
         Em/fQVVEblMIo8Qep92HImrwprvuS0JcSHWULUtxi8zS8QYkAr/KR7fIyBbM6M7qN+uQ
         3auBgWK99uSBk5tUpIJTtlBMXBi4bCFtbJO8p1E4g8uPgEN/2FoVsaX6eNeVf/BP8IwE
         X8+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788695951; x=1789300751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=g4mHo3F8s/8e+ESznlznShaPsnkOnnMwdoOs5mVuQUg=;
        b=UYoLf2PqRYlK477t7Sko7l5jSoF6XDZCN57L6rpDuI4AyaHbCvBXGYgsxDMCxCZFXI
         6KSSZXPz0tiuX/o6c7q/B5XpVXhqhrq1na/ewvJwe1McRlPi8mg+LVMUg/P7nAa71UsH
         C+VH9Q1J/t8TudhK7TIavAdAXHo6zvJgeoHiIVI0DzmpqlxQe1Bk7LSUrgPajZy7TcIm
         9nNQKgbyxS2O9XRrp6BMR1xDGFutgD48L4udyJA5+f0TZqdRjimGSLcuGwH8ZTA6Ah+X
         CE4Y0ROZaLGFmZK6jVOBX11wSIiVK93+e6RKhAxEVLlCQSFTSx0ISbAs2BptsaI+LQd0
         8LeQ==
X-Gm-Message-State: AFuF++n9QxClUUm9coMaS1FzYqM7XGfkn1ZC9xYCXDvFrwsskQlWEK+f
	OC68hBM1xWcvnKycpaKuIebohvOnLiz1F37PkCj+FNppGCRcKMbOkzakfiCv0Da/J/A=
X-Gm-Gg: AYBFou2nT5psqeXElLK8l2NQkDK90oMxVCiGBr7i/Nw+p5TqG365Jsp809r5GUrmiID
	aedRVy8Bn1bEJ+JNq0Bupr1XjsP715RDuAX38qFNoESuz6fVdbhtuyeoYU+zb5oQT0fULiBStq1
	aH1ZW/m8MyB1iTTo0v7kyah/2+PMeGr9tbkgxnssnE7vBupDgykqoBLwlDHzvgufi9EpduRIHoF
	ni+LKF6oT2J72c6/mtBY4hY1869TGmfkQu+1ZVaEbYOoFTdoVhQmtNeToj8LDt+ZP3RTqd5+vGU
	V1Bkx9kWGzFF1uVEfx5uk5683sRIar+m50lEORIx99iIbo97U7Qpb7igflM+z1j03uXBkNO9nC8
	aWTQ6B7pJi2p+VLcl+1oYF7e0OtaH/DUnv6QMOoguhrB2aHLVXK3TedKnCQJcAmIdLmao6R+6XJ
	sguaBsLrMrn25Rlaur/C63aHR1u4F1W8R0xVlSix0hIGa7kSj64jFGMCcA9kzEKbaMaz8utdhvY
	3Qrlw7Dcu5IDa1r
X-Received: by 2002:a05:6512:1325:b0:5ae:bcc4:c071 with SMTP id 2adb3069b0e04-5b616e7c32bmr5987572e87.0.1788695951173;
        Sun, 06 Sep 2026 04:59:11 -0700 (PDT)
Received: from localhost.localdomain ([80.66.93.120])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b6166ecf3dsm1634077e87.15.2026.09.06.04.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 04:59:10 -0700 (PDT)
From: Maxim Skokov <skokovmaksimevg@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: rtw89: RTL8851B BTC entry requires unpublished firmware 0.29.133.0
Date: Sun,  6 Sep 2026 14:58:53 +0300
Message-ID: <20260906115855.15755-1-skokovmaksimevg@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <5976dee678a04857b862bc8745420fef@realtek.com>
References: <20260905131503.6160-1-skokovmaksimevg@gmail.com> <5976dee678a04857b862bc8745420fef@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ping-Ke Shih <pkshih@realtek.com> wrote:
> >   - Is firmware 0.29.133 or newer expected to reach linux-firmware at
> >     some point, with the driver support having landed ahead of it?
>
> This one.
>
> When BTC expert does upgrade, he does review and implement the changes
> across chips in one go, because the firmware is share to many chips.
> Or, he will review the changes again and again.

Understood, thanks for explaining.  Good to know the table is meant to
run ahead of the published firmware rather than the other way round, and
that the entries land per-chip in one batch.

Thanks,
Maxim
