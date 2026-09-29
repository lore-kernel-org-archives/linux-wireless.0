Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA6D3CB2C7
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 16:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790699426; cv=none; b=TqxrPJpOFsuXpom6ELeSyxjoBI3ks+uWY2E8TjZZ+f++tK88HOAWilpUajeSfdsrsvsnkO7InXRNG+j2x5ayyutJDQbAIF9Q2/Fd7BDCmp8jYhZR8iuX90IRHi5bneQvR8T7sRFrKTkVtUG9Ih/RdvJ2kI+qX4s1v590a6VmIFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790699426; c=relaxed/simple;
	bh=yZLzULU2uih8NUS1IvSltwPGoqS/nnlu9ISb0E8Wc+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onzeYHIwyFco7JMe2XzLZE5InySzpldmX6MJ74rJvJJ06Vzn+tq9/Jd77Z0ZZ1b6IofzGnM00cnxtteZmlGlPm8WKVfzog9RPOfloA5e+7PCNYi2YVkjKFCzewgwKthm6LMtkzCA2bmCeGCDVPWF9EnogblzwiAesnHonzj+Fe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ed/vECsa; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ed/vECsa"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48af0707d41so547038f8f.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 09:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790699423; x=1791304223; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yZLzULU2uih8NUS1IvSltwPGoqS/nnlu9ISb0E8Wc+o=;
        b=Ed/vECsa2wbKYImD7D/SitTRJZ1iUhem0kP+Dt2nlr28Gm+2V33Jn1Du6yORAYHAok
         YC3b/rx/6H7zmedPSSNYFVCvhUvCkCR9yEqLgJ8TC3mucvDyVvDXo7WmZ6iOVA61cpfx
         b/nd4lCSdHj2jFYeViT5T1kaeXtn3Iau4Z4c/HlBQ9WhNjDkwagrUOb5AGdgC6bY/Uef
         sVLieE5V1sBP2nfioflJo48sh0hB1fAXHC+Zu6lwYTSqVLFcWVWMohjbd4hmtIY3Str7
         YsJtNGj/I1Wj7LO7+FBClJM/4uPN+LHS4w245mvB4VyS7eYa/CWmYUbCXqOVPfdHJhNn
         cT3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790699423; x=1791304223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yZLzULU2uih8NUS1IvSltwPGoqS/nnlu9ISb0E8Wc+o=;
        b=mz9xNbKUBUWCYv4iQGvmwt+aQO/wscnlbFWzeHXPrZHi5fvZ0gIOUlO5fWuflZ4R77
         ukoAAe4u9Nh4GojWkZ00O3Lg7rBPirAyiDdOwa99UnpM0ZbAvf7yn/fQcs7oGbU66f0a
         UTDEJRmSbcGhV1HDuYF/Nst7AoblQZEoWA8Pmja/x+jcRv5mpi/5FjR7WCKmm0MIZMju
         716ufgRXjUdideSihcItRRuw17PzILAVCCVOc6tXfOLM+JbkLSJ+ScX5moZi0IN1wG3Y
         5/4gZxNTPBOwaNwBs/vX662LAP4jz1tjQbbECMXhLMLjguI1iVizmUkZ6EQQMn6uwVNF
         6uWQ==
X-Gm-Message-State: AFq9FYJJZ5gHq62si4BFX40br9Avq1+8UjvEtYdKEnuKM+zMeG/pt5Gb
	d1XVVVEAYjlF7eGXPR5SDGQtmnblNfsFeVkXIzlAZpo9ucVxbgbf54A=
X-Gm-Gg: AYBFou2/bkiVIK0ywCJVX3zqrMBL3U1fs4qNosoNsVMHeNQXNc3OiDg7JPbXJhXqcSY
	CIYfKt0RUN1OaHxF6QOL0Qb1DTg+3jBhyD52lxEkYzFR8UQANODXyQBu4NztxnFmItRB48lnby3
	/K43RcxnxtUBqiamM2FW+UQcsnF4G738XAGc6d0Nyh8jD3FHs0MwHFjykle+iu4vYCX+V0guA2o
	hVPeYS4FUxOd3FRZIe5d2tugHpCahyJEjSSGSbGX2gAHmsATFVN+bFz8e2L2t4h5mQZcTM6yKqD
	TKkxeGNUehG9TqfLbthpwGZbfIOqBzbzQRj+evkxL+Ms+VSKbkkUmjRPvUhQ+VsL4pHYgLR4y+p
	t4lJo8vmMfa2QfAnOGpspMLiRCZ/hYtwvfwBRc5YXVGApEDW7aDQ/a7AARx3wQYM0xM6w7nbS+4
	zISGuPSoKy/l6M0vH0pbbmTImaoaRnocakVn4hX/ry6btkD6jdyqR4z2+8bNaxGcgYdZ9IdW1LT
	QjdQJ6JgABgpHf0q/rt7xW0iNX4OiK64uOKmPVOmzohr0WxcEYki+hY8KjcezlIfPc/6uFevoqC
	J5IxLbNrPebB+A==
X-Received: by 2002:a05:6000:2893:b0:488:7fdb:46b5 with SMTP id ffacd0b85a97d-48af1b2e134mr5635978f8f.20.1790699422665;
        Tue, 29 Sep 2026 09:30:22 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48af502cf08sm5879746f8f.9.2026.09.29.09.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 09:30:21 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH ath-next v4 0/8] wifi: ath9k: fix register access and spectral scan filter handling on ath9k_htc
Date: Tue, 29 Sep 2026 19:30:15 +0300
Message-ID: <20260929163015.1779285-1-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916173429.403889-1-nerijus.bendziunas@gmail.com>
References: <20260916173429.403889-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Toke,

Gentle ping on this series. Please let me know if any changes are needed.

Thanks,
Nerijus
