Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714523B1013
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 16:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784132884; cv=none; b=ODhkcOvXLyVm5xRgFUB8CPwpqRkHpk13l8n/IbIHdZ0Qxq3VOEWxYCA3Bak1pYiRoQ2l1UlNvnBJcD3g8pIE0vaWPJz7XA3j5iRgZ6OQ/MTKiJlx7rS7S9fKNWljbBEvjKTy8Qeq6JcWdbri+MOc1feAvvd2Yjyt8ei8y5ZI8FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784132884; c=relaxed/simple;
	bh=whbeM1Ql/RDLLR1NnOzpt+hHqQRUALuIobIOc7I4+VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvXQ9+S+xMMnF/2s5itMLNMkhiZKCETBnmswP4esS5XjM8ni7RMAPujsZEF3+sLUyzDbg/d4UbFHxQVacquie9nINGCB8cKCLG5G7pS7ICdy6pJKd946KrpMDqdK5PYDs20clT1HUrhLbfGj4rjrQFaVtUNfyrONLwtWnQ9oqg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai; spf=pass smtp.mailfrom=0sec.ai; dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b=oDyZsiG7; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0sec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b="oDyZsiG7"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47362928f65so5144560f8f.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 09:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0sec.ai; s=google; t=1784132881; x=1784737681; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=whbeM1Ql/RDLLR1NnOzpt+hHqQRUALuIobIOc7I4+VE=;
        b=oDyZsiG7wiOfWqhQ8BRe1ed0vb1ZHCXw4JU7iYbeNZs+nFCbEB0LFbiaYxvz76l0l5
         Y+O5A9/QNrieEHrCFenP0EtJvuFMFYs4zPy5ATNHyRl3XVEN0i/ojqrMPV0iigchW6oB
         FzAjChBFRsmXMhmHW20aa93RUJxcGG2xnfRNJ0yEnQQOnY/85J++MnjJ3pqNOmiZLIw/
         V3XFeo5DQn+dZXcWhI+Nnqed2i2fjXMn1X6tDMNkU9Az4hyb6tIEin+57W2ig8xmzUs5
         lnbZdA3xp4GZ80YIt2lp0HX1RJFT7OB8fTYBze/Y2b5MkInHH1o6/H+tqrte9neBbPzL
         inuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784132881; x=1784737681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=whbeM1Ql/RDLLR1NnOzpt+hHqQRUALuIobIOc7I4+VE=;
        b=LNIITvJJJWnYB4Yr1GUxrq34+tQOJSBexD2earcrdS/EhKWa77j5TvZSjv3uJmyKD3
         TwEI4Z6NlDolLgpnMvnjT1HXZ9vo6ynZnx5HwpmqJgXcqEIHk1+lqo0oXLj3Dq9wg8wP
         QjNB5f0Lhx0j+NtvEp+eYX+333lg4qL9ukUoL8Hq6XRY6Qx2QDv5sgqMHpY+7aZxrzb0
         +pOYUDs0tFYaSSvbRt4HUMCxxRklKJhlIkudXiyScxJu74atwYuzqnjfBfss0f4rmIRI
         wF87Zfh9G3c0KX7Z6ksdtXi20ZySsn5rRh+rLxNiLbpsctMmfzPO3IHc/S/Apv6svAsb
         hifQ==
X-Forwarded-Encrypted: i=1; AHgh+RppGnKcidZjFIOYISEpxO2n8H5IQ2fduLNblwwttCOK3rKo86U4M64cvSOWRWZ60COGbsKAAwLa+5cZgfC7zw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3vEeIE66VVtGASUN5sk5Z5tbYXIB+2SUM8Vqh4brcI/H1bgHb
	E+chlU0OO1O8MHwUeltASW0rEr/sVR6ru/I6lxtsVg/F9gshCP7JvOBpu3U1rrUb1gRO2Kb4HFC
	BsSBL4nDl
X-Gm-Gg: AfdE7ckDiFE2YEeQC5JvNEwMVIIdEHkVBWg4NGU1iOJ90p8Jt1bsmrRw0GvTiktU5am
	9y2AE8Y0j+DT1I4wDpAnhgEx+TCjjJ63NLrbucX5gh3l9/agppn17wEnTSU19JVzOZxcfIDgnU7
	pyZnygGZa89MV6AshW0F11xmUiyWmZDFS1Wggywy4el+Lsl/aqVnkrM/IO5xpvM4QKVFhlMbmbC
	ctGhvMNeQs3GjQfkrQpD4mqfv/uLG3ukRb+lItZ3TVqtwDMnMIUOYPManBkSVKy+GjkNh23wXn3
	pV8ujERMPuAoEvbR9oOY8QIZuRenjJqsg/QkHEKGuIVwVOIBsel6/XcIpO4FdmruUDIvmlDjTts
	PrHKgVkyX9wCfeOCTKl192IWZBMC5vijf/fNjbU89Pk0atqQ0qpdzznRx4G2dMHk6vQm0LACnIo
	5lVJhSn6B+ZxOuE5KK6AUxCaN67oJNH+p/6orj3x1cm3aOj+i1CiRvSYfp3w6HOrhHYDAtoOvYF
	UVJepFoJZkcIxmZVF/QwA6k/3RgrA==
X-Received: by 2002:a5d:5f87:0:b0:47d:f445:9490 with SMTP id ffacd0b85a97d-47f488c6b08mr8260998f8f.60.1784132880500;
        Wed, 15 Jul 2026 09:28:00 -0700 (PDT)
Received: from PeakBook-Mini.tail8e484.ts.net ([178.197.218.188])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635a9cesm18065381f8f.14.2026.07.15.09.27.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Jul 2026 09:28:00 -0700 (PDT)
From: Doruk Tan Ozturk <doruk@0sec.ai>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Brian Norris <briannorris@chromium.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] wifi: mwifiex: bound the pairwise-cipher OUI walk to the IE length
Date: Wed, 15 Jul 2026 18:27:57 +0200
Message-ID: <20260715162757.1886-1-doruk@0sec.ai>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715144752.GF56330@francesco-nb>
References: <20260715144752.GF56330@francesco-nb>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> maybe define an intermediate variable to store `offsetof(struct ie_body, ptk_body)`
> so that it is clear what this is, and you also can re-use it later?

Good idea, will do in v2. Thanks.

-Doruk
