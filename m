Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9014B3EAC8D
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 04:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788753721; cv=none; b=ZLwz7Zvvky/KlpNN5CJGFQUjIHhmkHce9t1QT/b4H72UKzZQNy3BpDwOZ2W0ztBjpwcxf7IjI9Q7jYQ7mBu02g/m8Kc/+FpunEZyKJ80mdXjEHN5ikPjn19d6GuhFK0lLJOZi9ivl+2rmNnRP5SAYawSzmtVCoAeJrQBwluW6lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788753721; c=relaxed/simple;
	bh=295eWmKjjJSsf2Qb21fsc0R7caj2Ox8IuLV/wjJRXIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcgQlz4MeT1laTXUf1yuWgVJ1U17AcjuT/Mb8OKLYhzMznYKDfDMh5nayRz9L5rGS3gBxgOJzmG0/1Bk+SLC6rRUr03bIot7Nu/7NecowkaWuqgQgPjLLTP/J5z6g5hXoeWoTfikft8Xd+ohjw0vrOMCf8l0GbZAcBl83v8NGOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GtTz7Ll+; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GtTz7Ll+"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5b28c91fba5so3640357e87.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 21:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788753717; x=1789358517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YJSxnvBJYF8uc7sGAY2P+/nrv3c6F1c5XrQLy8OPO8I=;
        b=GtTz7Ll+++qA5Ak0AqBb5mkv1FwdLgtsNCFUPoa3ZACT4aAHNxonlAHyDtVBaNIHlp
         gAkIDLI9w+MLtMrYtjkLKsIObMQTd7/E4jzYMQ//CRbRaLEIA3oywI2u0Hkm7IfpMf6A
         ek04n/AYu+0Xo3g+vgCX6k5ZThK+bH6ovkpzYvdNSM3fqmUfyZ8WCTQJXi4skBXT66b8
         Yrr5GY/8EnNqNUnvB7ptpIVlhQ1IN9x84RL4bUaCwoDaj6BjMWG/z95EbRsFa8Rq0EIv
         pEaBESN1m3kJpNaeZkravSisq2Pv+Q/sh5PjyZFdl/hWaeaMjhXNveAJNZsEOx7Bvc97
         LL6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788753717; x=1789358517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YJSxnvBJYF8uc7sGAY2P+/nrv3c6F1c5XrQLy8OPO8I=;
        b=KTxHWiezPV4/pfwDAdwYK5zDsryp8/SA2ePI8U1vnm+X3Cl03lPeEjeZx4gK7q2fYS
         ez75HP3peuzQfOrU3xRvN5k3mjND3zDuHTXgxZBmh6T6AZkCaaE1sXAtp+BSQ4odHGfP
         ECLhka/crwzaqt6n+HOAnVvlV53UxQjMmfKvDMP3ZI1+OWCw+FPf8U9dVPGGIFDm8Nlz
         2WUCNkuIl/Ehbw3hV4onixS3NrnQa3wLxcN9BydzX9Wa033nDYLz2sB9NjX2AUomaaQy
         +D5gcr/bkwqCr5sn/N1I9QErPxopohsWry4Iu0iljIt+6VZ95F/EA7YyId8W5prK+ADt
         fn2Q==
X-Gm-Message-State: AFuF++mcprVLyqcM8f7qsJ0VoFOb6JWxZ/Zupd28ncfuQ2pO5uGxCsfp
	fp4nzJUHBXZ0D5Citov3z4zq2C2e+3CsyIrmowOL8Nr7CT2H9KnQe/xM
X-Gm-Gg: AYBFou3p1Mo1x+8iX6rhvnY/4r82Xw1Otz6+Bu5Xj05Bed0fBagigYhrgJFuYJ9NRfQ
	nqVgdP1HIwB8msWb/Cya5AQjGr5zs+3fnKoeqm6Ge1OApgUToinbntoIIAA5Iq13pZ/rDy/IsQG
	sYECMIiV56PmJge4baB+M6gcMOJTupt5PdeHcpYrKxNJ+uTfTe/Hv/Jfoya5kCTtDk00WLPd25f
	9iDjiSuwfhJg/rTbUUxbOYt30cyG2iSM5NyRN4a9nOYD6l2/WoaCikVHXVW9da3pxSbAifeayT7
	rjnI0Znx3b4UFBQ4g/V5F8Jg4Pv/CHcOlzGZvzjNDUmKjDM8BSEMxWIORTLvwQ2yEXVjVFR/mYg
	nTBdJ8W7NyubHTqdX0TgZWng9Oj6z+ACpCskmIl5H8StsLymzXddPyi5rA4MlzYsmB4yyynZJnr
	IyQBWt/2IJVkOfAVECcO1xhYaPv6V4UAFRFrYY1StAK6M7dQAZTvA3tbkj3mKT4C5ZJz0COq6G0
	qD+
X-Received: by 2002:a05:6512:128a:b0:5b6:10bc:b869 with SMTP id 2adb3069b0e04-5b6177bf69bmr2695515e87.23.1788753717151;
        Sun, 06 Sep 2026 21:01:57 -0700 (PDT)
Received: from localhost.localdomain ([80.66.93.99])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b61669abd4sm2123344e87.5.2026.09.06.21.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 21:01:56 -0700 (PDT)
From: Maxim Skokov <skokovmaksimevg@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: rtw89: fix typos in comments, debug messages and struct field
Date: Mon,  7 Sep 2026 07:00:33 +0300
Message-ID: <20260907040138.4321-1-skokovmaksimevg@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <8094bfc474e34b2f826b9487e49bd601@realtek.com>
References: <20260904222548.19732-1-skokovmaksimevg@gmail.com> <8094bfc474e34b2f826b9487e49bd601@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ping-Ke Shih <pkshih@realtek.com> wrote:
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
>
> Add a tag like  Assisted-by: LLM codespell ?
>
> Just reply this mail, no need to resend v2.

Yes, thanks, that is the right tag and it matches the format documented in
Documentation/process/coding-assistants.rst.  Please add:

Assisted-by: LLM codespell

The note below the --- line can be dropped, since the tag now says the same
thing in the commit message.

Thanks for the review.

Maxim
