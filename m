Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A45258EE9
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 07:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788594416; cv=none; b=IICa4m2p1HAz3M/HSAt9QCnemSPsIV7G6gGeV3eRLAjyL1b+A31QX3iRSKNlZOhbDlEB3Gh15EHNDvhvg1ieWfeUcZk2uMH9MqkgEZZYDrtD6BdQdE9ynx5etzTMR5XpHxspKY+QzqpRGXi8Zc+R6GGAwUppqjzPJS1rWc/BLGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788594416; c=relaxed/simple;
	bh=xff8GUk+CZ0GDybRtzZe3eSDdPuy4kMPI4af0+AeHfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLkcLV6NEPlUIdu366rO4v24ZMFizegp3JX6VDu5VxxWyWKzy5j1ubfj4v/4Zjmb4Q9wMd5+Afr4exELe2FPQz2iv0tBBVeW682uTRZB6BB317+swc4+MJpoxxm6Pey4VM8mgZkFJi2DpPWuBfnR/Ocnp44qjceDVOo810tqwoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GmImc+Xc; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GmImc+Xc"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4843efcbdb2so946993f8f.2
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2026 00:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788594414; x=1789199214; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xff8GUk+CZ0GDybRtzZe3eSDdPuy4kMPI4af0+AeHfQ=;
        b=GmImc+XcF7BGv6Pcjjyl9VJUW7eWCbNNY+sd9+aOCT/4bLdCoK80DhAWdG4H+h9EQS
         u+xpT6XUeudBYmHrti/lOWfTT77itipkUTYPZXUuPIuh9T3IukOmodRYljb+y9LI/VC9
         xYhlw7A3J+MsuBwWSlr/NI2acrCjGQVw2eiHruIxem91JKkriNe7PRoJOvQyPRVDsYDH
         8msaldOmvLMqqFVVtUSm5CGTYbnJSthgAn/Cvki2d3Fx6bxGNz7Y8GQJTEey/fTVMqR0
         WEOvzdhJwoE8BEnZgmp72pbjsbNMffl7f+8O87HYEkuPxBuRmb27CHUb7vajtzyznJ2o
         qNsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788594414; x=1789199214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xff8GUk+CZ0GDybRtzZe3eSDdPuy4kMPI4af0+AeHfQ=;
        b=ILG79S9RnRtysetfakrfsUdI2d+ONadd952UEXmVA9ZhIHmB13qd+123qu28fz6F3B
         6oPW341PbYRECUsuGign/dU2tzXBSLS0SfkO0IJZPWYgunb9r7kAeWOtml21WAneAjPm
         yhIlvokMlBRTp9KtVmmpxxvcBL/0M0S5HIvrM5Qu2nQ+M04u8kk7hThhDV/VZWMQaVZv
         8omt3GTKLv7agUMnI2xs1sGXBu728zdqTqGgCZbYVhAA2hqBUL4kXv43eoYW/L968erP
         7Vlqf7cHuL3toUYMTGUsPOyzGGIgD7R6/W8kPybeoWTQIaOEUNz1gWOGlRYc0WPb8hSn
         tEhQ==
X-Forwarded-Encrypted: i=1; AKwUvByX0rYNZCqpZmYszpfRKSjEQKg1WHZhKR+4yVvQu3ozoiW6RNF5hf8ergyQX30u3Ypa7TI660mCN21FAOfZ+w==@vger.kernel.org
X-Gm-Message-State: AFuF++n+pxEk3+3I8jJivVsIZaxH4Ed4Z5so0OtymayldrahJc+lf54z
	UjUTYE7UN9RVkI6+MRuzlySFJ1xADEaUK2y63JvVBlS+UgqqY9sma7k=
X-Gm-Gg: AYBFou0WT1bAbkDM/DaepZCxCXQDFLAHCQZfyZWyd8JfjQuQAzzelqMcfpXhbVVppkt
	3K9/Lm1LNic89kfpLiDhGPrUHLteSKURHDMG0LzfdsLr+Ls77C+Gysk4qtw+frdFQNYLXFaeIOB
	8OgKvGP42OAW/F/gPYPAtHlK4UQ6COQ4fVK/QNBU4OYC4322hHxGuA6OGdSbMUlm6OwwGVMfghT
	TPppCRNOpiBpRV/ZVNuyLqr8qSbJP069PQIrdx58W1AaHrKm8eazbHbrKqnNWWJpNk3qHCbJgki
	Yb+wGHxVyMKB1AbfKc4j4GwMdCByO/aw8x0h6Gltq8O4bU/xGHY6C9Kg0rw1yBCK0BZq8eBaSC1
	syOQGhqOD4ynR6IwlRfBaqIBKQQHDfi8F9oA8VYOsQx0tbFDGVj9p2bEUtMUQpjb6ahIds4MrNG
	Mf5EHD/tzBDRA9JFhxv7Qpr6tlFv/XB1UkckHgjzsBuTfyywZnkpKoGhKQStBX7nCSf60uEh6vc
	3qEm/jcSbd2uRqyEpHHQN1CXwzsdsPjhgcVWSCkK6bMLS0WDrsKiP0Lyn9h1nT/j9QmLX+9z1YC
	wgim
X-Received: by 2002:a05:6000:491d:b0:484:3785:210e with SMTP id ffacd0b85a97d-485872d4f0fmr12136802f8f.25.1788594413532;
        Sat, 05 Sep 2026 00:46:53 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858bcefd59sm8629206f8f.19.2026.09.05.00.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 00:46:53 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@kernel.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] wifi: ath9k_htc: fix the byte count of a full RMW buffer flush
Date: Sat,  5 Sep 2026 10:46:49 +0300
Message-ID: <20260905074649.341820-1-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904180849.775404-1-nerijus.bendziunas@gmail.com>
References: <20260904180849.775404-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please do not apply this patch, and do not send it to stable.

The message is wrong: ar9271_hw_pa_cal() does fill the buffer, with
exactly 15 entries, on every AR9271 reset.

With the size fixed the command is 8 (HTC) + 4 (WMI) + 180 = 192
bytes, three full 64-byte USB packets. The firmware ends a command
only on a short packet, so this one never ends. The next command is
glued to it and the device is dead until power-cycled. An AR9271 hangs
this way on the first interface open.

A v3 follows in a new thread: the size fix plus a cap of 14 entries,
so the buffer can never produce a 192-byte command.

Nerijus
