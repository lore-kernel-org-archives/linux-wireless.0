Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894283B7750
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 07:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791272794; cv=none; b=KCovs9PeiqFnImJVgVciO9LoUX4jBUiacqZeOknCWjnF9S300X3PVJ3jfHpDoGwxMcjt9QeiuLViVJDvFcl0zOq6UocUe7nY7Rjzq3B+JfTKQYaE9o/j7vg43oBW1ZLRxzIVfQ/g6QnpjE3IrWsOUQSyikiFRjZZ5gE90NHcx9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791272794; c=relaxed/simple;
	bh=jojZgS/siqNz1VrOC7A5IgdOx6uFms2WqJVnwwZP/jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxqbi2/2QSEOvhxSl3YoJ3z3R0cvEEnH3alz3m1JlC5LpThpM5uQvTBzNNT2EYByJ72PTvO0llHvptAMSlcF8eGH5ZDBxJW8xl53XEOPD4EoPaY59vnZNP+ggbZ03Lt3j16fVqYRH8c0h4oXqJT7K6LRn2AgoheGkLiSXmXz6WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ghH0/HPa; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ghH0/HPa"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48b02b1b4cfso265664f8f.0
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 00:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791272791; x=1791877591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jojZgS/siqNz1VrOC7A5IgdOx6uFms2WqJVnwwZP/jc=;
        b=ghH0/HPaGpSykhL0sAs5emx7jiItsNqFBUZv1WIHa9RfkG6VTN6gEgQBviA+v8qCHO
         5+1J8tBT83Lu0OoYNTxSwEfmg9ahS6x4Q/cYaFULKGeGMBwPXRf8bCLPqSQpJlMvhZnu
         CRhkvbtH0vcb4DgR4VtNWD7WXyL1s6q+RXj4Ck7LRngP+/EAUVou8Vf0wQq4O49P8VPA
         SNcIBeM8+fCve+UoYdvAb0ilGWro7XgcK7dReG4ehb0HgSzyzgLSZXamyh3zGeqDwpRY
         wTph4PFYmzaBO64eOyZcTCqcVOz2ZhzZ4gcN/0Gzym4Y559Eb3ZU4DiyvAZrcxKRMB0u
         0DvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791272791; x=1791877591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jojZgS/siqNz1VrOC7A5IgdOx6uFms2WqJVnwwZP/jc=;
        b=U2FpCt+xXIz6fxGRjJ8T6nDBKUCdW2ruVbV/PjRG5uEWB8+O/b8IUi0axEuD0HQhng
         bVjD2VYckoD1zxaq09RQsd7v4qDnH4rvtdzKJs1tBB+FqfHNGDLcw725O3+aogw88fPH
         ydWKiy+z/Qat5YtZUL6y/hFqHX63yUGOL31Y/oxwx2GwlVR1JG20lB6qHzPE/kgmnhBZ
         /54whlCdrTTw9H+U9H0Q0sGKsEh21Ec0itoyu2wHzmzKUoU0JX+P/DExhq98NwxjGOvA
         rSnTreE7Tncoas9lHLRUPi8ZibHgwyW3TIoAmG8mstr117SLAILuBvgq8SYkkYJ/3Ptu
         4NuQ==
X-Forwarded-Encrypted: i=1; AKwUvByXke/C5Naf2YQK56ytYXTQYHSxVpM8n6Ef/wGA+ex0wAmrKf/4i4eobe6GT9hqiLLgsgukOBleOpMjJ7PZ2A==@vger.kernel.org
X-Gm-Message-State: AFuF++kJ5zYeCXn5koUcqReaQ3fVK9BLEqN2X7BOOLJgAp8PM9Ar+hWB
	dV55xesYcTh2Ewfliyy8QW/U1/SjKMrmXnh53/SogI7HbxHreK4dEhyM
X-Gm-Gg: AYBFou1lU4QzCtCuhIwWeaQh2Ony7vMwI1F9WGJ68kWfDh+9CJMiPswbdabAzxfHKdj
	uwqCmXdZzPgY/795OgM1K+ie2pSFUbQVSc0o/vDe10TkQQu7DaZrIo4lFmiPEt94IncUuScTR+l
	iwnZEQr0CoGdNGMEs8rxjaIYqr3mA+dwfwzP8+POhxHDWPN/Egn8I9Lmn5ojQ8pRUo0lpyjcnwj
	heYSjgLMrjN2Uc6wx3gdt0tm4tHSRMVi/ELJJmK88mU0mcIFGNKZ/rtE2fvM2lQJyY+Kv8nSk52
	/TfaZxE/cZKLvrW+1VHOIxVq6Y3KgpK8in3YrUGAalHVefrXEAmaQJmzd5R4S1dS1r5U2erIZNx
	oQlb8yIQ87s+ypkzY0Y9XpnUDvz6TxcHPTxIa/AanU7074tUVeWeMk/HvXuCapTQuUkblcRGHSa
	K1rTict5Aodl0YbP2qEvfNvJbqQ33wbrltCwKwQcwaINq3spP2jbLBmCwiPt6FVrWzrlkU+Gp7W
	ox2
X-Received: by 2002:a05:600c:1388:b0:49f:c5aa:9ef4 with SMTP id 5b1f17b1804b1-4a17b53a52fmr11049415e9.8.1791272790704;
        Tue, 06 Oct 2026 00:46:30 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a178db0929sm52237855e9.12.2026.10.06.00.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 00:46:30 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next v3 0/2] wifi: rtw88: channel switch in AP mode
Date: Tue,  6 Oct 2026 09:46:29 +0200
Message-ID: <20261006074629.372782-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <b6c8d3f63f7e40fa8b515352cba19541@realtek.com>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

On 2026-10-06 Ping-Ke Shih wrote:
> If you have something changed, you should not carry my acked-by.
> Or, point out the reason you can.

You are right, sorry. v4 drops it; the only change since the version
you acked is the initialisation of the beacon pointer in the caller.

Best regards,
Mehmet
